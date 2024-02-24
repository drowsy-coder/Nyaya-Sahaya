import 'package:flutter/material.dart';
import 'package:law_help/screens/stakeholders/lawyer/lawyer_chat.dart';
import 'package:law_help/screens/stakeholders/lawyer/lawyer_doc.dart';
import 'package:law_help/screens/stakeholders/lawyer/home/lawyer_home.dart';
import 'package:law_help/screens/stakeholders/lawyer/news_screen.dart';

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
    ScreenModel(screen: const LawyerHome(), icon: Icons.home, text: "Home"),
    ScreenModel(screen: const LawyerChat(), icon: Icons.chat, text: "Chat"),
    ScreenModel(
        screen: const LawyerNews(), icon: Icons.read_more, text: "News"),
    ScreenModel(
        screen: const LawyerDocument(), icon: Icons.add, text: "Documents"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedIndex].screen,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.deepPurple,
        type: BottomNavigationBarType.shifting,
        elevation: 20.0,
        iconSize: 30,
        showUnselectedLabels: false,
        selectedFontSize: 15,
        unselectedFontSize: 12,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: screens
            .map((screen) => BottomNavigationBarItem(
                  icon: Icon(screen.icon),
                  label: screen.text,
                ))
            .toList(),
      ),
    );
  }
}
