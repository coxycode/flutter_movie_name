import 'package:flutter/foundation.dart';
import '../models/movie.dart';

class WatchlistProvider extends ChangeNotifier {
  final Set<Movie> _watchlist = {};
  
  Set<Movie> get watchlist => _watchlist;
  
  bool isInWatchlist(String movieId) {
    return _watchlist.any((movie) => movie.id == movieId);
  }

  void toggleWatchlist(Movie movie) {
    if (isInWatchlist(movie.id)) {
      _watchlist.removeWhere((m) => m.id == movie.id);
    } else {
      _watchlist.add(movie);
    }
    notifyListeners();
  }

  void removeFromWatchlist(String movieId) {
    _watchlist.removeWhere((movie) => movie.id == movieId);
    notifyListeners();
  }
} 