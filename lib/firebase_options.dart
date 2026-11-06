import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with Firebase.initializeApp.
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
        return android;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux',
        );
      default:
        return android;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAmgv7vQItfRfoBYzJT3JR-4Fqv3O9d2Fo',
    appId: '1:711604503802:android:8dd87365b534c9f86ff543',
    messagingSenderId: '711604503802',
    projectId: 'bintang-pintar-app',
    storageBucket: 'bintang-pintar-app.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAmgv7vQItfRfoBYzJT3JR-4Fqv3O9d2Fo',
    appId: '1:711604503802:web:8dd87365b534c9f86ff543',
    messagingSenderId: '711604503802',
    projectId: 'bintang-pintar-app',
    storageBucket: 'bintang-pintar-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAmgv7vQItfRfoBYzJT3JR-4Fqv3O9d2Fo',
    appId: '1:711604503802:ios:8dd87365b534c9f86ff543',
    messagingSenderId: '711604503802',
    projectId: 'bintang-pintar-app',
    storageBucket: 'bintang-pintar-app.firebasestorage.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAmgv7vQItfRfoBYzJT3JR-4Fqv3O9d2Fo',
    appId: '1:711604503802:ios:8dd87365b534c9f86ff543',
    messagingSenderId: '711604503802',
    projectId: 'bintang-pintar-app',
    storageBucket: 'bintang-pintar-app.firebasestorage.app',
  );

  /// FirebaseOptions for supersinan-e8000 (Dedicated Question Bank Firestore)
  static const FirebaseOptions supersinan = FirebaseOptions(
    apiKey: 'AIzaSyAJEFiYgLQRF3t4qV8SNqcln6e7wFTH6qk',
    authDomain: 'supersinan-e8000.firebaseapp.com',
    projectId: 'supersinan-e8000',
    storageBucket: 'supersinan-e8000.firebasestorage.app',
    messagingSenderId: '443161971494',
    appId: '1:443161971494:web:c5e591bb0025a7b5e34fe7',
  );
}
