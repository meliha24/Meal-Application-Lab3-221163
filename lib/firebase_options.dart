// lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return FirebaseOptions(
      apiKey: 'AIzaSyBDZdgL2f1B89ql_CCdIl0CK8gdT_x-TgM',
      appId: '1:521058915290:android:cd1f936090385a86c8a6e3',
      messagingSenderId: '521058915290',
      projectId: 'meal-app',
    );
  }
}
