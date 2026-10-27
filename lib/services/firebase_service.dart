import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  bool get hasRealFirebaseConfig {
    try {
      final key = DefaultFirebaseOptions.currentPlatform.apiKey;
      return key.isNotEmpty &&
          !key.contains('Placeholder') &&
          !key.contains('Demo') &&
          key != 'AIzaSyDemoPlaceholderWebKey';
    } catch (_) {
      return false;
    }
  }

  Future<bool> initialize() async {
    // If credentials are only placeholder templates, keep live mode disabled
    if (!hasRealFirebaseConfig) {
      _isInitialized = false;
      debugPrint(
        '[ReliefConnect] Live Firebase project not yet configured. Running in DEMO MODE with instant local authentication.',
      );
      return false;
    }

    try {
      if (Firebase.apps.isNotEmpty) {
        _isInitialized = true;
        return true;
      }

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _isInitialized = true;
      debugPrint('[ReliefConnect] Firebase initialized with real credentials.');
      return true;
    } catch (e) {
      _isInitialized = false;
      debugPrint('[ReliefConnect] Firebase initialization failed: $e. Using Demo Mode.');
      return false;
    }
  }
}
