/// Clase que representa una película en la aplicación.
///
/// Esta clase almacena información básica de una película, como su ID, título,
/// ruta del póster, calificación promedio y descripción.
class Movie {
  /// ID único de la película en la base de datos de TMDB.
  final int id;

  /// Título de la película.
  final String title;

  /// Ruta relativa del póster de la película.
  ///
  /// Esta ruta se combina con la URL base de TMDB para obtener la imagen completa.
  /// Ejemplo: "https://image.tmdb.org/t/p/w500$posterPath".
  final String posterPath;

  /// Calificación promedio de la película, en una escala de 0 a 10.
  final double voteAverage;

  /// Descripción o resumen de la película.
  final String overview;

  /// Constructor de la clase `Movie`.
  ///
  /// Requiere los siguientes parámetros:
  /// - [id]: ID único de la película.
  /// - [title]: Título de la película.
  /// - [posterPath]: Ruta relativa del póster.
  /// - [voteAverage]: Calificación promedio.
  /// - [overview]: Descripción de la película.
  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.voteAverage,
    required this.overview,
  });

  /// Constructor factory que crea una instancia de `Movie` a partir de un JSON.
  ///
  /// Este método es útil para convertir los datos obtenidos de la API de TMDB
  /// en un objeto de tipo `Movie`.
  ///
  /// Parámetros:
  /// - [json]: Un mapa que contiene los datos de la película en formato JSON.
  ///
  /// Retorna:
  /// Una instancia de `Movie` con los datos proporcionados.
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'], // Obtiene el ID de la película.
      title: json['title'], // Obtiene el título de la película.
      posterPath: json['poster_path'], // Obtiene la ruta del póster.
      voteAverage:
          json['vote_average'].toDouble(), // Obtiene la calificación promedio.
      overview: json['overview'], // Obtiene la descripción de la película.
    );
  }
}
