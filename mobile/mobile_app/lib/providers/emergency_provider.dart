import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:async';
import '../models/alert_model.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';
import '../services/local_storage_service.dart';
import '../services/sensor_service.dart';

class EmergencyProvider extends ChangeNotifier {
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  final SensorService _sensorService = SensorService();

  // Speech recognition
  bool _isListening = false;
  bool _isSpeechInitialized = false;
  String _recognizedText = '';
  String _manualMessage = '';

  // Alert state
  AlertModel? _currentAlert;
  List<AlertModel> _activeAlerts = [];
  bool _isAlertCreating = false;
  String? _alertError;
  int _alertCountdown = 0;

  // Sensors
  bool _sensorListeningActive = false;

  // Sync
  Timer? _syncTimer;

  // Getters
  bool get isListening => _isListening;
  bool get isSpeechInitialized => _isSpeechInitialized;
  String get recognizedText => _recognizedText;
  String get manualMessage => _manualMessage;
  
  AlertModel? get currentAlert => _currentAlert;
  List<AlertModel> get activeAlerts => _activeAlerts;
  bool get isAlertCreating => _isAlertCreating;
  bool get isAlertActive => _currentAlert != null && _currentAlert!.status != 'cancelled' && _currentAlert!.status != 'resolved';
  String? get alertError => _alertError;
  int get alertCountdown => _alertCountdown;
  bool get hasSensorDetection => _sensorListeningActive;

  /// Initialize speech recognition
  Future<void> initializeSpeech() async {
    if (!_isSpeechInitialized) {
      try {
        _isSpeechInitialized = await _speechToText.initialize(
          onStatus: (status) {
            if (status == 'notListening' || status == 'done') {
              _isListening = false;
            } else if (status == 'listening') {
              _isListening = true;
            }
            notifyListeners();
          },
          onError: (errorNotification) {
            debugPrint('🔊 Speech error: ${errorNotification.errorMsg}');
            _isListening = false;
            notifyListeners();
          },
        );
        notifyListeners();
        debugPrint('✅ Speech recognition initialized');
      } catch (e) {
        debugPrint('❌ Speech init error: $e');
      }
    }
  }

  /// Toggle listening
  Future<void> toggleListening() async {
    if (!_isSpeechInitialized) {
      await initializeSpeech();
    }

    if (_isListening) {
      await _speechToText.stop();
      _isListening = false;
    } else {
      _isListening = true;
      await _speechToText.listen(
        onResult: (result) {
          _recognizedText = result.recognizedWords;

          final lowerText = _recognizedText.toLowerCase();
          if (lowerText.contains('help') || 
              lowerText.contains('save me') || 
              lowerText.contains('emergency')) {
            triggerEmergency(
              source: 'voice',
              message: _recognizedText,
              userId: 'current_user_id',
            );
            _speechToText.stop();
          }
          notifyListeners();
        },
      );
    }
    notifyListeners();
  }

  /// Update manual message
  void updateManualMessage(String message) {
    _manualMessage = message;
    notifyListeners();
  }

  /// Start sensor monitoring
  void startSensorMonitoring() {
    if (_sensorListeningActive) return;

    _sensorService.onSensorEvent = (triggerType) {
      debugPrint('📡 Sensor event detected: $triggerType');
      triggerEmergency(
        source: triggerType,
        message: 'Emergency detected via $triggerType sensor',
        userId: 'current_user_id',
      );
    };

    _sensorService.startListening();
    _sensorListeningActive = true;
    notifyListeners();
    debugPrint('📡 Sensor monitoring started');
  }

  /// Stop sensor monitoring
  void stopSensorMonitoring() {
    _sensorService.stopListening();
    _sensorListeningActive = false;
    notifyListeners();
    debugPrint('📡 Sensor monitoring stopped');
  }

