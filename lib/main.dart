import 'package:flutter/material.dart';

import 'app.dart';
import 'services/demo_data_service.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Safely attempt Firebase initialization; falls back to demo mode if credentials are not configured yet
  await FirebaseService.instance.initialize();

  // Ensure realistic demonstration data is seeded for viva and offline evaluation
  DemoDataService.instance.ensureInitialized();

  runApp(const ReliefConnectApp());
}
