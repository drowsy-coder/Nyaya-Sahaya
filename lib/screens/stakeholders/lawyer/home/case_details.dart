// ignore_for_file: use_rethrow_when_possible

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CaseDetailScreen extends StatelessWidget {
  final String caseId;

  const CaseDetailScreen({super.key, required this.caseId});

  Future<DocumentSnapshot> fetchCaseDetails() async {
    try {
      final caseDocument = await FirebaseFirestore.instance
          .collection('cases')
          .doc(caseId)
          .get();
      return caseDocument;
    } catch (e) {
      // Handle any potential errors, e.g., Firestore exception
      throw e;
    }
  }

  Widget _buildSectionInfoCard(String title, String content) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
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
            const Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Colors.blue,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Date: September 23, 2023',
                  style: TextStyle(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Case Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: fetchCaseDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for data to load, you can display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there's an error fetching the data, display an error message.
            return Center(
              child: Text('Error loading case details: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            // If no data or the document does not exist, display a message.
            return const Center(child: Text('Case not found.'));
          } else {
            final caseData = snapshot.data!.data() as Map<String, dynamic>;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildSectionInfoCard(
                    "IPC Section:",
                    caseData['ipcSections'] ?? 'N/A',
                  ),
                  const SizedBox(height: 10),
                  _buildSectionInfoCard(
                    "Lawyer:",
                    caseData['lawyerName'] ?? 'N/A',
                  ),
                  const SizedBox(height: 10),
                  _buildSectionInfoCard("Judge:", "Jane Smith"),
                  const SizedBox(height: 10),
                  _buildSectionInfoCard(
                    "Next Hearing:",
                    caseData['nextHearingDate'] ?? 'N/A',
                  ),
                  const SizedBox(height: 20),
                  _buildSectionInfoCard("Case Status:", "Ongoing"),
                  const SizedBox(height: 20),
                  _buildSectionInfoCard(
                    "Sections Violated:",
                    caseData['ipcSections'] ?? 'N/A',
                  ),
                  const SizedBox(height: 20),
                  // Add more relevant case-related facts or features here.
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
