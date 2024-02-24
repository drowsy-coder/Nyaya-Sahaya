// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cardScreens/vakNam.dart';
import 'cardScreens/bailApp.dart';
import '../../login/login_method.dart';

class LawyerDocument extends StatefulWidget {
  const LawyerDocument({Key? key}) : super(key: key);

  @override
  _LawyerDocumentState createState() => _LawyerDocumentState();
}

class _LawyerDocumentState extends State<LawyerDocument> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _startDelayedDisplay();
  }

  void _startDelayedDisplay() async {
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _isVisible = true;
    });
  }

  void _logout(BuildContext context) async {
    await _auth.signOut();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('uid');
    prefs.remove('email');
    prefs.remove('caseNumber');
    prefs.remove('isLoggedIn');

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Generation'),
        actions: [
          IconButton(
            onPressed: () {
              _logout(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.grey[800]!.withOpacity(0.6),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/stamp.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildCard(context, 'Bail Generation System',
                        'Ease of bail generation for the lawyers', 1),
                    const SizedBox(height: 20.0),
                    _buildCard(context, 'Vakalatnama Generator',
                        'Vakalatnama generation for the start of the case', 2),
                    const SizedBox(height: 20.0),
                    _buildCard(
                      context,
                      'Prayer Generator',
                      'Prayer generator for end-case proceedings',
                      3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.grey[800],
    );
  }

  void _handleCardTap(BuildContext context, String cardTitle) {
    if (cardTitle == 'Bail Generation System') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BailGenerationPage()),
      );
    } else if (cardTitle == 'Vakalatnama Generator') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const VakalatnamaGeneratorPage()),
      );
    } else if (cardTitle == 'Prayer Generator') {
    } else {}
  }

  Widget _buildCard(
      BuildContext context, String cardTitle, String subtitle, int index) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
      child: GestureDetector(
        onTap: () {
          _handleCardTap(context, cardTitle);
        },
        child: Container(
          height: 130.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.8),
                Colors.grey[800]!.withOpacity(0.8),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  cardTitle,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10.0),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
