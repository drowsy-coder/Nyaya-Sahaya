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
      ipcSection: '498A',
      nameOfCrime: 'Dowry',
      punishment: '10 years in jail',
      bailable: "",
    ),
    FirInfo(
      ipcSection: '55A',
      nameOfCrime: 'Rape',
      punishment: '8 years in jail',
      bailable: "",
    ),
    FirInfo(
      ipcSection: '690',
      nameOfCrime: 'Murder',
      punishment: '15 years in jail',
      bailable: "",
    ),
    // Add more FIR data as needed
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
              // Create a beautiful card for matching FIR info
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
