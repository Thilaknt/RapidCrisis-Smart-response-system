import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _darkModeEnabled = true;
  bool _soundEnabled = true;
  int _alertRadius = 10; // km
  List<String> _emergencyContacts = [];

  bool get notificationsEnabled => _notificationsEnabled;
  bool get locationEnabled => _locationEnabled;
  bool get darkModeEnabled => _darkModeEnabled;
  bool get soundEnabled => _soundEnabled;
  int get alertRadius => _alertRadius;
  List<String> get emergencyContacts => _emergencyContacts;

  /// Load settings from local storage
  Future<void> loadSettings() async {
    try {
      final notifSetting = await LocalStorageService.getSetting('notifications');
      _notificationsEnabled = notifSetting != 'false';

      final locSetting = await LocalStorageService.getSetting('location');
      _locationEnabled = locSetting != 'false';

      final soundSetting = await LocalStorageService.getSetting('sound');
      _soundEnabled = soundSetting != 'false';

      final radiusSetting = await LocalStorageService.getSetting('alertRadius');
      if (radiusSetting != null) {
        _alertRadius = int.tryParse(radiusSetting) ?? 10;
      }

      debugPrint('✅ Settings loaded');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Load settings error: $e');
    }
  }

  /// Toggle notifications
  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    await LocalStorageService.saveSetting('notifications', enabled.toString());
    notifyListeners();
    debugPrint('📢 Notifications: $enabled');
  }

  /// Toggle location
  Future<void> setLocationEnabled(bool enabled) async {
    _locationEnabled = enabled;
    await LocalStorageService.saveSetting('location', enabled.toString());
    notifyListeners();
    debugPrint('📍 Location: $enabled');
  }

  /// Toggle sound
  Future<void> setSoundEnabled(bool enabled) async {
    _soundEnabled = enabled;
    await LocalStorageService.saveSetting('sound', enabled.toString());
    notifyListeners();
    debugPrint('🔊 Sound: $enabled');
  }

  /// Update alert radius
  Future<void> setAlertRadius(int radius) async {
    _alertRadius = radius;
    await LocalStorageService.saveSetting('alertRadius', radius.toString());
    notifyListeners();
    debugPrint('📡 Alert radius: $radius km');
  }

  /// Add emergency contact
  Future<void> addEmergencyContact(String contact) async {
    if (!_emergencyContacts.contains(contact)) {
      _emergencyContacts.add(contact);
      await _saveEmergencyContacts();
      notifyListeners();
      debugPrint('➕ Emergency contact added: $contact');
    }
  }

  /// Remove emergency contact
  Future<void> removeEmergencyContact(String contact) async {
    _emergencyContacts.remove(contact);
    await _saveEmergencyContacts();
    notifyListeners();
    debugPrint('➖ Emergency contact removed: $contact');
  }

  /// Save emergency contacts to storage
  Future<void> _saveEmergencyContacts() async {
    try {
      await LocalStorageService.saveSetting(
        'emergencyContacts',
        _emergencyContacts.join(','),
      );
    } catch (e) {
      debugPrint('❌ Save contacts error: $e');
    }
  }

  /// Load emergency contacts from storage
  Future<void> loadEmergencyContacts() async {
    try {
      final contactsStr = await LocalStorageService.getSetting('emergencyContacts');
      if (contactsStr != null && contactsStr.isNotEmpty) {
        _emergencyContacts = contactsStr.split(',');
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Load contacts error: $e');
    }
  }

  /// Reset to defaults
  Future<void> resetToDefaults() async {
    _notificationsEnabled = true;
    _locationEnabled = true;
    _soundEnabled = true;
    _alertRadius = 10;
    _emergencyContacts.clear();

    await LocalStorageService.clearAll();
    notifyListeners();
    debugPrint('🔄 Settings reset to defaults');
  }
}
