// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:law_help/screens/stakeholders/lawyer/cardScreens/pdf_view.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;

class VakalatnamaGeneratorPage extends StatefulWidget {
  const VakalatnamaGeneratorPage({super.key});

  @override
  State<VakalatnamaGeneratorPage> createState() =>
      _VakalatnamaGeneratorPageState();
}

class _VakalatnamaGeneratorPageState extends State<VakalatnamaGeneratorPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String courtName = '';
  String suitNum = '';
  String pet = '';
  String res = '';
  String lawyer = '';
  String date = '';
  String und = '_________';

  Future<void> createPdf(
    BuildContext context,
    String courtName,
    String suitNum,
    String pet,
    String res,
    String lawyer,
    String date,
  ) async {
    final pdf = pw.Document();

    const regularStyle = pw.TextStyle(fontSize: 12);
    final boldStyle =
        pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'IN THE COURT OF $courtName',
                style: boldStyle,
                textAlign: pw.TextAlign.center,
              ),
              pw.Text(
                'Suit/Appeal No. $suitNum, JURISDICTION OF 201',
                style: regularStyle,
              ),
              pw.Text('In re:- $pet Plaintiff(s)', style: regularStyle),
              pw.Text('Versus', style: boldStyle),
              pw.Text(
                '$res Respondent(s)',
                style: regularStyle,
              ),
              pw.Text(
                  'Know all to whom these present shall come that I/we $pet',
                  style: regularStyle),
              pw.Text('The above name, $lawyer, do hereby appoint',
                  style: regularStyle),
              pw.Text(
                  '(herein after called the advocate/s) to be my / our Advocate in the above - noted case authorize him:- ',
                  style: boldStyle),
              pw.Text(
                  '1. To act, appear and plead in the above-noted case in this court or in any other court in which the same may be tried or heard and also in the appellate court including High Court subject to payment of fees separately for each court by me/us',
                  style: regularStyle),
              pw.Text(
                  '2. To sign file, verify and present pleadings, appeals cross-objection or petitions for executions review, revision, withdrawal, compromise or other petitions or affidavits or other documents as may be deemed necessary or proper for the prosecution of the said case in all its stages subjects to payment of fees for each stage',
                  style: regularStyle),
              pw.Text(
                '3. To file and take back documents, to admit and/or deny the documents of opposite party. ',
                style: regularStyle,
                textAlign: pw.TextAlign.center,
              ),
              pw.Text(
                  '4. To withdraw or compromise the said case or submit to arbitration any differences of disputes that may arise touching or in any manner relating to the said case.',
                  style: regularStyle),
              pw.Text(
                  '5. To take execution proceedings on paying separate fee. ',
                  style: regularStyle,
                  textAlign: pw.TextAlign.justify),
              pw.Text(
                  '6. To deposit, draw and receive money, cheques, cash and grant receipts hereof and to do all other acts and things which may be necessary to be done for the progress and in the course of the prosecution on the said case.',
                  style: regularStyle,
                  textAlign: pw.TextAlign.justify),
              pw.Text(
                  '7. To appoint and instruct any other Legal Practitioner authorizing him to exercise the power and authority hereby conferred upon the Advocate whenever he may think fit to do so and to sign the power of attorney on our behalf.',
                  style: regularStyle,
                  textAlign: pw.TextAlign.justify),
              pw.Text('\n'),
              pw.Text(
                  'And I/we undersigned to hereby agree to ratify and confirm all acts done by the Advocate or his substitute in the matter as my/our own acts, as if done by me/us to all intents and purpose.',
                  style: boldStyle,
                  textAlign: pw.TextAlign.justify),
              pw.Text(
                  'And I/we undertake that I/We or my/our duly authorized agent would appear in court on all hearings and will inform the Advocate for appearance when the case is called.',
                  style: regularStyle,
                  textAlign: pw.TextAlign.justify),
              pw.Text(
                  'And I/We undersigned do hereby agree not to hold the advocate or his substitute responsible for the result of the said case. The adjournment costs whenever ordered by the court shall be of the Advocate which he shall receive and retain for himself.',
                  style: regularStyle,
                  textAlign: pw.TextAlign.justify),
              pw.Text(
                  'And I/we undersigned do hereby agree that in the event of the whole or part of the fee agreed by me/us to be paid to the advocate remaining unpaid he shall be entitled to withdraw from the prosecution of the said case until the same is paid up. The fee settle is only for the above case and above Court. I/We hereby agree that once the fee is paid, I /We will not be entitled for the refund of the same in any case whatsoever and if the case prolongs for more than 3 years the original fee shall be paid again by me/us.',
                  style: regularStyle,
                  textAlign: pw.TextAlign.justify),
              pw.Text(
                  '''IN WITNESS WHERE OF I/We do here unto set my/our hand to these presents the contents of which have
been understood by me/us on this $date of 2023 Accepted subject to the terms of
the fees. ''',
                  style: boldStyle, textAlign: pw.TextAlign.justify),
              pw.Text('\n'),
              pw.Text('$und           $und'),
              pw.Text(
                  'Client                                                                 Advocate',
                  style: boldStyle),
            ],
          );
        },
      ),
    );

    const fileName = "example.pdf";
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/files/$fileName';

    final file = File(filePath);
    await file.create(recursive: true);
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PDF generated successfully!'),
      ),
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PDFViewScreen(pdfFilePath: file.path),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Vakalatnama'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 8.0),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Court Name',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintText: 'Enter court name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter court name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      courtName = value!;
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Suit number',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintText: 'Enter Suit number',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Suit number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      suitNum = value!;
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Petitioner',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintText: 'Enter Petitioner\'s name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Petitioner\'s name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      pet = value!;
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Resopondent',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintText: 'Enter Respondent\'s name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Respondent\'s name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      res = value!;
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Lawyer',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintText: 'Enter Lawyer name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Lawyer name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      lawyer = value!;
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintText: 'Enter date',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter date';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      date = value!;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        createPdf(context, courtName, suitNum, pet, res, lawyer,
                            date);
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
