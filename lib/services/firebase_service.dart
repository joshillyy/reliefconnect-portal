import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';

import '../firebase_options.dart';

class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<bool> initialize() async {
    try {
      // Check if Firebase is already initialized
      if (Firebase.apps.isNotEmpty) {
        _isInitialized = true;
        debugPrint('[ReliefConnect] Firebase already initialized.');
        return true;
      }

      // Try initializing Firebase with platform options
      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        _isInitialized = true;
        debugPrint(
          '[ReliefConnect] Firebase initialized successfully with DefaultFirebaseOptions.',
        );
        return true;
      } catch (innerError) {
        // Fallback to default initializeApp
        await Firebase.initializeApp();
        _isInitialized = true;
        debugPrint(
          '[ReliefConnect] Firebase initialized with system default config.',
        );
        return true;
      }
    } catch (e) {
      _isInitialized = false;
      debugPrint(
        '[ReliefConnect] Live Firebase not configured on this machine: $e\n'
        'Activating offline DEMO MODE with realistic disaster relief data for faculty evaluation.',
      );
      return false;
    }
  }
}
