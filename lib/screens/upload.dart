// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _uploadedFiles = [];

  Future<void> _uploadFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);

        final Reference storageReference = FirebaseStorage.instance.ref().child(
            'uploaded_documents/${DateTime.now().millisecondsSinceEpoch.toString()}');
        final UploadTask uploadTask = storageReference.putFile(file);

        await uploadTask.whenComplete(() async {
          String downloadURL = await storageReference.getDownloadURL();
          setState(() {
            _uploadedFiles.add(downloadURL);
          });
        });
      }
    } catch (e) {}
  }

  Future<void> _downloadFile(String downloadURL) async {
    try {
      final http.Response response = await http.get(Uri.parse(downloadURL));
      final String fileName = downloadURL.split('/').last;

      final Directory? externalDirectory = await getExternalStorageDirectory();

      final String savePath = '${externalDirectory!.path}/$fileName.pdf';

      final File file = File(savePath);

      await file.writeAsBytes(response.bodyBytes);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Upload and Download'),
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: _uploadFile,
            child: const Text('Upload Document'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _uploadedFiles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('File $index'),
                  onTap: () {
                    _downloadFile(_uploadedFiles[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
