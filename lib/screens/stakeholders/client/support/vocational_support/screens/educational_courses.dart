import 'package:flutter/material.dart';

class EducationalCoursesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Educational Courses'),
      ),
      body: Center(
        child: Text(
          'This is the Educational Courses Screenss',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
