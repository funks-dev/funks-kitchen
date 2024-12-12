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
    apiKey: 'AIzaSyDs7GXp45nuRT-jlk4o6dnXJgNQqJFBKQw',
    appId: '1:772981263255:web:9b5f6724c3ce33dada12d2',
    messagingSenderId: '772981263255',
    projectId: 'funks-kitchen',
    authDomain: 'funks-kitchen.firebaseapp.com',
    storageBucket: 'funks-kitchen.firebasestorage.app',
    measurementId: 'G-8C2XY0H0TW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB8bWSxZ2Uh8wmqnIH0GVLK-_LVvIoHrw4',
    appId: '1:772981263255:android:ca3b089d813dfab4da12d2',
    messagingSenderId: '772981263255',
    projectId: 'funks-kitchen',
    storageBucket: 'funks-kitchen.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDB0jjMJ89Ogcw2X0zxVPwoFK4WMdjObaE',
    appId: '1:772981263255:ios:8b2bfa349448393bda12d2',
    messagingSenderId: '772981263255',
    projectId: 'funks-kitchen',
    storageBucket: 'funks-kitchen.firebasestorage.app',
    iosBundleId: 'com.example.funksKitchen2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDB0jjMJ89Ogcw2X0zxVPwoFK4WMdjObaE',
    appId: '1:772981263255:ios:8b2bfa349448393bda12d2',
    messagingSenderId: '772981263255',
    projectId: 'funks-kitchen',
    storageBucket: 'funks-kitchen.firebasestorage.app',
    iosBundleId: 'com.example.funksKitchen2',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDs7GXp45nuRT-jlk4o6dnXJgNQqJFBKQw',
    appId: '1:772981263255:web:ce4fe151a9242342da12d2',
    messagingSenderId: '772981263255',
    projectId: 'funks-kitchen',
    authDomain: 'funks-kitchen.firebaseapp.com',
    storageBucket: 'funks-kitchen.firebasestorage.app',
    measurementId: 'G-02X4KEPKYG',
  );
}
