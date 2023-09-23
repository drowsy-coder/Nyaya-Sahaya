import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:law/screens/stakeholders/client/client_home/no_cases_found.dart';
import 'package:law/screens/stakeholders/client/support/case_info_analyser.dart';

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key});

  @override
  _ClientHomePageState createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  late String clientEmail;
  bool textScanning = false;
  String scannedText = '';

  @override
  void initState() {
    super.initState();
    getClientEmail();
  }

  void getClientEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        clientEmail = user.email!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (clientEmail == null) {
      return const CircularProgressIndicator();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('cases')
          .where('clientEmail', isEqualTo: clientEmail)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const NoCasesFoundScreen();
        }

        final document = snapshot.data!.docs.first;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Case Details'),
            actions: [
              IconButton(
                icon: const Icon(Icons.question_mark),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CaseInfoAnalyzer(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildSectionInfoCard("IPC Section:", document['ipcSections']),
                const SizedBox(height: 10),
                _buildSectionInfoCard("Lawyer:", document['lawyerName']),
                const SizedBox(height: 10),
                _buildSectionInfoCard("Judge:", "Jane Smith"),
                const SizedBox(height: 10),
                _buildSectionInfoCard(
                    "Next Hearing:", document['nextHearingDate']),
                const SizedBox(height: 20),
                _buildSectionInfoCard("Case Status:", "Ongoing"),
                const SizedBox(height: 20),
                _buildSectionInfoCard(
                    "Sections Violated:", document['ipcSections']),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionInfoCard(String title, String content) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF232323), Color(0xFF121212)],
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Colors.blue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Date: September 23, 2023',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
