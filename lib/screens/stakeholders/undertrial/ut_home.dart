// ignore_for_file: library_private_types_in_public_api

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:law_help/screens/stakeholders/undertrial/fir_analyser.dart';
import 'support screens/no_case.dart';

class UTHome extends StatefulWidget {
  const UTHome({super.key});

  @override
  _UTHomeState createState() => _UTHomeState();
}

class _UTHomeState extends State<UTHome> {
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CaseInfoAnalyzer(),
                    ),
                  );
                },
                icon: const Icon(Icons.find_in_page),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildHeaderCard(document),
                const SizedBox(
                  height: 60,
                ),
                _buildAnimatedSection(document),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderCard(QueryDocumentSnapshot document) {
    return Container(
      margin: const EdgeInsets.only(
        top: 24.0,
        left: 16.0,
        right: 16.0,
      ),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF333333), Color(0xFF111111)],
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildSectionInfo("IPC Section:", document['ipcSections'],
              'assets/images/orange-error-icon-0.png'),
          _buildSectionInfo(
              "Lawyer:", document['lawyerName'], 'assets/images/3731686.png'),
          _buildSectionInfo(
              "Judge:", document['judgeName'], 'assets/images/judge.png'),
          _buildSectionInfo("Next Hearing:", document['nextHearingDate'],
              'assets/images/schedule.png'),
          _buildSectionInfo(
              "Case Status:", "Ongoing", 'assets/images/loading.png'),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionInfo(String title, String content, String imagePath) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            imagePath,
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  children: [
                    TextSpan(
                      text: '$title ',
                    ),
                    TextSpan(
                      text: content,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedSection(QueryDocumentSnapshot document) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      margin: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16.0),
                bottomLeft: Radius.circular(16.0),
              ),
              child: Image.asset(
                'assets/images/courtN.png',
                width: 100,
                height: 100,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Next Hearing',
                        textStyle: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[400]!,
                        ),
                        speed: const Duration(milliseconds: 120),
                      ),
                    ],
                    isRepeatingAnimation: false,
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Date: ',
                        ),
                        TextSpan(
                          text: document['nextHearingDate'],
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: 'Time: ',
                        ),
                        TextSpan(
                          text: '10:00 AM',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                      children: [
                        TextSpan(
                          text: 'Location: ',
                        ),
                        TextSpan(
                          text: 'Bilaspur HC',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
