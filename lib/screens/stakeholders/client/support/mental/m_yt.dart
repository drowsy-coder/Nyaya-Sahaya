import 'package:flutter/material.dart';
import 'm_player.dart';

class VideoListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mental Health Videos'),
      ),
      body: ListView(
        children: [
          VideoCard(
            videoId: 'JbaxHSPohrY',
            title: 'Shephard\'s Pie',
            thumbnailUrl: 'thumbnail_url_1',
            description: 'Description for Video 1',
          ),
          VideoCard(
            videoId: 'video_id_2',
            title: 'Video Title 2',
            thumbnailUrl: 'thumbnail_url_2',
            description: 'Description for Video 2',
          ),
          VideoCard(
            videoId: 'video_id_3',
            title: 'Video Title 3',
            thumbnailUrl: 'thumbnail_url_3',
            description: 'Description for Video 3',
          ),
          VideoCard(
            videoId: 'video_id_4',
            title: 'Video Title 4',
            thumbnailUrl: 'thumbnail_url_4',
            description: 'Description for Video 4',
          ),
        ],
      ),
    );
  }
}

class VideoCard extends StatelessWidget {
  final String videoId;
  final String title;
  final String thumbnailUrl;
  final String description;

  VideoCard({
    required this.videoId,
    required this.title,
    required this.thumbnailUrl,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: InkWell(
        onTap: () {
          // Navigate to the player screen with the selected video
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(
                videoId: videoId,
                title: title,
                description: description,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(thumbnailUrl),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
