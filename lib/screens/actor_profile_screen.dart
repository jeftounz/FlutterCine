import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/tmdb_service.dart';
import '../widgets/movie_card.dart'; // Importa el widget MovieCard

class ActorProfileScreen extends StatelessWidget {
  final int actorId;

  ActorProfileScreen({required this.actorId});

  @override
  Widget build(BuildContext context) {
    final tmdbService = Provider.of<TMDbService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Actor profile')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: tmdbService.getActorDetails(actorId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final actor = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://image.tmdb.org/t/p/w500${actor['profile_path']}',
                      ),
                      radius: 60,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    actor['name'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    actor['biography'] ?? 'No hay biografía disponible',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Cast on:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  FutureBuilder<List<dynamic>>(
                    future: tmdbService.getActorMovies(actorId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final movies = snapshot.data!;
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // Dos columnas
                                crossAxisSpacing: 8.0, // Espacio entre columnas
                                mainAxisSpacing: 8.0, // Espacio entre filas
                                childAspectRatio:
                                    0.9, // Relación de aspecto (ancho/alto)
                              ),
                          itemCount: movies.length,
                          itemBuilder: (context, index) {
                            final movie = movies[index];
                            return MovieCard(movie: movie);
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final dynamic movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withOpacity(0.5), // Fondo semi-transparente
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Imagen de la película
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
            child: Image.network(
              'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 120, // Altura fija para la imagen
            ),
          ),
          // Título de la película
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              movie['title'],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
