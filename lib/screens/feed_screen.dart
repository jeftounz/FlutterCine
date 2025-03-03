import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/tmdb_service.dart';
import '../models/movie_model.dart';
import 'detail_screen.dart';

class FeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tmdbService = Provider.of<TMDbService>(context);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 26.0, top: 10.0),
          child: SizedBox(
            width: 25.0,
            height: 25.0,
            child: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.green,
                shape: const CircleBorder(),
                padding: EdgeInsets.zero,
                minimumSize: Size.zero, // Establece el tamaño mínimo a cero
                tapTargetSize:
                    MaterialTapTargetSize.shrinkWrap, // Ajusta el área de toque
              ),
            ),
          ),
        ),
        title: Center(
          child: Text('Latest', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menú',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.circle, color: Colors.green),
              title: Text('Opción 1'),
              onTap: () {
                // No hace nada
              },
            ),
            // Puedes agregar más opciones aquí
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
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
                  crossAxisCount: 2,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                  childAspectRatio: 151 / 218,
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailScreen(movie: movie)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
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
            Container(
              color: Colors.transparent,
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
