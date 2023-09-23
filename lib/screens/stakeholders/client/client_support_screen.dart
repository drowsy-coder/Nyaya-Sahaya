import 'package:flutter/material.dart';
import 'package:law/screens/stakeholders/client/support/mental_support.dart';
import 'package:law/screens/stakeholders/client/support/vocational_support/vocational_support.dart';

class ClientSupportScreen extends StatelessWidget {
  const ClientSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Screen'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey[800]!, Colors.grey[900]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  const Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Sahayata',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Get answers to all your questions',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Image.asset(
                        'assets/images/welcome.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                children: <Widget>[
                  SupportOptionCard(
                    title: 'Vocational Support',
                    description: 'Explore vocational support services',
                    iconPath: 'assets/images/3526220.png',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return VocationalSupportScreen();
                          },
                        ),
                      );
                    },
                    gradientColors: const [Colors.purple, Colors.deepPurple],
                  ),
                  const SizedBox(height: 20),
                  SupportOptionCard(
                    title: 'Mental Health Support',
                    description: 'Access mental health resources.',
                    iconPath: 'assets/images/mental.png',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const MentalSupportScreen();
                          },
                        ),
                      );
                    },
                    gradientColors: const [Colors.teal, Colors.green],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SupportOptionCard extends StatelessWidget {
  final String title;
  final String description;
  final String iconPath;
  final VoidCallback onPressed;
  final List<Color> gradientColors;

  const SupportOptionCard({
    super.key,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.onPressed,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Row(
              children: <Widget>[
                Image.asset(
                  iconPath,
                  width: 60,
                  height: 60,
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
