import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as html;
import 'package:url_launcher/url_launcher.dart';

class LawyerReadScreen extends StatefulWidget {
  @override
  _LawyerReadScreenState createState() => _LawyerReadScreenState();
}

class _LawyerReadScreenState extends State<LawyerReadScreen> {
  List<Map<String, dynamic>> articleDetailsList = [
    {
      'url':
          'https://www.livelaw.in/supreme-court/certified-copy-can-be-produced-to-prove-original-sale-deed-in-trial-supreme-court-238454',
      'title':
          'Certified Copy Can Be Produced to Prove Original Sale Deed in Trial: Supreme Court',
    },
    {
      'url':
          'https://www.livelaw.in/top-stories/suprem-court-hearing-contempt-plea-reservation-list-revision-indra-sawhney-judgement-238434',
      'title':
          'Supreme Court Hearing Contempt Plea for Reservation List Revision in Indra Sawhney Judgement',
    },
    {
      'url':
          'https://www.livelaw.in/top-stories/supreme-court-krishna-janmabhoomi-shahi-eidgah-scientific-survey-238429',
      'title':
          'Supreme Court Orders Scientific Survey at Krishna Janmabhoomi in Mathura',
    },
    {
      'url':
          'https://www.livelaw.in/supreme-court/suprem-court-tamil-paper-mandatory-10th-class-exam-minority-linguistic-language-tamilnadu-tamil-learning-act-238394',
      'title':
          'Supreme Court: Tamil Paper for Mandatory 10th Class Exam for Minority Linguistic Language in Tamil Nadu',
    },
    {
      'url':
          'https://www.livelaw.in/high-court/allahabad-high-court/allahabad-high-court-ruling-amendment-application-hindu-marriage-act-238450',
      'title':
          'Allahabad High Court Rules on Amendment Application under Hindu Marriage Act',
    },
    {
      'url':
          'https://www.livelaw.in/high-court/punjab-and-haryana-high-court/punjab-haryana-high-court-passport-police-verification-complete-status-fir-238445',
      'title':
          'Punjab & Haryana High Court: Passport Police Verification - Complete Status Must be Provided in FIR',
    },
    {
      'url':
          'https://www.livelaw.in/news-updates/delhi-court-acquit-rajasthan-chief-minister-ashok-gehlot-defamation-case-union-minister-gajendra-singh-shekhawat-238184',
      'title':
          'Delhi Court Acquits Rajasthan Chief Minister Ashok Gehlot in Defamation Case Against Union Minister Gajendra Singh Shekhawat',
    },
    {
      'url':
          'https://www.livelaw.in/supreme-court/validity-execution-of-will-supreme-court-explains-238387',
      'title':
          'Validity of Execution of Will: Supreme Court Explains the Legal Position',
    },
    {
      'url':
          'https://www.livelaw.in/high-court/kerala-high-court/kerala-high-court-motor-accidents-legal-representatives-entitled-to-compensation-238452',
      'title':
          'Kerala High Court: Motor Accidents - Legal Representatives Entitled to Compensation Even Without Medical Bills',
    },
    {
      'url':
          'https://www.livelaw.in/high-court/punjab-and-haryana-high-court/punjab-haryana-high-court-virtual-court-traffic-challan-rti-portal-238436',
      'title':
          'Punjab & Haryana High Court: Virtual Court for Traffic Challan - Use RTI Portal for Information',
    },
  ];

  Future<void> fetchArticleDetails() async {
    for (var article in articleDetailsList) {
      String url = article['url'];
      try {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final document = htmlParser.parse(response.body);
          final thumbnail = document
              .querySelector('meta[property="og:image"]')
              ?.attributes['content'];

          setState(() {
            article['thumbnail'] = thumbnail ?? '';
          });
        } else {
          throw Exception('Failed to load article details');
        }
      } catch (e) {
        throw Exception('Failed to fetch article details for $url: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchArticleDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article Cards Example'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: <Widget>[
          for (var article in articleDetailsList)
            Card(
              elevation: 3,
              margin: const EdgeInsets.all(10),
              child: ListTile(
                leading: article['thumbnail'] != null
                    ? Image.network(article['thumbnail'])
                    : SizedBox(),
                title: Text(article['title']),
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

  Future<void> launchUrl(Uri uri) async {
    final urlString = uri.toString();
    if (await canLaunch(urlString)) {
      await launch(urlString);
    } else {
      throw 'Could not launch $urlString';
    }
  }

  Future<bool> canLaunchUrl(Uri uri) async {
    final urlString = uri.toString();
    return await canLaunch(urlString);
  }
}

void main() {
  runApp(MaterialApp(
    home: LawyerReadScreen(),
  ));
}
