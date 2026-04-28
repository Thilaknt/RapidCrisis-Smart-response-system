import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class SensorService {
  static final SensorService _instance = SensorService._internal();

  factory SensorService() {
    return _instance;
  }

  SensorService._internal();

  StreamSubscription? _accelerometerSubscription;
  DateTime? _lastTriggerTime;
  static const Duration debounceInterval = Duration(seconds: 10);
  
  // Sensor thresholds
  static const double accelerationThreshold = 50.0; // m/s²
  static const double fallDetectionThreshold = 30.0; // m/s²

  /// Callback for sensor events
  Function(String triggerType)? onSensorEvent;

  /// Start listening to sensor data
  void startListening() {
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      _processSensorData(event);
    });
    debugPrint('📡 Sensor listening started');
  }

  /// Stop listening to sensor data
  void stopListening() {
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
    debugPrint('📡 Sensor listening stopped');
  }

  /// Process accelerometer data
  void _processSensorData(AccelerometerEvent event) {
    // Calculate total acceleration magnitude
    final acceleration = sqrt(
      event.x * event.x + event.y * event.y + event.z * event.z,
    );

    // Check if we should trigger based on debounce
    final now = DateTime.now();
    if (_lastTriggerTime != null && 
        now.difference(_lastTriggerTime!).inSeconds < debounceInterval.inSeconds) {
      return; // Still in debounce period
    }

    // Detect sudden acceleration (shock/impact)
    if (acceleration > accelerationThreshold) {
      debugPrint('🚨 High acceleration detected: ${acceleration.toStringAsFixed(2)} m/s²');
      _lastTriggerTime = now;
      onSensorEvent?.call('acceleration');
      return;
    }

    // Detect fall pattern (free fall followed by impact)
    if (acceleration > fallDetectionThreshold && acceleration < accelerationThreshold) {
      debugPrint('⬇️ Fall pattern detected: ${acceleration.toStringAsFixed(2)} m/s²');
      _lastTriggerTime = now;
      onSensorEvent?.call('fall');
      return;
    }
  }

  /// Check if sensors are available
  static Future<bool> areSensorsAvailable() async {
    try {
      // Try to get one accelerometer reading
      final accelData = await accelerometerEvents.first;
      return accelData.x.isFinite;
    } catch (e) {
      debugPrint('❌ Sensors not available: $e');
      return false;
    }
  }

  /// Get current acceleration magnitude
  static Future<double> getCurrentAcceleration() async {
    try {
      final event = await accelerometerEvents.first;
      return sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
    } catch (e) {
      debugPrint('❌ Error reading accelerometer: $e');
      return 0.0;
    }
  }

  /// Reset debounce timer (for testing)
  void resetDebounce() {
    _lastTriggerTime = null;
  }
}
