import 'dart:convert';

class Movie {
  final String id;
  final String title;
  final String posterUrl;
  final String overview;
  final double rating;
  final String releaseDate;
  final List<String> genres;

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.rating,
    required this.releaseDate,
    required this.genres,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      posterUrl: json['poster_url'],
      overview: json['overview'],
      rating: json['rating'].toDouble(),
      releaseDate: json['release_date'],
      genres: List<String>.from(json['genres']),
    );
  }

  // Convert JSON string to List<Movie>
  static List<Movie> fromJsonString(String jsonString) {
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData.map((json) => Movie.fromJson(json)).toList();
  }
}