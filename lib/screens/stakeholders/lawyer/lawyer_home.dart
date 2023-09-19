import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:nyaya_sahaya/components/bottom_nav_bar.dart';
import 'package:nyaya_sahaya/screens/stakeholders/lawyer/lawyer_chat.dart';
import 'package:nyaya_sahaya/screens/stakeholders/lawyer/lawyer_profile.dart';
import 'package:nyaya_sahaya/screens/stakeholders/lawyer/lawyer_read.dart';
import 'package:nyaya_sahaya/widgets/buttons/menu_widget.dart';

import '../../../widgets/buttons/logout_button.dart';

import 'package:flutter/material.dart';

class LawyerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        DashboardHeader(),
      ],
    );
  }
}

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          HoverCard(
            title: 'Cases Pending',
            count: '15',
            icon: Icons.timer,
          ),
          HoverCard(
            title: 'Total Cases',
            count: '50',
            icon: Icons.folder,
          ),
          HoverCard(
            title: 'Cases Closed',
            count: '35',
            icon: Icons.check_circle,
          ),
        ],
      ),
    );
  }
}

class HoverCard extends StatefulWidget {
  final String title;
  final String count;
  final IconData icon;

  HoverCard({required this.title, required this.count, required this.icon});

  @override
  _HoverCardState createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: Container(
        width: 150, // Adjust the width as needed
        child: Card(
          elevation: isHovered ? 10 : 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  widget.icon,
                  size: 48,
                  color: Colors.blue,
                ),
                SizedBox(height: 8),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  widget.count,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
