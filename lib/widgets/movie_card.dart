import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../screens/detail_screen.dart'; // Importa el archivo correcto

class MovieCard extends StatelessWidget {
  final Movie movie;

  MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(
          'https://image.tmdb.org/t/p/w200${movie.posterPath}',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(movie.title),
        subtitle: Text(
          'Rating: ${(movie.voteAverage * 10).toStringAsFixed(0)}%',
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailScreen(movie: movie)),
          );
        },
      ),
    );
  }
}
