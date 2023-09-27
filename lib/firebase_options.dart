// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA-g7v3SUbPfAGQmPpjSY0VJYzXjK0v1SU',
    appId: '1:1034164058516:web:429070eb256899b861f781',
    messagingSenderId: '1034164058516',
    projectId: 'testlaw-7aced',
    authDomain: 'testlaw-7aced.firebaseapp.com',
    storageBucket: 'testlaw-7aced.appspot.com',
    measurementId: 'G-P2EGY7LS6Y',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBJuTdzZWhPBFzOC8LmToGjmFpktA1ZEvw',
    appId: '1:1034164058516:android:0f6b48a5ea83e93461f781',
    messagingSenderId: '1034164058516',
    projectId: 'testlaw-7aced',
    storageBucket: 'testlaw-7aced.appspot.com',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDSEBY8SHQ6vRsTf3KM2UF0iiN8t79WVOE',
    appId: '1:1034164058516:ios:af95afc66f36ccb261f781',
    messagingSenderId: '1034164058516',
    projectId: 'testlaw-7aced',
    storageBucket: 'testlaw-7aced.appspot.com',
    iosBundleId: 'com.sunflower.law.RunnerTests',
  );
}
