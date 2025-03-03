import 'package:flutter/material.dart';
import '../screens/actor_profile_screen.dart';

class ActorCard extends StatelessWidget {
  // `actor` es un objeto dinámico que contiene los datos del actor.
  final dynamic actor;

  // Constructor que recibe el objeto `actor` requerido.
  ActorCard({required this.actor});

  @override
  Widget build(BuildContext context) {
    // GestureDetector para detectar toques en la tarjeta del actor.
    return GestureDetector(
      // Al tocar la tarjeta, navega a la pantalla de perfil del actor.
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            // Crea una instancia de ActorProfileScreen con el ID del actor.
            builder: (context) => ActorProfileScreen(actorId: actor['id']),
          ),
        );
      },
      // Contenedor principal de la tarjeta del actor.
      child: Container(
        width: 100, // Ancho fijo del contenedor.
        height: 140, // Altura fija del contenedor.
        // Decoración del contenedor (borde redondeado y sombra).
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
        // Columna para organizar la imagen y el nombre del actor.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagen del actor.
            ClipRRect(
              // Redondea las esquinas superiores de la imagen.
              borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
              // Muestra la imagen del actor desde la URL.
              child: Image.network(
                'https://image.tmdb.org/t/p/w200${actor['profile_path']}',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 100, // Altura fija para la imagen
              ),
            ),
            // Contenedor para el nombre del actor.
            Container(
              padding: EdgeInsets.all(4.0),
              // Decoración del contenedor del nombre (fondo semi-transparente y borde inferior redondeado).
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(8.0),
                ),
              ),
              // Texto con el nombre del actor.
              child: Text(
                actor['name'],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
