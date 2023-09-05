import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../stakeholders/client_home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _caseNumberController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoginForm = true;
  bool _isLoading = false;

  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

   void _initSharedPreferences() async {
  _prefs = await SharedPreferences.getInstance();

  final String? uid = _prefs.getString('uid');
  if (uid != null) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ClientHomePage()));
  }
}


  void _saveUserDataToPrefs(String uid, String email, String caseNumber) {
    _prefs.setString('uid', uid);
    _prefs.setString('email', email);
    _prefs.setString('caseNumber', caseNumber);
  }

  void _logout() {
  _prefs.remove('uid');
  _prefs.remove('email');
  _prefs.remove('caseNumber');
  _prefs.remove('isLoggedIn');

  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
}


  Future<void> _signInWithEmail(String email, String password) async {
  setState(() {
    _isLoading = true;
  });

  try {
    final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final User user = userCredential.user!;

    await _storeUserData(user.uid);

    _saveUserDataToPrefs(user.uid, email, _caseNumberController.text.trim());

    _prefs.setBool('isLoggedIn', true);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ClientHomePage()));
  } on FirebaseAuthException catch (e) {
    setState(() {
      _isLoading = false;
    });

    print('Failed to sign in with email and password: ${e.message}');
  }
}

Future<void> _createAccount(String email, String password) async {
  setState(() {
    _isLoading = true;
  });

  try {
    final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final User user = userCredential.user!;

    await _storeUserData(user.uid);

    _saveUserDataToPrefs(user.uid, email, _caseNumberController.text.trim());

    _prefs.setBool('isLoggedIn', true);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ClientHomePage()));
  } on FirebaseAuthException catch (e) {
    setState(() {
      _isLoading = false;
    });

    print('Failed to create user account: ${e.message}');
  }
}

  Future<void> _storeUserData(String uid) async {
    final String email = _emailController.text.trim();
    final String caseNumber = _caseNumberController.text.trim();

    await _firestore.collection('users').doc(uid).set({
      'name': email.split('@')[0],
      'email': email,
      'caseNumber': caseNumber,
      'uid': uid,
    });
  }

  void _submitForm() {
    if (_isLoginForm) {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      _signInWithEmail(email, password);
    } else {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      _createAccount(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLoginForm ? 'Login' : 'Create Account'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              if (!_isLoginForm)
                TextFormField(
                  controller: _caseNumberController,
                  decoration: const InputDecoration(labelText: 'Case Number'),
                ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(_isLoginForm ? 'Login' : 'Create Account'),
              ),
              TextButton(
                onPressed: _toggleFormMode,
                child: Text(_isLoginForm ? 'Create an account' : 'Have an account? Sign in'),
              ),
              if (_isLoading)
                const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleFormMode() {
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }
}
