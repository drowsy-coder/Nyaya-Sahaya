import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:law/chat/lawyer_client_chat.dart';

class LawyerChatScreen extends StatefulWidget {
  @override
  _LawyerChatScreenState createState() => _LawyerChatScreenState();
}

class _LawyerChatScreenState extends State<LawyerChatScreen> {
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
    final caseData = cases.firstWhere((element) => element.id == caseId);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LawyerClientChat(
          recvEmail: caseData['clientEmail'],
          recvName: caseData['clientName'],
          senderEmail: currentUser.email!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Chat'),
      ),
      body: cases.isEmpty
          ? const Center(
              child: Text('No clients available'),
            )
          : ListView.builder(
              itemCount: cases.length,
              itemBuilder: (context, index) {
                final caseData = cases[index].data() as Map<String, dynamic>;
                final clientName = caseData['clientName'] as String;
                final caseId = cases[index].id;

                return ListTile(
                  onTap: () {
                    _onCaseTap(caseId);
                  },
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(clientName),
                );
              },
            ),
    );
  }
}
