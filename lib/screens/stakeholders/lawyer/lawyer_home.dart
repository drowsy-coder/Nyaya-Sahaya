import 'package:flutter/material.dart';

class LawyerHomePage extends StatelessWidget {
  const LawyerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lawyer Home'),
        ),
        body: const Column(
          children: [
            SizedBox(height: 20),
            DashboardHeader(),
            SizedBox(height: 20),
            Expanded(
              child: PlaceholderCardsColumn(),
            ),
          ],
        ));
  }
}

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          HoverCard(
            title: 'Cases Pending',
            count: '15',
            icon: Icons.timer,
          ),
          HoverCard(
            title: 'Total Cases',
            count: '50',
            icon: Icons.folder,
          ),
          HoverCard(
            title: 'Cases Closed',
            count: '35',
            icon: Icons.check_circle,
          ),
        ],
      ),
    );
  }
}

class HoverCard extends StatefulWidget {
  final String title;
  final String count;
  final IconData icon;

  HoverCard(
      {super.key,
      required this.title,
      required this.count,
      required this.icon});

  @override
  _HoverCardState createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: Container(
        width: 150, // Adjust the width as needed
        child: Card(
          elevation: isHovered ? 10 : 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  widget.icon,
                  size: 48,
                  color: Colors.blue,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.count,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlaceholderCardsColumn extends StatelessWidget {
  const PlaceholderCardsColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PlaceholderCard(
            title: 'Card 1',
            description: 'Description 1',
          ),
          PlaceholderCard(
            title: 'Card 2',
            description: 'Description 2',
          ),
          PlaceholderCard(
            title: 'Card 3',
            description: 'Description 3',
          ),
          PlaceholderCard(
            title: 'Card 4',
            description: 'Description 4',
          ),
          PlaceholderCard(
            title: 'Card 5',
            description: 'Description 5',
          ),
          PlaceholderCard(
            title: 'Card 6',
            description: 'Description 6',
          ),
          PlaceholderCard(
            title: 'Card 7',
            description: 'Description 7',
          ),
        ],
      ),
    );
  }
}

class PlaceholderCard extends StatelessWidget {
  final String title;
  final String description;

  PlaceholderCard({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
