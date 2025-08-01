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
    apiKey: 'AIzaSyAKu8B19c3vg52c_zr6AuX7hJFD7rUJgZo',
    appId: '1:437425472246:web:ce9e85acc1eba6b26722d7',
    messagingSenderId: '437425472246',
    projectId: 'nama-e8bf9',
    authDomain: 'nama-e8bf9.firebaseapp.com',
    storageBucket: 'nama-e8bf9.appspot.com',
    measurementId: 'G-W0V7Q06YG5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAfRruG8mU1QukBBSjRB_MWgkD91R_cW8M',
    appId: '1:437425472246:android:5a334753362ddb326722d7',
    messagingSenderId: '437425472246',
    projectId: 'nama-e8bf9',
    storageBucket: 'nama-e8bf9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCzpkpHGZ2Dv2jRNNOuJeH3joT2y5-iaHU',
    appId: '1:437425472246:ios:2b550b84c2d52a396722d7',
    messagingSenderId: '437425472246',
    projectId: 'nama-e8bf9',
    storageBucket: 'nama-e8bf9.appspot.com',
    iosClientId:
        '437425472246-diubalruiea7p6n90bc6jttaldmg5o53.apps.googleusercontent.com',
    iosBundleId: 'com.DarkshanDev.sinol',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCzpkpHGZ2Dv2jRNNOuJeH3joT2y5-iaHU',
    appId: '1:437425472246:ios:2b550b84c2d52a396722d7',
    messagingSenderId: '437425472246',
    projectId: 'nama-e8bf9',
    storageBucket: 'nama-e8bf9.appspot.com',
    iosClientId:
        '437425472246-diubalruiea7p6n90bc6jttaldmg5o53.apps.googleusercontent.com',
    iosBundleId: 'com.DarkshanDev.sinol',
  );
}
