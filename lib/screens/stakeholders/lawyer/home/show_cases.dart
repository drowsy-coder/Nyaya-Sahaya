import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nyaya_sahaya/screens/stakeholders/lawyer/home/case_details.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Case List'),
      ),
      body: ListView.builder(
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
      ),
    );
  }
}
