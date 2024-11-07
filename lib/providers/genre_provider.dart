import 'package:flutter/foundation.dart';
import '../models/movie.dart';

class GenreProvider extends ChangeNotifier {
  String? _selectedGenre;
  String _selectedFilter = 'Popular';
  bool _isLoading = false;
  List<Movie> _movies = [];

  String? get selectedGenre => _selectedGenre;
  String get selectedFilter => _selectedFilter;
  bool get isLoading => _isLoading;
  List<Movie> get movies => _movies;

  Future<void> selectGenre(String genreName) async {
    _selectedGenre = genreName;
    notifyListeners();
    await fetchMoviesByGenre(genreName);
  }

  void selectFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
    // Implement filter logic
  }

  Future<void> fetchMoviesByGenre(String genreName) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implement API call to fetch movies by genre
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      // Dummy data
      _movies = List.generate(
        10,
        (index) => Movie(
          id: 'id_$index',
          title: 'Movie ${index + 1}',
          posterUrl: 'https://example.com/poster.jpg',
          overview: 'This is a sample movie overview',
          rating: 4.5,
          releaseDate: '2024',
          genres: [genreName],
        ),
      );
    } catch (e) {
      _movies = [];
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 