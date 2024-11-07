import 'package:flutter/material.dart';
import '../models/person.dart';
import '../widgets/person_filmography.dart';

class CastCrewScreen extends StatefulWidget {
  final String movieTitle;

  const CastCrewScreen({
    super.key,
    required this.movieTitle,
  });

  @override
  State<CastCrewScreen> createState() => _CastCrewScreenState();
}

class _CastCrewScreenState extends State<CastCrewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  final List<Person> _cast = []; // Will be populated from API
  final List<Person> _crew = []; // Will be populated from API

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadCastAndCrew();
  }

  Future<void> _loadCastAndCrew() async {
    setState(() => _isLoading = true);
    try {
      // TODO: Implement API call to fetch cast and crew
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      // Dummy data
      setState(() {
        _cast.addAll(_generateDummyCast());
        _crew.addAll(_generateDummyCrew());
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Cast & Crew'),
                  Text(
                    widget.movieTitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              pinned: true,
              floating: true,
              bottom: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'Cast (${_cast.length})'),
                  Tab(text: 'Crew (${_crew.length})'),
                ],
              ),
            ),
          ];
        },
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabController,
                children: [
                  _CastList(cast: _cast),
                  _CrewList(crew: _crew),
                ],
              ),
      ),
    );
  }
}

class _CastList extends StatelessWidget {
  final List<Person> cast;

  const _CastList({required this.cast});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: cast.length,
      itemBuilder: (context, index) {
        final person = cast[index];
        return _PersonCard(person: person);
      },
    );
  }
}

class _CrewList extends StatelessWidget {
  final List<Person> crew;

  const _CrewList({required this.crew});

  @override
  Widget build(BuildContext context) {
    // Group crew by department
    final departments = crew.fold<Map<String, List<Person>>>(
      {},
      (map, person) {
        if (!map.containsKey(person.department)) {
          map[person.department] = [];
        }
        map[person.department]!.add(person);
        return map;
      },
    );

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: departments.length,
      itemBuilder: (context, index) {
        final department = departments.keys.elementAt(index);
        final departmentCrew = departments[department]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                department,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...departmentCrew.map((person) => _PersonCard(person: person)),
          ],
        );
      },
    );
  }
}

class _PersonCard extends StatelessWidget {
  final Person person;

  const _PersonCard({required this.person});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showPersonDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(person.profilePath),
                onBackgroundImageError: (_, __) {},
                child: person.profilePath.isEmpty
                    ? Text(person.name[0].toUpperCase())
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      person.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      person.role,
                      style: TextStyle(
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Known for: ${person.knownFor.take(2).join(", ")}',
                      style: const TextStyle(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  void _showPersonDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  _buildBottomSheetHandle(),
                  Expanded(
                    child: CustomScrollView(
                      controller: scrollController,
                      slivers: [
                        _buildPersonHeader(),
                        _buildBiography(),
                        _buildFilmography(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBottomSheetHandle() {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildPersonHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 45,
              backgroundImage: NetworkImage(person.profilePath),
              onBackgroundImageError: (_, __) {},
              child: person.profilePath.isEmpty
                  ? Text(person.name[0].toUpperCase())
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    person.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    person.role,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBiography() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Biography',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(person.biography),
          ],
        ),
      ),
    );
  }

  Widget _buildFilmography() {
    return const SliverToBoxAdapter(
      child: PersonFilmography(),
    );
  }
}

// Helper methods for dummy data
List<Person> _generateDummyCast() {
  final movies = [
    'https://image.tmdb.org/t/p/w500/or06FN3Dka5tukK1e9sl16pB3iy.jpg',
    'https://image.tmdb.org/t/p/w500/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg',
    'https://image.tmdb.org/t/p/w500/2bXbqYdUdNVa8VIWXVfclP2ICtT.jpg',
    'https://image.tmdb.org/t/p/w500/pjeMs3yqRmFL3giJy4PMXWZTTPa.jpg',
  ];

  return List.generate(
    10,
    (index) => Person(
      id: 'cast_$index',
      name: 'Actor Name $index',
      profilePath: movies[index % movies.length],
      role: 'Character Name',
      department: 'Acting',
      knownFor: ['Avengers: Endgame', 'Joker', 'The Lion King'],
      biography: 'This is a sample biography for the actor...',
    ),
  );
}

List<Person> _generateDummyCrew() {
  return List.generate(
    10,
    (index) => Person(
      id: 'crew_$index',
      name: 'Crew Member $index',
      profilePath: 'https://example.com/profile.jpg',
      role: 'Job Title',
      department: index % 2 == 0 ? 'Directing' : 'Production',
      knownFor: ['Movie 1', 'Movie 2'],
      biography: 'This is a sample biography for the crew member...',
    ),
  );
}