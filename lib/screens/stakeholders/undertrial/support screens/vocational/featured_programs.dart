// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeaturedScreen extends StatefulWidget {
  const FeaturedScreen({super.key});

  @override
  _FeaturedScreenState createState() => _FeaturedScreenState();
}

class _FeaturedScreenState extends State<FeaturedScreen> {
  List<Map<String, dynamic>> articleDetailsList = [
    {
      'title': 'IGNOU LSC',
      'image': 'assets/images/ignou0.png',
      'url':
          'http://www.ignou.ac.in/ignou/aboutignou/division/rsd/activities/detail/206'
    },
    {
      'title': 'Prison Reforms',
      'image': 'assets/images/haryana-prisons-logo-1.png',
      'url': 'https://haryanaprisons.gov.in/prison-reforms'
    },
    {
      'title': 'DOJ',
      'image': 'assets/images/doj.png',
      'url':
          'https://www.ojp.gov/ncjrs/virtual-library/abstracts/prison-education-india'
    },
    {
      'title': 'Training Manual of Basic Course for Prison Officers 2017',
      'image': 'assets/images/bprd.png',
      'url':
          'https://bprd.nic.in/WriteReadData/CMS/Training%20Manual%20Prison%20Officers.pdf'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Featured Programs'),
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
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    article['image'],
                    width: 100,
                    height: 199,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  article['title'],
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
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
}