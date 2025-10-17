import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';

class MedFormScreen extends StatefulWidget {
  final Medicine? existing;
  const MedFormScreen({super.key, this.existing});

  @override
  State<MedFormScreen> createState() => _MedFormScreenState();
}


class _MedFormScreenState extends State<MedFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  late TextEditingController name;
  late TextEditingController form;
  late TextEditingController dose;
  late TextEditingController notes;

  ScheduleMode mode = ScheduleMode.weekly;
  bool active = true;
  Set<int> days = {1, 2, 3, 4, 5, 6, 7};
  List<Clock> times = [const Clock(9, 0)];
  List<DateTime> dates = [];

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.existing?.name ?? '');
    form = TextEditingController(text: widget.existing?.form ?? '');
    dose = TextEditingController(text: widget.existing?.dose ?? '');
    notes = TextEditingController(text: widget.existing?.notes ?? '');
    if (widget.existing != null) {
      final s = widget.existing!.schedule;
      active = s.active;
      mode = s.mode;
      days = {...s.daysOfWeek};
      times = [...s.times];
      dates = [...s.dates];
    }
  }

  @override
  void dispose() {
    name.dispose();
    form.dispose();
    dose.dispose();
    notes.dispose();
    super.dispose();
  }

  Future<void> pickTime(int index) async {
    final initial = TimeOfDay(hour: times[index].hour, minute: times[index].minute);
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) setState(() => times[index] = Clock(picked.hour, picked.minute));
  }

  Future<void> addDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2, 12, 31),
      locale: const Locale('ru'),
    );
    if (d != null) {
      final x = DateTime(d.year, d.month, d.day);
      if (!dates.any((e) => e.year == x.year && e.month == x.month && e.day == x.day)) {
        setState(() => dates.add(x));
        dates.sort((a, b) => a.compareTo(b));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.existing == null ? 'Новое лекарство' : 'Редактирование')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: name,
              decoration: const InputDecoration(labelText: 'Название'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Обязательное поле' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(controller: form, decoration: const InputDecoration(labelText: 'Форма выпуска')),
            const SizedBox(height: 12),
            TextFormField(controller: dose, decoration: const InputDecoration(labelText: 'Дозировка')),
            const SizedBox(height: 12),
            TextFormField(controller: notes, decoration: const InputDecoration(labelText: 'Комментарий'), maxLines: 3),
            const SizedBox(height: 16),
            SwitchListTile(title: const Text('Схема активна'), value: active, onChanged: (v) => setState(() => active = v)),
            const SizedBox(height: 8),
            SegmentedButton<ScheduleMode>(
              segments: const [
                ButtonSegment(value: ScheduleMode.weekly, label: Text('По дням недели'), icon: Icon(Icons.repeat)),
                ButtonSegment(value: ScheduleMode.dates, label: Text('Конкретные даты'), icon: Icon(Icons.event)),
              ],
              selected: {mode},
              onSelectionChanged: (s) => setState(() => mode = s.first),
            ),
            const SizedBox(height: 16),
            if (mode == ScheduleMode.weekly)
              _WeeklySection(
                days: days,
                onToggle: (d) => setState(() => days.contains(d) ? days.remove(d) : days.add(d)),
              ),
            if (mode == ScheduleMode.dates)
              _DatesSection(
                dates: dates,
                onAdd: addDate,
                onRemove: (d) => setState(() => dates.remove(d)),
                format: (d) => DateFormat('dd.MM.yyyy', 'ru').format(d),
              ),
            const SizedBox(height: 16),
            const Text('Время приёма'),
            const SizedBox(height: 8),
            Column(children: [
              for (int i = 0; i < times.length; i++)
                ListTile(
                  title: Text('${times[i]}'),
                  leading: const Icon(Icons.schedule),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(onPressed: () => pickTime(i), icon: const Icon(Icons.edit)),
                    IconButton(onPressed: () => setState(() => times.removeAt(i)), icon: const Icon(Icons.delete)),
                  ]),
                ),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final picked = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 9, minute: 0));
                    if (picked != null) setState(() => times.add(Clock(picked.hour, picked.minute)));
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Добавить время'),
                ),
              ),
            ]),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                if (times.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Добавьте хотя бы одно время')));
                  return;
                }
                if (mode == ScheduleMode.weekly && days.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Выберите дни недели')));
                  return;
                }
                if (mode == ScheduleMode.dates && dates.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Выберите хотя бы одну дату')));
                  return;
                }
                final sched = Schedule(active: active, mode: mode, times: times, daysOfWeek: days, dates: dates);
                if (widget.existing == null) {
                  final created = Medicine(
                    id: const Uuid().v4(),
                    name: name.text.trim(),
                    form: form.text.trim(),
                    dose: dose.text.trim(),
                    notes: notes.text.trim(),
                    schedule: sched,
                  );
                  Navigator.pop(context, created);
                } else {
                  final updated = widget.existing!;
                  updated
                    ..name = name.text.trim()
                    ..form = form.text.trim()
                    ..dose = dose.text.trim()
                    ..notes = notes.text.trim()
                    ..schedule = sched;
                  Navigator.pop(context, updated);
                }
              },
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklySection extends StatelessWidget {
  final Set<int> days;
  final ValueChanged<int> onToggle;
  const _WeeklySection({required this.days, required this.onToggle});
  @override
  Widget build(BuildContext context) {
    final labels = ['Пн','Вт','Ср','Чт','Пт','Сб','Вс'];
    return Wrap(
      spacing: 8,
      children: List.generate(7, (i) {
        final day = i + 1;
        final selected = days.contains(day);
        return FilterChip(label: Text(labels[i]), selected: selected, onSelected: (_) => onToggle(day));
      }),
    );
  }
}

class _DatesSection extends StatelessWidget {
  final List<DateTime> dates;
  final VoidCallback onAdd;
  final ValueChanged<DateTime> onRemove;
  final String Function(DateTime) format;
  const _DatesSection({required this.dates, required this.onAdd, required this.onRemove, required this.format});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(alignment: Alignment.centerLeft, child: OutlinedButton.icon(onPressed: onAdd, icon: const Icon(Icons.event_available), label: const Text('Добавить дату'))),
        if (dates.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: dates.map((d) => InputChip(label: Text(format(d)), onDeleted: () => onRemove(d))).toList(),
          ),
      ],
    );
  }
}