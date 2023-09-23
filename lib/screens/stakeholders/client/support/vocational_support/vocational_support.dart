import 'package:flutter/material.dart';
import 'package:law/screens/stakeholders/client/support/vocational_support/screens/computer_training.dart';
import 'package:law/screens/stakeholders/client/support/vocational_support/screens/featured_programs.dart';
// import 'package:law/screens/stakeholders/client/support/vocational_support/screens/vocational_support.dart';
import 'package:law/screens/stakeholders/client/support/vocational_support/screens/educational_courses.dart'
    as eduCourses;
import 'package:law/screens/stakeholders/client/support/vocational_support/screens/vocational_training.dart';

class WelcomeCard extends StatefulWidget {
  const WelcomeCard({super.key});

  @override
  _WelcomeCardState createState() => _WelcomeCardState();
}

class _WelcomeCardState extends State<WelcomeCard> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: AnimatedOpacity(
        duration: const Duration(seconds: 1),
        opacity: _opacity,
        child: Column(
          children: [
            Container(
              height: 100,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/welcome.png',
                  height: 120,
                  width: 120,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Unnatii',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Empowering Undertrials with Knowledge and Skills',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[200],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VocationalSupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Education for Undertrials'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const WelcomeCard(),
            const SizedBox(height: 40),
            Center(
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                children: [
                  _buildCard(
                    title: 'Educational Courses',
                    imageAsset: 'assets/images/education.png',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              eduCourses.EducationalCoursesScreen(),
                        ),
                      );
                    },
                  ),
                  _buildCard(
                    title: 'Vocational Training',
                    imageAsset: 'assets/images/learn.png',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => VocationalTrainingScreen(),
                        ),
                      );
                    },
                  ),
                  _buildCard(
                    title: 'Featured Programs',
                    imageAsset: 'assets/images/light-bulb.png',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FeaturedScreen(),
                        ),
                      );
                    },
                  ),
                  _buildCard(
                    title: 'Computer Training',
                    imageAsset: 'assets/images/computer.png',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ComputerTrainingScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String imageAsset,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              child: Center(
                child: Image.asset(
                  imageAsset,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: VocationalSupportScreen(),
  ));
}
