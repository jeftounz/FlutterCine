class Movie {
  final int id;
  final String title;
  final String posterPath;
  final double voteAverage;
  final String overview;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.voteAverage,
    required this.overview,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      posterPath: json['poster_path'],
      voteAverage: json['vote_average'].toDouble(),
      overview: json['overview'],
    );
  }
}
