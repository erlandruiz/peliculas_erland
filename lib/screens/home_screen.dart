import 'package:flutter/material.dart';
import 'package:peliculas_erland/providers/movies_provider.dart';
import 'package:peliculas_erland/widgets/widgets.dart';
import 'package:provider/provider.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context);

   


    return Scaffold(
      appBar: AppBar(
        title: Text('Películas en cines'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () {}, 
            )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
        children: [

          //TODO CardSwiper

          //tarjestas principales
          CardSwiper(movies: moviesProvider.onDisplayMovies, ),

          //Slicer de peliculas

          MovieSlider(
            movies:moviesProvider.popularMovies,
            title : 'Populares', 
          ),
          CardSwiper(movies: moviesProvider.onDisplayMovies, ),
          MovieSlider(movies:moviesProvider.popularMovies,
            title : 'Populares',),
          CardSwiper(movies: moviesProvider.onDisplayMovies, ),
          MovieSlider(movies:moviesProvider.popularMovies,
            title : 'Populares',),
          CardSwiper(movies: moviesProvider.onDisplayMovies, ),
          MovieSlider(movies:moviesProvider.popularMovies,
            title : 'Populares',),
          CardSwiper(movies: moviesProvider.onDisplayMovies, ),
          MovieSlider(movies:moviesProvider.popularMovies,
            title : 'Populares',),

          //Listado horizontal de películas
        ],
      ),)
    );
  }
}