  /// Create emergency alert with full integration
  Future<void> triggerEmergency({
    required String source,
    required String message,
    required String userId,
    double? latitude,
    double? longitude,
    String? imagePath,
  }) async {
    if (_isAlertCreating) return;
    
    _isAlertCreating = true;
    _alertError = null;
    notifyListeners();

    try {
      var lat = latitude;
      var lng = longitude;
      
      if (lat == null || lng == null) {
        final location = await LocationService.getCurrentLocation();
        if (location != null) {
          lat = location.latitude;
          lng = location.longitude;
        } else {
          lat = 0.0;
          lng = 0.0;
        }
      }

      final timestamp = DateTime.now();
      final alertId = '${userId}_${timestamp.millisecondsSinceEpoch}';

      _currentAlert = AlertModel(
        id: alertId,
        userId: userId,
        triggerType: source,
        message: message.isEmpty ? 'Emergency alert triggered!' : message,
        latitude: lat!,
        longitude: lng!,
        status: 'pending',
        createdAt: timestamp,
        severity: 5,
        synced: false,
      );

      await LocalStorageService.saveAlert(_currentAlert!);
      debugPrint('💾 Alert saved locally: $alertId');

      final apiAlert = await ApiService.sendAlert(
        userId: userId,
        triggerType: source,
        message: _currentAlert!.message,
        latitude: lat,
        longitude: lng,
      );

      if (apiAlert != null) {
        _currentAlert = _currentAlert!.copyWith(
          id: apiAlert.id,
          synced: true,
          status: 'active',
        );
        await LocalStorageService.markAlertSynced(alertId);
        debugPrint('✅ Alert sent to API: ${apiAlert.id}');
      } else {
        debugPrint('⚠️ Alert pending sync (offline)');
      }

      _activeAlerts = [_currentAlert!, ..._activeAlerts];
      _startAlertCountdown();
      _startSyncRetry();

    } catch (e) {
      _alertError = 'Failed to create alert: $e';
      debugPrint('❌ Alert creation error: $e');
    } finally {
      _isAlertCreating = false;
      notifyListeners();
    }
  }

  void _startAlertCountdown() {
    _alertCountdown = 30;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_alertCountdown > 0) {
        _alertCountdown--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  void _startSyncRetry() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      final unsynced = await LocalStorageService.getUnsyncedAlerts();
      
      for (var alert in unsynced) {
        final apiAlert = await ApiService.sendAlert(
          userId: alert.userId,
          triggerType: alert.triggerType,
          message: alert.message,
          latitude: alert.latitude,
          longitude: alert.longitude,
        );

        if (apiAlert != null) {
          await LocalStorageService.markAlertSynced(alert.id);
          debugPrint('✅ Offline alert synced: ${alert.id}');
        }
      }

      if (unsynced.isEmpty) {
        timer.cancel();
      }
    });
  }

  Future<void> cancelCurrentAlert({String? reason}) async {
    if (_currentAlert == null) return;

    try {
      final success = await ApiService.cancelAlert(
        alertId: _currentAlert!.id,
        reason: reason ?? 'User cancelled',
      );

      if (success) {
        _currentAlert = _currentAlert!.copyWith(status: 'cancelled');
        debugPrint('✅ Alert cancelled: ${_currentAlert!.id}');
      }
    } catch (e) {
      debugPrint('❌ Cancel alert error: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateAlertStatus(String alertId, String newStatus) async {
    try {
      final success = await ApiService.updateAlertStatus(
        alertId: alertId,
        status: newStatus,
      );

      if (success) {
        if (_currentAlert?.id == alertId) {
          _currentAlert = _currentAlert!.copyWith(status: newStatus);
        }
        
        final index = _activeAlerts.indexWhere((a) => a.id == alertId);
        if (index >= 0) {
          _activeAlerts[index] = _activeAlerts[index].copyWith(status: newStatus);
        }

        debugPrint('✅ Alert status updated: $alertId -> $newStatus');
      }
    } catch (e) {
      debugPrint('❌ Update status error: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchActiveAlerts(String userId) async {
    try {
      _activeAlerts = await ApiService.getAlerts(
        userId: userId,
        status: 'active',
      );
      debugPrint('✅ Fetched ${_activeAlerts.length} active alerts');
    } catch (e) {
      debugPrint('❌ Fetch alerts error: $e');
    } finally {
      notifyListeners();
    }
  }

  void clearError() {
    _alertError = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    _speechToText.stop();
    _sensorService.stopListening();
    super.dispose();
  }
}
