import 'package:flutter/material.dart';

class FeaturedProgramsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Featured Programs'),
      ),
      body: const Center(
        child: Text(
          'This is the Featured Programs Screens',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
