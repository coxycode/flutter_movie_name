import 'package:flutter/material.dart';
import '../providers/watchlist_provider.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';

class MovieDetailsScreen extends StatelessWidget {
  final String title;
  final String posterUrl;
  final String overview;
  final double rating;
  final String releaseDate;

  const MovieDetailsScreen({
    super.key,
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.rating,
    required this.releaseDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(title),
              background: Image.network(
                posterUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      Text(' $rating'),
                      const SizedBox(width: 16),
                      Text(releaseDate),
                      const Spacer(),
                      _buildWatchlistButton(context),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(overview),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWatchlistButton(BuildContext context) {
    return Consumer<WatchlistProvider>(
      builder: (context, watchlistProvider, child) {
        return IconButton(
          icon: Icon(
            Icons.bookmark,
            color: watchlistProvider.isInWatchlist(title) 
                ? Colors.red 
                : null,
          ),
          onPressed: () {
            watchlistProvider.toggleWatchlist(
              Movie(
                id: title, // Using title as ID for simplicity
                title: title,
                posterUrl: posterUrl,
                overview: overview,
                rating: rating,
                releaseDate: releaseDate,
                genres: [], // Add empty list for genres since we don't have that info in the details screen
              ),
            );
          },
        );
      },
    );
  }
}
