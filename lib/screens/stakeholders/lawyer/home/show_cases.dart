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
  late User currentUser;
  List<DocumentSnapshot> cases = [];

  @override
  void initState() {
    super.initState();
    fetchCases();
  }

  Future<void> fetchCases() async {
    currentUser = FirebaseAuth.instance.currentUser!;
    final casesQuery = await FirebaseFirestore.instance
        .collection('cases')
        .where('lawyerId', isEqualTo: currentUser.uid)
        .get();
    setState(() {
      cases = casesQuery.docs.toList();
    });
  }

  void _onCaseTap(String caseId) {
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
        final nextHearingDate = caseData['nextHearingDate'] as String;
        final caseId = cases[index].id;

        return Card(
          elevation: 3,
          margin: const EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: InkWell(
            onTap: () {
              _onCaseTap(caseId);
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clientName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Next hearing: $nextHearingDate',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
