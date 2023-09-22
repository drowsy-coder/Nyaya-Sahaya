import 'package:flutter/material.dart';

class LawyerClientChat extends StatefulWidget {
  final String clientEmail;

  LawyerClientChat({required this.clientEmail});

  @override
  _LawyerClientChatState createState() => _LawyerClientChatState();
}

class _LawyerClientChatState extends State<LawyerClientChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Email Display'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Client Email:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              widget.clientEmail,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
