import 'package:flutter/material.dart';
import 'package:law_help/screens/stakeholders/court/court_add_case.dart';
import 'package:law_help/screens/stakeholders/court/court_home.dart';
import 'package:law_help/screens/stakeholders/lawyer/news_screen.dart';
import 'case_search.dart';

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
        screen: const LawyerNews(), icon: Icons.read_more, text: "News"),
    ScreenModel(
        screen: const WebViewExample(),
        icon: Icons.search,
        text: "Search Precedents"),
    ScreenModel(
        screen: const CourtAddCase(),
        icon: Icons.document_scanner_sharp,
        text: "Add Case"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens.map((screen) => screen.screen).toList(),
      ),
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
