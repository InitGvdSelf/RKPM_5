import 'package:flutter/material.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';

class StatsScreen extends StatelessWidget {
  final List<Medicine> meds;
  final List<DoseEntry> doses;

  const StatsScreen({super.key, required this.meds, required this.doses});

  @override
  Widget build(BuildContext context) {
    final taken = doses.where((e) => e.status == DoseStatus.taken).length;
    final skipped = doses.where((e) => e.status == DoseStatus.skipped).length;
    final pending = doses.where((e) => e.status == DoseStatus.pending).length;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Общие показатели', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            // карточки ниже создадим через приватный виджет
          ],
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _StatCard(label: 'Лекарства', value: meds.length.toString()),
            _StatCard(label: 'Все дозы', value: doses.length.toString()),
            _StatCard(label: 'Принято', value: taken.toString()),
            _StatCard(label: 'Пропущено', value: skipped.toString()),
            _StatCard(label: 'Ожидается', value: pending.toString()),
          ],
        ),
      ]),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(value, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(label),
        ]),
      ),
    );
  }
}