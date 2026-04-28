import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/alert_model.dart';
import '../models/user_model.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api'; // Change to your backend URL
  
  // Headers for requests
  static Map<String, String> _getHeaders({String? token}) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Send an emergency alert to backend
  static Future<AlertModel?> sendAlert({
    required String userId,
    required String triggerType,
    required String message,
    required double latitude,
    required double longitude,
    String? token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/alerts'),
        headers: _getHeaders(token: token),
        body: jsonEncode({
          'userId': userId,
          'triggerType': triggerType,
          'message': message,
          'latitude': latitude,
          'longitude': longitude,
          'status': 'pending',
          'severity': 5,
          'createdAt': DateTime.now().toUtc().toIso8601String(),
        }),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw TimeoutException('Alert submission timeout'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return AlertModel(
          id: data['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
          userId: userId,
          triggerType: triggerType,
          message: message,
          latitude: latitude,
          longitude: longitude,
          status: data['status'] ?? 'pending',
          createdAt: DateTime.now(),
          synced: true,
        );
      } else {
        debugPrint('❌ Alert send failed: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Alert send error: $e');
      return null;
    }
  }

  // Get active alerts for a user
  static Future<List<AlertModel>> getAlerts({
    required String userId,
    String? token,
    String status = 'active',
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/alerts?userId=$userId&status=$status'),
        headers: _getHeaders(token: token),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((item) => AlertModel.fromMap(item, item['id'] ?? ''))
            .toList();
      } else {
        debugPrint('❌ Get alerts failed: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('❌ Get alerts error: $e');
      return [];
    }
  }

  // Update alert status
  static Future<bool> updateAlertStatus({
    required String alertId,
    required String status,
    String? responderId,
    String? token,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/alerts/$alertId'),
        headers: _getHeaders(token: token),
        body: jsonEncode({
          'status': status,
          if (responderId != null) 'responderId': responderId,
          'updatedAt': DateTime.now().toUtc().toIso8601String(),
        }),
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      debugPrint('❌ Update alert error: $e');
      return false;
    }
  }

  // Cancel an alert
  static Future<bool> cancelAlert({
    required String alertId,
    String? reason,
    String? token,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/alerts/$alertId'),
        headers: _getHeaders(token: token),
        body: jsonEncode({
          'status': 'cancelled',
          'reason': reason,
          'resolvedAt': DateTime.now().toUtc().toIso8601String(),
        }),
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      debugPrint('❌ Cancel alert error: $e');
      return false;
    }
  }

  // Get nearby alerts for responders
  static Future<List<AlertModel>> getNearbyAlerts({
    required double latitude,
    required double longitude,
    double radiusKm = 10,
    String? token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/alerts/nearby?lat=$latitude&lng=$longitude&radius=$radiusKm',
        ),
        headers: _getHeaders(token: token),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((item) => AlertModel.fromMap(item, item['id'] ?? ''))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('❌ Get nearby alerts error: $e');
      return [];
    }
  }

  // Accept an alert as responder
  static Future<bool> acceptAlert({
    required String alertId,
    required String responderId,
    String? token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/alerts/$alertId/accept'),
        headers: _getHeaders(token: token),
        body: jsonEncode({'responderId': responderId}),
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      debugPrint('❌ Accept alert error: $e');
      return false;
    }
  }

  // Create or update user profile
  static Future<UserModel?> upsertUser({
    required String userId,
    required Map<String, dynamic> userData,
    String? token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user'),
        headers: _getHeaders(token: token),
        body: jsonEncode({
          'id': userId,
          ...userData,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return UserModel.fromMap(data, userId);
      }
      return null;
    } catch (e) {
      debugPrint('❌ Upsert user error: $e');
      return null;
    }
  }

  // Get user profile
  static Future<UserModel?> getUserProfile({
    required String userId,
    String? token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/$userId'),
        headers: _getHeaders(token: token),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserModel.fromMap(data, userId);
      }
      return null;
    } catch (e) {
      debugPrint('❌ Get user error: $e');
      return null;
    }
  }

  // Update location
  static Future<bool> updateLocation({
    required String userId,
    required double latitude,
    required double longitude,
    String? token,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/user/$userId/location'),
        headers: _getHeaders(token: token),
        body: jsonEncode({
          'latitude': latitude,
          'longitude': longitude,
          'lastSeenAt': DateTime.now().toUtc().toIso8601String(),
        }),
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      debugPrint('❌ Update location error: $e');
      return false;
    }
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  
  @override
  String toString() => message;
}
