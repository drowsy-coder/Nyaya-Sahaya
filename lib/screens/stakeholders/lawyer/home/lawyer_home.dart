// ignore_for_file: library_private_types_in_public_api
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:law/screens/stakeholders/lawyer/home/show_cases.dart';
import 'package:law/widgets/buttons/logout_button.dart';

class LawyerHomePage extends StatelessWidget {
  const LawyerHomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = screenHeight / 4; // Set card height to 1/4 of the screen

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lawyer Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Logout logic
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              SizedBox(
                width: 250, // Adjust the card width as needed
                height: cardHeight, // Set card height
                child: DashboardHeader(
                  iconName: Icons.query_builder_outlined,
                  cardText: 'Cases Pending',
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                width: 250, // Adjust the card width as needed
                height: cardHeight, // Set card height
                child: DashboardHeader(
                  iconName: Icons.star,
                  cardText: 'Starred Cases',
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                width: 250, // Adjust the card width as needed
                height: cardHeight, // Set card height
                child: DashboardHeader(
                  iconName: Icons.check,
                  cardText: 'Completed Cases',
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardHeader extends StatelessWidget {
  final IconData iconName;
  final String cardText;

  const DashboardHeader({
    Key? key,
    required this.iconName,
    required this.cardText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
        side: BorderSide(color: Colors.blue),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            color: Colors.black38,
            child: Icon(
              iconName,
              color: Colors.white,
              size: 64.0,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12.0),
            color: Colors.blue,
            child: Text(
              cardText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}
/**
import 'package:flutter/material.dart';

class LawyerHomePage extends StatelessWidget {
  const LawyerHomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = screenHeight / 3; // Set card height to 1/3 of the screen

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lawyer Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Logout logic
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              SizedBox(
                width: 250, // Adjust the card width as needed
                height: cardHeight, // Set card height
                child: DashboardHeader(),
              ),
              SizedBox(width: 10),
              SizedBox(
                width: 250, // Adjust the card width as needed
                height: cardHeight, // Set card height
                child: DashboardHeader(),
              ),
              SizedBox(width: 10),
              SizedBox(
                width: 250, // Adjust the card width as needed
                height: cardHeight, // Set card height
                child: DashboardHeader(),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({Key? key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
        side: BorderSide(color: Colors.blue),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            color: Colors.black38,
            child: const Icon(
              Icons.query_builder_outlined,
              color: Colors.white,
              size: 64.0,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12.0),
            color: Colors.blue,
            child: const Text(
              'Cases Pending',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:law/screens/stakeholders/lawyer/home/show_cases.dart';
import 'package:law/widgets/buttons/logout_button.dart';

class LawyerHomePage extends StatelessWidget {
  const LawyerHomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lawyer Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout), // You can use any icon you prefer
            onPressed: () {
              LogoutButton();
            },
          ),
        ],
      ),
      body: const SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.all(14.0),
          child: Row(
            children: [
              SizedBox(width: 10, height: 10),
              DashboardHeader(),
              SizedBox(width: 10, height: 10),
              DashboardHeader(),
              SizedBox(width: 10, height: 10),
              DashboardHeader(),
              SizedBox(width: 10, height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({Key? key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250, // Adjust the card width as needed
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
          side: BorderSide(color: Colors.blue),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              color: Colors.black38,
              child: const Icon(
                Icons.query_builder_outlined,
                color: Colors.white,
                size: 64.0,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12.0),
              color: Colors.blue,
              child: const Text(
                'Cases Pending',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:law/screens/stakeholders/lawyer/home/show_cases.dart';
import 'package:law/widgets/buttons/logout_button.dart';

class LawyerHomePage extends StatelessWidget {
  const LawyerHomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lawyer Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout), // You can use any icon you prefer
            onPressed: () {
              LogoutButton();
            },
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(14.0), // Add your desired padding here
        child: Column(
          children: [
            SizedBox(height: 20),
            const DashboardHeader(),
            SizedBox(height: 20),
            Text(
              'Clients', // Add the header text here
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: CaseList(
                showClosed: true,
                showOpen: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({Key? key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceEvenly, // Adjust spacing as needed
      children: [
        Expanded(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
              side: BorderSide(color: Colors.blue),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  color: Colors.black38,
                  child: const Icon(
                    Icons.query_builder_outlined,
                    color: Colors.white,
                    size: 64.0,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  color: Colors.blue,
                  child: const Text(
                    'Cases Pending',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 10), // Adjust spacing between cards
        Expanded(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
              side: BorderSide(color: Colors.blue),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  color: Colors.black38,
                  child: const Icon(
                    Icons.query_builder_outlined,
                    color: Colors.white,
                    size: 64.0,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  color: Colors.blue,
                  child: const Text(
                    'Another Card',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 10), // Adjust spacing between cards
        Expanded(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
              side: BorderSide(color: Colors.blue),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  color: Colors.black38,
                  child: const Icon(
                    Icons.query_builder_outlined,
                    color: Colors.white,
                    size: 64.0,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  color: Colors.blue,
                  child: const Text(
                    'Yet Another Card',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}




class LawyerHomePage extends StatelessWidget {
  const LawyerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lawyer Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout), // You can use any icon you prefer
            onPressed: () {
              LogoutButton();
            },
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(14.0), // Add your desired padding here
        child: Column(
          children: [
            SizedBox(height: 20),
            DashboardHeader(),
            SizedBox(height: 20),
            Text(
              'Clients', // Add the header text here
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: CaseList(
                showClosed: true,
                showOpen: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardHeader extends StatefulWidget {
  const DashboardHeader({super.key});

  @override
  _DashboardHeaderState createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  late String lawyerId;
  int totalCases = 0; // Initialize totalCases with 0

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      lawyerId = user.uid;
      fetchLawyerIdAndTotalCases();
    }
  }

  Future<void> fetchLawyerIdAndTotalCases() async {
    final casesQuery = await FirebaseFirestore.instance
        .collection('cases')
        .where('lawyerId', isEqualTo: lawyerId)
        .get();

    // Set the totalCases to the length of the documents returned
    setState(() {
      totalCases = casesQuery.docs.length;
    });
  }

  void navigateToCaseListScreen(
      BuildContext context, bool showClosed, bool showOpen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CaseListScreen(
          showClosed: showClosed,
          showOpen: showOpen,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
          side: BorderSide(color: Colors.blue)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            color: Colors.black38, // Ribbon background color
            child: const Icon(
              Icons.query_builder_outlined, // Your icon here
              color: Colors.white, // Icon color
              size: 64.0,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12.0),
            color: Colors.blue, // Background color
            child: const Text(
              'Cases Pending', // Your text at the bottom
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
  
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              navigateToCaseListScreen(context, false, true);
            },
            child: HoverCard(
              title: 'Cases Pending',
              count: '$totalCases',
              icon: Icons.timer,
              backgroundColor: Colors.blue,
              textColor: Colors.white,
            ),
          ),
          GestureDetector(
            onTap: () {
              navigateToCaseListScreen(context, true, true);
            },
            child: HoverCard(
              title: 'Total Cases',
              count: '$totalCases',
              icon: Icons.folder,
              backgroundColor: Colors.green,
              textColor: Colors.white,
            ),
          ),
          GestureDetector(
            onTap: () {
              navigateToCaseListScreen(context, false, false);
            },
            child: const HoverCard(
              title: 'Cases Closed',
              count: '0',
              icon: Icons.check_circle,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            ),
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
  final Color backgroundColor;
  final Color textColor;

  const HoverCard({
    Key? key,
    required this.title,
    required this.count,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
  }) : super(key: key);

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
      child: SizedBox(
        width: 150,
        child: Card(
          elevation: isHovered ? 10 : 2,
          color: widget.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  widget.icon,
                  size: 48,
                  color: widget.textColor,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: widget.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.count,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: widget.textColor,
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
**/