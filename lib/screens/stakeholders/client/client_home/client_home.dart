import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:law/screens/stakeholders/client/client_home/no_cases_found.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:mime/mime.dart';

class ClientHomePage extends StatefulWidget {
  @override
  _ClientHomePageState createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  late String clientEmail; // Variable to hold the client's email
  bool textScanning = false;
  XFile? imageFile;
  String scannedText = '';
  @override
  void initState() {
    super.initState();
    // Call the method to fetch the user's email when the widget initializes
    getClientEmail();
  }

  void getClientEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        clientEmail = user.email!;
        print(clientEmail);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (clientEmail == null) {
      return CircularProgressIndicator();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('cases')
          .where('clientEmail', isEqualTo: clientEmail)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // If the stream is still waiting for data, show a loading indicator
          return CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          // If there are no documents in the snapshot, display a message
          return NoCasesFoundScreen();
        }

        final document = snapshot.data!.docs.first;

        return DefaultTabController(
          length: 3, // Number of tabs (Timeline, Section Info, Grid).
          child: Scaffold(
            appBar: AppBar(
              title: Text('Case Details'),
              actions: [
                IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () {
                    // Add a tooltip or navigation to the app's information page.
                  },
                ),
              ],
              bottom: TabBar(
                tabs: [
                  Tab(text: 'Timeline'),
                  Tab(text: 'Section Info'),
                  Tab(text: 'Grid'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                // Timeline Tab
                _buildTimeline(),

                // Section Info Tab
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildSectionInfoCard(
                          "IPC Section:", document['ipcSections']),
                      const SizedBox(height: 10),
                      _buildSectionInfoCard("Lawyer:", document['lawyerName']),
                      const SizedBox(height: 10),
                      _buildSectionInfoCard("Judge:", "Jane Smith"),
                      const SizedBox(height: 10),
                      _buildSectionInfoCard(
                          "Next Hearing:", document['nextHearingDate']),
                      const SizedBox(height: 20),
                      _buildSectionInfoCard("Case Status:", "Ongoing"),
                      const SizedBox(height: 20),
                      _buildSectionInfoCard(
                          "Sections Violated:", document['ipcSections']),
                      const SizedBox(height: 20),
                      // Add more relevant case-related facts or features here.
                    ],
                  ),
                ),

                // Grid Tab
                _buildGrid(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFactItem(String fact) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.blue, // Background color for the container.
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color.
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // Offset of the shadow.
          ),
        ],
      ),
      child: Center(
        child: Text(
          fact,
          style: const TextStyle(
            fontSize: 18.0,
            color: Colors.white, // Text color for carousel items.
            fontWeight: FontWeight.bold, // Make the text bold.
          ),
        ),
      ),
    );
  }

  Widget _buildSectionInfoCard(String title, String content) {
    return Container(
      width:
          double.infinity, // Make the card stretch to the whole screen width.
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey[300], // Background color for the card (grey).
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color.
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // Offset of the shadow.
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Text color for the title (black).
              ),
            ),
            SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black, // Text color for the content (black).
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline() {
    // Implement your timeline widget here.
    // You can use a ListView or a custom widget to create the timeline.
    // Each entry in the timeline should represent a case fact.
    return ListView(
        // Add timeline entries here.
        );
  }

  Widget _buildGrid() {
    // Implement your grid widget here.
    // You can use a GridView.builder to create a grid of case facts.
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns in the grid.
      ),
      itemBuilder: (context, index) {
        // Build grid items here.
        return _buildFactItem("Fact ${index + 1}: ...");
      },
    );
  }

  /**void getImage() async {
    try {
      final _picker = ImagePicker();
      // ignore: unused_local_variable
      final pickedImage = await _picker.getImage(source: ImageSource.camera);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      setState(() {});
      scannedText = "Error Occured";
    }
  }**/
}
