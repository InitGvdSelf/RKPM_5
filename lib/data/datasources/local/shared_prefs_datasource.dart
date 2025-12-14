import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsDataSource {
  static const String keyTheme = 'app_theme';
  static const String keyUserId = 'user_id';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyFavoriteItems = 'favorite_items';
  static const String keyLastSyncTimestamp = 'last_sync_timestamp';

  Future<SharedPreferences> _getPrefs() => SharedPreferences.getInstance();

  // Theme (String)
  Future<void> saveTheme(String theme) async {
    final prefs = await _getPrefs();
    await prefs.setString(keyTheme, theme);
  }

  Future<String?> getTheme() async {
    final prefs = await _getPrefs();
    return prefs.getString(keyTheme);
  }

  // UserId (int)
  Future<void> saveUserId(int userId) async {
    final prefs = await _getPrefs();
    await prefs.setInt(keyUserId, userId);
  }

  Future<int?> getUserId() async {
    final prefs = await _getPrefs();
    return prefs.getInt(keyUserId);
  }

  // Notifications (bool)
  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await _getPrefs();
    await prefs.setBool(keyNotificationsEnabled, enabled);
  }

  Future<bool?> areNotificationsEnabled() async {
    final prefs = await _getPrefs();
    return prefs.getBool(keyNotificationsEnabled);
  }

  // Favorites (List<String>)
  Future<void> saveFavoriteItems(List<String> items) async {
    final prefs = await _getPrefs();
    await prefs.setStringList(keyFavoriteItems, items);
  }

  Future<List<String>?> getFavoriteItems() async {
    final prefs = await _getPrefs();
    return prefs.getStringList(keyFavoriteItems);
  }

  // Last sync (DateTime -> int millis)
  Future<void> saveLastSyncTimestamp(DateTime dateTime) async {
    final prefs = await _getPrefs();
    await prefs.setInt(keyLastSyncTimestamp, dateTime.millisecondsSinceEpoch);
  }

  Future<DateTime?> getLastSyncTimestamp() async {
    final prefs = await _getPrefs();
    final ms = prefs.getInt(keyLastSyncTimestamp);
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  // Helpers
  Future<bool> containsKey(String key) async {
    final prefs = await _getPrefs();
    return prefs.containsKey(key);
  }

  Future<void> removeValue(String key) async {
    final prefs = await _getPrefs();
    await prefs.remove(key);
  }

  Future<void> clearAll() async {
    final prefs = await _getPrefs();
    await prefs.clear();
  }
}