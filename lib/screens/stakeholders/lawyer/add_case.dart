// ignore_for_file: library_private_types_in_public_api, empty_catches

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class LawyerAddCase extends StatefulWidget {
  const LawyerAddCase({super.key});

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
    if (picked != _selectedDate) {
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
        final String lawyerId = user.uid;

        final String clientEmail = _clientEmailController.text.trim();
        final String clientName = _clientNameController.text.trim();
        final String ipcSections = _ipcSectionsController.text.trim();
        final String nextHearingDate = _nextHearingDateController.text.trim();

        try {
          final DocumentSnapshot userData = await FirebaseFirestore.instance
              .collection('users')
              .doc(lawyerId)
              .get();
          final String lawyerName = userData['name'];

          await FirebaseFirestore.instance.collection('cases').add({
            'lawyerName': lawyerName,
            'lawyerId': lawyerId,
            'clientEmail': clientEmail,
            'clientName': clientName,
            'ipcSections': ipcSections,
            'nextHearingDate': nextHearingDate,
          });
          _clientEmailController.clear();
          _clientNameController.clear();
          _ipcSectionsController.clear();
          _nextHearingDateController.clear();
          _selectedDate = null;
        } catch (error) {
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Case'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Image.asset('assets/images/2689736.png',
                        height: 120, width: 120),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              Container(
                width: 380,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[900],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[800]!,
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _clientEmailController,
                        decoration: InputDecoration(
                          labelText: 'Client Email',
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[900],
                          icon: const Icon(Icons.email, color: Colors.blue),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the client\'s email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _clientNameController,
                        decoration: InputDecoration(
                          labelText: 'Client Name',
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[900],
                          icon: const Icon(Icons.person, color: Colors.red),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the client\'s name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _ipcSectionsController,
                        decoration: InputDecoration(
                          labelText: 'IPC Sections Violated',
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[900],
                          icon: const Icon(Icons.assignment,
                              color: Colors.yellow),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the IPC sections violated';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _nextHearingDateController,
                            decoration: InputDecoration(
                              labelText: 'Next Hearing Date',
                              border: const OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.grey[900],
                              suffixIcon: const Icon(Icons.calendar_today,
                                  color: Colors.green),
                              icon: const Icon(Icons.date_range,
                                  color: Colors.white),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select the next hearing date';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitCase,
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.purple),
                        ),
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
