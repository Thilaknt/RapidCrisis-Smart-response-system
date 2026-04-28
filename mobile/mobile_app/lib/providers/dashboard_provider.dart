import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/location_service.dart';
import '../services/api_service.dart';

class DashboardProvider extends ChangeNotifier {
  double _userLatitude = 0.0;
  double _userLongitude = 0.0;
  bool _isLocationLoading = false;
  String? _locationError;
  DateTime? _lastLocationUpdate;

  double get userLatitude => _userLatitude;
  double get userLongitude => _userLongitude;
  bool get isLocationLoading => _isLocationLoading;
  String? get locationError => _locationError;
  DateTime? get lastLocationUpdate => _lastLocationUpdate;

  String get formattedLocation {
    return LocationService.formatCoordinates(_userLatitude, _userLongitude);
  }

  /// Update current location
  Future<void> updateLocation() async {
    _isLocationLoading = true;
    _locationError = null;
    notifyListeners();

    try {
      final location = await LocationService.getCurrentLocation();
      if (location != null) {
        _userLatitude = location.latitude;
        _userLongitude = location.longitude;
        _lastLocationUpdate = DateTime.now();
        debugPrint('📍 Location updated: $_userLatitude, $_userLongitude');
      } else {
        _locationError = 'Could not get location';
      }
    } catch (e) {
      _locationError = 'Location error: $e';
      debugPrint('❌ Location error: $e');
    } finally {
      _isLocationLoading = false;
      notifyListeners();
    }
  }

  /// Start continuous location updates
  void startLocationTracking() {
    LocationService.getLocationStream(updateInterval: const Duration(seconds: 30)).listen((location) {
      _userLatitude = location.latitude;
      _userLongitude = location.longitude;
      _lastLocationUpdate = DateTime.now();
      notifyListeners();
    });
  }

  /// Sync location to backend
  Future<void> syncLocationToBackend(String userId, String? token) async {
    try {
      await ApiService.updateLocation(
        userId: userId,
        latitude: _userLatitude,
        longitude: _userLongitude,
        token: token,
      );
      debugPrint('✅ Location synced to backend');
    } catch (e) {
      debugPrint('❌ Sync location error: $e');
    }
  }

  void clearError() {
    _locationError = null;
    notifyListeners();
  }
}
