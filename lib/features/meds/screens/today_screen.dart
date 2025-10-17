import 'package:flutter/material.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';

class ScheduleScreen extends StatefulWidget {
  final List<Medicine> medicines;
  final List<DoseEntry> Function(DateTime day) dosesForDay;
  final void Function(String doseId, DoseStatus status) onMarkDose;
  final void Function(String doseId, String note) onSetDoseNote;
  final String Function(DateTime) fmtDate;
  final String Function(DateTime) fmtMonth;
  final String Function(DateTime) fmtTime;

  const ScheduleScreen({
    super.key,
    required this.medicines,
    required this.dosesForDay,
    required this.onMarkDose,
    required this.onSetDoseNote,
    required this.fmtDate,
    required this.fmtMonth,
    required this.fmtTime,
  });

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late DateTime selected;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selected = DateTime(now.year, now.month, now.day);
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.dosesForDay(selected)..sort((a, b) => a.plannedAt.compareTo(b.plannedAt));
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Row(
            children: [
              Expanded(child: Text(widget.fmtMonth(selected), style: Theme.of(context).textTheme.titleLarge)),
              IconButton(onPressed: () => setState(() => selected = DateTime(selected.year, selected.month - 1, 1)), icon: const Icon(Icons.chevron_left)),
              IconButton(onPressed: () => setState(() => selected = DateTime(selected.year, selected.month + 1, 1)), icon: const Icon(Icons.chevron_right)),
              TextButton(
                onPressed: () {
                  final now = DateTime.now();
                  setState(() => selected = DateTime(now.year, now.month, now.day));
                },
                child: const Text('Сегодня'),
              ),
            ],
          ),
        ),
        CalendarDatePicker(
          initialDate: selected,
          firstDate: DateTime(selected.year - 1),
          lastDate: DateTime(selected.year + 1, 12, 31),
          currentDate: DateTime.now(),
          onDateChanged: (d) => setState(() => selected = DateTime(d.year, d.month, d.day)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(widget.fmtDate(selected), style: Theme.of(context).textTheme.titleMedium),
          ),
        ),
        Expanded(
          child: items.isEmpty
              ? const Center(child: Text('На выбранный день доз нет'))
              : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (context, i) {
              final d = items[i];
              final m = widget.medicines.firstWhere((e) => e.id == d.medicineId);
              final color = switch (d.status) {
                DoseStatus.pending => Colors.orange,
                DoseStatus.taken => Colors.green,
                DoseStatus.skipped => Colors.red,
              };
              return Card(
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: color, child: const Icon(Icons.medication, color: Colors.white)),
                  title: Text(m.name),
                  subtitle: Text('${m.dose} • ${m.form} • ${widget.fmtTime(d.plannedAt)}'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (v) {
                      if (v == 'take') widget.onMarkDose(d.id, DoseStatus.taken);
                      if (v == 'skip') widget.onMarkDose(d.id, DoseStatus.skipped);
                      if (v == 'note') _editNote(context, d.id, d.note);
                    },
                    itemBuilder: (c) => const [
                      PopupMenuItem(value: 'take', child: Text('Принято')),
                      PopupMenuItem(value: 'skip', child: Text('Пропущено')),
                      PopupMenuItem(value: 'note', child: Text('Заметка')),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _editNote(BuildContext context, String doseId, String initial) async {
    final ctrl = TextEditingController(text: initial);
    await showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Заметка'),
        content: TextField(controller: ctrl, maxLines: 3),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Отмена')),
          FilledButton(
            onPressed: () {
              widget.onSetDoseNote(doseId, ctrl.text.trim());
              Navigator.pop(c);
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}