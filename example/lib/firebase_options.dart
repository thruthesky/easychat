// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyBz2OFyac4LdNAA8jomtLlpSdBsO1BWyjY',
    appId: '1:817502397544:web:c3089782f014d4032487dd',
    messagingSenderId: '817502397544',
    projectId: 'withcenter-test-2',
    authDomain: 'withcenter-test-2.firebaseapp.com',
    databaseURL: 'https://withcenter-test-2-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'withcenter-test-2.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDAIKWyh_TWL2I9gYmkQhEjsuGDrn0xYNw',
    appId: '1:817502397544:android:85a62bf26a22aa032487dd',
    messagingSenderId: '817502397544',
    projectId: 'withcenter-test-2',
    databaseURL: 'https://withcenter-test-2-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'withcenter-test-2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB5-ncie3C1gmgypFVyvQPfzRIyh-RjH3M',
    appId: '1:817502397544:ios:53c68169cfdd7f282487dd',
    messagingSenderId: '817502397544',
    projectId: 'withcenter-test-2',
    databaseURL: 'https://withcenter-test-2-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'withcenter-test-2.appspot.com',
    androidClientId: '817502397544-0ojaqhcn44u9e46oor7h4iop111phb2i.apps.googleusercontent.com',
    iosBundleId: 'com.example.example',
  );
}
