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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyA67TFeKWFYXHXOKHtsTFtQuaFkG_y04Yg',
    appId: '1:229392966027:web:6b593d8e1b7192f726cf8e',
    messagingSenderId: '229392966027',
    projectId: 'prospereai-27e40',
    authDomain: 'prospereai-27e40.firebaseapp.com',
    storageBucket: 'prospereai-27e40.appspot.com',
    measurementId: 'G-0YCY7L0MKR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDJGnuNFEXpKo7W1cg1GjHxEdjG4cP1ia4',
    appId: '1:229392966027:android:f6ef7a435c11cfef26cf8e',
    messagingSenderId: '229392966027',
    projectId: 'prospereai-27e40',
    storageBucket: 'prospereai-27e40.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBe4JRXTAmE8LKuOet6jneB52W8X_KjUxs',
    appId: '1:229392966027:ios:a8ed0ea2fd3e0a7b26cf8e',
    messagingSenderId: '229392966027',
    projectId: 'prospereai-27e40',
    storageBucket: 'prospereai-27e40.appspot.com',
    iosBundleId: 'com.example.prospereAi',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBe4JRXTAmE8LKuOet6jneB52W8X_KjUxs',
    appId: '1:229392966027:ios:a8ed0ea2fd3e0a7b26cf8e',
    messagingSenderId: '229392966027',
    projectId: 'prospereai-27e40',
    storageBucket: 'prospereai-27e40.appspot.com',
    iosBundleId: 'com.example.prospereAi',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA67TFeKWFYXHXOKHtsTFtQuaFkG_y04Yg',
    appId: '1:229392966027:web:b074c6c8f2e9043526cf8e',
    messagingSenderId: '229392966027',
    projectId: 'prospereai-27e40',
    authDomain: 'prospereai-27e40.firebaseapp.com',
    storageBucket: 'prospereai-27e40.appspot.com',
    measurementId: 'G-F5J4WCZGBJ',
  );

}