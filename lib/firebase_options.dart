// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBlbIjGyi7d_3TEQYKeDtj6aZddUPrHMys',
    appId: '1:1067887184197:web:6b797c3be1e12f0236162c',
    messagingSenderId: '1067887184197',
    projectId: 'bookit-d3106',
    authDomain: 'bookit-d3106.firebaseapp.com',
    storageBucket: 'bookit-d3106.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCVYtZQAYQwtpk1pBhcNpD2OMacQi7O6SM',
    appId: '1:1067887184197:android:a70aecb7798f93cd36162c',
    messagingSenderId: '1067887184197',
    projectId: 'bookit-d3106',
    storageBucket: 'bookit-d3106.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCboIFEha9cA8wIzSOan1a7sMURoCFTZsY',
    appId: '1:1067887184197:ios:24fa2baf5d09322a36162c',
    messagingSenderId: '1067887184197',
    projectId: 'bookit-d3106',
    storageBucket: 'bookit-d3106.appspot.com',
    iosBundleId: 'com.example.finalProject',
  );
}
