import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'providers/activity_provider.dart';
import 'providers/app_state_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/relief_request_provider.dart';
import 'providers/relief_task_provider.dart';
import 'screens/auth/splash_screen.dart';

class ReliefConnectApp extends StatelessWidget {
  const ReliefConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ReliefRequestProvider()),
        ChangeNotifierProvider(create: (_) => ReliefTaskProvider()),
        ChangeNotifierProvider(create: (_) => ActivityProvider()),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
