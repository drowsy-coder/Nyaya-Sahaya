// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nyaya_sahaya/screens/stakeholders/lawyer_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../stakeholders/client_home.dart';

enum UserRole {
  lawyer,
  client,
}

String userRoleToString(UserRole role) {
  return role.toString().split('.').last;
}

UserRole stringToUserRole(String role) {
  return UserRole.values.firstWhere(
    (e) => e.toString().split('.').last == role,
    orElse: () => UserRole.client,
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _identifierController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoginForm = true;
  bool _isLoading = false;
  UserRole _userRole = UserRole.client;

  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  void _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = _prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      final String? uid = _prefs.getString('uid');
      final String? email = _prefs.getString('email');
      final String? identifier = _prefs.getString('identifier');
      final String? storedUserRole = _prefs.getString('userRole');

      if (uid != null &&
          email != null &&
          identifier != null &&
          storedUserRole != null) {
        setState(() {
          _userRole = stringToUserRole(storedUserRole);
        });

        if (_userRole == UserRole.client) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ClientHomePage(),
            ),
          );
        } else if (_userRole == UserRole.lawyer) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LawyerHomePage(),
            ),
          );
        }
      }
    }
  }

  void _saveUserDataToPrefs(String uid, String email, String identifier) {
    _prefs.setString('uid', uid);
    _prefs.setString('email', email);
    _prefs.setString('identifier', identifier);
    _prefs.setString('userRole', userRoleToString(_userRole));
  }

  Future<void> _signInWithEmail(
      String email, String password, String identifier) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User user = userCredential.user!;
      final String uid = user.uid;

      final DocumentSnapshot userData =
          await _firestore.collection('users').doc(uid).get();

      if (userData.exists) {
        final String storedUserRole = userData['userRole'];
        final UserRole userRole = stringToUserRole(storedUserRole);

        if (userRole == _userRole && userData['identifier'] == identifier) {
          await _storeUserData(uid, email, identifier);

          _saveUserDataToPrefs(uid, email, identifier);

          _prefs.setBool('isLoggedIn', true);
          Navigator.of(context).pop();
          if (_userRole == UserRole.client) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const ClientHomePage()));
          } else if (_userRole == UserRole.lawyer) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const LawyerHomePage()));
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Failed to sign in with email and password: ${e.message}');
    }
  }

  Future<void> _createAccount(
      String email, String password, String identifier) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User user = userCredential.user!;
      final String uid = user.uid;

      await _storeUserData(uid, email, identifier);

      _saveUserDataToPrefs(uid, email, identifier);

      _prefs.setBool('isLoggedIn', true);

      if (_userRole == UserRole.client) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const ClientHomePage()));
      } else if (_userRole == UserRole.lawyer) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LawyerHomePage()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });

      print('Failed to create user account: ${e.message}');
    }
  }

  Future<void> _storeUserData(
      String uid, String email, String identifier) async {
    await _firestore.collection('users').doc(uid).set({
      'name': email.split('@')[0],
      'email': email,
      'identifier': identifier,
      'userRole': userRoleToString(_userRole),
      if (_userRole == UserRole.client) 'caseNumber': identifier,
      if (_userRole == UserRole.lawyer) 'barNumber': identifier,
      'uid': uid,
    });
  }

  void _submitForm() {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String identifier = _identifierController.text.trim();

    if (_isLoginForm) {
      _signInWithEmail(email, password, identifier);
    } else {
      _createAccount(email, password, identifier);
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
              // Role selection
              DropdownButtonFormField<UserRole>(
                value: _userRole,
                onChanged: (UserRole? newValue) {
                  setState(() {
                    _userRole = newValue!;
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: UserRole.client,
                    child: Text('Client'),
                  ),
                  DropdownMenuItem(
                    value: UserRole.lawyer,
                    child: Text('Lawyer'),
                  ),
                ],
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              if (_userRole == UserRole.lawyer)
                TextFormField(
                  controller: _identifierController,
                  decoration: const InputDecoration(labelText: 'Bar Number'),
                ),
              if (_userRole == UserRole.client)
                TextFormField(
                  controller: _identifierController,
                  decoration: const InputDecoration(labelText: 'Case Number'),
                ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(_isLoginForm ? 'Login' : 'Create Account'),
              ),
              TextButton(
                onPressed: _toggleFormMode,
                child: Text(_isLoginForm
                    ? 'Create an account'
                    : 'Have an account? Sign in'),
              ),
              if (_isLoading) const CircularProgressIndicator(),
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
