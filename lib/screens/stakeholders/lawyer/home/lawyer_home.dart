import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nyaya_sahaya/screens/stakeholders/lawyer/home/show_cases.dart';

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

class DashboardHeader extends StatefulWidget {
  const DashboardHeader({Key? key});

  @override
  _DashboardHeaderState createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  late String lawyerId;
  int totalCases = 0; // Initialize totalCases with 0

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      lawyerId = user.uid;
      fetchLawyerIdAndTotalCases();
    }
  }

  Future<void> fetchLawyerIdAndTotalCases() async {
    print(lawyerId);
    final casesQuery = await FirebaseFirestore.instance
        .collection('cases')
        .where('lawyerId', isEqualTo: lawyerId)
        .get();

    // Set the totalCases to the length of the documents returned
    setState(() {
      totalCases = casesQuery.docs.length;
    });
  }

  void navigateToCaseListScreen(
      BuildContext context, bool showClosed, bool showOpen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CaseListScreen(
          showClosed: showClosed,
          showOpen: showOpen,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              navigateToCaseListScreen(context, false, true);
            },
            child: HoverCard(
              title: 'Cases Pending',
              count: '$totalCases',
              icon: Icons.timer,
            ),
          ),
          GestureDetector(
            onTap: () {
              navigateToCaseListScreen(context, true, true);
            },
            child: HoverCard(
              title: 'Total Cases',
              count: '$totalCases',
              icon: Icons.folder,
            ),
          ),
          GestureDetector(
            onTap: () {
              navigateToCaseListScreen(context, false, false);
            },
            child: HoverCard(
              title: 'Cases Closed',
              count: '0',
              icon: Icons.check_circle,
            ),
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

  HoverCard({
    Key? key,
    required this.title,
    required this.count,
    required this.icon,
  }) : super(key: key);

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
