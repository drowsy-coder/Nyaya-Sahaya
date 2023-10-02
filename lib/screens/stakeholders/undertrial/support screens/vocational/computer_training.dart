import 'package:flutter/material.dart';

import '../../../../../methods/youtube player/m_player.dart';

class ComputerTrainingScreen extends StatelessWidget {
  const ComputerTrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Computer Training',
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
            videoId: 'y2kg3MOk1sY',
            title: 'Computer Technology Basics',
            thumbnailUrl: 'assets/images/ct1.jpg',
            description: 'freeCodeCamp',
          ),
          VideoCard(
            videoId: 'S-nHYzK-BVg',
            title: 'Microsoft Word for beginners',
            thumbnailUrl: 'assets/images/ct2.jpg',
            description: 'Technology for Teachers and Students',
          ),
          VideoCard(
            videoId: 'LgXzzu68j7M',
            title: 'Excel Tutorial in 15 min',
            thumbnailUrl: 'assets/images/voc4.jpg',
            description: 'Kevin Stewart',
          ),
          VideoCard(
            videoId: 'LxgheItBIzQ',
            title: 'Top 15 Microsoft Word Tips & Tricks',
            thumbnailUrl: 'assets/images/ct4.jpg',
            description: 'Kevin Stewart',
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
