import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'map_service.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();

  factory LocationService() {
    return _instance;
  }

  LocationService._internal();

  /// Check and request location permissions
  static Future<bool> requestLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('⚠️ Location permission denied');
          return false;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openLocationSettings();
        return false;
      }
      
      return true;
    } catch (e) {
      debugPrint('❌ Location permission error: $e');
      return false;
    }
  }

  /// Get current location
  static Future<({double latitude, double longitude})?> getCurrentLocation() async {
    try {
      final hasPermission = await requestLocationPermission();
      if (!hasPermission) return null;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 30),
      );

      return (latitude: position.latitude, longitude: position.longitude);
    } catch (e) {
      debugPrint('❌ Get location error: $e');
      return null;
    }
  }

  /// Get last known location (faster)
  static Future<({double latitude, double longitude})?> getLastKnownLocation() async {
    try {
      final position = await Geolocator.getLastKnownPosition();
      
      if (position != null) {
        return (latitude: position.latitude, longitude: position.longitude);
      }
      
      // Fallback to current location
      return await getCurrentLocation();
    } catch (e) {
      debugPrint('❌ Get last known location error: $e');
      return null;
    }
  }

  /// Stream of location updates
  static Stream<({double latitude, double longitude})> getLocationStream({
    Duration updateInterval = const Duration(seconds: 10),
  }) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100, // Update every 100 meters
        timeLimit: updateInterval,
      ),
    ).map((position) => (latitude: position.latitude, longitude: position.longitude));
  }

  /// Calculate distance between two points in kilometers
  static double calculateDistance({
    required double lat1,
    required double lng1,
    required double lat2,
    required double lng2,
  }) {
    return Geolocator.distanceBetween(lat1, lng1, lat2, lng2) / 1000;
  }

  /// Check if location service is enabled
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Format coordinates for display
  static String formatCoordinates(double latitude, double longitude) {
    return '$latitude, $longitude';
  }

  /// Get readable address string from coordinates using OpenStreetMap Nominatim
  static Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    return await MapService.getAddressFromCoordinates(latitude, longitude);
  }
}
