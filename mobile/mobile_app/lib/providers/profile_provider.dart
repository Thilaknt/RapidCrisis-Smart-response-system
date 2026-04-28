import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class ProfileProvider extends ChangeNotifier {
  UserModel? _userProfile;
  bool _isLoading = false;
  String? _error;
  int _points = 0;
  int _reputation = 0;
  List<String> _activityHistory = [];

  UserModel? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get points => _points;
  int get reputation => _reputation;
  List<String> get activityHistory => _activityHistory;

  /// Load user profile
  Future<void> loadProfile({
    required String userId,
    String? token,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final profile = await ApiService.getUserProfile(
        userId: userId,
        token: token,
      );

      if (profile != null) {
        _userProfile = profile;
        // Simulate loading points and reputation from profile
        _points = (profile.id.hashCode.abs() % 1000);
        _reputation = (profile.id.hashCode.abs() % 500);
        debugPrint('✅ Profile loaded: ${profile.name}');
      }
    } catch (e) {
      _error = 'Failed to load profile: $e';
      debugPrint('❌ Load profile error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update profile
  Future<void> updateProfile({
    required String userId,
    required Map<String, dynamic> userData,
    String? token,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updated = await ApiService.upsertUser(
        userId: userId,
        userData: userData,
        token: token,
      );

      if (updated != null) {
        _userProfile = updated;
        debugPrint('✅ Profile updated');
      }
    } catch (e) {
      _error = 'Failed to update profile: $e';
      debugPrint('❌ Update profile error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add activity to history
  void addActivity(String activity) {
    _activityHistory.insert(0, '${DateTime.now().toString()}: $activity');
    if (_activityHistory.length > 50) {
      _activityHistory.removeLast();
    }
    notifyListeners();
  }

  /// Add points
  void addPoints(int amount) {
    _points += amount;
    addActivity('Earned $amount points');
    notifyListeners();
  }

  /// Add reputation
  void addReputation(int amount) {
    _reputation += amount;
    addActivity('Reputation +$amount');
    notifyListeners();
  }

  /// Update emergency contacts
  Future<void> updateEmergencyContacts({
    required String userId,
    required List<String> contacts,
    String? token,
  }) async {
    try {
      await ApiService.upsertUser(
        userId: userId,
        userData: {'emergencyContacts': contacts},
        token: token,
      );

      if (_userProfile != null) {
        _userProfile = _userProfile!.copyWith(emergencyContacts: contacts);
      }

      debugPrint('✅ Emergency contacts updated');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Update contacts error: $e');
    }
  }

  /// Update permissions
  Future<void> updatePermissions({
    required String userId,
    required Map<String, bool> permissions,
    String? token,
  }) async {
    try {
      await ApiService.upsertUser(
        userId: userId,
        userData: {'permissions': permissions},
        token: token,
      );

      if (_userProfile != null) {
        _userProfile = _userProfile!.copyWith(permissions: permissions);
      }

      debugPrint('✅ Permissions updated');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Update permissions error: $e');
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
