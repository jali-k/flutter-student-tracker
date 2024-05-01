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
    apiKey: 'AIzaSyBUv69HkuCHHvHt4Leeushx4NQhIzr4VJg',
    appId: '1:399348135128:web:68e3111c7c123cf61613ad',
    messagingSenderId: '399348135128',
    projectId: 'student-progress-app-854fa',
    authDomain: 'student-progress-app-854fa.firebaseapp.com',
    storageBucket: 'student-progress-app-854fa.appspot.com',
    measurementId: 'G-F5952E1HJV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDKsMCsKiab_5HoMsnZrOKpDsIWTu50Lko',
    appId: '1:399348135128:android:049ae50601c9b5e81613ad',
    messagingSenderId: '399348135128',
    projectId: 'student-progress-app-854fa',
    storageBucket: 'student-progress-app-854fa.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC1gg412UaN1wq3VqzBBuS_XCGuCggNZC0',
    appId: '1:399348135128:ios:c411579ccf4a5f5d1613ad',
    messagingSenderId: '399348135128',
    projectId: 'student-progress-app-854fa',
    storageBucket: 'student-progress-app-854fa.appspot.com',
    iosBundleId: 'com.spt.spt',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC1gg412UaN1wq3VqzBBuS_XCGuCggNZC0',
    appId: '1:399348135128:ios:447d9cf96e6bebb71613ad',
    messagingSenderId: '399348135128',
    projectId: 'student-progress-app-854fa',
    storageBucket: 'student-progress-app-854fa.appspot.com',
    iosBundleId: 'com.spt.spt.RunnerTests',
  );
}