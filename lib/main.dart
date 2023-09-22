import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
<<<<<<< HEAD
import 'package:law/screens/login/login_page.dart';
=======
import 'package:firebase_auth/firebase_auth.dart';
import 'package:law/screens/intro_screen/intro_screen.dart';
import 'package:law/screens/login/login_page.dart';

>>>>>>> 2f77740f8825e79643894a568f87cdeb7c502809
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Login',
      theme: ThemeData.dark(),
<<<<<<< HEAD
      home: LoginPage(),
=======
      home: AuthWrapper(), // Use AuthWrapper as the initial widget
>>>>>>> 2f77740f8825e79643894a568f87cdeb7c502809
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return user != null ? LoginPage() : IntroScreen();
  }
}
