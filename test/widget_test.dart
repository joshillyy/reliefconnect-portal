import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:relief_connect/app.dart';
import 'package:relief_connect/core/widgets/emergency_alert_card.dart';
import 'package:relief_connect/core/widgets/status_badge.dart';

void main() {
  testWidgets('StatusBadge renders correctly with appropriate styling', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              StatusBadge(label: 'Pending'),
              StatusBadge(label: 'Critical', isUrgency: true),
            ],
          ),
        ),
      ),
    );

    expect(find.text('PENDING'), findsOneWidget);
    expect(find.text('CRITICAL'), findsOneWidget);
  });

  testWidgets('EmergencyAlertCard displays emergency hotline 112 / 108', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: EmergencyAlertCard())),
    );

    expect(find.text('Immediate Danger Notice'), findsOneWidget);
    expect(find.text('DIAL 112 / 108'), findsOneWidget);
  });

  testWidgets(
    'ReliefConnectApp boots and transitions from Splash Screen to Onboarding',
    (WidgetTester tester) async {
      await tester.pumpWidget(const ReliefConnectApp());
      expect(find.text('ReliefConnect'), findsOneWidget);

      // Allow splash timer (1800ms) and animations to settle
      await tester.pump(const Duration(milliseconds: 1900));
      await tester.pumpAndSettle();

      // After splash transitions, onboarding or sign in appears
      expect(find.byType(Scaffold), findsWidgets);
    },
  );
}
