import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:nyaya_sahaya/screens/stakeholders/lawyer/add_case.dart';
import 'package:nyaya_sahaya/screens/stakeholders/lawyer/lawyer_chat.dart';
import 'package:nyaya_sahaya/screens/stakeholders/lawyer/lawyer_home.dart';
import 'package:nyaya_sahaya/screens/stakeholders/lawyer/lawyer_profile.dart';
import 'package:nyaya_sahaya/screens/stakeholders/lawyer/lawyer_read.dart';

class ScreenModel {
  final Widget screen;
  final IconData icon;
  final String text;

  ScreenModel({
    required this.screen,
    required this.icon,
    required this.text,
  });
}

class LawyerScreen extends StatefulWidget {
  @override
  _LawyerScreenState createState() => _LawyerScreenState();
}

class _LawyerScreenState extends State<LawyerScreen> {
  int _selectedIndex = 0;

  // Define your screens as a static list
  static final List<ScreenModel> screens = [
    ScreenModel(screen: LawyerHomePage(), icon: Icons.home, text: "Home"),
    ScreenModel(screen: LawyerChatScreen(), icon: Icons.chat, text: "Chat"),
    ScreenModel(
        screen: LawyerReadScreen(), icon: Icons.read_more, text: "Read"),
    ScreenModel(screen: LawyerAddCase(), icon: Icons.add, text: "Profile"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lawyer Section'),
      ),
      body: screens[_selectedIndex].screen, // Display the selected screen
      bottomNavigationBar: Container(
        color: Colors.black38,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            gap: 8,
            tabBackgroundColor: Colors.grey.shade800,
            padding: EdgeInsets.all(16),
            tabs: List.generate(
              screens.length,
              (index) => GButton(
                icon: screens[index].icon,
                text: screens[index].text,
              ),
            ),
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
