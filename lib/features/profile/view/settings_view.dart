import 'package:flutter/material.dart';
import 'package:rkpm_5/app/di.dart';
import 'package:rkpm_5/core/theme_controller.dart';
import 'package:rkpm_5/domain/usecases/settings/get_settings_usecase.dart';
import 'package:rkpm_5/domain/usecases/settings/update_dark_theme_usecase.dart';
import 'package:rkpm_5/domain/usecases/settings/update_notifications_usecase.dart';

class SettingsView extends StatefulWidget {
  final ThemeController theme;

  const SettingsView({super.key, required this.theme});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _notificationsEnabled = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    try {
      final result = await DI.getSettingsUseCase();
      result.darkTheme.fold(
        (_) {},
        (isDark) {
          // Theme is already loaded in ThemeController, just update UI if needed
        },
      );
      result.notificationsEnabled.fold(
        (_) {},
        (enabled) {
          setState(() => _notificationsEnabled = enabled);
        },
      );
    } catch (e) {
      // On error, use defaults
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateNotifications(bool value) async {
    setState(() => _notificationsEnabled = value);
    final result = await DI.updateNotificationsUseCase(value);
    result.fold(
      (failure) {
        // Revert on error
        setState(() => _notificationsEnabled = !value);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка: ${failure.message}')),
          );
        }
      },
      (_) {
        // Success - value already updated
      },
    );
  }

  Future<void> _updateTheme(bool value) async {
    await widget.theme.setDark(value);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Настройки')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Уведомления'),
            subtitle: const Text('Напоминания о приёме лекарств'),
            value: _notificationsEnabled,
            onChanged: _updateNotifications,
          ),
          SwitchListTile(
            title: const Text('Тёмная тема'),
            subtitle: const Text('Переключение оформления приложения'),
            value: widget.theme.isDark,
            onChanged: _updateTheme,
          ),
          const Divider(),
          ListTile(
            title: const Text('О приложении'),
            subtitle: const Text('Трекер приёма лекарств (RKPM_5)'),
            trailing: const Icon(Icons.info_outline),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'RKPM_5',
                applicationVersion: '1.0.0',
                applicationLegalese: 'Учебный проект',
              );
            },
          ),
        ],
      ),
    );
  }
}

