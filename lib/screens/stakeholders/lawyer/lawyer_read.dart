import 'package:flutter/material.dart';
import 'package:law/widgets/buttons/logout_button.dart';

class LawyerReadScreen extends StatelessWidget {
  const LawyerReadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Example'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10), // Adjust padding as needed
        children: <Widget>[
          Card(
            elevation: 3, // Adjust elevation for shadow effect
            margin: const EdgeInsets.all(10), // Adjust margin as needed
            child: ListTile(
              leading: const Icon(
                  Icons.account_circle), // Optional: Add an icon or image
              title: const Text('Card Title'), // Add a title
              subtitle: const Text('Card Subtitle'), // Add a subtitle
              trailing: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  // Add action on button press if needed
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
