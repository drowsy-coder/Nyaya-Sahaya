import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:law/screens/intro_screen/intro_screen.dart';
import 'package:law/screens/login/login_page.dart';
import 'package:local_auth/local_auth.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final LocalAuthentication auth = LocalAuthentication();
  bool authenticated = false;

  try {
    authenticated = await auth.authenticate(
      localizedReason: 'Verify Fingerprint to Unlock the App',
      options: const AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: true,
      ),
    );
  } catch (e) {
    print("Fingerprint authentication error: $e");
  }

  if (authenticated) {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Login',
      theme: ThemeData.dark(),
      home: AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return user != null ? const LoginPage() : IntroScreen();
  }
}
