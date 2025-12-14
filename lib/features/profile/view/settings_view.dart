import 'package:flutter/material.dart';
import 'package:rkpm_5/core/theme_controller.dart';

class SettingsView extends StatefulWidget {
  final ThemeController theme;

  const SettingsView({super.key, required this.theme});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Уведомления'),
            subtitle: const Text('Напоминания о приёме лекарств'),
            value: notificationsEnabled,
            onChanged: (v) => setState(() => notificationsEnabled = v),
          ),
          SwitchListTile(
            title: const Text('Тёмная тема'),
            subtitle: const Text('Переключение оформления приложения'),
            value: widget.theme.isDark,
            onChanged: widget.theme.setDark,
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

