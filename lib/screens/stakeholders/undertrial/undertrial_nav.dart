import 'package:flutter/material.dart';
import 'package:law_help/screens/stakeholders/undertrial/ut%20map/ut_map.dart';
import 'package:law_help/screens/stakeholders/undertrial/ut_chat.dart';
import 'package:law_help/screens/stakeholders/undertrial/ut_home.dart';
import 'package:law_help/screens/stakeholders/undertrial/ut_support.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({Key? key}) : super(key: key);

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = [
    const UTHome(),
    const UTChat(),
    const UTSupport(),
    const UTMap(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent),
            label: 'Support',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gps_fixed),
            label: 'Find Lawyer',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey, 
        backgroundColor: Colors.deepPurple, 
        type: BottomNavigationBarType
            .shifting, 
        elevation: 20.0,
        iconSize: 30, 
        showUnselectedLabels:
            false,
        selectedFontSize: 15, 
        unselectedFontSize:
            12, 
        onTap: _onItemTapped,
      ),
    );
  }
}
