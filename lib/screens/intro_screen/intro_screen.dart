import 'package:flutter/material.dart';
import 'package:law/screens/intro_screen/screen1.dart';
import 'package:law/screens/intro_screen/screen2.dart';
import 'package:law/screens/intro_screen/screen3.dart';
import 'package:law/screens/login/login_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroScreen extends StatefulWidget {
  IntroScreen({Key? key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (value) {
              setState(() {
                onLastPage = value == 2; // Assuming you have 3 pages
              });
            },
            controller: _controller,
            children: [Page3(), Page2(), Page1()],
          ),
          Container(
            alignment: Alignment(0, 0.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  child: Text(
                    "back",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    _controller.previousPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  },
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                ),
                GestureDetector(
                  child: Text(
                    onLastPage ? "done" : "next",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    if (onLastPage) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    } else {
                      _controller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
