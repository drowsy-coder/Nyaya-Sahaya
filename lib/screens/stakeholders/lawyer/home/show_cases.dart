import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CaseListScreen extends StatefulWidget {
  final bool showClosed;
  final bool showOpen;

  CaseListScreen({
    required this.showClosed,
    required this.showOpen,
  });
  @override
  _CaseListScreenState createState() => _CaseListScreenState();
}

class _CaseListScreenState extends State<CaseListScreen> {
  late User currentUser; // To store the current user
  List<DocumentSnapshot> cases = []; // To store the filtered cases

  @override
  void initState() {
    super.initState();
    fetchCases();
  }

  Future<void> fetchCases() async {
    currentUser = FirebaseAuth.instance.currentUser!;

    // Query Firestore to get all cases
    final casesQuery = await FirebaseFirestore.instance
        .collection('cases')
        .where('lawyerId', isEqualTo: currentUser.uid)
        .get();

    // Filter cases based on the logged-in user's ID matching the lawyerId
    setState(() {
      cases = casesQuery.docs.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Case List'),
      ),
      body: ListView.builder(
        itemCount: cases.length,
        itemBuilder: (context, index) {
          final caseData = cases[index].data() as Map<String, dynamic>;
          final clientName = cases[index]["clientName"];
          // You can display the case data here
          return ListTile(
            title: Text('Client: $clientName'),
            subtitle: Text('Next hearing: ${caseData['nextHearingDate']}'),
            // Add more case details as needed
          );
        },
      ),
    );
  }
}
