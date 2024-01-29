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
        return ios;
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
    apiKey: 'AIzaSyChFzrO0cUeTi6bCvOAfNMv5pHjwfPwk7A',
    appId: '1:503649637996:web:33138724588faae03caa49',
    messagingSenderId: '503649637996',
    projectId: 'eco-connect-5958d',
    authDomain: 'eco-connect-5958d.firebaseapp.com',
    storageBucket: 'eco-connect-5958d.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDh1oxXvjllCG3BOWXZb7AdbPHUqHjITME',
    appId: '1:503649637996:android:a2c28a2909abbb853caa49',
    messagingSenderId: '503649637996',
    projectId: 'eco-connect-5958d',
    storageBucket: 'eco-connect-5958d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDLEDOQLOjXp-oib-JUWPPTKMhT5CidHHc',
    appId: '1:503649637996:ios:d6c1b31fdaeaed213caa49',
    messagingSenderId: '503649637996',
    projectId: 'eco-connect-5958d',
    storageBucket: 'eco-connect-5958d.appspot.com',
    iosBundleId: 'com.example.ecoConnect',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDLEDOQLOjXp-oib-JUWPPTKMhT5CidHHc',
    appId: '1:503649637996:ios:67d4a08d014cf3c33caa49',
    messagingSenderId: '503649637996',
    projectId: 'eco-connect-5958d',
    storageBucket: 'eco-connect-5958d.appspot.com',
    iosBundleId: 'com.example.ecoConnect.RunnerTests',
  );
}