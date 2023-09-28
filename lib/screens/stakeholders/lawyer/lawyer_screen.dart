// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:law/screens/stakeholders/lawyer/add_case.dart';
import 'package:law/screens/stakeholders/lawyer/lawyer_chat/lawyer_chat.dart';
import 'package:law/screens/stakeholders/lawyer/home/lawyer_home.dart';
import 'package:law/screens/stakeholders/lawyer/lawyer_read.dart';

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
  const LawyerScreen({super.key});

  @override
  _LawyerScreenState createState() => _LawyerScreenState();
}

class _LawyerScreenState extends State<LawyerScreen> {
  int _selectedIndex = 0;

  static final List<ScreenModel> screens = [
    ScreenModel(screen: const LawyerHomePage(), icon: Icons.home, text: "Home"),
    ScreenModel(screen: LawyerChatScreen(), icon: Icons.chat, text: "Chat"),
    ScreenModel(
        screen: const NewsScreen(), icon: Icons.read_more, text: "Read"),
    ScreenModel(
        screen: const LawyerAddCase(), icon: Icons.add, text: "Add Case"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedIndex].screen,
      bottomNavigationBar: Container(
        color: Colors.black38,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            gap: 7,
            padding: const EdgeInsets.all(16),
            tabs: List.generate(
              screens.length,
              (index) => GButton(
                icon: screens[index].icon,
                text: screens[index].text,
                onPressed: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                backgroundColor: _selectedIndex == index
                    ? Colors.yellow
                    : Colors.grey.shade800,
                textColor:
                    _selectedIndex == index ? Colors.black : Colors.white,
                iconActiveColor: Colors.black,
              ),
            ),
            selectedIndex: _selectedIndex,
          ),
        ),
      ),
    );
  }
}
