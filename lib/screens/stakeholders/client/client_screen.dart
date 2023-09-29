// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:law/screens/stakeholders/client/client_chat/client_chat_screen.dart';
import 'package:law/screens/stakeholders/client/client_home/client_home.dart';
import 'package:law/screens/stakeholders/client/client_support_screen.dart';
import 'package:law/screens/stakeholders/client/client_lawyer_map.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';

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

class ClientScreen extends StatefulWidget {
  const ClientScreen({super.key});

  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  int _selectedIndex = 0;

  static final List<ScreenModel> screens = [
    ScreenModel(screen: const ClientHomePage(), icon: Icons.home, text: "Home"),
    ScreenModel(
        screen: const ClientChatScreen(), icon: Icons.chat, text: "Chat"),
    ScreenModel(
        screen: const ClientSupportScreen(),
        icon: Icons.support_agent,
        text: "Support"),
    ScreenModel(
        screen: const MapScreen(), icon: Icons.gps_fixed, text: "Find Lawyer"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedIndex].screen,
      extendBody: true,
      bottomNavigationBar: DotNavigationBar(
        backgroundColor: Colors.black,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          DotNavigationBarItem(
            icon: const Icon(Icons.home),
            selectedColor: Colors.yellow,
          ),
          DotNavigationBarItem(
            icon: const Icon(Icons.chat),
            selectedColor: Colors.yellow,
          ),
          DotNavigationBarItem(
            icon: const Icon(Icons.read_more),
            selectedColor: Colors.yellow,
          ),
          DotNavigationBarItem(
            icon: const Icon(Icons.add),
            selectedColor: Colors.yellow,
          ),
        ],
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.white,
      ),
    );
  }
}
