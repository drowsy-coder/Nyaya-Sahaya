import 'package:flutter/material.dart';

class LawyerProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lawyer Profile'),
      ),
      body: Center(
        child: Text(
          'This is the Lawyer Profile Screen',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
