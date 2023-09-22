// ignore_for_file: library_private_types_in_public_api, empty_catches

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:read_pdf_text/read_pdf_text.dart';

class FirInfo {
  final String ipcSection;
  final String nameOfCrime;
  final String punishment;
  final String bailable;

  FirInfo({
    required this.ipcSection,
    required this.nameOfCrime,
    required this.punishment,
    required this.bailable,
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
      ipcSection: '300',
      nameOfCrime: 'Murder',
      punishment: 'Death or life sentence and fine',
      bailable: 'Non-bailable',
    ),
    FirInfo(
      ipcSection: '375',
      nameOfCrime: 'Sexual Assault',
      punishment: '7 years to life sentence in jail',
      bailable: 'Non-bailable',
    ),
    FirInfo(
      ipcSection: '307',
      nameOfCrime: 'Attempted Murder',
      punishment: '10 years to life imprisonment',
      bailable: 'Non-bailable',
    ),
    FirInfo(
      ipcSection: '359',
      nameOfCrime: 'Attempted Kidnapping',
      punishment: '7 years and fine',
      bailable: 'Non-bailable',
    ),
    FirInfo(
      ipcSection: '366-B',
      nameOfCrime: 'Importation of a Girl from a Foreign Country',
      punishment: '10 years and fine',
      bailable: 'Non-bailable',
    ),
    FirInfo(
      ipcSection: '378',
      nameOfCrime: 'Theft',
      punishment: '3 years in jail',
      bailable: 'Non-bailable',
    ),
    FirInfo(
      ipcSection: '383',
      nameOfCrime: 'Extortion',
      punishment: '3 years in jail',
      bailable: 'Bailable',
    ),
    FirInfo(
      ipcSection: '391',
      nameOfCrime: 'Dacoity',
      punishment: '10 years and fine',
      bailable: 'Non-bailable',
    ),
    FirInfo(
      ipcSection: '390',
      nameOfCrime: 'Robbery',
      punishment: '10 to 14 years and fine',
      bailable: 'Non-bailable',
    ),
    FirInfo(
      ipcSection: '415',
      nameOfCrime: 'Cheating',
      punishment: '1 year and fine',
      bailable: 'Bailable',
    ),
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

        List<FirInfo> matchingFirs = [];

        for (FirInfo info in firData) {
          if (text.contains(info.ipcSection)) {
            matchingFirs.add(info);
          }
        }

        if (matchingFirs.isNotEmpty) {
          setState(() {
            pdfText = '';
            displayedCards = matchingFirs.map((info) {
              return Card(
                elevation: 5.0,
                margin: const EdgeInsets.all(10.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('IPC Section: ${info.ipcSection}'),
                      Text('Name of Crime: ${info.nameOfCrime}'),
                      Text('Punishment: ${info.punishment}'),
                      Text('Baillable: ${info.bailable}'),
                    ],
                  ),
                ),
              );
            }).toList();
          });
        } else {
          setState(() {
            pdfText = 'No matching FIR information found in the PDF';
            displayedCards = [];
          });
        }
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FIR Information Analyzer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: pickAndParsePDF,
              child: const Text('Pick and Analyze PDF'),
            ),
            const SizedBox(height: 20.0),
            Text(
              pdfText,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: ListView(
                children: displayedCards,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
