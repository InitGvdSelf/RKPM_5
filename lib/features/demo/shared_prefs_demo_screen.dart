import 'package:flutter/material.dart';

import '../../core/models/app_theme.dart';
import '../../data/datasources/local/shared_prefs_datasource.dart';
import '../../domain/usecases/manage_theme_usecase.dart';

class SharedPrefsDemoScreen extends StatefulWidget {
  const SharedPrefsDemoScreen({super.key});

  @override
  State<SharedPrefsDemoScreen> createState() => _SharedPrefsDemoScreenState();
}

class _SharedPrefsDemoScreenState extends State<SharedPrefsDemoScreen> {
  late final SharedPrefsDataSource _ds;
  late final ManageThemeUseCase _themeUC;

  String _log = '—';
  AppTheme _theme = AppTheme.light;

  @override
  void initState() {
    super.initState();
    _ds = SharedPrefsDataSource();
    _themeUC = ManageThemeUseCase(_ds);
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final t = await _themeUC.getCurrentTheme();
    setState(() {
      _theme = t;
      _log = 'Текущая тема из SharedPrefs: ${t.value}';
    });
  }

  Future<void> _toggleTheme() async {
    final t = await _themeUC.toggleTheme();
    setState(() {
      _theme = t;
      _log = 'Тема переключена и сохранена: ${t.value}';
    });
  }

  Future<void> _saveSampleData() async {
    await _ds.saveUserId(123);
    await _ds.setNotificationsEnabled(true);
    await _ds.saveFavoriteItems(['aspirin', 'ibuprofen', 'vitamin-c']);
    await _ds.saveLastSyncTimestamp(DateTime.now());

    final uid = await _ds.getUserId();
    final notif = await _ds.areNotificationsEnabled();
    final fav = await _ds.getFavoriteItems();
    final last = await _ds.getLastSyncTimestamp();

    setState(() {
      _log = 'Сохранено/прочитано:\n'
          'userId=$uid\n'
          'notifications=$notif\n'
          'favorites=${fav ?? []}\n'
          'lastSync=$last';
    });
  }

  Future<void> _clearAll() async {
    await _ds.clearAll();
    setState(() {
      _theme = AppTheme.light;
      _log = 'Все ключи очищены (prefs.clear())';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _theme == AppTheme.dark;

    return MaterialApp(
      theme: ThemeData(
        brightness: isDark ? Brightness.dark : Brightness.light,
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PR12 — Shared Preferences Demo'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Тема: ${_theme.value}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),

              FilledButton(
                onPressed: _toggleTheme,
                child: const Text('Toggle theme (save + read)'),
              ),
              const SizedBox(height: 8),

              FilledButton(
                onPressed: _saveSampleData,
                child: const Text('Save + read sample data'),
              ),
              const SizedBox(height: 8),

              OutlinedButton(
                onPressed: _clearAll,
                child: const Text('Clear all prefs'),
              ),
              const SizedBox(height: 16),

              const Text('Лог:'),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(_log),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}