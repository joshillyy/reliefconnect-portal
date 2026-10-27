import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../services/demo_data_service.dart';

enum AuthStatus { unauthenticated, authenticating, authenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  UserModel? _currentUser;
  AuthStatus _status = AuthStatus.unauthenticated;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  AuthStatus get status => _status;
  bool get isAuthenticated =>
      _status == AuthStatus.authenticated && _currentUser != null;
  bool get isLoading => _status == AuthStatus.authenticating;
  String? get errorMessage => _errorMessage;

  // Current Role Helpers
  bool get isVolunteer => _currentUser?.role == UserRole.volunteer;
  bool get isRequester => _currentUser?.role == UserRole.requester;
  bool get isAdmin => _currentUser?.role == UserRole.admin;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> signIn({
    required String email,
    required String password,
    bool isDemoMode = true,
  }) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authRepository.signIn(
        email: email,
        password: password,
        forceDemo: isDemoMode,
      );
      _currentUser = user;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
    required UserRole role,
    String? adminBootstrapCode,
    bool isDemoMode = true,
  }) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authRepository.signUp(
        name: name,
        email: email,
        password: password,
        phone: phone,
        role: role,
        adminBootstrapCode: adminBootstrapCode,
        forceDemo: isDemoMode,
      );
      _currentUser = user;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// 1-Click Demo Login for Faculty Demonstration
  void loginAsDemoRole(UserRole role) {
    DemoDataService.instance.ensureInitialized();
    final users = DemoDataService.instance.getUsers();
    final demoUser = users.firstWhere(
      (u) => u.role == role,
      orElse: () => users.first,
    );
    _currentUser = demoUser;
    _status = AuthStatus.authenticated;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> sendPasswordReset(String email, {bool isDemoMode = true}) async {
    try {
      await _authRepository.sendPasswordReset(email, forceDemo: isDemoMode);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfile(
    UserModel updatedUser, {
    bool isDemoMode = true,
  }) async {
    try {
      final res = await _authRepository.updateUserProfile(
        updatedUser,
        forceDemo: isDemoMode,
      );
      _currentUser = res;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut({bool isDemoMode = true}) async {
    await _authRepository.signOut(forceDemo: isDemoMode);
    _currentUser = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
