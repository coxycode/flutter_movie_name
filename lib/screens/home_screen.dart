import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'search_screen.dart';
import 'watchlist_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;

  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
    WatchlistScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('Movie App'),
            floating: true,
          ),
          _buildFeaturedMovies(),
          _buildSection(
            title: 'Now Playing',
            movies: _getDummyMovies(),
          ),
          _buildSection(
            title: 'Popular',
            movies: _getDummyMovies(),
          ),
          _buildSection(
            title: 'Coming Soon',
            movies: _getDummyMovies(),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedMovies() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 240,
        child: PageView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return _buildFeaturedCard(_getDummyMovies()[index]);
          },
        ),
      ),
    );
  }

  Widget _buildFeaturedCard(Movie movie) {
    return GestureDetector(
      onTap: () => _navigateToMovieDetails(movie),
      child: Card(
        margin: const EdgeInsets.all(8),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              movie.posterUrl,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${movie.rating}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        movie.releaseDate,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Movie> movies,
  }) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to see all movies in this category
                  },
                  child: const Text('See All'),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return _buildMovieCard(movies[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCard(Movie movie) {
    return GestureDetector(
      onTap: () => _navigateToMovieDetails(movie),
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  movie.posterUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                Text(' ${movie.rating}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToMovieDetails(Movie movie) {
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
  }

  List<Movie> _getDummyMovies() {
    return [
      Movie(
        id: '299534',
        title: 'Avengers: Endgame',
        posterUrl: 'https://image.tmdb.org/t/p/w500/or06FN3Dka5tukK1e9sl16pB3iy.jpg',
        overview: 'The epic conclusion to the Infinity Saga',
        rating: 4.8,
        releaseDate: '2019',
        genres: ['Action', 'Adventure', 'Sci-Fi'],
      ),
      Movie(
        id: '475557',
        title: 'Joker',
        posterUrl: 'https://image.tmdb.org/t/p/w500/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg',
        overview: 'Put on a happy face',
        rating: 4.7,
        releaseDate: '2019',
        genres: ['Crime', 'Drama', 'Thriller'],
      ),
      Movie(
        id: '420818',
        title: 'The Lion King',
        posterUrl: 'https://image.tmdb.org/t/p/w500/2bXbqYdUdNVa8VIWXVfclP2ICtT.jpg',
        overview: 'The King has Returned',
        rating: 4.6,
        releaseDate: '2019',
        genres: ['Adventure', 'Animation', 'Drama'],
      ),
      Movie(
        id: '330457',
        title: 'Frozen II',
        posterUrl: 'https://image.tmdb.org/t/p/w500/pjeMs3yqRmFL3giJy4PMXWZTTPa.jpg',
        overview: 'Journey into the unknown',
        rating: 4.5,
        releaseDate: '2019',
        genres: ['Animation', 'Adventure', 'Family'],
      ),
      Movie(
        id: '429617',
        title: 'Spider-Man: Far from Home',
        posterUrl: 'https://image.tmdb.org/t/p/w500/lcq8dVxeeOqHvvgcte707K0KVx5.jpg',
        overview: 'Far From Home',
        rating: 4.7,
        releaseDate: '2019',
        genres: ['Action', 'Adventure', 'Sci-Fi'],
      ),
      Movie(
        id: '301528',
        title: 'Toy Story 4',
        posterUrl: 'https://image.tmdb.org/t/p/w500/w9kR8qbmQ01HwnvK4alvnQ2ca0L.jpg',
        overview: 'To infinity and beyond',
        rating: 4.6,
        releaseDate: '2019',
        genres: ['Animation', 'Adventure', 'Comedy'],
      ),
      Movie(
        id: '181812',
        title: 'Star Wars: The Rise of Skywalker',
        posterUrl: 'https://image.tmdb.org/t/p/w500/db32LaOibwEliAmSL2jjDF6oDdj.jpg',
        overview: 'The saga concludes',
        rating: 4.5,
        releaseDate: '2019',
        genres: ['Action', 'Adventure', 'Sci-Fi'],
      ),
      Movie(
        id: '420817',
        title: 'Aladdin',
        posterUrl: 'https://image.tmdb.org/t/p/w500/3iYQTLGoy7QnjcUYRJy4YrAgGvp.jpg',
        overview: 'A whole new world',
        rating: 4.4,
        releaseDate: '2019',
        genres: ['Adventure', 'Fantasy', 'Romance'],
      ),
      Movie(
        id: '284054',
        title: 'Black Panther',
        posterUrl: 'https://image.tmdb.org/t/p/w500/uxzzxijgPIY7slzFvMotPv8wjKA.jpg',
        overview: 'Wakanda Forever',
        rating: 4.8,
        releaseDate: '2018',
        genres: ['Action', 'Adventure', 'Sci-Fi'],
      ),
      Movie(
        id: '424694',
        title: 'Bohemian Rhapsody',
        posterUrl: 'https://image.tmdb.org/t/p/w500/lHu1wtNaczFPGFDTrjCSzeLPTKN.jpg',
        overview: 'The story of a legend',
        rating: 4.7,
        releaseDate: '2018',
        genres: ['Drama', 'Music', 'Biography'],
      ),
    ];
  }
} 