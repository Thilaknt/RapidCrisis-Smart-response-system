import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import '../models/alert_model.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();

  factory LocalStorageService() {
    return _instance;
  }

  LocalStorageService._internal();

  static const String alertBoxName = 'alerts';
  static const String userBoxName = 'user';
  static const String settingsBoxName = 'settings';

  /// Initialize Hive and open boxes
  static Future<void> initialize() async {
    try {
      await Hive.initFlutter();
      
      // Open boxes
      await Hive.openBox<String>(alertBoxName);
      await Hive.openBox<String>(userBoxName);
      await Hive.openBox<String>(settingsBoxName);
      
      debugPrint('✅ Local storage initialized');
    } catch (e) {
      debugPrint('❌ Local storage init error: $e');
    }
  }

  /// Save an alert locally
  static Future<void> saveAlert(AlertModel alert) async {
    try {
      final box = Hive.box<String>(alertBoxName);
      final alertJson = {
        'id': alert.id,
        'userId': alert.userId,
        'triggerType': alert.triggerType,
        'message': alert.message,
        'latitude': alert.latitude,
        'longitude': alert.longitude,
        'status': alert.status,
        'createdAt': alert.createdAt.toUtc().toIso8601String(),
        'severity': alert.severity,
        'synced': alert.synced,
      };
      
      // Store as JSON string
      await box.put(alert.id, alertJson.toString());
      debugPrint('💾 Alert saved locally: ${alert.id}');
    } catch (e) {
      debugPrint('❌ Save alert error: $e');
    }
  }

  /// Get all unsynced alerts
  static Future<List<AlertModel>> getUnsyncedAlerts() async {
    try {
      final box = Hive.box<String>(alertBoxName);
      final alerts = <AlertModel>[];
      
      for (var value in box.values) {
        try {
          // Parse JSON back from string
          final alertMap = _parseJsonString(value);
          if (alertMap != null && alertMap['synced'] != true) {
            alerts.add(AlertModel(
              id: alertMap['id'] ?? '',
              userId: alertMap['userId'] ?? '',
              triggerType: alertMap['triggerType'] ?? 'button',
              message: alertMap['message'] ?? '',
              latitude: (alertMap['latitude'] ?? 0).toDouble(),
              longitude: (alertMap['longitude'] ?? 0).toDouble(),
              status: alertMap['status'] ?? 'pending',
              createdAt: DateTime.parse(alertMap['createdAt'] ?? DateTime.now().toIso8601String()),
              severity: alertMap['severity'] ?? 5,
              synced: false,
            ));
          }
        } catch (e) {
          debugPrint('⚠️ Error parsing alert: $e');
        }
      }
      
      return alerts;
    } catch (e) {
      debugPrint('❌ Get unsynced alerts error: $e');
      return [];
    }
  }

  /// Mark alert as synced
  static Future<void> markAlertSynced(String alertId) async {
    try {
      final box = Hive.box<String>(alertBoxName);
      final value = box.get(alertId);
      
      if (value != null) {
        final alertMap = _parseJsonString(value);
        if (alertMap != null) {
          alertMap['synced'] = true;
          await box.put(alertId, alertMap.toString());
          debugPrint('✅ Alert marked as synced: $alertId');
        }
      }
    } catch (e) {
      debugPrint('❌ Mark synced error: $e');
    }
  }

  /// Delete alert
  static Future<void> deleteAlert(String alertId) async {
    try {
      final box = Hive.box<String>(alertBoxName);
      await box.delete(alertId);
      debugPrint('🗑️ Alert deleted: $alertId');
    } catch (e) {
      debugPrint('❌ Delete alert error: $e');
    }
  }

  /// Save user data
  static Future<void> saveUser(String userId, Map<String, dynamic> userData) async {
    try {
      final box = Hive.box<String>(userBoxName);
      await box.put(userId, userData.toString());
      debugPrint('💾 User data saved locally');
    } catch (e) {
      debugPrint('❌ Save user error: $e');
    }
  }

  /// Get user data
  static Future<Map<String, dynamic>?> getUser(String userId) async {
    try {
      final box = Hive.box<String>(userBoxName);
      final value = box.get(userId);
      
      if (value != null) {
        return _parseJsonString(value);
      }
      return null;
    } catch (e) {
      debugPrint('❌ Get user error: $e');
      return null;
    }
  }

  /// Save setting
  static Future<void> saveSetting(String key, String value) async {
    try {
      final box = Hive.box<String>(settingsBoxName);
      await box.put(key, value);
      debugPrint('⚙️ Setting saved: $key');
    } catch (e) {
      debugPrint('❌ Save setting error: $e');
    }
  }

  /// Get setting
  static Future<String?> getSetting(String key) async {
    try {
      final box = Hive.box<String>(settingsBoxName);
      return box.get(key);
    } catch (e) {
      debugPrint('❌ Get setting error: $e');
      return null;
    }
  }

  /// Clear all data
  static Future<void> clearAll() async {
    try {
      await Hive.box<String>(alertBoxName).clear();
      await Hive.box<String>(userBoxName).clear();
      await Hive.box<String>(settingsBoxName).clear();
      debugPrint('🧹 All local storage cleared');
    } catch (e) {
      debugPrint('❌ Clear error: $e');
    }
  }

  /// Helper to parse JSON-like string
  static Map<String, dynamic>? _parseJsonString(String jsonStr) {
    try {
      // Remove outer braces if present
      final cleaned = jsonStr.replaceFirst('{', '').replaceFirst(RegExp(r'}$'), '');
      final map = <String, dynamic>{};
      
      // Simple parsing (in production, use proper JSON parser)
      final pairs = cleaned.split(', ');
      for (var pair in pairs) {
        final parts = pair.split(': ');
        if (parts.length == 2) {
          final key = parts[0].replaceAll(RegExp("[\"']"), '').trim();
          final value = parts[1].replaceAll(RegExp("[\"']"), '').trim();
          map[key] = value;
        }
      }
      return map;
    } catch (e) {
      debugPrint('⚠️ Parse error: $e');
      return null;
    }
  }
}
