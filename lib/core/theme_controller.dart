import 'package:flutter/material.dart';
import 'package:rkpm_5/app/di.dart';

/// Controller for app theme management.
/// Loads theme preference from settings repository on initialization
/// and persists changes to SharedPreferences.
class ThemeController extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;
  bool _isInitialized = false;

  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  /// Initialize theme from settings repository.
  /// Should be called once during app startup.
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final result = await DI.settingsRepository.getDarkTheme();
      result.fold(
        (_) {
          // On error, use default (light theme)
          _mode = ThemeMode.light;
        },
        (isDark) {
          _mode = isDark ? ThemeMode.dark : ThemeMode.light;
        },
      );
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      // On error, use default
      _mode = ThemeMode.light;
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Set dark theme and persist to storage.
  Future<void> setDark(bool value) async {
    final newMode = value ? ThemeMode.dark : ThemeMode.light;
    if (newMode == _mode) return;

    _mode = newMode;
    notifyListeners();

    // Persist to storage
    try {
      await DI.settingsRepository.setDarkTheme(value);
    } catch (e) {
      // Log error but don't revert UI change
      debugPrint('Failed to persist theme: $e');
    }
  }
}