import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '/screens/stakeholders/client/views/camera_view.dart';
import '/screens/stakeholders/client/views/upload_view.dart';

class NoCasesFoundScreen extends StatelessWidget {
  const NoCasesFoundScreen({
    super.key,
  });

  void _navigateToTakePictureScreen(NavigatorState navigator) async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    navigator.push(
      MaterialPageRoute(
        builder: (context) => TakePictureScreen(camera: firstCamera),
      ),
    );
  }

  void _navigateToUploadView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Upload()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("No current cases."),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.file_upload_outlined,
                  color: Color.fromARGB(255, 255, 234, 9),
                ),
                label: const Text(
                  'Upload Image',
                  style: TextStyle(
                      color: Color.fromARGB(
                          255, 255, 234, 9)), // Change text color here
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 0, 0, 0), // Change button background color here
                ),
                onPressed: () {
                  _navigateToUploadView(context);
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.black,
                ),
                label: const Text(
                  'Take Image',
                  style: TextStyle(
                      color: Color.fromARGB(
                          255, 0, 0, 0)), // Change text color here
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 255, 234, 9), // Change button background color here
                ),
                onPressed: () {
                  _navigateToTakePictureScreen(Navigator.of(context));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
