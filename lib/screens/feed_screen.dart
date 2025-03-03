import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/tmdb_service.dart';
import '../models/movie_model.dart';
import 'detail_screen.dart'; // Importa el archivo correcto

class FeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tmdbService = Provider.of<TMDbService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Películas Populares')),
      body: Padding(
        padding: const EdgeInsets.all(25.0), // Margen alrededor del GridView
        child: FutureBuilder<List<dynamic>>(
          future: tmdbService.getPopularMovies(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final movies = snapshot.data!;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Dos columnas
                  crossAxisSpacing: 20.0, // Espacio entre columnas
                  mainAxisSpacing: 20.0, // Espacio entre filas
                  childAspectRatio:
                      151 / 218, // Relación de aspecto (ancho/alto)
                ),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = Movie.fromJson(movies[index]);
                  return GridItem(movie: movie);
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  final Movie movie;

  const GridItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navegar a la pantalla de detalles de la película
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailScreen(movie: movie)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0), // Esquinas redondeadas
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${(movie.voteAverage * 10).toStringAsFixed(0)}% User Score',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
