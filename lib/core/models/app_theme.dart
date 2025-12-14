enum AppTheme {
  light,
  dark;

  String get value => name; // 'light' / 'dark'

  static AppTheme fromString(String? value) {
    if (value == AppTheme.dark.name) return AppTheme.dark;
    return AppTheme.light;
  }

  AppTheme toggle() => this == AppTheme.light ? AppTheme.dark : AppTheme.light;
}