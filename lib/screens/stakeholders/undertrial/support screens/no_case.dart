import 'package:flutter/material.dart';

class NoCasesFoundScreen extends StatelessWidget {
  const NoCasesFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Case Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 350, // Adjust the width as needed
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey[850],
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/orange-error-icon-0.png',
                    width: 100,
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'No current cases.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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
