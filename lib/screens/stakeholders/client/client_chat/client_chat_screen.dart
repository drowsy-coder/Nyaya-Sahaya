import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:law/chat/lawyer_client_chat.dart';

class ClientChatScreen extends StatefulWidget {
  const ClientChatScreen({super.key});

  @override
  _ClientChatScreenState createState() => _ClientChatScreenState();
}

class _ClientChatScreenState extends State<ClientChatScreen> {
  late User currentUser;
  String lawyerName = '';
  List<DocumentSnapshot> cases = [];

  @override
  void initState() {
    super.initState();
    fetchCases();
  }

  Future<void> fetchCases() async {
    currentUser = FirebaseAuth.instance.currentUser!;
    print(currentUser.email!); // Move this line after initializing currentUser

    // Query Firestore to get all cases where clientEmail matches the current user's email
    final casesQuery = await FirebaseFirestore.instance
        .collection('cases')
        .where('clientEmail', isEqualTo: currentUser.email)
        .get();

    final lawyerId = casesQuery.docs.toList()[0]['lawyerId'] as String;
    // Get the user where userId is equal to lawyerId
    final lawyerDataSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(lawyerId)
        .get();
    final lawyerData = lawyerDataSnapshot.data() as Map<String, dynamic>;
    // Get the lawyerName from the lawyerData
    lawyerName = lawyerData['name'] as String;

    // Filter cases based on the logged-in user's email matching the clientEmail
    setState(() {
      cases = casesQuery.docs.toList();
    });
  }

  Future<void> _onCaseTap(String caseId, String clientName) async {
    final caseData = cases.firstWhere((element) => element.id == caseId);
    final lawyerId = caseData['lawyerId'] as String;
    final lawyerDataSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(lawyerId)
        .get();

    if (lawyerDataSnapshot.exists) {
      final lawyerData = lawyerDataSnapshot.data() as Map<String, dynamic>;
      lawyerName = lawyerData['name'] as String;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LawyerClientChat(
            recvEmail: lawyerData['email'],
            recvName: lawyerName,
            senderEmail: currentUser.email!,
          ),
        ),
      );
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Chat'),
      ),
      body: cases.isEmpty
          ? const Center(
              child: Text('No cases available'),
            )
          : ListView.builder(
              itemCount: cases.length,
              itemBuilder: (context, index) {
                final caseData = cases[index].data() as Map<String, dynamic>;
                final clientName = caseData['clientName'] as String;
                final caseId = cases[index].id;

                return ListTile(
                  onTap: () async {
                    await _onCaseTap(caseId, clientName);
                    setState(() {});
                  },
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(lawyerName),
                );
              },
            ),
    );
  }
}
