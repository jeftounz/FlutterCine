import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/tmdb_service.dart';
import '../models/movie_model.dart';
import '../widgets/actor_card.dart';

class DetailScreen extends StatelessWidget {
  final Movie movie;

  DetailScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
    final tmdbService = Provider.of<TMDbService>(context);

    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: FutureBuilder<Map<String, dynamic>>(
        future: tmdbService.getMovieDetails(movie.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final details = snapshot.data!;
            return Column(
              children: [
                Image.network(
                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
                Text('Rating: ${(movie.voteAverage * 10).toStringAsFixed(0)}%'),
                Text(details['overview']),
                FutureBuilder<List<dynamic>>(
                  future: tmdbService.getMovieCredits(movie.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final actors = snapshot.data!;
                      return Expanded(
                        child: ListView.builder(
                          itemCount: actors.length,
                          itemBuilder: (context, index) {
                            final actor = actors[index];
                            return ActorCard(actor: actor);
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
