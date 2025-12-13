import 'package:flutter/material.dart';
import 'package:rkpm_5/core/app_dependencies.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final deps = AppDependencies.of(context);

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
            value: deps.theme.isDark,
            onChanged: deps.theme.setDark,
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