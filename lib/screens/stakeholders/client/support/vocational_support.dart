import 'package:flutter/material.dart';

class WelcomeCard extends StatefulWidget {
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
                  'assets/images/welcome.png', // Replace with your image path
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
  const VocationalSupportScreen({Key? key});

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
            WelcomeCard(),
            const SizedBox(height: 40), // Increase spacing
            Center(
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true, // Allow GridView to take minimum space
                children: [
                  _buildCard(
                    title: 'Educational Courses',
                    imageAsset: 'assets/images/2689736.png',
                    onTap: () {},
                  ),
                  _buildCard(
                    title: 'Vocational Training',
                    imageAsset: 'assets/images/2689736.png',
                    onTap: () {},
                  ),
                  _buildCard(
                    title: 'Featured Programs',
                    imageAsset: 'assets/images/2689736.png',
                    onTap: () {},
                  ),
                  _buildCard(
                    title: 'Featured Programs',
                    imageAsset: 'assets/images/2689736.png',
                    onTap: () {},
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
      elevation: 6, // Add elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              child: Center(
                child: Image.asset(
                  imageAsset,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8), // Add spacing
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.blue, // Use your preferred color
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
