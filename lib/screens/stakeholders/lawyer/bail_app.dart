import 'package:flutter/material.dart';
import 'package:text2pdf/text2pdf.dart';

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
  String und = "___________";
  String dot = "...........";

  Future<void> createPdf(
    BuildContext context,
    String clientName,
    String ipcSections,
    String firNumber,
    String father,
  ) async {
    String content = '''
IN THE COURT OF COURTS OF, ADDITIONAL DISTRICT AND SESSION JUDGE, COURTS

IN THE MATTER OF:
$clientName, Son of $father,  25 Years of Age, Working as $und Residing at $und
$dot Petitioner

Versus
State of $und, Through PQR, Son of Years of age, Working as
Residing at $und
$dot Respondent

FIR No.: $firNumber

U/s:
P.S.: 

APPLICATION UNDER SECTION 439 OF THE CODE OF CRIMINAL PROCEDURE 1973 FOR GRANT OF BAIL
Most Respectfully Show:

1. That the present application under section 439 of the Code of Criminal Procedure 1973 is being filed by the Petitioner for seeking grant of bail in FIR No. registered at Police Station. The present petition is being moved as the petitioner been arrested on in connection with the said FIR. The petitioner is now in judicial/police custody.

2. That the Petitioner is innocent and is being falsely implicated in the above said case as he has nothing to do with the matter.

3. That the Petitioner is a law-abiding citizen of India. The petitioner is gainfully carrying on the business of (Give details) $und at $und.

4. That the Petitioner is a responsible person and is living at the above mentioned address.

5. (Give all other relevant facts, which have led to the arrest or which show the petitioner's innocence or disassociation with the alleged offence supposed to have been committed)

6. That the Petitioner is innocent and no useful purpose would be served by keeping him under custody and this is a fit case for grant of bail. (It would be pertinent to mention as to the stage of investigation or in case the charge sheet has been filed, whether charges have been imposed, evidence has started, the length of the list of witnesses cited by the prosecution etc. as these would all be mitigating circumstances.

7. That the Petitioner undertakes to abide by the conditions that this Honorable Court may impose at the time of granting bail to the Petitioner and further undertakes to attend the trial on every date of hearing.

8. That the Petitioner has not filed any other similar petition before this or any other Honorable Court for grant of bail in case of the present FIR. (Or give details and results of earlier applications.

PRAYER:
In view of the above stated facts and circumstances it is most respectfully prayed that this Honorable Court may be pleased to
a. Grant bail to the Petitioner in connection with FIR No. $firNumber registered under section $ipcSections for the offence of $und (give sections) at Police Station $und (give place).
b. Pass any other such order as this Honorable Court may deem fit and proper in the interest of justice.

$dot Petitioner
Through
Counsel
Place:
Dated: 
''';

    if (content.isNotEmpty) {
      await Text2Pdf.generatePdf(content);
      // Display a snackbar indicating PDF creation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF generated successfully!'),
        ),
      );
    } else {
      // Display a snackbar if content is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Content cannot be empty for PDF generation.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bail App View'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'This is the Bail App View.',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20.0),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Client Name'),
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
                  TextFormField(
                    decoration: InputDecoration(labelText: 'IPC Sections'),
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
                  TextFormField(
                    decoration: InputDecoration(labelText: 'FIR Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter FIR number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      firNumber = value!;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Father Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Father name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      father = value!;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        createPdf(context, clientName, ipcSections, firNumber,
                            father);
                      }
                    },
                    child: Text('Generate PDF'),
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
