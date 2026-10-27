import 'package:flutter_test/flutter_test.dart';
import 'package:relief_connect/core/utils/validators.dart';

void main() {
  group('Validators Unit Tests', () {
    test('Email validator accepts valid emails and rejects invalid ones', () {
      expect(Validators.email('test@reliefconnect.org'), isNull);
      expect(Validators.email('volunteer.123@gmail.com'), isNull);
      expect(Validators.email(''), isNotNull);
      expect(Validators.email('invalid-email'), isNotNull);
      expect(Validators.email('user@'), isNotNull);
    });

    test('Password validator requires at least 6 characters', () {
      expect(Validators.password('password123'), isNull);
      expect(Validators.password('123456'), isNull);
      expect(Validators.password('12345'), isNotNull);
      expect(Validators.password(''), isNotNull);
      expect(Validators.password(null), isNotNull);
    });

    test('Phone validator checks 10-13 digit numbers', () {
      expect(Validators.phone('9876543210'), isNull);
      expect(Validators.phone('+91 9876543210'), isNull);
      expect(Validators.phone('12345'), isNotNull);
      expect(Validators.phone(''), isNotNull);
    });

    test('Positive integer validator requires positive number', () {
      expect(Validators.positiveInteger('1'), isNull);
      expect(Validators.positiveInteger('45'), isNull);
      expect(Validators.positiveInteger('0'), isNotNull);
      expect(Validators.positiveInteger('-5'), isNotNull);
      expect(Validators.positiveInteger('abc'), isNotNull);
      expect(Validators.positiveInteger(''), isNotNull);
    });

    test('Required field validator checks for empty or whitespace strings', () {
      expect(Validators.required('Silchar Ward 4'), isNull);
      expect(Validators.required(''), isNotNull);
      expect(Validators.required('   '), isNotNull);
      expect(Validators.required(null), isNotNull);
    });
  });
}
