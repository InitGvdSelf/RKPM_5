import 'package:flutter/material.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';

typedef DosesForDay = List<DoseEntry> Function(DateTime);

class TodayScreen extends StatelessWidget {
  final List<Medicine> medicines;
  final DosesForDay dosesForDay;
  final void Function(String, DoseStatus) onMarkDose;
  final void Function(String, String) onSetDoseNote;
  final String Function(DateTime) fmtDate;
  final String Function(DateTime) fmtMonth;
  final String Function(DateTime) fmtTime;
  final bool embedded;

  const TodayScreen({
    super.key,
    required this.medicines,
    required this.dosesForDay,
    required this.onMarkDose,
    required this.onSetDoseNote,
    required this.fmtDate,
    required this.fmtMonth,
    required this.fmtTime,
    this.embedded = false,
  });

  @override
  Widget build(BuildContext context) {
    final body = _buildBody(context);
    if (embedded) return body;
    return Scaffold(appBar: AppBar(title: const Text('Сегодня')), body: body);
  }

  Widget _buildBody(BuildContext context) {
    final today = DateUtils.dateOnly(DateTime.now());
    final list = dosesForDay(today);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (!embedded)
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text('Сегодня', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
          ),
        if (list.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 24),
            child: Text('На сегодня ничего не запланировано'),
          )
        else
          ...list.map((e) => ListTile(
            leading: const Icon(Icons.alarm),
            title: Text(e.medicineId),
            subtitle: Text(fmtTime(e.plannedAt)),
            trailing: PopupMenuButton<String>(
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'taken', child: Text('Отметить: принято')),
                PopupMenuItem(value: 'skipped', child: Text('Отметить: пропущено')),
                PopupMenuItem(value: 'note', child: Text('Добавить заметку')),
              ],
              onSelected: (v) {
                if (v == 'taken') onMarkDose(e.id, DoseStatus.taken);
                if (v == 'skipped') onMarkDose(e.id, DoseStatus.skipped);
                if (v == 'note') onSetDoseNote(e.id, 'Заметка');
              },
            ),
          )),
      ],
    );
  }
}