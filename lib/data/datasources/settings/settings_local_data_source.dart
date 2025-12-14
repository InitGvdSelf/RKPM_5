import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for app settings using SharedPreferences.
/// Stores non-sensitive settings like theme preference and notification settings.
class SettingsLocalDataSource {
  static const _kDarkTheme = 'settings_dark_theme';
  static const _kNotificationsEnabled = 'settings_notifications_enabled';

  final SharedPreferences _prefs;

  SettingsLocalDataSource(this._prefs);

  // Theme settings
  Future<void> setDarkTheme(bool value) async {
    await _prefs.setBool(_kDarkTheme, value);
  }

  Future<bool> getDarkTheme() async {
    return _prefs.getBool(_kDarkTheme) ?? false;
  }

  // Notification settings
  Future<void> setNotificationsEnabled(bool value) async {
    await _prefs.setBool(_kNotificationsEnabled, value);
  }

  Future<bool> getNotificationsEnabled() async {
    return _prefs.getBool(_kNotificationsEnabled) ?? true;
  }
}

