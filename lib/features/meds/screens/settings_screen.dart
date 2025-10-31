import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final bool embedded;
  final bool darkMode;
  final ValueChanged<bool>? onToggleDark;

  const SettingsScreen({
    super.key,
    this.embedded = false,
    this.darkMode = false,
    this.onToggleDark,
  });

  @override
  Widget build(BuildContext context) {
    final body = ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (!embedded)
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text('Настройки', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Тёмная тема', style: TextStyle(fontSize: 16)),
            Switch(value: darkMode, onChanged: (v) => onToggleDark?.call(v)),
          ],
        ),
      ],
    );
    if (embedded) return body;
    return Scaffold(appBar: AppBar(title: const Text('Настройки')), body: body);
  }
}