import 'package:flutter/material.dart';

import '../../../../../methods/youtube player/m_player.dart';

class EducationalCoursesScreen extends StatelessWidget {
  const EducationalCoursesScreen({super.key});

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
      body: ListView(children: const [
        VideoCardItem(
          videoId: '_pTU4gwmcMs',
          title: 'Accountancy',
          thumbnailUrl: 'assets/images/accountancy0.webp',
          description: '',
        ),
        VideoCardItem(
          videoId: 'LLdKcFpHgM8',
          title: 'Financial Planning',
          thumbnailUrl: 'assets/images/finance1.webp',
          description: '',
        ),
        VideoCardItem(
          videoId: 'wTWVhB3Tb2M',
          title: 'Cooking',
          thumbnailUrl: 'assets/images/cooking2.webp',
          description: '',
        ),
        VideoCardItem(
          videoId: 'AywrG_JKnjY',
          title: 'Health and Wellness',
          thumbnailUrl: 'assets/images/health3.webp',
          description: '',
        ),
        VideoCardItem(
          videoId: 'srn5jgr9TZo',
          title: 'Communication skills',
          thumbnailUrl: 'assets/images/communication4.webp',
          description: '',
        ),
      ]),
    );
  }
}

class VideoCardItem extends StatelessWidget {
  final String videoId;
  final String title;
  final String thumbnailUrl;
  final String description;

  const VideoCardItem(
      {super.key,
      required this.videoId,
      required this.title,
      required this.thumbnailUrl,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
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
            borderRadius: BorderRadius.circular(16.0),
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
                    width: 180,
                    height: 160,
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
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
