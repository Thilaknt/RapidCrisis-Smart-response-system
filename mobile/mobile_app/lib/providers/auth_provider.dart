import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;
  String? _authToken;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;
  String? get authToken => _authToken;

  /// Initialize auth state from local storage
  Future<void> initializeAuth() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userData = await LocalStorageService.getUser('current_user');
      if (userData != null) {
        _currentUser = UserModel(
          id: userData['id'] ?? '',
          name: userData['name'] ?? '',
          email: userData['email'] ?? '',
          phoneNumber: userData['phoneNumber'],
          role: userData['role'] ?? 'user',
          createdAt: DateTime.parse(userData['createdAt'] ?? DateTime.now().toIso8601String()),
        );
        _isAuthenticated = true;
        _error = null;
      }
    } catch (e) {
      debugPrint('❌ Auth init error: $e');
      _error = 'Failed to initialize auth';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Generic Authentication (mock implementation for MVP)
  Future<bool> authenticateUser(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Mock authentication logic - replace with actual Firebase email/pass later
      await Future.delayed(const Duration(seconds: 2));

      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email and Password cannot be empty.');
      }

      final user = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: name.isEmpty ? 'Anonymous User' : name,
        email: email,
        role: 'user', // Defaults to user until onboarding updates it
        createdAt: DateTime.now(),
      );

      _currentUser = user;
      _isAuthenticated = true;
      _authToken = 'mock_auth_token_${DateTime.now().millisecondsSinceEpoch}';

      await LocalStorageService.saveUser('current_user', {
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'role': user.role,
        'createdAt': user.createdAt.toUtc().toIso8601String(),
      });

      debugPrint('✅ Login successful: ${user.email}');
      return true;
    } catch (e) {
      _error = 'Login failed: $e';
      debugPrint('❌ Login error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Login with Google (mock implementation)
  Future<bool> loginWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      final user = UserModel(
        id: 'google_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Google User',
        email: 'user@gmail.com',
        role: 'user',
        createdAt: DateTime.now(),
      );

      _currentUser = user;
      _isAuthenticated = true;
      _authToken = 'mock_google_token_${DateTime.now().millisecondsSinceEpoch}';

      await LocalStorageService.saveUser('current_user', {
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'role': user.role,
        'createdAt': user.createdAt.toUtc().toIso8601String(),
      });

      debugPrint('✅ Google login successful: ${user.email}');
      return true;
    } catch (e) {
      _error = 'Google login failed: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Login with Phone OTP (mock implementation)
  Future<bool> loginWithPhoneOTP(String phoneNumber, String otp) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));

      // Mock verification
      if (otp == '000000') {
        final user = UserModel(
          id: 'phone_${phoneNumber.hashCode}',
          name: phoneNumber,
          phoneNumber: phoneNumber,
          email: '$phoneNumber@emergency.app',
          role: 'user',
          createdAt: DateTime.now(),
        );

        _currentUser = user;
        _isAuthenticated = true;
        _authToken = 'mock_phone_token_${DateTime.now().millisecondsSinceEpoch}';

        await LocalStorageService.saveUser('current_user', {
          'id': user.id,
          'name': user.name,
          'phoneNumber': phoneNumber,
          'role': user.role,
          'createdAt': user.createdAt.toUtc().toIso8601String(),
        });

        debugPrint('✅ Phone OTP login successful: $phoneNumber');
        return true;
      } else {
        throw Exception('Invalid OTP');
      }
    } catch (e) {
      _error = 'Phone OTP login failed: $e';
      debugPrint('❌ Phone OTP login error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Anonymous login
  Future<bool> loginAnonymously() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = UserModel(
        id: 'anonymous_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Anonymous User',
        email: 'anonymous@emergency.app',
        role: 'user',
        createdAt: DateTime.now(),
      );

      _currentUser = user;
      _isAuthenticated = true;
      _authToken = 'mock_anonymous_token_${DateTime.now().millisecondsSinceEpoch}';

      await LocalStorageService.saveUser('current_user', {
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'role': user.role,
        'createdAt': user.createdAt.toUtc().toIso8601String(),
      });

      debugPrint('✅ Anonymous login successful');
      return true;
    } catch (e) {
      _error = 'Anonymous login failed: $e';
      debugPrint('❌ Anonymous login error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update user role
  Future<void> updateUserRole(String role) async {
    if (_currentUser == null) return;

    try {
      _currentUser = _currentUser!.copyWith(role: role);
      await LocalStorageService.saveUser('current_user', {
        'id': _currentUser!.id,
        'name': _currentUser!.name,
        'email': _currentUser!.email,
        'role': _currentUser!.role,
        'createdAt': _currentUser!.createdAt.toUtc().toIso8601String(),
      });

      // Also sync to backend if token available
      if (_authToken != null) {
        await ApiService.upsertUser(
          userId: _currentUser!.id,
          userData: {'role': role},
          token: _authToken,
        );
      }

      notifyListeners();
      debugPrint('✅ User role updated: $role');
    } catch (e) {
      debugPrint('❌ Update role error: $e');
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      _currentUser = null;
      _isAuthenticated = false;
      _authToken = null;
      _error = null;

      await LocalStorageService.clearAll();
      notifyListeners();
      debugPrint('✅ Logout successful');
    } catch (e) {
      debugPrint('❌ Logout error: $e');
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
