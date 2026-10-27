import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class AppStateProvider extends ChangeNotifier {
  bool _isDemoMode = true; // Defaults to reliable demo mode
  bool _initialized = false;

  bool get isDemoMode => _isDemoMode;
  bool get isInitialized => _initialized;
  bool get isFirebaseAvailable =>
      FirebaseService.instance.isInitialized &&
      FirebaseService.instance.hasRealFirebaseConfig;

  void initialize() {
    if (isFirebaseAvailable) {
      _isDemoMode = false;
    } else {
      _isDemoMode = true;
    }
    _initialized = true;
    notifyListeners();
  }

  void toggleDemoMode(bool enableDemo) {
    if (!enableDemo && !isFirebaseAvailable) {
      return;
    }
    _isDemoMode = enableDemo;
    notifyListeners();
  }
}
