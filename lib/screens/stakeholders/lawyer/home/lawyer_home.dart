// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:law/screens/stakeholders/lawyer/home/case_details.dart';
import 'package:law/screens/stakeholders/lawyer/home/show_cases.dart';

import 'place_holder_column.dart';

class LawyerHomePage extends StatelessWidget {
  const LawyerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lawyer Home'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          DashboardHeader(),
          SizedBox(height: 20),
          Text(
            'Clients', // Add the header text here
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: CaseList(
              showClosed: true,
              showOpen: true,
            ),
          ),
        ],
      ),
    );
  }
}
class DashboardHeader extends StatefulWidget {
  const DashboardHeader({super.key});

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
              backgroundColor: Colors.blue,
              textColor: Colors.white,
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
              backgroundColor: Colors.green,
              textColor: Colors.white,
            ),
          ),
          GestureDetector(
            onTap: () {
              navigateToCaseListScreen(context, false, false);
            },
            child: const HoverCard(
              title: 'Cases Closed',
              count: '0',
              icon: Icons.check_circle,
              backgroundColor: Colors.red,
              textColor: Colors.white,
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
  final Color backgroundColor;
  final Color textColor;

  const HoverCard({
    Key? key,
    required this.title,
    required this.count,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
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
      child: SizedBox(
        width: 150,
        child: Card(
          elevation: isHovered ? 10 : 2,
          color: widget.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  widget.icon,
                  size: 48,
                  color: widget.textColor,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: widget.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.count,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: widget.textColor,
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
