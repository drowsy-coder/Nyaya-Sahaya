// ignore_for_file: library_private_types_in_public_api
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import '../../../../models/hover_card.dart';
import 'show_cases.dart';

class LawyerHome extends StatelessWidget {
  const LawyerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lawyer Home'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(14.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            DashboardHeader(),
            SizedBox(height: 20),
            Text(
              'Clients',
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
  late String lawyerEmail;
  int totalCases = 0;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      lawyerEmail = user.email!;
      fetchLawyerIdAndTotalCases();
    }
  }

  Future<void> fetchLawyerIdAndTotalCases() async {
    final casesQuery = await FirebaseFirestore.instance
        .collection('cases')
        .where('lawyerEmail', isEqualTo: lawyerEmail)
        .get();
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
              title: 'Pending',
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
