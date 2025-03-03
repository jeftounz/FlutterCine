/// Clase que representa un actor en la aplicación.
///
/// Esta clase almacena información básica de un actor, como su ID, nombre,
/// ruta de la foto de perfil, biografía y lista de películas en las que ha participado.
class Actor {
  /// ID único del actor en la base de datos de TMDB.
  final int id;

  /// Nombre completo del actor.
  final String name;

  /// Ruta relativa de la foto de perfil del actor.
  ///
  /// Esta ruta se combina con la URL base de TMDB para obtener la imagen completa.
  /// Ejemplo: "https://image.tmdb.org/t/p/w500$profilePath".
  final String profilePath;

  /// Biografía del actor.
  ///
  /// Puede ser `null` si no hay una biografía disponible.
  final String? biography;

  /// Lista de películas en las que el actor ha participado.
  ///
  /// Esta lista puede estar vacía si no hay información disponible.
  final List<dynamic> movies;

  /// Constructor de la clase `Actor`.
  ///
  /// Requiere los siguientes parámetros:
  /// - [id]: ID único del actor.
  /// - [name]: Nombre completo del actor.
  /// - [profilePath]: Ruta relativa de la foto de perfil.
  /// - [biography]: Biografía del actor (opcional).
  /// - [movies]: Lista de películas en las que ha participado.
  Actor({
    required this.id,
    required this.name,
    required this.profilePath,
    this.biography,
    required this.movies,
  });

  /// Constructor factory que crea una instancia de `Actor` a partir de un JSON.
  ///
  /// Este método es útil para convertir los datos obtenidos de la API de TMDB
  /// en un objeto de tipo `Actor`.
  ///
  /// Parámetros:
  /// - [json]: Un mapa que contiene los datos del actor en formato JSON.
  ///
  /// Retorna:
  /// Una instancia de `Actor` con los datos proporcionados.
  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(
      id: json['id'], // Obtiene el ID del actor.
      name: json['name'], // Obtiene el nombre del actor.
      profilePath:
          json['profile_path'], // Obtiene la ruta de la foto de perfil.
      biography:
          json['biography'], // Obtiene la biografía del actor (puede ser null).
      movies:
          json['movies'] ??
          [], // Obtiene la lista de películas (o una lista vacía si no hay datos).
    );
  }
}
