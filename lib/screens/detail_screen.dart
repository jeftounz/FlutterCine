import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/tmdb_service.dart';
import '../models/movie_model.dart';
import '../widgets/actor_card.dart';

class DetailScreen extends StatelessWidget {
  // `movie` es el objeto Movie que contiene los detalles de la película a mostrar.
  final Movie movie;

  // Constructor que recibe el objeto `movie` requerido.
  DetailScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
    // Obtiene una instancia de `TMDbService` usando Provider.
    final tmdbService = Provider.of<TMDbService>(context);

    // Construye la estructura de la pantalla usando Scaffold.
    return Scaffold(
      // Barra de aplicación (AppBar) con fondo transparente y sin sombra.
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Fondo transparente
        elevation: 0, // Sin sombra
        // Botón de cierre en la esquina superior izquierda.
        leading: Container(
          margin: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            // Al presionar el botón, cierra la pantalla actual.
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      // Permite que el cuerpo se extienda detrás de la barra de aplicación.
      extendBodyBehindAppBar: true,
      // El cuerpo de la pantalla se construye usando un FutureBuilder.
      body: FutureBuilder<Map<String, dynamic>>(
        // Llama al servicio `getMovieDetails` para obtener los detalles de la película.
        future: tmdbService.getMovieDetails(movie.id),
        // Función `builder` que se ejecuta en cada estado del Future.
        builder: (context, snapshot) {
          // Si el Future está en estado de espera, muestra un indicador de carga.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // Si el Future ha completado con un error, muestra un mensaje de error.
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Si el Future ha completado con datos, construye la interfaz de usuario con los datos de la película.
          else {
            return Stack(
              children: [
                // Imagen de fondo de la película.
                Image.network(
                  'https://image.tmdb.org/t/p/w1280${movie.posterPath}',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
                // Contenedor posicionado en la parte inferior de la pantalla.
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16.0),
                      ),
                    ),
                    // Columna para organizar los detalles de la película.
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título de la película.
                        Text(
                          movie.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        // Espacio vertical.
                        SizedBox(height: 8),
                        // Puntuación del usuario.
                        Text(
                          '${(movie.voteAverage * 10).toStringAsFixed(0)}% User Score',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        // Espacio vertical.
                        SizedBox(height: 16),
                        // FutureBuilder para obtener la lista de actores de la película.
                        FutureBuilder<List<dynamic>>(
                          // Llama al servicio `getMovieCredits` para obtener los créditos de la película.
                          future: tmdbService.getMovieCredits(movie.id),
                          // Función `builder` que se ejecuta en cada estado del Future.
                          builder: (context, snapshot) {
                            // Si el Future está en estado de espera, muestra un indicador de carga.
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            // Si el Future ha completado con un error, muestra un mensaje de error.
                            else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            // Si el Future ha completado con datos, construye la lista de actores.
                            else {
                              final actors = snapshot.data!;
                              // Columna para organizar los actores.
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Título "Actores principales:".
                                  Text(
                                    'Actores principales:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  // Espacio vertical.
                                  SizedBox(height: 8),
                                  // Centra las tarjetas de los actores usando Wrap.
                                  Center(
                                    child: Wrap(
                                      alignment: WrapAlignment.center,
                                      spacing: 8.0,
                                      children: [
                                        // Crea tarjetas de actores para los primeros 3 actores.
                                        for (
                                          var i = 0;
                                          i < 3 && i < actors.length;
                                          i++
                                        )
                                          ActorCard(actor: actors[i]),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
