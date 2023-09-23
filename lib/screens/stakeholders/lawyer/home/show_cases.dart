// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:law/screens/stakeholders/lawyer/home/case_details.dart';

class CaseList extends StatefulWidget {
  final bool showClosed;
  final bool showOpen;

  const CaseList({
    super.key,
    required this.showClosed,
    required this.showOpen,
  });

  @override
  _CaseListState createState() => _CaseListState();
}

class _CaseListState extends State<CaseList> {
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

  void _onCaseTap(String caseId) {
    // Navigate to the CaseDetailScreen and pass the caseId
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CaseDetailScreen(caseId: caseId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cases.length,
      itemBuilder: (context, index) {
        final caseData = cases[index].data() as Map<String, dynamic>;
        final clientName = caseData['clientName'] as String;
        final caseId = cases[index].id;

        return ListTile(
          onTap: () {
            // When a list item is tapped, open the CaseDetailScreen
            _onCaseTap(caseId);
          },
          title: Text('Client: $clientName'),
          subtitle: Text('Next hearing: ${caseData['nextHearingDate']}'),
        );
      },
    );
  }
}

class CaseListScreen extends StatefulWidget {
  final bool showClosed;
  final bool showOpen;

  const CaseListScreen({
    super.key,
    required this.showClosed,
    required this.showOpen,
  });

  @override
  _CaseListScreenState createState() => _CaseListScreenState();
}

class _CaseListScreenState extends State<CaseListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Case List'),
      ),
      body: CaseList(showClosed: widget.showClosed, showOpen: widget.showOpen),
    );
  }
}
