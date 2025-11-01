import 'package:flutter/material.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';

class StatsScreen extends StatelessWidget {
  final List<Medicine> medicines;
  final List<DoseEntry> doses;

  const StatsScreen({
    super.key,
    required this.medicines,
    required this.doses,
  });

  @override
  Widget build(BuildContext context) {
    final totalMeds = medicines.length;
    final totalDoses = doses.length;
    final taken   = doses.where((e) => e.status == DoseStatus.taken).length;
    final skipped = doses.where((e) => e.status == DoseStatus.skipped).length;
    final pending = doses.where((e) => e.status == DoseStatus.pending).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Статистика')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _StatHeader(title: 'Общая статистика'),
            const SizedBox(height: 12),
            _StatCard(
              icon: Icons.medication,
              title: 'Лекарств',
              value: '$totalMeds',
            ),
            _StatCard(
              icon: Icons.event_note,
              title: 'Всего доз',
              value: '$totalDoses',
            ),
            const SizedBox(height: 16),
            _StatHeader(title: 'По статусам'),
            const SizedBox(height: 12),
            _StatCard(
              icon: Icons.check_circle,
              title: 'Принято',
              value: '$taken',
            ),
            _StatCard(
              icon: Icons.remove_circle,
              title: 'Пропущено',
              value: '$skipped',
            ),
            _StatCard(
              icon: Icons.pending_actions,
              title: 'Ожидает',
              value: '$pending',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      // Если когда-нибудь понадобится нижняя кнопка — используем FAB,
      // чтобы не конфликтовать с home-indicator.
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: Padding(
      //   padding: EdgeInsets.only(
      //     bottom: MediaQuery.of(context).viewPadding.bottom + 8,
      //     left: 12,
      //     right: 12,
      //   ),
      //   child: SizedBox(
      //     width: double.infinity,
      //     child: FilledButton.icon(
      //       onPressed: () { /* ваш экшен */ },
      //       icon: const Icon(Icons.ios_share),
      //       label: const Text('Экспорт отчёта'),
      //     ),
      //   ),
      // ),
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
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: Text(
          value,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}