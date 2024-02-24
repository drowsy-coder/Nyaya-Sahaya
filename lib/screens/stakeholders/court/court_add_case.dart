// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../login/login_method.dart';

class CourtAddCase extends StatefulWidget {
  const CourtAddCase({Key? key}) : super(key: key);

  @override
  _CourtAddCaseState createState() => _CourtAddCaseState();
}

class _CourtAddCaseState extends State<CourtAddCase> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _clientEmailController = TextEditingController();
  final TextEditingController _lawyerEmailController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _caseNumberController = TextEditingController();
  final TextEditingController _ipcSectionsController = TextEditingController();
  final TextEditingController _nextHearingDateController =
      TextEditingController();
  DateTime? _selectedDate;

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('uid');
    prefs.remove('email');
    prefs.remove('caseNumber');
    prefs.remove('isLoggedIn');

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _nextHearingDateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  void _submitCase() async {
    if (_formKey.currentState!.validate()) {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final String courtId = user.uid;
        final String courtEmail = user.email!;
        final String lawyerEmail = _lawyerEmailController.text.trim();
        final String clientEmail = _clientEmailController.text.trim();
        final String caseNumber = _caseNumberController.text.trim();
        final String ipcSections = _ipcSectionsController.text.trim();
        final String nextHearingDate = _nextHearingDateController.text.trim();
        final String clientName = _clientNameController.text.trim();

        try {
          final QuerySnapshot existingCases = await FirebaseFirestore.instance
              .collection('cases')
              .where('courtId', isEqualTo: courtId)
              .where('clientEmail', isEqualTo: clientEmail)
              .get();

          if (existingCases.docs.isNotEmpty) {
            for (QueryDocumentSnapshot doc in existingCases.docs) {
              await FirebaseFirestore.instance
                  .collection('cases')
                  .doc(doc.id)
                  .delete();
            }
          }

          final QuerySnapshot lawyerQuery = await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: lawyerEmail)
              .get();

          if (lawyerQuery.docs.isNotEmpty) {
            final String lawyerName = lawyerQuery.docs[0]['name'];

            final DocumentSnapshot userData = await FirebaseFirestore.instance
                .collection('users')
                .doc(courtId)
                .get();

            final String judgeName = userData['name'];

            await FirebaseFirestore.instance.collection('cases').add({
              'judgeName': judgeName,
              'courtId': courtId,
              'courtEmail': courtEmail,
              'caseNumber': caseNumber,
              'clientEmail': clientEmail,
              'lawyerEmail': lawyerEmail,
              'clientName': clientName,
              'lawyerName': lawyerName,
              'ipcSections': ipcSections,
              'nextHearingDate': nextHearingDate,
            });

            _clientEmailController.clear();
            _clientNameController.clear();
            _lawyerEmailController.clear();
            _ipcSectionsController.clear();
            _nextHearingDateController.clear();
            _selectedDate = null;
          }
        } catch (error) {
          rethrow;
        }
      }
      // Implementation for submitting the case
      // This is where you will handle the form submission logic
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Case'),
        backgroundColor: Colors.deepPurple, // Improved app bar color
        actions: [
          IconButton(
              onPressed: () => _logout(context), icon: const Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        // Allows the form to be scrollable
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/2689736-2.png', height: 140, width: 140),
            const SizedBox(height: 20),
            Card(
              // Using Card for a cleaner look
              elevation: 5,
              shadowColor: Colors.deepPurpleAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.grey[900],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextFormField(
                        controller: _clientEmailController,
                        label: 'Undertrial Email',
                        icon: Icons.email,
                      ),
                      _buildTextFormField(
                        controller: _caseNumberController,
                        label: 'Case Number',
                        icon: Icons.numbers,
                      ),
                      _buildTextFormField(
                        controller: _lawyerEmailController,
                        label: 'Lawyer Email',
                        icon: Icons.email,
                      ),
                      _buildTextFormField(
                        controller: _clientNameController,
                        label: 'Undertrial Name',
                        icon: Icons.person,
                      ),
                      _buildTextFormField(
                        controller: _ipcSectionsController,
                        label: 'IPC Sections Violated',
                        icon: Icons.gavel,
                      ),
                      _buildDateField(
                        label: 'Next Hearing Date',
                        controller: _nextHearingDateController,
                        onTap: () => _selectDate(context),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitCase,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple, // Button color
                        ),
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField(
      {required TextEditingController controller,
      required String label,
      required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          filled: true,
          fillColor: Colors.grey[850],
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDateField(
      {required String label,
      required TextEditingController controller,
      required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: AbsorbPointer(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon:
                  const Icon(Icons.date_range, color: Colors.deepPurple),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              filled: true,
              fillColor: Colors.grey[850],
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select $label';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
