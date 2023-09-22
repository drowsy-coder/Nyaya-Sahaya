import 'package:flutter/material.dart';

class ComputerTrainingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Computer Training'),
      ),
      body: Center(
        child: Text(
          'This is the Computer Training Screen',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
