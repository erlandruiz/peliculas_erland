

import 'dart:async';
// import 'dart:convert';


import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:peliculas_erland/helpers/debouncer.dart';
import 'package:peliculas_erland/models/models.dart';


class MoviesProvider extends ChangeNotifier{
  String _apiKey    = '85858b012b46c393488b890ebb5de1f8';
  String _baseUrl   = 'api.themoviedb.org';
  String _language  = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
    
    );

  final StreamController<List<Movie>> _suggestionStreamController = StreamController.broadcast();
  Stream<List<Movie>> get suggestionsStream => _suggestionStreamController.stream;

  Future<String>_getJsonData(String endPoint , [int page = 1]) async{
    final url = Uri.https(_baseUrl,endPoint, {
      'api_key'   : _apiKey,
      'language'  : _language,
      'page'      : '$page'
      });

  // Await the http get response, then decode the json-formatted response.
  final  response = await http.get(url);
  return response.body;

  }


  MoviesProvider(){
    print ('MoviesProvider inicializado');
    this.getOnDisplayMovies();
    this.getPopularMovies();

    // _suggestionStreamController.close();
  }
  getOnDisplayMovies() async{
    final jsonData = await _getJsonData('3/movie/now_playing');
 
  final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
 
  

  

  onDisplayMovies= nowPlayingResponse.results;
  notifyListeners();
  }


  getPopularMovies() async{
    _popularPage++;

    final jsonData = await _getJsonData('3/movie/popular' , _popularPage);
  // Await the http get response, then decode the json-formatted response.
  final popularResponse = PopularResponse.fromJson(jsonData);
 
  popularMovies= [...popularMovies, ...popularResponse.results];
 
  notifyListeners();

  }

  Future<List<Cast>> getMovieCast(int movieId) async {

    if(moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    print('pidiendo info al servidor - Cast ');

    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies( String query) async {
    final url = Uri.https(_baseUrl,'3/search/movie', {
      'api_key'   : _apiKey,
      'language'  : _language,
      'query':  query
      });

        final  response = await http.get(url);
        final searchResponse = SearchResponse.fromJson(response.body);

        return searchResponse.results;



  }

  void getSuggestionsByQuery( String searchTerm){
    debouncer.value = '';
    debouncer.onValue = ( value) async {
      final results = await searchMovies(value);
      _suggestionStreamController.add(results);
        // print('Tenemos un valor a buscar : $value');
    };
    final timer = Timer.periodic(Duration(milliseconds: 300), (_) { 
        debouncer.value = searchTerm;
    });
    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }

}