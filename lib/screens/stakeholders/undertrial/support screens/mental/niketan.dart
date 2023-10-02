// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:law_help/screens/stakeholders/undertrial/support%20screens/mental/m_yt.dart';
import 'package:url_launcher/url_launcher.dart';
import 'chat_support.dart';
import 'm_issues.dart';

class MentalSupportScreen extends StatefulWidget {
  const MentalSupportScreen({Key? key}) : super(key: key);

  @override
  _MentalSupportScreenState createState() => _MentalSupportScreenState();
}

class _MentalSupportScreenState extends State<MentalSupportScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Hero(
      tag: 'welcome_tag',
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _animation.value,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF3498DB),
                    Color(0xFF2E86C1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.asset(
                    'assets/images/mental.png',
                    height: 120,
                    width: 120,
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'Niketan',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCallChatCards(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              launch("tel:1800 599 0019");
            },
            child: _buildSupportCard(
              context,
              'Crisis Helpline',
              Icons.phone,
              Colors.green,
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ChatBotScreen(),
                ),
              );
            },
            child: _buildSupportCard(
              context,
              'Chat Support',
              Icons.chat,
              Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCard(
      BuildContext context, String text, IconData icon, Color color) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.43,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: 36,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildResourceCard(BuildContext context, String title,
      String description, Function onPressed, String imagePath) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ),
        onTap: onPressed as void Function(),
        leading: Image.asset(
          imagePath,
          width: 50,
          height: 50,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental Health Support'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildWelcomeSection(context),
            const SizedBox(height: 16),
            _buildCallChatCards(context),
            const SizedBox(height: 40),
            _buildResourceCard(
              context,
              'Common Issues',
              'You are not Alone',
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MentalHealthIssuesScreen(),
                  ),
                );
              },
              'assets/images/hug.png',
            ),
            const SizedBox(height: 16),
            _buildResourceCard(
              context,
              'Helpful Videos',
              'Hear from the experts',
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const VideoListScreen(),
                  ),
                );
              },
              'assets/images/4404094.png',
            ),
          ],
        ),
      ),
    );
  }
}
