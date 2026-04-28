import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class MapService {
  static const String _nominatimBaseUrl = 'https://nominatim.openstreetmap.org';
  static const String _osrmBaseUrl = 'http://router.project-osrm.org';
  
  // A custom user agent is required by Nominatim's usage policy
  static const Map<String, String> _headers = {
    'User-Agent': 'RapidResponseSystemApp/1.0 (contact@rapidresponsesystem.example.com)',
  };

  /// Fetch a human-readable address from coordinates using Nominatim API (OpenStreetMap)
  static Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      final url = Uri.parse('$_nominatimBaseUrl/reverse?format=json&lat=$latitude&lon=$longitude&zoom=18&addressdetails=1');
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['display_name'] != null) {
          // You can also format this shorter using address parts
          return data['display_name'];
        }
      } else {
        debugPrint('Nominatim API error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Geocoding error: $e');
    }
    // Fallback if API fails
    return 'Lat: ${latitude.toStringAsFixed(4)}, Lng: ${longitude.toStringAsFixed(4)}';
  }

  /// Calculates driving route details using OSRM 
  /// Returns a record with distance (in meters) and duration (in seconds)
  static Future<({double distance, double duration})?> getRouteInfo({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) async {
    try {
      // OSRM format is longitude,latitude
      final coordinates = '$startLng,$startLat;$endLng,$endLat';
      final url = Uri.parse('$_osrmBaseUrl/route/v1/driving/$coordinates?overview=false');
      
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 'Ok' && data['routes'] != null && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          return (
            distance: (route['distance'] as num).toDouble(),
            duration: (route['duration'] as num).toDouble()
          );
        }
      } else {
        debugPrint('OSRM API error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Routing error: $e');
    }
    
    return null;
  }
}
