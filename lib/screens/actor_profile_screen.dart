import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/tmdb_service.dart';
import '../models/actor_model.dart';

class ActorProfileScreen extends StatelessWidget {
  final int actorId;

  ActorProfileScreen({required this.actorId});

  @override
  Widget build(BuildContext context) {
    final tmdbService = Provider.of<TMDbService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Perfil del Actor')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: tmdbService.getActorDetails(actorId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final actor = Actor.fromJson(snapshot.data!);
            return Column(
              children: [
                Image.network(
                  'https://image.tmdb.org/t/p/w500${actor.profilePath}',
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
                Text(actor.name),
                Text(actor.biography ?? 'No hay biografía disponible'),
                FutureBuilder<List<dynamic>>(
                  future: tmdbService.getActorMovies(actorId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final movies = snapshot.data!;
                      return Expanded(
                        child: ListView.builder(
                          itemCount: movies.length,
                          itemBuilder: (context, index) {
                            final movie = movies[index];
                            return ListTile(title: Text(movie['title']));
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
