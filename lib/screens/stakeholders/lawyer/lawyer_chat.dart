import 'package:flutter/material.dart';

class LawyerChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lawyer Chat'),
      ),
      body: Center(
        child: Text(
          'This is the Lawyer Chat Screen',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
