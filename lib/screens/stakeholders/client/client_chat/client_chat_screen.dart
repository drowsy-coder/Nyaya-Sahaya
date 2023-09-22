import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:law/screens/stakeholders/client/client_chat/client_chat_screen.dart';
import 'package:law/screens/stakeholders/lawyer/home/case_details.dart';
import 'package:law/chat/lawyer_client_chat.dart';

class LawyerChatScreen extends StatefulWidget {
  @override
  _LawyerChatScreenState createState() => _LawyerChatScreenState();
}

class _LawyerChatScreenState extends State<LawyerChatScreen> {
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
    // Get the case with ID caseId
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
        title: const Text('Client Chat'), // Change the title to "Client Chat"
      ),
      body: cases.isEmpty
          ? const Center(
              child:
                  Text('No cases available'), // Display message for no clients
            )
          : ListView.builder(
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
                  leading: CircleAvatar(
                    // Profile icon on the left
                    // You can customize this with the client's profile image
                    // For now, it's a simple circle avatar
                    backgroundColor: Colors.blue, // Example background color
                    child: Icon(
                      Icons.person, // You can replace this with a profile image
                      color: Colors.white,
                    ),
                  ),
                  title: Text(clientName), // Display client name
                );
              },
            ),
    );
  }
}
