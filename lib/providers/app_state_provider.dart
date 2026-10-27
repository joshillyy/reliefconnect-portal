import 'package:flutter/material.dart';

import '../services/firebase_service.dart';

class AppStateProvider extends ChangeNotifier {
  bool _isDemoMode =
      true; // Defaults to safe demo mode unless Firebase is verified
  bool _initialized = false;

  bool get isDemoMode => _isDemoMode;
  bool get isInitialized => _initialized;
  bool get isFirebaseAvailable => FirebaseService.instance.isInitialized;

  void initialize() {
    // If Firebase initialized cleanly, we can allow live mode, otherwise lock to demo
    if (FirebaseService.instance.isInitialized) {
      _isDemoMode = false;
    } else {
      _isDemoMode = true;
    }
    _initialized = true;
    notifyListeners();
  }

  void toggleDemoMode(bool enableDemo) {
    if (!enableDemo && !FirebaseService.instance.isInitialized) {
      // Cannot enable live Firebase if not initialized
      return;
    }
    _isDemoMode = enableDemo;
    notifyListeners();
  }
}
