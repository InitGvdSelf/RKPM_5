import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final bool darkMode;
  final ValueChanged<bool> onToggleDark;

  const SettingsScreen({
    super.key,
    required this.darkMode,
    required this.onToggleDark,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 12),
          const Text('Настройки', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          SwitchListTile(
            title: const Text('Тёмная тема'),
            value: darkMode,
            onChanged: onToggleDark,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Уведомления'),
            subtitle: const Text('Напоминания о приёме'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Язык интерфейса'),
            subtitle: const Text('Русский'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('О приложении'),
            subtitle: const Text('Версия 1.0.0'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}