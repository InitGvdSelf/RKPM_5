// lib/features/meds/screens/today_screen.dart
import 'package:flutter/material.dart';
import 'package:rkpm_5/core/app_dependencies.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

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
    final state = AppDependencies.of(context).state;

    // список доз на день
    final items = List<DoseEntry>.from(state.dosesForDay(selected))
      ..sort((a, b) => a.plannedAt.compareTo(b.plannedAt));

    return Scaffold(
      appBar: AppBar(title: const Text('Расписание')),
      body: Column(
        children: [
          // Заголовок месяца + кнопки навигации
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    state.fmtMonth(selected),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  onPressed: () => setState(
                        () => selected = DateTime(selected.year, selected.month - 1, 1),
                  ),
                  icon: const Icon(Icons.chevron_left),
                ),
                IconButton(
                  onPressed: () => setState(
                        () => selected = DateTime(selected.year, selected.month + 1, 1),
                  ),
                  icon: const Icon(Icons.chevron_right),
                ),
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

          // Календарь
          CalendarDatePicker(
            initialDate: selected,
            firstDate: DateTime(selected.year - 1),
            lastDate: DateTime(selected.year + 1, 12, 31),
            currentDate: DateTime.now(),
            onDateChanged: (d) =>
                setState(() => selected = DateTime(d.year, d.month, d.day)),
          ),

          // Дата и список приёмов
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                state.fmtDate(selected),
                style: Theme.of(context).textTheme.titleMedium,
              ),
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
                // ищем лекарство по id
                final m = state.medicines.firstWhere((e) => e.id == d.medicineId);
                final color = switch (d.status) {
                  DoseStatus.pending => Colors.orange,
                  DoseStatus.taken => Colors.green,
                  DoseStatus.skipped => Colors.red,
                };
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color,
                      child: const Icon(Icons.medication, color: Colors.white),
                    ),
                    title: Text(m.name),
                    subtitle: Text('${m.dose} • ${m.form} • ${state.fmtTime(d.plannedAt)}'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (v) {
                        if (v == 'take') state.markDose(d.id, DoseStatus.taken);
                        if (v == 'skip') state.markDose(d.id, DoseStatus.skipped);
                        if (v == 'note') _editNote(context, d.id, d.note);
                        setState(() {}); // чтобы сразу отрисовать изменения
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
      ),
    );
  }

  void _editNote(BuildContext context, String doseId, String initial) async {
    final state = AppDependencies.of(context).state;
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
              state.setDoseNote(doseId, ctrl.text.trim());
              Navigator.pop(c);
              setState(() {});
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}