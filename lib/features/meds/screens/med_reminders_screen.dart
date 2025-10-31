import 'package:flutter/material.dart';

class MedRemindersScreen extends StatelessWidget {
  const MedRemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Напоминания')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.alarm),
            title: Text('09:00 — Утренний приём'),
            subtitle: Text('Пн, Ср, Пт'),
          ),
          ListTile(
            leading: Icon(Icons.alarm),
            title: Text('21:00 — Вечерний приём'),
            subtitle: Text('Ежедневно'),
          ),
        ],
      ),
    );
  }
}