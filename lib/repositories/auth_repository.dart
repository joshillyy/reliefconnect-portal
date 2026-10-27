import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../core/constants/app_constants.dart';
import '../models/user_model.dart';
import '../services/demo_data_service.dart';
import '../services/firebase_service.dart';

class AuthRepository {
  final _uuid = const Uuid();

  bool get _isLiveFirebase =>
      FirebaseService.instance.isInitialized &&
      FirebaseService.instance.hasRealFirebaseConfig;

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
    required UserRole role,
    String? adminBootstrapCode,
    bool forceDemo = false,
  }) async {
    // Role protection validation
    if (role == UserRole.admin) {
      if (adminBootstrapCode?.trim() != AppConstants.adminBootstrapCode) {
        throw Exception(
          'Administrator registration requires an authorized Coordinator Bootstrap Key. '
          'Contact the relief command center or enter the demo key (RELIEF2026).',
        );
      }
    }

    if (!_isLiveFirebase || forceDemo) {
      // Demo Mode Registration
      final normalizedEmail = email.trim().toLowerCase();

      final newUser = UserModel(
        id: 'usr_${_uuid.v4().substring(0, 8)}',
        name: name.trim(),
        email: normalizedEmail,
        phone: phone.trim(),
        role: role,
        skills: role == UserRole.volunteer ? ['First Aid & CPR'] : [],
        location: 'Volunteer Pool',
        completedTasksCount: 0,
        createdAt: DateTime.now(),
        isAdminBootstrapVerified: role == UserRole.admin,
      );

      DemoDataService.instance.addUser(newUser);
      return newUser;
    }

    // Live Firebase Registration
    try {
      final cred = await fb.FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password,
          );

      final user = cred.user;
      if (user == null) throw Exception('Firebase user creation failed.');

      final newUser = UserModel(
        id: user.uid,
        name: name.trim(),
        email: email.trim().toLowerCase(),
        phone: phone.trim(),
        role: role,
        skills: role == UserRole.volunteer ? ['First Aid & CPR'] : [],
        location: '',
        completedTasksCount: 0,
        createdAt: DateTime.now(),
        isAdminBootstrapVerified: role == UserRole.admin,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(newUser.toMap());

      return newUser;
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Authentication failed.');
    } catch (e) {
      throw Exception('Registration error: $e');
    }
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
    bool forceDemo = false,
  }) async {
    if (!_isLiveFirebase || forceDemo) {
      // Demo Mode Sign In
      final normalizedEmail = email.trim().toLowerCase();
      var user = DemoDataService.instance.getUserByEmail(normalizedEmail);

      if (user == null) {
        // Auto-create on the fly so login never fails for any custom credentials!
        final namePart = normalizedEmail.split('@')[0];
        final cleanName = namePart.isNotEmpty
            ? namePart[0].toUpperCase() + namePart.substring(1)
            : 'Volunteer';

        user = UserModel(
          id: 'usr_${_uuid.v4().substring(0, 8)}',
          name: cleanName,
          email: normalizedEmail,
          phone: '9876543210',
          role: UserRole.volunteer,
          skills: ['First Aid & CPR'],
          location: 'Relief Center',
          completedTasksCount: 1,
          createdAt: DateTime.now(),
        );
        DemoDataService.instance.addUser(user);
      }
      return user;
    }

    // Live Firebase Sign In
    try {
      final cred = await fb.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = cred.user;
      if (user == null) throw Exception('User not found.');

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (!doc.exists || doc.data() == null) {
        return UserModel(
          id: user.uid,
          name: user.displayName ?? 'Volunteer',
          email: user.email ?? email,
          phone: '',
          role: UserRole.volunteer,
          createdAt: DateTime.now(),
        );
      }

      return UserModel.fromMap(doc.data()!, doc.id);
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Sign in failed.');
    } catch (e) {
      throw Exception('Authentication error: $e');
    }
  }

  Future<void> sendPasswordReset(String email, {bool forceDemo = false}) async {
    if (!_isLiveFirebase || forceDemo) {
      return;
    }

    try {
      await fb.FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Failed to send password reset email.');
    }
  }

  Future<UserModel> updateUserProfile(
    UserModel user, {
    bool forceDemo = false,
  }) async {
    if (!_isLiveFirebase || forceDemo) {
      DemoDataService.instance.updateUser(user);
      return user;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .update(user.toMap());
      return user;
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<void> signOut({bool forceDemo = false}) async {
    if (_isLiveFirebase && !forceDemo) {
      await fb.FirebaseAuth.instance.signOut();
    }
  }
}
