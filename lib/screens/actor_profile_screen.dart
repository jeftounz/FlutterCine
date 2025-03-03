import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/tmdb_service.dart';

class ActorProfileScreen extends StatelessWidget {
  // `actorId` es el identificador único del actor que se mostrará en esta pantalla.
  final int actorId;

  // Constructor que recibe el `actorId` requerido.
  ActorProfileScreen({required this.actorId});

  @override
  Widget build(BuildContext context) {
    // Obtiene una instancia de `TMDbService` usando Provider.
    final tmdbService = Provider.of<TMDbService>(context);

    // Construye la estructura de la pantalla usando Scaffold.
    return Scaffold(
      // Barra de aplicación con el título "Actor profile".
      appBar: AppBar(title: Text('Actor profile')),
      // El cuerpo de la pantalla se construye usando un FutureBuilder.
      body: FutureBuilder<Map<String, dynamic>>(
        // Llama al servicio `getActorDetails` para obtener los detalles del actor.
        future: tmdbService.getActorDetails(actorId),
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
          // Si el Future ha completado con datos, construye la interfaz de usuario con los datos del actor.
          else {
            final actor = snapshot.data!;
            return SingleChildScrollView(
              // Agrega un relleno alrededor del contenido.
              padding: EdgeInsets.all(16.0),
              // Columna para organizar los widgets verticalmente.
              child: Column(
                // Alinea los widgets al inicio del eje cruzado (izquierda).
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Centra el CircleAvatar que muestra la imagen del actor.
                  Center(
                    child: CircleAvatar(
                      // Establece la imagen de fondo del CircleAvatar desde la URL.
                      backgroundImage: NetworkImage(
                        'https://image.tmdb.org/t/p/w500${actor['profile_path']}',
                      ),
                      // Establece el radio del CircleAvatar.
                      radius: 60,
                    ),
                  ),
                  // Agrega un espacio vertical.
                  SizedBox(height: 16),
                  // Muestra el nombre del actor con estilo de texto.
                  Text(
                    actor['name'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  // Agrega un espacio vertical.
                  SizedBox(height: 8),
                  // Muestra la biografía del actor o un mensaje si no hay biografía disponible.
                  Text(
                    actor['biography'] ?? 'No hay biografía disponible',
                    style: TextStyle(fontSize: 16),
                  ),
                  // Agrega un espacio vertical.
                  SizedBox(height: 16),
                  // Muestra el título "Cast on:".
                  Text(
                    'Cast on:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  // FutureBuilder para obtener la lista de películas en las que ha participado el actor.
                  FutureBuilder<List<dynamic>>(
                    // Llama al servicio `getActorMovies` para obtener las películas del actor.
                    future: tmdbService.getActorMovies(actorId),
                    // Función `builder` que se ejecuta en cada estado del Future.
                    builder: (context, snapshot) {
                      // Si el Future está en estado de espera, muestra un indicador de carga.
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      // Si el Future ha completado con un error, muestra un mensaje de error.
                      else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      // Si el Future ha completado con datos, construye la interfaz de usuario con la lista de películas.
                      else {
                        final movies = snapshot.data!;
                        // GridView.builder para mostrar las películas en una cuadrícula.
                        return GridView.builder(
                          // No permite el desplazamiento del GridView.
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          // Configura el diseño de la cuadrícula.
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // Dos columnas
                                crossAxisSpacing: 8.0, // Espacio entre columnas
                                mainAxisSpacing: 8.0, // Espacio entre filas
                                childAspectRatio:
                                    0.9, // Relación de aspecto (ancho/alto)
                              ),
                          // Número de elementos en la cuadrícula.
                          itemCount: movies.length,
                          // Función que construye cada elemento de la cuadrícula.
                          itemBuilder: (context, index) {
                            final movie = movies[index];
                            // MovieCard para mostrar la información de la película.
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

// Widget para mostrar la información de una película.
class MovieCard extends StatelessWidget {
  final dynamic movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      // Establece el color de fondo de la tarjeta con opacidad.
      color: Colors.black.withOpacity(0.5),
      // Columna para organizar los widgets verticalmente.
      child: Column(
        // Estira los widgets en el eje cruzado (horizontal).
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ClipRRect para redondear las esquinas de la imagen.
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
            // Muestra la imagen de la película desde la URL.
            child: Image.network(
              'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 120, // Altura fija para la imagen
            ),
          ),
          // Agrega un relleno alrededor del título de la película.
          Padding(
            padding: const EdgeInsets.all(8.0),
            // Muestra el título de la película con estilo de texto.
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
