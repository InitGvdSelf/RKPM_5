import 'package:flutter/material.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';

class StatsScreen extends StatelessWidget {
  final List<Medicine> meds;
  final List doses;
  final bool embedded;

  const StatsScreen({
    super.key,
    required this.meds,
    required this.doses,
    this.embedded = false,
  });

  @override
  Widget build(BuildContext context) {
    final body = _buildBody(context);
    if (embedded) return body;
    return Scaffold(appBar: AppBar(title: const Text('Статистика')), body: body);
  }

  Widget _buildBody(BuildContext context) {
    final d = doses.cast<DoseEntry>();
    final totalMeds = meds.length;
    final taken = d.where((e) => e.status == DoseStatus.taken).length;
    final pending = d.where((e) => e.status == DoseStatus.pending).length;
    final skipped = d.where((e) => e.status == DoseStatus.skipped).length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (!embedded)
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text('Статистика', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
          ),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.35,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            _card(context, Icons.medication, 'Всего лекарств', '$totalMeds', null),
            _card(context, Icons.check_circle, 'Принято', '$taken', Colors.green),
            _card(context, Icons.schedule, 'Запланировано', '$pending', Colors.indigo),
            _card(context, Icons.cancel, 'Пропущено', '$skipped', Colors.orange),
          ],
        ),
      ],
    );
  }

  Widget _card(BuildContext context, IconData i, String l, String v, Color? c) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(i, size: 28),
          const Spacer(),
          Text(v, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: c ?? Colors.black)),
          const SizedBox(height: 4),
          Text(l, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}