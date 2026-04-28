import 'package:flutter/material.dart';
import '../models/alert_model.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';

class ResponderProvider extends ChangeNotifier {
  List<AlertModel> _nearbyAlerts = [];
  bool _isLoadingAlerts = false;
  String? _error;
  AlertModel? _acceptedAlert;

  List<AlertModel> get nearbyAlerts => _nearbyAlerts;
  bool get isLoadingAlerts => _isLoadingAlerts;
  String? get error => _error;
  AlertModel? get acceptedAlert => _acceptedAlert;

  /// Fetch nearby alerts for responder
  Future<void> fetchNearbyAlerts({
    required double latitude,
    required double longitude,
    double radiusKm = 10,
    String? token,
  }) async {
    _isLoadingAlerts = true;
    _error = null;
    notifyListeners();

    try {
      _nearbyAlerts = await ApiService.getNearbyAlerts(
        latitude: latitude,
        longitude: longitude,
        radiusKm: radiusKm,
        token: token,
      );
      
      // Sort by distance (closest first)
      _nearbyAlerts.sort((a, b) {
        final distA = LocationService.calculateDistance(
          lat1: latitude,
          lng1: longitude,
          lat2: a.latitude,
          lng2: a.longitude,
        );
        final distB = LocationService.calculateDistance(
          lat1: latitude,
          lng1: longitude,
          lat2: b.latitude,
          lng2: b.longitude,
        );
        return distA.compareTo(distB);
      });

      debugPrint('✅ Fetched ${_nearbyAlerts.length} nearby alerts');
    } catch (e) {
      _error = 'Failed to fetch alerts: $e';
      debugPrint('❌ Fetch nearby alerts error: $e');
    } finally {
      _isLoadingAlerts = false;
      notifyListeners();
    }
  }

  /// Accept an alert as responder
  Future<bool> acceptAlert({
    required AlertModel alert,
    required String responderId,
    String? token,
  }) async {
    try {
      final success = await ApiService.acceptAlert(
        alertId: alert.id,
        responderId: responderId,
        token: token,
      );

      if (success) {
        _acceptedAlert = alert.copyWith(
          responderId: responderId,
          status: 'accepted',
        );
        
        // Remove from nearby list
        _nearbyAlerts.removeWhere((a) => a.id == alert.id);
        
        debugPrint('✅ Alert accepted: ${alert.id}');
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = 'Failed to accept alert: $e';
      debugPrint('❌ Accept alert error: $e');
      return false;
    } finally {
      notifyListeners();
    }
  }

  /// Reject/decline an alert
  Future<bool> declineAlert({
    required AlertModel alert,
    String? token,
  }) async {
    try {
      // Remove from nearby list
      _nearbyAlerts.removeWhere((a) => a.id == alert.id);
      debugPrint('✅ Alert declined: ${alert.id}');
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('❌ Decline alert error: $e');
      return false;
    }
  }

  /// Calculate distance to alert
  double getDistanceToAlert(double userLat, double userLng, AlertModel alert) {
    return LocationService.calculateDistance(
      lat1: userLat,
      lng1: userLng,
      lat2: alert.latitude,
      lng2: alert.longitude,
    );
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
