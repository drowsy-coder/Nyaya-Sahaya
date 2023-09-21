// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nyaya_sahaya/screens/login/login_old.dart';
import 'package:nyaya_sahaya/screens/stakeholders/client/client_screen.dart';
import 'package:nyaya_sahaya/screens/stakeholders/lawyer/lawyer_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Login',
      theme: ThemeData.dark(),
      home: ClientScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
