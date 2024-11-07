import 'package:flutter/material.dart';

class Genre {
  final String id;
  final String name;
  final String iconPath;
  final String backgroundImage;

  Genre({
    required this.id,
    required this.name,
    required this.iconPath,
    required this.backgroundImage,
  });
}

class GenresScreen extends StatefulWidget {
  const GenresScreen({super.key});

  @override
  State<GenresScreen> createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen> {
  String? _selectedGenre;
  bool _isLoading = false;

  // Dummy data - replace with actual API data
  final List<Genre> _genres = [
    Genre(
      id: '1',
      name: 'Action',
      iconPath: 'assets/icons/action.png',
      backgroundImage: 'assets/backgrounds/action.jpg',
    ),
    Genre(
      id: '2',
      name: 'Comedy',
      iconPath: 'assets/icons/comedy.png',
      backgroundImage: 'assets/backgrounds/comedy.jpg',
    ),
    // Add more genres...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildGenreGrid(),
          if (_selectedGenre != null) _buildMoviesList(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(_selectedGenre ?? 'Movie Genres'),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.7),
              ],
            ),
          ),
        ),
      ),
      bottom: _selectedGenre != null
          ? PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: _buildFilterChips(),
            )
          : null,
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('Popular'),
          _buildFilterChip('New Releases'),
          _buildFilterChip('Top Rated'),
          _buildFilterChip('Upcoming'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: false, // Implement selection logic
        onSelected: (selected) {
          // Implement filter logic
        },
      ),
    );
  }

  Widget _buildGenreGrid() {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildGenreCard(_genres[index]),
          childCount: _genres.length,
        ),
      ),
    );
  }

  Widget _buildGenreCard(Genre genre) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGenre = genre.name;
        });
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Genre background image
            Image.asset(
              genre.backgroundImage,
              fit: BoxFit.cover,
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            // Genre info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    genre.iconPath,
                    width: 24,
                    height: 24,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    genre.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoviesList() {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: _isLoading
          ? const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          : SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildMovieCard(),
                childCount: 10, // Replace with actual movie count
              ),
            ),
    );
  }

  Widget _buildMovieCard() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[800],
                image: const DecorationImage(
                  image: NetworkImage('https://image.tmdb.org/t/p/w500/or06FN3Dka5tukK1e9sl16pB3iy.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Avengers: Endgame',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const Text(' 4.8'),
                    const Spacer(),
                    Text(
                      '2019',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 