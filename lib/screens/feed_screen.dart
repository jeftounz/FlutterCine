import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/tmdb_service.dart';
import '../models/movie_model.dart';
import '../widgets/movie_card.dart';

class FeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tmdbService = Provider.of<TMDbService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Películas Populares')),
      body: FutureBuilder<List<dynamic>>(
        future: tmdbService.getPopularMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final movies = snapshot.data!;
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = Movie.fromJson(movies[index]);
                return MovieCard(movie: movie);
              },
            );
          }
        },
      ),
    );
  }
}
