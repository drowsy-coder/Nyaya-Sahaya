import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_role.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signInWithEmail(
    String email,
    String password,
    String identifier,
    UserRole userRole,
  ) async {
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
        final UserRole storedUserRoleEnum = stringToUserRole(storedUserRole);

        if (storedUserRoleEnum == userRole &&
            userData['identifier'] == identifier) {
          final String displayName =
              userData['name']; // Get the name from Firestore
          await user.updateDisplayName(
              displayName); // Update the user's display name

          _storeUserData(uid, email, identifier, userRole);
        }
      }
    } on FirebaseAuthException catch (e) {
      print('Failed to sign in with email and password: ${e.message}');
      throw e;
    }
  }

  Future<void> createAccount(
    String email,
    String password,
    String identifier,
    UserRole userRole,
  ) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User user = userCredential.user!;
      final String uid = user.uid;

      final DocumentSnapshot userData =
          await _firestore.collection('users').doc(uid).get();

      if (userData.exists) {
        final String storedUserRole = userData['userRole'];
        final UserRole storedUserRoleEnum = stringToUserRole(storedUserRole);

        if (storedUserRoleEnum == userRole &&
            userData['identifier'] == identifier) {
          final String displayName =
              userData['name']; // Get the name from Firestore
          await user.updateDisplayName(
              displayName); // Update the user's display name

          _storeUserData(uid, email, identifier, userRole);
        }
      }
    } on FirebaseAuthException catch (e) {
      print('Failed to create user account: ${e.message}');
      throw e;
    }
  }

  Future<void> _storeUserData(
      String uid, String email, String identifier, UserRole userRole) async {
    await _firestore.collection('users').doc(uid).set({
      'name': email.split('@')[0],
      'email': email,
      'identifier': identifier,
      'userRole': userRoleToString(userRole),
      if (userRole == UserRole.client) 'caseNumber': identifier,
      if (userRole == UserRole.lawyer) 'barNumber': identifier,
      'uid': uid,
    });
  }
}
