

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:peliculas_erland/models/models.dart';


class MoviesProvider extends ChangeNotifier{
  String _apiKey    = '85858b012b46c393488b890ebb5de1f8';
  String _baseUrl   = 'api.themoviedb.org';
  String _language  = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];


  MoviesProvider(){
    print ('MoviesProvider inicializado');
    this.getOnDisplayMovies();
    this.getPopularMovies();
  }
  getOnDisplayMovies() async{
    var url = Uri.https(_baseUrl,'3/movie/now_playing', {
      'api_key'   : _apiKey,
      'language'  : _language,
      'page'      : '1'
      });

  // Await the http get response, then decode the json-formatted response.
  final  response = await http.get(url);
  final nowPlayingResponse = NowPlayingResponse.fromJson(response.body);
 
  

  

  onDisplayMovies= nowPlayingResponse.results;
  notifyListeners();
  }


  getPopularMovies() async{

      var url = Uri.https(_baseUrl,'3/movie/popular', {
      'api_key'   : _apiKey,
      'language'  : _language,
      'page'      : '1'
      });

  // Await the http get response, then decode the json-formatted response.
  final  response = await http.get(url);
  final popularResponse = PopularResponse.fromJson(response.body);
 
  

  

  popularMovies= [...popularMovies, ...popularResponse.results];
 
  notifyListeners();

  }

}