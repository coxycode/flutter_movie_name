import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/watchlist_provider.dart';
import '../models/movie.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Lists'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Watchlist'),
            Tab(text: 'Favorites'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _WatchlistTab(),
          _FavoritesTab(),
        ],
      ),
    );
  }
}

class _WatchlistTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WatchlistProvider>(
      builder: (context, watchlistProvider, child) {
        final watchlist = watchlistProvider.watchlist.toList();

        if (watchlist.isEmpty) {
          return const _EmptyListView(
            message: 'Your watchlist is empty',
            suggestion: 'Add movies you want to watch later',
          );
        }

        return _MovieListView(
          movies: watchlist,
          onDismissed: (movie) {
            watchlistProvider.removeFromWatchlist(movie.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Movie removed from watchlist'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    watchlistProvider.toggleWatchlist(movie);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _FavoritesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WatchlistProvider>(
      builder: (context, watchlistProvider, child) {
        final favorites = watchlistProvider.watchlist
            .where((movie) => movie.rating >= 4.0)
            .toList();

        if (favorites.isEmpty) {
          return const _EmptyListView(
            message: 'No favorite movies yet',
            suggestion: 'Add movies you love to your favorites',
          );
        }

        return _MovieListView(
          movies: favorites,
          onDismissed: (movie) {
            watchlistProvider.removeFromWatchlist(movie.id);
          },
        );
      },
    );
  }
}

class _MovieListView extends StatelessWidget {
  final List<Movie> movies;
  final Function(Movie) onDismissed;

  const _MovieListView({
    required this.movies,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return _MovieListTile(
          movie: movie,
          onDismissed: onDismissed,
        );
      },
    );
  }
}

class _MovieListTile extends StatelessWidget {
  final Movie movie;
  final Function(Movie) onDismissed;

  const _MovieListTile({
    required this.movie,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(movie.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) => onDismissed(movie),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              movie.posterUrl,
              width: 60,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 90,
                  color: Colors.grey[800],
                  child: const Icon(
                    Icons.movie,
                    color: Colors.white54,
                  ),
                );
              },
            ),
          ),
          title: Text(
            movie.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  Text(' ${movie.rating}'),
                  const SizedBox(width: 8),
                  Text(movie.releaseDate),
                ],
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => onDismissed(movie),
          ),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/movie-details',
              arguments: {
                'title': movie.title,
                'posterUrl': movie.posterUrl,
                'overview': movie.overview,
                'rating': movie.rating,
                'releaseDate': movie.releaseDate,
              },
            );
          },
        ),
      ),
    );
  }
}

class _EmptyListView extends StatelessWidget {
  final String message;
  final String suggestion;

  const _EmptyListView({
    required this.message,
    required this.suggestion,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.movie_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            suggestion,
            style: TextStyle(
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
} 