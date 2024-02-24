import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CourtManage extends StatefulWidget {
  const CourtManage({super.key});

  @override
  State<CourtManage> createState() => _CourtManageState();
}

class _CourtManageState extends State<CourtManage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _caseIdController = TextEditingController();
  final TextEditingController _dateOfFilingController = TextEditingController();
  final TextEditingController _completedHearingsController =
      TextEditingController();
  final TextEditingController _adjournmentsController = TextEditingController();
  final TextEditingController _advocatesController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000, 1),
      lastDate: DateTime.now(),
    ))!;
    if (picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateOfFilingController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  double calculateCoefficient(Map<String, dynamic> caseData, int totalEntries) {
    int timeDifferenceScore = DateTime.now().millisecondsSinceEpoch -
        DateTime.parse(caseData['dateOfFiling']).millisecondsSinceEpoch;

    double coefficient = (timeDifferenceScore +
        caseData['completedHearings'] +
        caseData['adjournments'] +
        caseData['advocates'] +
        (totalEntries * 0.2));

    return coefficient;
  }

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
          rethrow;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text(
          'Manage Cases',
          style: TextStyle(
              fontFamily: 'Pacifico',
              color: Colors.black,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _caseIdController,
                decoration: const InputDecoration(labelText: 'Case ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the case ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateOfFilingController,
                    decoration: const InputDecoration(
                      labelText: 'Date of Filing',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select the date of filing';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _completedHearingsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Number of Completed Hearings'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of completed hearings';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _adjournmentsController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Number of Adjournments'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of adjournments';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _advocatesController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Number of Advocates'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of advocates';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitCase,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.pinkAccent),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
