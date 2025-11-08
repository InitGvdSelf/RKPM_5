// lib/features/meds/screens/stats_screen.dart
import 'package:flutter/material.dart';
import 'package:rkpm_5/core/app_dependencies.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppDependencies.of(context).state;

    final meds = state.medicines;
    final doses = state.dosesForDay(DateTime.now()); // считаем на сегодня

    final totalMeds  = meds.length;
    final totalDoses = doses.length;
    final taken      = doses.where((e) => e.status == DoseStatus.taken).length;
    final skipped    = doses.where((e) => e.status == DoseStatus.skipped).length;
    final pending    = doses.where((e) => e.status == DoseStatus.pending).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Статистика')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const _StatHeader(title: 'Общая статистика'),
            const SizedBox(height: 12),
            _StatCard(icon: Icons.medication,    title: 'Лекарств',  value: '$totalMeds'),
            _StatCard(icon: Icons.event_note,    title: 'Всего доз', value: '$totalDoses'),
            const SizedBox(height: 16),
            const _StatHeader(title: 'По статусам'),
            const SizedBox(height: 12),
            _StatCard(icon: Icons.check_circle,  title: 'Принято',   value: '$taken'),
            _StatCard(icon: Icons.remove_circle, title: 'Пропущено', value: '$skipped'),
            _StatCard(icon: Icons.pending_actions,title: 'Ожидает',  value: '$pending'),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _StatHeader extends StatelessWidget {
  final String title;
  const _StatHeader({required this.title});
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const _StatCard({required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: Text(value, style: Theme.of(context).textTheme.titleLarge),
      ),
    );
  }
}