import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../screens/detail_screen.dart'; // Importa el archivo correcto

class MovieCard extends StatelessWidget {
  // `movie` es un objeto Movie que contiene los detalles de la película.
  final Movie movie;

  // Constructor que recibe el objeto `movie` requerido.
  MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    // Construye la tarjeta (Card) que muestra la información de la película.
    return Card(
      child: ListTile(
        // Imagen de la película en la parte izquierda de la tarjeta.
        leading: Image.network(
          'https://image.tmdb.org/t/p/w200${movie.posterPath}',
          width: 50, // Ancho fijo de la imagen.
          height: 50, // Altura fija de la imagen.
          fit: BoxFit.cover, // Ajusta la imagen para cubrir el espacio.
        ),
        // Título de la película.
        title: Text(movie.title),
        // Subtítulo con la puntuación de la película.
        subtitle: Text(
          'Rating: ${(movie.voteAverage * 10).toStringAsFixed(0)}%',
        ),
        // Función que se ejecuta al tocar la tarjeta.
        onTap: () {
          // Navega a la pantalla de detalles de la película (DetailScreen).
          Navigator.push(
            context,
            MaterialPageRoute(
              // Crea una instancia de DetailScreen pasando el objeto Movie.
              builder: (context) => DetailScreen(movie: movie),
            ),
          );
        },
      ),
    );
  }
}
