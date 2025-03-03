import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/tmdb_service.dart';
import '../models/movie_model.dart';
import 'detail_screen.dart';

class FeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtiene una instancia de TMDbService usando Provider.
    final tmdbService = Provider.of<TMDbService>(context);

    // Construye la estructura de la pantalla usando Scaffold.
    return Scaffold(
      // Barra de aplicación (AppBar).
      appBar: AppBar(
        // Botón de menú en la esquina superior izquierda.
        leading: Padding(
          padding: const EdgeInsets.only(left: 26.0, top: 10.0),
          child: SizedBox(
            width: 25.0,
            height: 25.0,
            child: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              // Al presionar, abre el Drawer.
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              // Estilos del IconButton.
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
        // Título centrado de la AppBar.
        title: Center(
          child: Text('Latest', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      // Drawer (menú lateral).
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Cabecera del Drawer.
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menú',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            // Opción 1 del Drawer.
            ListTile(
              leading: Icon(Icons.circle, color: Colors.green),
              title: Text('Opción 1'),
              onTap: () {
                // No hace nada por ahora.
              },
            ),
            // Puedes agregar más opciones aquí.
          ],
        ),
      ),
      // Cuerpo de la pantalla con un Padding.
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        // FutureBuilder para obtener la lista de películas populares.
        child: FutureBuilder<List<dynamic>>(
          future: tmdbService.getPopularMovies(),
          builder: (context, snapshot) {
            // Si el Future está en estado de espera, muestra un indicador de carga.
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            // Si el Future ha completado con un error, muestra un mensaje de error.
            else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            // Si el Future ha completado con datos, construye la lista de películas.
            else {
              final movies = snapshot.data!;
              // GridView.builder para mostrar las películas en una cuadrícula.
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                  childAspectRatio: 151 / 218,
                ),
                itemCount: movies.length,
                // Función que construye cada elemento de la cuadrícula.
                itemBuilder: (context, index) {
                  final movie = Movie.fromJson(movies[index]);
                  // GridItem para mostrar la información de la película.
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

// Widget para mostrar un elemento de la cuadrícula (película).
class GridItem extends StatelessWidget {
  final Movie movie;

  const GridItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    // GestureDetector para detectar toques en la película.
    return GestureDetector(
      onTap: () {
        // Navega a la pantalla de detalles de la película.
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailScreen(movie: movie)),
        );
      },
      // Contenedor que contiene la información de la película.
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
        // Columna para organizar los widgets verticalmente.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagen de la película.
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Contenedor para el título y la puntuación de la película.
            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título de la película.
                  Text(
                    movie.title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Espacio vertical.
                  SizedBox(height: 4),
                  // Puntuación del usuario.
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
