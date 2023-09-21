import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CaseDetailScreen extends StatelessWidget {
  final String caseId;

  CaseDetailScreen({required this.caseId});

  Future<DocumentSnapshot> fetchCaseDetails() async {
    try {
      final caseDocument = await FirebaseFirestore.instance
          .collection('cases')
          .doc(caseId)
          .get();
      return caseDocument;
    } catch (e) {
      // Handle any potential errors, e.g., Firestore exception
      print('Error fetching case details: $e');
      throw e;
    }
  }

  Widget _buildSectionInfoCard(String title, String content) {
    return Container(
      width:
          double.infinity, // Make the card stretch to the whole screen width.
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey[300], // Background color for the card (grey).
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color.
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // Offset of the shadow.
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Text color for the title (black).
              ),
            ),
            SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black, // Text color for the content (black).
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Case Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: fetchCaseDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for data to load, you can display a loading indicator.
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there's an error fetching the data, display an error message.
            return Center(
              child: Text('Error loading case details: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            // If no data or the document does not exist, display a message.
            return Center(child: Text('Case not found.'));
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
