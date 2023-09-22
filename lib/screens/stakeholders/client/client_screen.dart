// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:law/screens/stakeholders/client/client_home/client_home.dart';
import 'package:law/screens/stakeholders/client/client_support_screen.dart';
import 'package:law/screens/stakeholders/client/client_lawyer_map.dart';
import 'package:law/screens/stakeholders/lawyer/lawyer_chat.dart';

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
    ScreenModel(screen:  const LawyerChatScreen(), icon: Icons.chat, text: "Chat"),
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
