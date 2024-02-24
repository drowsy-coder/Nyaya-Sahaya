// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../universal chat/chat.dart';

class LawyerChat extends StatefulWidget {
  const LawyerChat({super.key});

  @override
  _LawyerChatState createState() => _LawyerChatState();
}

class _LawyerChatState extends State<LawyerChat> {
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
        .where('lawyerEmail', isEqualTo: currentUser.email)
        .get();

    setState(() {
      cases = casesQuery.docs.toList();
    });
  }

  void _onCaseTap(String caseId, String clientEmail, String clientName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LawyerClientChat(
          recvEmail: clientEmail,
          recvName: clientName,
          senderEmail: currentUser.email!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Clients'),
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
                final clientName = caseData['clientName'] as String;
                final clientEmail = caseData['clientEmail'] as String;
                final caseId = cases[index].id;
                final caseNumber = caseData['caseNumber'] as String;
                return Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    onTap: () {
                      _onCaseTap(caseId, clientEmail, clientName);
                    },
                    leading: const CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      clientName,
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
