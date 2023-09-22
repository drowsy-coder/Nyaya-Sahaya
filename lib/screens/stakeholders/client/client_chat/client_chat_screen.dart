import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:law/chat/lawyer_client_chat.dart';

class ClientChatScreen extends StatefulWidget {
  @override
  _ClientChatScreenState createState() => _ClientChatScreenState();
}

class _ClientChatScreenState extends State<ClientChatScreen> {
  late User currentUser; // To store the current user
  String lawyerName = ''; // Initialize lawyerName
  List<DocumentSnapshot> cases = []; // To store the filtered cases

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

    // Filter cases based on the logged-in user's email matching the clientEmail
    setState(() {
      cases = casesQuery.docs.toList();
    });
  }

  Future<void> _onCaseTap(String caseId, String clientName) async {
    // Get the case from the caseId
    final caseData = cases.firstWhere((element) => element.id == caseId);
    // Get the lawyerId
    final lawyerId = caseData['lawyerId'] as String;
    // Get the user where userId is equal to lawyerId
    final lawyerDataSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(lawyerId)
        .get();

    if (lawyerDataSnapshot.exists) {
      // Check if the lawyerDataSnapshot exists
      final lawyerData = lawyerDataSnapshot.data() as Map<String, dynamic>;
      // Get the lawyerName from the lawyerData
      lawyerName = lawyerData['name'] as String;

      // Navigate to the LawyerClientChat screen with appropriate data
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LawyerClientChat(
            recvEmail: lawyerData['email'], // Current user's email
            recvName: lawyerName, // Client's name
            senderEmail: currentUser.email!,
          ),
        ),
      );
    } else {
      // Handle the case where the lawyer data doesn't exist
      print('Lawyer data not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Chat'), // Change the title to "Client Chat"
      ),
      body: cases.isEmpty
          ? const Center(
              child: Text('No cases available'), // Display message for no cases
            )
          : ListView.builder(
              itemCount: cases.length,
              itemBuilder: (context, index) {
                final caseData = cases[index].data() as Map<String, dynamic>;
                final clientName = caseData['clientName'] as String;
                final caseId = cases[index].id;

                return ListTile(
                  onTap: () async {
                    // When a list item is tapped, open the LawyerClientChat screen
                    await _onCaseTap(caseId, clientName);
                    // Ensure that _onCaseTap is awaited before rebuilding the UI
                    setState(() {});
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
                  title: Text(lawyerName), // Display client name
                );
              },
            ),
    );
  }
}
