import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(
    home: LawyerReadScreen(),
  ));
}

class LawyerReadScreen extends StatefulWidget {
  @override
  _LawyerReadScreenState createState() => _LawyerReadScreenState();
}

class _LawyerReadScreenState extends State<LawyerReadScreen> {
  List<Map<String, dynamic>> articleDetailsList = [
    {
      'title':
          'Certified Copy Can Be Produced To Prove Original Sale Deed In Trial : Supreme Court',
      'image': 'assets/images/news0.jpg',
      'url':
          'https://www.livelaw.in/supreme-court/certified-copy-can-be-produced-to-prove-original-sale-deed-in-trial-supreme-court-238454'
    },
    {
      'title':
          'Revision Of OBC Reservation List In Kerala: Supreme Court Issues Contempt Notice To Centre, Kerala Govt & KSCBC',
      'image': 'assets/images/news1.jpg',
      'url':
          'https://www.livelaw.in/top-stories/suprem-court-hearing-contempt-plea-reservation-list-revision-indra-sawhney-judgement-238434'
    },
    {
      'title':
          'Krishna Janmabhoomi Case | Supreme Court Leaves It Open To Allahabad HC To Decide Plea For Survey Of Shahi Eidgah Mosque',
      'image': 'assets/images/news2.jpg',
      'url':
          'https://www.livelaw.in/top-stories/supreme-court-krishna-janmabhoomi-shahi-eidgah-scientific-survey-238429'
    },
    {
      'title':
          'Prescribe Minimum Marks Requirement For Languages Other Than Tamil & English Also In TN Schools: Supreme Court In Linguistic Minorities\' Plea',
      'image': 'assets/images/news3.jpg',
      'url':
          'https://www.livelaw.in/supreme-court/suprem-court-tamil-paper-mandatory-10th-class-exam-minority-linguistic-language-tamilnadu-tamil-learning-act-238394'
    },
    {
      'title':
          'Hindu Marriage Act | Every Amendment Sought To Pleadings Can\'t Be Allowed, Party Must Show Irreparable Injury: Allahabad High Court',
      'image': 'assets/images/news4.jpg',
      'url':
          'https://www.livelaw.in/high-court/allahabad-high-court/allahabad-high-court-ruling-amendment-application-hindu-marriage-act-238450'
    },
    {
      'title':
          'Passport Act | Police Must Disclose Complete Status Of FIR In Police Verification: Punjab & Haryana High Court',
      'image': 'assets/images/news5.jpg',
      'url':
          'https://www.livelaw.in/high-court/punjab-and-haryana-high-court/punjab-haryana-high-court-passport-police-verification-complete-status-fir-238445'
    },
    {
      'title':
          'Delhi Court Refuses To Acquit Rajasthan CM Ashok Gehlot In Defamation Case By Union Minister Gajendra Singh Shekhawat',
      'image': 'assets/images/news6.jpg',
      'url':
          'https://www.livelaw.in/news-updates/delhi-court-acquit-rajasthan-chief-minister-ashok-gehlot-defamation-case-union-minister-gajendra-singh-shekhawat-238184'
    },
    {
      'title':
          'Principles To Prove Validity & Execution Of Will : Supreme Court Explains',
      'image': 'assets/images/news7.jpg',
      'url':
          'https://www.livelaw.in/supreme-court/validity-execution-of-will-supreme-court-explains-238387'
    },
    {
      'title':
          'Motor Accidents | Legal Representatives Entitled To Compensation Even If Not Dependents Or Legal Heirs: Kerala High Court',
      'image': 'assets/images/news8.jpg',
      'url':
          'https://www.livelaw.in/high-court/kerala-high-court/kerala-high-court-motor-accidents-legal-representatives-entitled-to-compensation-238452'
    },
    {
      'title':
          'Punjab & Haryana High Court Launches  RTI Portal, Virtual Court For Traffic Challan',
      'image': 'assets/images/news9.jpg',
      'url':
          'https://www.livelaw.in/high-court/punjab-and-haryana-high-court/punjab-haryana-high-court-virtual-court-traffic-challan-rti-portal-238436'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Legal News'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: <Widget>[
          for (var article in articleDetailsList)
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: const EdgeInsets.all(10),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    article['image'],
                    width: 100,
                    height: 199,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  article['title'],
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
                onTap: () {
                  _launchURL(article['url']);
                },
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
