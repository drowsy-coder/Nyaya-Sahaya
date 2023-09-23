import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ComputerTrainingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Computer Training'),
        ),
        body: MyGridView(),
      ),
    );
  }
}

class MyGridView extends StatelessWidget {
  final List<CardItem> cardItems = [
    CardItem(
      image: 'assets/images/cn.jpg',
      header: 'Computer Networks',
      externalLink: 'https://archive.nptel.ac.in/courses/106/105/106105183/',
    ),
    CardItem(
      image: 'assets/images/cpp.jpg',
      header: 'Programming in C++',
      externalLink: 'https://onlinecourses.nptel.ac.in/noc21_cs02/preview',
    ),
    CardItem(
      image: 'assets/images/cao.jpg',
      header: 'Computer Architecture',
      externalLink: 'https://nptel.ac.in/courses/106102062',
    ),
    CardItem(
      image: 'assets/images/computer_graphics.jpg',
      header: 'Computer Graphics',
      externalLink: 'https://nptel.ac.in/courses/106102062',
    ),
    CardItem(
      image: 'assets/images/java_programming.jpg',
      header: 'Java Programming',
      externalLink: 'https://nptel.ac.in/courses/106102062',
    ),
    CardItem(
      image: 'assets/images/dsa.jpg',
      header: 'Data Structures and Algorithms',
      externalLink: 'https://nptel.ac.in/courses/106102062',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
      ),
      itemCount: cardItems.length,
      itemBuilder: (context, index) {
        return MyCard(
          image: cardItems[index].image,
          header: cardItems[index].header,
          onTap: () {
            launch(cardItems[index].externalLink); // Open external link
          },
        );
      },
    );
  }
}

class CardItem {
  final String image;
  final String header;
  final String externalLink;

  CardItem({
    required this.image,
    required this.header,
    required this.externalLink,
  });
}

class MyCard extends StatelessWidget {
  final String image;
  final String header;
  final VoidCallback? onTap;

  MyCard({
    required this.image,
    required this.header,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: onTap, // Invoke the onTap callback when clicked
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.asset(
              image,
              height: 130,
              width: double.infinity,
              fit: BoxFit
                  .cover, // Ensure the image fits within the available space
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                header,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
