// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_pdfview/flutter_pdfview.dart';

class BailAppView extends StatefulWidget {
  BailAppView({Key? key}) : super(key: key);

  @override
  _BailAppViewState createState() => _BailAppViewState();
}

class _BailAppViewState extends State<BailAppView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String clientName = '';
  String ipcSections = '';
  String firNumber = '';
  String father = '';
  String state = '';
  String age = '';
  String city = '';
  String pS = '';
  String dated = '';
  String occ = '';
  String und = "___________";
  String dot = "...........";

  Future<void> createPdf(
    BuildContext context,
    String clientName,
    String ipcSections,
    String firNumber,
    String father,
    String state,
    String age,
    String city,
    String pS,
    String dated,
    String occ,
  ) async {
    final pdf = pw.Document();

    final regularStyle = pw.TextStyle(fontSize: 12);
    final boldStyle =
        pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'IN THE COURT OF COURTS OF, ADDITIONAL DISTRICT AND SESSION JUDGE, COURTS',
                style: boldStyle,
              ),
              pw.Text('\n'),
              pw.Text(
                '$clientName, Son of $father, $age Years of Age, Working as $occ Residing at $pS',
                style: regularStyle,
              ),
              pw.Text('\n'),
              pw.Text('$dot Petitioner', style: regularStyle),
              pw.Text('\n'),
              pw.Text('Versus', style: regularStyle),
              pw.Text('\n'),
              pw.Text(
                'State of $state, Through $und, Son of $und, $und Years of age, Working as $und',
                style: regularStyle,
              ),
              pw.Text('\n'),
              pw.Text('Residing at $city', style: regularStyle),
              pw.Text('$dot Respondent', style: regularStyle),
              pw.Text('FIR No.: $firNumber', style: regularStyle),
              pw.Text('U/s: $ipcSections', style: regularStyle),
              pw.Text('P.S.: $pS', style: regularStyle),
              pw.Text('\n'),
              pw.Text(
                'APPLICATION UNDER SECTION 439 OF THE CODE OF CRIMINAL PROCEDURE 1973 FOR GRANT OF BAIL',
                style: boldStyle,
              ),
              pw.Text('Most Respectfully Show:', style: regularStyle),
              pw.Text(
                '1. That the present application under section 439 of the Code of Criminal Procedure 1973 is being filed by the Petitioner for seeking grant of bail in FIR No. registered at Police Station. The present petition is being moved as the petitioner has been arrested on in connection with the said FIR. The petitioner is now in judicial/police custody.',
                style: regularStyle,
              ),
              pw.Text(
                '2. That the Petitioner is innocent and is being falsely implicated in the above said case as he has nothing to do with the matter.',
                style: regularStyle,
              ),
              pw.Text(
                '3. That the Petitioner is a law-abiding citizen of India. The petitioner is gainfully carrying on the business of (Give details) $occ at $city.',
                style: regularStyle,
              ),
              pw.Text(
                '4. That the Petitioner is a responsible person and is living at the above-mentioned address.',
                style: regularStyle,
              ),
              pw.Text(
                '5. (Give all other relevant facts, which have led to the arrest or which show the petitioner\'s innocence or disassociation with the alleged offence supposed to have been committed)',
                style: regularStyle,
              ),
              pw.Text(
                '6. That the Petitioner is innocent and no useful purpose would be served by keeping him under custody and this is a fit case for the grant of bail. (It would be pertinent to mention as to the stage of investigation or in case the charge sheet has been filed, whether charges have been imposed, evidence has started, the length of the list of witnesses cited by the prosecution etc. as these would all be mitigating circumstances.',
                style: regularStyle,
              ),
              pw.Text(
                '7. That the Petitioner undertakes to abide by the conditions that this Honorable Court may impose at the time of granting bail to the Petitioner and further undertakes to attend the trial on every date of hearing.',
                style: regularStyle,
              ),
              pw.Text(
                '8. That the Petitioner has not filed any other similar petition before this or any other Honorable Court for the grant of bail in case of the present FIR. (Or give details and results of earlier applications.',
                style: regularStyle,
              ),
              pw.Text('PRAYER:', style: regularStyle),
              pw.Text(
                'In view of the above-stated facts and circumstances, it is most respectfully prayed that this Honorable Court may be pleased to',
                style: regularStyle,
              ),
              pw.Text(
                'a. Grant bail to the Petitioner in connection with FIR No. $firNumber registered under section $ipcSections for the offence of $ipcSections (give sections) at Police Station $pS (give place).',
                style: regularStyle,
              ),
              pw.Text(
                'b. Pass any other such order as this Honorable Court may deem fit and proper in the interest of justice.',
                style: regularStyle,
              ),
              pw.Text('$dot Petitioner', style: regularStyle),
              pw.Text('Through', style: regularStyle),
              pw.Text('Counsel', style: regularStyle),
              pw.Text('Place: $city', style: regularStyle),
              pw.Text('Dated: $dated', style: regularStyle),
            ],
          );
        },
      ),
    );

    final file = File("/storage/emulated/0/Download/example.pdf");
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PDF generated successfully!'),
      ),
    );

    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (_) => PDFView(
    //       filePath: file.path,
    //       enableSwipe: true,
    //       swipeHorizontal: true,
    //       autoSpacing: false,
    //       pageFling: false,
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Bail Application'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            const Text(
              'Client Details',
              style: TextStyle(fontSize: 24.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Client Name',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintText: 'Enter client name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter client name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      clientName = value!;
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'IPC Sections',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintText: 'Enter IPC sections',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter IPC sections';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      ipcSections = value!;
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'FIR Number',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintText: 'Enter FIR Number',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter FIR Number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      firNumber = value!;
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Father\'s Name',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintText: 'Enter Father\'s name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Father\'s name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      father = value!;
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'State',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintText: 'Enter State',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter State';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      state = value!;
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintText: 'Enter City',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter City';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      city = value!;
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintText: 'Enter Age',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Age';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      age = value!;
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Police Station',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintText: 'Enter Police Station',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Police Station';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      pS = value!;
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Dated',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintText: 'Enter Date',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        createPdf(context, clientName, ipcSections, firNumber,
                            father, state, age, city, pS, dated, occ);
                      }
                    },
                    child: const Text('Generate PDF'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
