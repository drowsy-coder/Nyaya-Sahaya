import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as html;
import 'package:url_launcher/url_launcher.dart';

class LawyerReadScreen extends StatelessWidget {
  const LawyerReadScreen({Key? key}) : super(key: key);

  Future<Map<String, dynamic>> fetchArticleDetails(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final document = htmlParser.parse(response.body);
        final title = document.querySelector('title')?.text;
        final thumbnail = document
            .querySelector('meta[property="og:image"]')
            ?.attributes['content'];

        return {
          'title': title ?? 'No Title',
          'thumbnail': thumbnail ?? '',
          'url': url,
        };
      } else {
        throw Exception('Failed to load article details');
      }
    } catch (e) {
      throw Exception('Failed to fetch article details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article Cards Example'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: <Widget>[
          FutureBuilder<Map<String, dynamic>>(
            future: fetchArticleDetails(
                'https://www.livelaw.in/supreme-court/certified-copy-can-be-produced-to-prove-original-sale-deed-in-trial-supreme-court-238454'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.network(snapshot.data!['thumbnail']),
                    title: Text(snapshot.data!['title']),
                    onTap: () {
                      _launchURL(snapshot.data!['url']);
                    },
                  ),
                );
              } else {
                return Text('No data available');
              }
            },
          ),
          // Add more ArticleCard instances as needed
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: LawyerReadScreen(),
  ));
}
