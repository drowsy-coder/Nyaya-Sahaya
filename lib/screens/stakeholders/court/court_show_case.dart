// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

class CourtCaseList extends StatefulWidget {
  final bool showClosed;
  final bool showOpen;

  const CourtCaseList({
    super.key,
    required this.showClosed,
    required this.showOpen,
  });

  @override
  _CourtCaseListState createState() => _CourtCaseListState();
}

class _CourtCaseListState extends State<CourtCaseList> {
  final GlobalKey<ExpansionTileCardState> cardA = GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardB = GlobalKey();
  late User currentUser;
  List<DocumentSnapshot> cases = [];

  @override
  void initState() {
    super.initState();
    fetchCases();
  }

  Future<void> fetchCases() async {
    final currentDate = DateTime.now();
    final currentDateWithoutTime =
        DateTime(currentDate.year, currentDate.month, currentDate.day);
    final formattedDate =
        "${currentDateWithoutTime.year}-${currentDateWithoutTime.month}-0${currentDateWithoutTime.day}";

    currentUser = FirebaseAuth.instance.currentUser!;

    final casesQuery = await FirebaseFirestore.instance
        .collection('cases')
        .where('courtEmail', isEqualTo: currentUser.email)
        .where('nextHearingDate', isEqualTo: formattedDate)
        .get();

    setState(() {
      cases = casesQuery.docs.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cases.length,
      itemBuilder: (context, index) {
        final caseData = cases[index].data() as Map<String, dynamic>;
        final clientName = caseData['clientName'] as String;
        final nextHearingDate = caseData['nextHearingDate'] as String;
        final ipc = caseData['ipcSections'] ?? 'N/A';
        final lawyer = caseData['lawyerName'] ?? 'N/A';
        final judge = caseData['judgeName'] ?? 'N/A';
        final caseNumber = caseData['caseNumber'] ?? 'N/A';
        return Card(
          margin: const EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: InkWell(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ExpansionTileCard(
                leading: CircleAvatar(child: Text(caseNumber)),
                title: Text(
                  clientName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Next Hearing: $nextHearingDate',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                children: <Widget>[
                  const Divider(
                    thickness: 1.0,
                    height: 1.0,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                              text: '• ',
                            ),
                            const TextSpan(
                              text: 'Client Name: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            TextSpan(text: '$clientName\n'),
                            const TextSpan(
                              text: '• ',
                            ),
                            const TextSpan(
                              text: 'Next Hearing Date: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            TextSpan(text: '$nextHearingDate\n'),
                            const TextSpan(
                              text: '• ',
                            ),
                            const TextSpan(
                              text: 'IPC Section: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(text: '$ipc\n'),
                            const TextSpan(
                              text: '• ',
                            ),
                            const TextSpan(
                              text: 'Case Status: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const TextSpan(text: 'Ongoing\n'),
                            const TextSpan(
                              text: '• ',
                            ),
                            const TextSpan(
                              text: 'Lawyer: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            TextSpan(text: '$lawyer\n'),
                            const TextSpan(
                              text: '• ',
                            ),
                            const TextSpan(
                              text: 'Judge: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            TextSpan(text: '$judge\n'),
                          ],
                        ),
                      ),
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

class CourtCaseListScreen extends StatefulWidget {
  final bool showClosed;
  final bool showOpen;

  const CourtCaseListScreen({
    super.key,
    required this.showClosed,
    required this.showOpen,
  });

  @override
  _CourtCaseListScreenState createState() => _CourtCaseListScreenState();
}

class _CourtCaseListScreenState extends State<CourtCaseListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Case List'),
      ),
      body: CourtCaseList(
          showClosed: widget.showClosed, showOpen: widget.showOpen),
    );
  }
}
