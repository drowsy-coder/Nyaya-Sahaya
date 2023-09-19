import 'package:flutter/material.dart';

class LawyerReadScreen extends StatelessWidget {
  const LawyerReadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Read Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'This is the Read Screen',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
