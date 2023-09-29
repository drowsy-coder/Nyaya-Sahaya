import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:law/screens/stakeholders/lawyer/bail_app.dart';

class LawyerAddCase extends StatefulWidget {
  const LawyerAddCase({Key? key});

  @override
  // ignore: library_private_types_in_public_api
  _LawyerAddCaseState createState() => _LawyerAddCaseState();
}

class _LawyerAddCaseState extends State<LawyerAddCase> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _caseIdController = TextEditingController();
  final TextEditingController _dateOfFilingController = TextEditingController();
  final TextEditingController _completedHearingsController =
      TextEditingController();
  final TextEditingController _adjournmentsController = TextEditingController();
  final TextEditingController _advocatesController = TextEditingController();

  // Calculate the coefficient based on the formula
  double calculateCoefficient(Map<String, dynamic> caseData, int totalEntries) {
    // Extract necessary data from caseData map
    // String caseId = caseData['caseId'];
    String dateOfFiling = caseData['dateOfFiling'];
    int completedHearings = caseData['completedHearings'];
    int adjournments = caseData['adjournments'];
    int advocates = caseData['advocates'];

    // Calculate the time difference score (assuming you have the logic for it)
    int timeDifferenceScore = DateTime.now().millisecondsSinceEpoch -
        DateTime.parse(dateOfFiling).millisecondsSinceEpoch;

    // Calculate coefficient using the provided formula
    double coefficient = (timeDifferenceScore + (totalEntries * 0.2) + completedHearings + adjournments + advocates) ;

    return coefficient;
  }

  // Sort cases based on coefficient
  List<DocumentSnapshot> sortCases(List<DocumentSnapshot> cases) {
    return cases
      ..sort((a, b) {
        double coefficientA = calculateCoefficient(
            a.data() as Map<String, dynamic>, cases.length);
        double coefficientB = calculateCoefficient(
            b.data() as Map<String, dynamic>, cases.length);
        return coefficientA.compareTo(coefficientB);
      });
  }

  void _submitCase() async {
    if (_formKey.currentState!.validate()) {
      // Implement Firebase Firestore code to store case details
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final String lawyerId = user.uid;

        final String caseId = _caseIdController.text.trim();
        final String dateOfFiling = _dateOfFilingController.text.trim();
        int completedHearings =
            int.tryParse(_completedHearingsController.text) ?? 0;
        int adjournments = int.tryParse(_adjournmentsController.text) ?? 0;
        int advocates = int.tryParse(_advocatesController.text) ?? 0;

        try {
          final DocumentSnapshot userData = await FirebaseFirestore.instance
              .collection('users')
              .doc(lawyerId)
              .get();
          final String lawyerName = userData['name'];

          // Store the case details in Firebase Firestore
          await FirebaseFirestore.instance.collection('cases').add({
            'lawyerName': lawyerName,
            'lawyerId': lawyerId,
            'caseId': caseId,
            'dateOfFiling': dateOfFiling,
            'completedHearings': completedHearings,
            'adjournments': adjournments,
            'advocates': advocates,
          });

          _caseIdController.clear();
          _dateOfFilingController.clear();
          _completedHearingsController.clear();
          _adjournmentsController.clear();
          _advocatesController.clear();
        } catch (error) {
          print(error.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text('Add Case',
            style: TextStyle(
                fontFamily: 'Pacifico',
                color: Colors.black,
                fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BailAppView()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ... Existing code for form fields

                // Replace the StreamBuilder widget with the following:
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('cases')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }

                    List<DocumentSnapshot> cases = snapshot.data!.docs;

                    // Sort cases based on coefficient
                    cases = sortCases(cases);

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: cases.length,
                      itemBuilder: (context, index) {
                        final caseData =
                            cases[index].data() as Map<String, dynamic>;

                        double coefficient =
                            calculateCoefficient(caseData, cases.length);

                        return ListTile(
                          title: Text("Case ID: ${caseData['caseId']}"),
                          subtitle: Text("Coefficient: $coefficient"),
                          // Display other case details as needed
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
