import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class MediaScreen extends StatefulWidget {
  final String title;
  final String videoUrl;
  final String thumbnailUrl;
  final String type; // 'trailer', 'clip', 'behindScenes'

  const MediaScreen({
    super.key,
    required this.title,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.type,
  });

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    
    try {
      await _videoPlayerController.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        placeholder: Image.network(
          widget.thumbnailUrl,
          fit: BoxFit.cover,
        ),
      );
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      // Handle initialization error
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: _isInitialized
                  ? Chewie(controller: _chewieController!)
                  : const Center(child: CircularProgressIndicator()),
            ),
            Expanded(
              child: _buildRelatedVideos(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatedVideos() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // Replace with actual related videos count
      itemBuilder: (context, index) {
        return _buildVideoCard(
          title: 'Related Video ${index + 1}',
          duration: '2:30',
          thumbnailUrl: 'https://example.com/thumbnail.jpg',
          onTap: () {
            // Handle related video tap
          },
        );
      },
    );
  }

  Widget _buildVideoCard({
    required String title,
    required String duration,
    required String thumbnailUrl,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Stack(
              children: const [],
            ),
          ],
        ),
      ),
    );
  }
} 