import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool notificationsEnabled = true;
  bool darkThemeEnabled = false;

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
            value: darkThemeEnabled,
            onChanged: (v) => setState(() => darkThemeEnabled = v),
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
          ListTile(
            title: const Text('Сбросить настройки'),
            trailing: const Icon(Icons.restore),
            onTap: () {
              setState(() {
                notificationsEnabled = true;
                darkThemeEnabled = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Настройки сброшены')),
              );
            },
          ),
        ],
      ),
    );
  }
}