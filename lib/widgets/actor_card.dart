import 'package:flutter/material.dart';
import '../screens/actor_profile_screen.dart'; // Importa el archivo correcto

class ActorCard extends StatelessWidget {
  final dynamic actor;

  ActorCard({required this.actor});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(
          'https://image.tmdb.org/t/p/w200${actor['profile_path']}',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(actor['name']),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActorProfileScreen(actorId: actor['id']),
            ),
          );
        },
      ),
    );
  }
}
