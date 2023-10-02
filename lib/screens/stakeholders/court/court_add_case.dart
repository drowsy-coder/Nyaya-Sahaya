// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../login/login_method.dart';

class CourtAddCase extends StatefulWidget {
  const CourtAddCase({super.key});

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

  bool _clientEmailFocused = false;
  bool _lawyerEmailFocused = false;
  bool _clientNameFocused = false;
  bool _ipcSectionsFocused = false;
  bool _nextHearingDateFocused = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _logout(BuildContext context) async {
    await _auth.signOut();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('uid');
    prefs.remove('email');
    prefs.remove('caseNumber');
    prefs.remove('isLoggedIn');

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

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
          print('Error: $error');
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Case'),
        actions: [
          IconButton(
              onPressed: () {
                _logout(context);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image.asset('assets/images/2689736-2.png',
                      height: 140, width: 140),
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
                          labelText: 'Undertrial Email',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: _clientEmailFocused ? 3 : 1,
                              color: Colors.lightBlueAccent,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[900],
                          icon: const Icon(
                            Icons.email,
                            color: Colors.lightBlueAccent,
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the client\'s email';
                        }
                        return null;
                      },
                      onTap: () {
                        setState(() {
                          _clientEmailFocused = true;
                          _clientNameFocused = false;
                          _ipcSectionsFocused = false;
                          _nextHearingDateFocused = false;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _caseNumberController,
                      decoration: InputDecoration(
                          labelText: 'Case Number',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: _clientEmailFocused ? 3 : 1,
                              color: Colors.pink,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[900],
                          icon: const Icon(
                            Icons.numbers,
                            color: Colors.pink,
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the client\'s email';
                        }
                        return null;
                      },
                      onTap: () {
                        setState(() {
                          _clientEmailFocused = true;
                          _clientNameFocused = false;
                          _ipcSectionsFocused = false;
                          _nextHearingDateFocused = false;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _lawyerEmailController,
                      decoration: InputDecoration(
                          labelText: 'Lawyer Email',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: _lawyerEmailFocused ? 3 : 1,
                              color: Colors.green,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[900],
                          icon: const Icon(
                            Icons.email,
                            color: Colors.green,
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the lawyer\'s email';
                        }
                        return null;
                      },
                      onTap: () {
                        setState(() {
                          _clientEmailFocused = false;
                          _lawyerEmailFocused = true;
                          _clientNameFocused = false;
                          _ipcSectionsFocused = false;
                          _nextHearingDateFocused = false;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _clientNameController,
                      decoration: InputDecoration(
                        labelText: 'Undertrial Name',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: _clientNameFocused ? 3 : 1,
                            color: Colors.redAccent,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        filled: true,
                        fillColor: Colors.grey[900],
                        icon: const Icon(Icons.person, color: Colors.red),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the Undertrial\'s name';
                        }
                        return null;
                      },
                      onTap: () {
                        setState(() {
                          _clientEmailFocused = false;
                          _clientNameFocused = true;
                          _ipcSectionsFocused = false;
                          _nextHearingDateFocused = false;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _ipcSectionsController,
                      decoration: InputDecoration(
                        labelText: 'IPC Sections Violated',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: _ipcSectionsFocused ? 3 : 1,
                            color: Colors.yellowAccent,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        filled: true,
                        fillColor: Colors.grey[900],
                        icon:
                            const Icon(Icons.assignment, color: Colors.yellow),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the IPC sections violated';
                        }
                        return null;
                      },
                      onTap: () {
                        setState(() {
                          _clientEmailFocused = false;
                          _clientNameFocused = false;
                          _ipcSectionsFocused = true;
                          _nextHearingDateFocused = false;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _nextHearingDateController,
                          decoration: InputDecoration(
                            labelText: 'Next Hearing Date',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: _nextHearingDateFocused ? 3 : 1,
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
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
                          onTap: () {
                            setState(() {
                              _clientEmailFocused = false;
                              _clientNameFocused = false;
                              _ipcSectionsFocused = false;
                              _nextHearingDateFocused = true;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitCase,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.amberAccent),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
