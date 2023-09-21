import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LawyerAddCase extends StatefulWidget {
  @override
  _LawyerAddCaseState createState() => _LawyerAddCaseState();
}

class _LawyerAddCaseState extends State<LawyerAddCase> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _clientEmailController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _ipcSectionsController = TextEditingController();
  final TextEditingController _nextHearingDateController =
      TextEditingController();
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    ))!;
    if (picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        _nextHearingDateController.text = "${picked.toLocal()}"
            .split(' ')[0]; 
      });
  }

  void _submitCase() async {
    if (_formKey.currentState!.validate()) {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final String lawyerName = user.displayName ?? "Lawyer Name";
        final String lawyerId = user.uid;

        final String clientEmail = _clientEmailController.text.trim();
        final String clientName = _clientNameController.text.trim();
        final String ipcSections = _ipcSectionsController.text.trim();
        final String nextHearingDate = _nextHearingDateController.text.trim();

        try {
          await FirebaseFirestore.instance.collection('cases').add({
            'lawyerName': lawyerName,
            'lawyerId': lawyerId,
            'clientEmail': clientEmail,
            'clientName': clientName,
            'ipcSections': ipcSections,
            'nextHearingDate': nextHearingDate,
          });

          // Reset the form after successful submission
          _clientEmailController.clear();
          _clientNameController.clear();
          _ipcSectionsController.clear();
          _nextHearingDateController.clear();
          _selectedDate = null;
        } catch (error) {
          // Handle any potential errors here
          print('Error adding case: $error');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _clientEmailController,
              decoration: InputDecoration(
                labelText: 'Client Email',
                border: OutlineInputBorder(),
                filled: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the client\'s email';
                }
                // Add additional validation if needed
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _clientNameController,
              decoration: InputDecoration(
                labelText: 'Client Name',
                border: OutlineInputBorder(),
                filled: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the client\'s name';
                }
                // Add additional validation if needed
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _ipcSectionsController,
              decoration: InputDecoration(
                labelText: 'IPC Sections Violated',
                border: OutlineInputBorder(),
                filled: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the IPC sections violated';
                }
                // Add additional validation if needed
                return null;
              },
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _nextHearingDateController,
                  decoration: InputDecoration(
                    labelText: 'Next Hearing Date',
                    border: OutlineInputBorder(),
                    filled: true,
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select the next hearing date';
                    }
                    // Add additional validation if needed
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitCase,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
