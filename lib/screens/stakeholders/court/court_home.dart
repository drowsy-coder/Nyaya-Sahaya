// ignore_for_file: library_private_types_in_public_api
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../models/hover_card.dart';
import 'court_show_case.dart';

class CourtHome extends StatelessWidget {
  const CourtHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Cases'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(14.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            DashboardHeader(),
            SizedBox(height: 20),
            Text(
              'Hearings Today',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: CourtCaseList(
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
  late String courtEmail;
  int totalCases = 0;
  int todayCases = 0;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      courtEmail = user.email!;
      fetchLawyerIdAndTotalCases();
      fetchTotal();
    }
  }

  Future<void> fetchLawyerIdAndTotalCases() async {
    final currentDate = DateTime.now();
    final currentDateWithoutTime =
        DateTime(currentDate.year, currentDate.month, currentDate.day);
    final formattedDate =
        "${currentDateWithoutTime.year}-${currentDateWithoutTime.month}-0${currentDateWithoutTime.day}";

    final casesQuery = await FirebaseFirestore.instance
        .collection('cases')
        .where('courtEmail', isEqualTo: courtEmail)
        .where('nextHearingDate', isEqualTo: formattedDate)
        .get();

    setState(() {
      todayCases = casesQuery.docs.length;
    });
  }

  Future<void> fetchTotal() async {
    final casesQuery = await FirebaseFirestore.instance
        .collection('cases')
        .where('courtEmail', isEqualTo: courtEmail)
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
        builder: (context) => CourtCaseListScreen(
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
              title: 'Today',
              count: '$todayCases',
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
