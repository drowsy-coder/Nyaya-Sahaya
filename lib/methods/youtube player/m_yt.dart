import 'package:flutter/material.dart';
import 'm_player.dart';

class VideoListScreen extends StatelessWidget {
  const VideoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mental Health Videos',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.grey[900],
      ),
      body: ListView(
        children: const [
          VideoCard(
            videoId: 'rkZl2gsLUp4',
            title: 'Manage your mental health',
            thumbnailUrl: 'assets/images/hq720.jpg',
            description: 'TEDxClapham',
          ),
          VideoCard(
            videoId: 'TFbv757kup4',
            title: 'Becoming Mentally Strong',
            thumbnailUrl: 'assets/images/hqdefault.jpg',
            description: 'TEDxOcala',
          ),
          VideoCard(
            videoId: 'WWloIAQpMcQ',
            title: 'Cope with Anxiety',
            thumbnailUrl: 'assets/images/hqdefault-2.jpg',
            description: 'TEDxUHasselt',
          ),
          VideoCard(
            videoId: 'v1ojZKWfShQ',
            title: 'Eliminate Self Doubt',
            thumbnailUrl: 'assets/images/hqdefault-3.jpg',
            description: 'TEDxClapham',
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

  const VideoCard({super.key, 
    required this.videoId,
    required this.title,
    required this.thumbnailUrl,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(16.0), 
      ),
      child: InkWell(
        onTap: () {
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
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
                16.0),
            gradient: LinearGradient(
              colors: [
                Colors.grey[700]!.withOpacity(0.8),
                Colors.grey[850]!.withOpacity(0.9)
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.8),
                spreadRadius: 4,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset(
                    thumbnailUrl,
                    width: 140,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
