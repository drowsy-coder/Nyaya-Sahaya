import 'package:flutter/material.dart';
import 'package:law_help/screens/stakeholders/court/case_search.dart';
import 'package:law_help/screens/stakeholders/court/court_add_case.dart';
import 'package:law_help/screens/stakeholders/court/court_home.dart';

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

class CourtScreen extends StatefulWidget {
  const CourtScreen({super.key});

  @override
  State<CourtScreen> createState() => _CourtScreenState();
}

class _CourtScreenState extends State<CourtScreen> {
  int _selectedIndex = 0;

  static final List<ScreenModel> screens = [
    ScreenModel(screen: const CourtHome(), icon: Icons.home, text: "Home"),
    ScreenModel(
        screen: const WebViewExample(),
        icon: Icons.search,
        text: "Search Precedents"), // Assuming CaseSearch is your search screen
    ScreenModel(
        screen: const CourtAddCase(), icon: Icons.add_box, text: "Add Case"),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
