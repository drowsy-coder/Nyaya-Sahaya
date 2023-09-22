import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
import 'package:url_launcher/url_launcher.dart';

class LawyerReadScreen extends StatefulWidget {
  @override
  _LawyerReadScreenState createState() => _LawyerReadScreenState();
}

class _LawyerReadScreenState extends State<LawyerReadScreen> {
  List<Map<String, dynamic>> articleDetailsList = [
    // Add your article details here
  ];

  Future<void> fetchArticleDetails() async {
    for (var article in articleDetailsList) {
      String url = article['url'];
      try {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final document = htmlParser.parse(response.body);
          final thumbnail = document
              .querySelector('meta[property="og:image"]')
              ?.attributes['content'];

          setState(() {
            article['thumbnail'] = thumbnail ?? '';
          });
        } else {
          throw Exception('Failed to load article details');
        }
      } catch (e) {
        throw Exception('Failed to fetch article details for $url: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchArticleDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Legal News'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: <Widget>[
          for (var article in articleDetailsList)
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: const EdgeInsets.all(10),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: article['thumbnail'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          article['thumbnail'],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                    : SizedBox(
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.image,
                          size: 50,
                        ),
                      ),
                title: Text(
                  article['title'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  _launchURL(article['url']);
                },
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> launchUrl(Uri uri) async {
    final urlString = uri.toString();
    if (await canLaunchUrl(urlString as Uri)) {
      await launchUrl(urlString as Uri);
    } else {
      throw 'Could not launch $urlString';
    }
  }

  Future<bool> canLaunchUrl(Uri uri) async {
    final urlString = uri.toString();
    return await canLaunchUrl(urlString as Uri);
  }
}
