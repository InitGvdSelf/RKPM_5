import '../../core/models/app_theme.dart';
import '../../data/datasources/local/shared_prefs_datasource.dart';

class ManageThemeUseCase {
  ManageThemeUseCase(this._prefs);

  final SharedPrefsDataSource _prefs;

  Future<void> saveTheme(AppTheme theme) async {
    await _prefs.saveTheme(theme.value);
  }

  Future<AppTheme> getCurrentTheme() async {
    final value = await _prefs.getTheme();
    return AppTheme.fromString(value);
  }

  Future<AppTheme> toggleTheme() async {
    final current = await getCurrentTheme();
    final next = current.toggle();
    await saveTheme(next);
    return next;
  }
}