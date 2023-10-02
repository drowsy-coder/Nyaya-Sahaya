// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../universal chat/chat.dart';

class UTChat extends StatefulWidget {
  const UTChat({super.key});

  @override
  _UTChatState createState() => _UTChatState();
}

class _UTChatState extends State<UTChat> {
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
        .where('clientEmail', isEqualTo: currentUser.email)
        .get();

    setState(() {
      cases = casesQuery.docs.toList();
    });
  }

  Future<void> _onCaseTap(
      String caseId, String lawyerEmail, String lawyerName) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LawyerClientChat(
          recvEmail: lawyerEmail,
          senderEmail: currentUser.email!,
          recvName: lawyerName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Lawyer'),
      ),
      body: cases.isEmpty
          ? const Center(
              child: Text(
                'No clients available',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            )
          : ListView.builder(
              itemCount: cases.length,
              itemBuilder: (context, index) {
                final caseData = cases[index].data() as Map<String, dynamic>;
                final lawyerName = caseData['lawyerName'] as String;
                final caseId = cases[index].id;
                final caseNumber = caseData['caseNumber'] as String;
                final lawyerEmail = caseData['lawyerEmail'] as String;
                return Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    onTap: () {
                      _onCaseTap(caseId, lawyerEmail, lawyerName);
                    },
                    leading: const CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      lawyerName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Case Number: $caseNumber',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
