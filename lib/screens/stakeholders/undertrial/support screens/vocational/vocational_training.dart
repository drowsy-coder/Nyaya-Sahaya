import 'package:flutter/material.dart';

import '../../../../../methods/youtube player/m_player.dart';

class VocationalTrainingScreen extends StatelessWidget {
  const VocationalTrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vocational Training',
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
            videoId: 'kvnbVRlRLgg',
            title: 'Importance of Vocational Training',
            thumbnailUrl: 'assets/images/voc1.jpg',
            description: 'B-ABLE',
          ),
          VideoCard(
            videoId: 'DrpFqBFyi30',
            title: 'Plumbing Work Training',
            thumbnailUrl: 'assets/images/voc2.jpg',
            description: 'PLUMBER SPECIALIST',
          ),
          VideoCard(
            videoId: 'LgXzzu68j7M',
            title: 'Excel Tutorial in 15 min',
            thumbnailUrl: 'assets/images/voc4.jpg',
            description: 'Kevin Stewart',
          ),
          VideoCard(
            videoId: 'bLbUIevOxzY',
            title: 'How To Paint A Room',
            thumbnailUrl: 'assets/images/voc3.jpg',
            description: 'Paint Times',
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
              ], // Grey gradient
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
