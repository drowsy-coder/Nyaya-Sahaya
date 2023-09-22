import 'package:flutter/material.dart';

class MentalHealthIssuesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental Health Issues'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildMentalHealthIssueCard(
              context,
              'Anxiety',
              'assets/images/anxiety.png', // Replace with your image asset
              [
                'Feeling constantly worried or on edge',
                'Restlessness and difficulty concentrating',
                'Physical symptoms like increased heart rate',
              ],
            ),
            _buildMentalHealthIssueCard(
              context,
              'Depression',
              'assets/images/depression.png', // Replace with your image asset
              [
                'Persistent sadness and loss of interest in activities',
                'Fatigue and lack of energy',
                'Changes in appetite and sleep patterns',
              ],
            ),
            _buildMentalHealthIssueCard(
              context,
              'Stress',
              'assets/images/stress.png',
              [
                'Feeling overwhelmed by life events',
                'Muscle tension and irritability',
                'Difficulty relaxing and switching off',
              ],
            ),
            _buildMentalHealthIssueCard(
              context,
              'Trauma',
              'assets/images/frustrated.png',
              [
                'Flashbacks and intrusive memories',
                'Feeling emotionally numb or detached',
                'Difficulty trusting others and forming relationships',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMentalHealthIssueCard(BuildContext context, String title,
      String imagePath, List<String> bulletPoints) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: bulletPoints.map((point) {
              return ListTile(
                leading: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                title: Text(point),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
