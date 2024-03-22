// ignore_for_file: library_private_types_in_public_api, empty_catches

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:read_pdf_text/read_pdf_text.dart';

class FirInfo {
  final String ipcSection;
  final String nameOfCrime;
  final String punishment;
  final String bailable;
  final String contact;

  FirInfo({
    required this.ipcSection,
    required this.nameOfCrime,
    required this.punishment,
    required this.bailable,
    required this.contact,
  });
}

class CaseInfoAnalyzer extends StatefulWidget {
  const CaseInfoAnalyzer({super.key});

  @override
  _CaseInfoAnalyzerState createState() => _CaseInfoAnalyzerState();
}

class _CaseInfoAnalyzerState extends State<CaseInfoAnalyzer> {
  String pdfText = '';
  List<Widget> displayedCards = [];

  List<FirInfo> firData = [
    FirInfo(
        ipcSection: '498A',
        nameOfCrime: 'Dowry',
        punishment: 'Life sentence and fine',
        bailable: 'Non-bailable',
        contact: 'Contact Family Lawyer'),
    FirInfo(
        ipcSection: '323',
        nameOfCrime: 'Intentionally causing physical harm',
        punishment: '1 Year or Fine or Both',
        bailable: 'Non-bailable',
        contact: 'Contact Criminal Lawyer'),
    FirInfo(
        ipcSection: '375',
        nameOfCrime: 'Sexual Assault',
        punishment: '7 years to life sentence in jail',
        bailable: 'Non-bailable',
        contact: 'Contact Criminal Lawyer'),
    // FirInfo(
    //     ipcSection: '307',
    //     nameOfCrime: 'Attempted Murder',
    //     punishment: '10 years to life imprisonment',
    //     bailable: 'Non-bailable',
    //     contact: 'Contact Criminal Lawyer'),
    FirInfo(
        ipcSection: '359',
        nameOfCrime: 'Attempted Kidnapping',
        punishment: '7 years and fine',
        bailable: 'Non-bailable',
        contact: 'Contact Criminal Lawyer'),
    FirInfo(
        ipcSection: '366-B',
        nameOfCrime: 'Importation of a Girl from a Foreign Country',
        punishment: '10 years and fine',
        bailable: 'Non-bailable',
        contact: 'Contact Criminal Lawyer'),
    FirInfo(
        ipcSection: '378',
        nameOfCrime: 'Theft',
        punishment: '3 years in jail',
        bailable: 'Non-bailable',
        contact: 'Contact Civil Lawyer'),
    FirInfo(
        ipcSection: '383',
        nameOfCrime: 'Extortion',
        punishment: '3 years in jail',
        bailable: 'Bailable',
        contact: 'Contact Criminal Lawyer'),
    FirInfo(
        ipcSection: '391',
        nameOfCrime: 'Dacoity',
        punishment: '10 years and fine',
        bailable: 'Non-bailable',
        contact: 'Contact Criminal Lawyer'),
    FirInfo(
        ipcSection: '390',
        nameOfCrime: 'Robbery',
        punishment: '10 to 14 years and fine',
        bailable: 'Non-bailable',
        contact: 'Contact Criminal Lawyer'),
    FirInfo(
        ipcSection: '415',
        nameOfCrime: 'Cheating',
        punishment: '1 year and fine',
        bailable: 'Bailable',
        contact: 'Contact Civil Lawyer'),
    FirInfo(
        ipcSection: '279',
        nameOfCrime: 'Negligent Driving',
        punishment: '6 month and fine',
        bailable: 'Bailable',
        contact: 'Contact Criminal Lawyer'),
    FirInfo(
        ipcSection: '337',
        nameOfCrime: 'Rash Driving',
        punishment: '6 month and fine',
        bailable: 'Bailable',
        contact: 'Contact Criminal Lawyer'),
    FirInfo(
        ipcSection: '143',
        nameOfCrime: 'Unlawful Assembly',
        punishment: '1 year and fine',
        bailable: 'Bailable',
        contact: 'Contact Civil Lawyer'),
    FirInfo(
        ipcSection: '341',
        nameOfCrime: 'Wrongful restraint',
        punishment: '1 month and fine',
        bailable: 'Bailable',
        contact: 'Contact Civil Lawyer'),
  ];

  Future<void> pickAndParsePDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      try {
        String text = await ReadPdfText.getPDFtext(file.path ?? '');

        List<FirInfo> matchingFirs =
            firData.where((info) => text.contains(info.ipcSection)).toList();

        // Print the IPC sections of matching FIRs
        for (var fir in matchingFirs) {
          print('IPC Section: ${fir.ipcSection} - ${fir.nameOfCrime}');
        }

        setState(() {
          pdfText = matchingFirs.isNotEmpty
              ? ''
              : 'No matching FIR information found in the PDF';
          displayedCards = _buildCardsFromFirInfo(matchingFirs);
        });
      } catch (e) {
        // Handle the error or print it
        print('Error reading PDF: $e');
      }
    }
  }

  List<Widget> _buildCardsFromFirInfo(List<FirInfo> firs) {
    return firs.map((info) {
      return Card(
        elevation: 8.0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.grey[850]!, Colors.grey[900]!],
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.gavel, size: 24.0, color: Colors.white),
                ),
                title: Text(
                  info.nameOfCrime,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                subtitle: Text(
                  'Section: ${info.ipcSection}',
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing:
                    const Icon(Icons.navigate_next, color: Colors.white70),
                onTap: () {},
              ),
              Padding(
                padding: const EdgeInsets.only(left: 72.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Punishment: ${info.punishment}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Bailable: ${info.bailable}',
                      style:
                          const TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      '${info.contact}',
                      style:
                          const TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FIR Information Analyzer'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: pickAndParsePDF,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 24.0),
                textStyle: const TextStyle(fontSize: 18.0),
              ),
              child: const Text('Upload FIR'),
            ),
          ),
          if (pdfText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                pdfText,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.redAccent,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: displayedCards,
            ),
          ),
        ],
      ),
    );
  }
}
