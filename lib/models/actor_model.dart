class Actor {
  final int id;
  final String name;
  final String profilePath;
  final String? biography;
  final List<dynamic> movies;

  Actor({
    required this.id,
    required this.name,
    required this.profilePath,
    this.biography,
    required this.movies,
  });

  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(
      id: json['id'],
      name: json['name'],
      profilePath: json['profile_path'],
      biography: json['biography'],
      movies: json['movies'] ?? [],
    );
  }
}
