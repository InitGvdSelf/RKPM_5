import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rkpm_5/features/meds/domain/empty_state.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';
import 'package:rkpm_5/features/meds/models/med_course.dart';
import 'package:rkpm_5/features/meds/state/courses/courses_cubit.dart';
import 'package:rkpm_5/features/meds/state/courses/courses_state.dart';

class CoursesView extends StatelessWidget {
  const CoursesView({super.key});

  String _fmtDate(BuildContext context, DateTime d) =>
      MaterialLocalizations.of(context).formatMediumDate(d);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursesCubit, CoursesState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final entries = state.entries;
        final meds = context.read<CoursesCubit>().medsState.medicines;

        return Scaffold(
          appBar: AppBar(title: const Text('Курсы приёма')),
          body: entries.isEmpty
              ? const EmptyState(
            icon: Icons.playlist_add_check,
            title: 'Курсов нет',
            subtitle: 'Создайте первый курс приёма',
          )
              : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: entries.length,
            itemBuilder: (context, i) {
              final c = entries[i];

              final resolvedName = (c.medicineId == null)
                  ? c.medicineName
                  : (meds
                  .where((m) => m.id == c.medicineId)
                  .map((m) => m.name)
                  .cast<String?>()
                  .firstWhere((e) => e != null, orElse: () => null) ??
                  c.medicineName);

              final period = c.endDate == null
                  ? _fmtDate(context, c.startDate)
                  : '${_fmtDate(context, c.startDate)} — ${_fmtDate(context, c.endDate!)}';

              return Dismissible(
                key: ValueKey(c.id),
                background: Container(color: Colors.red),
                confirmDismiss: (_) async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (d) => AlertDialog(
                      title: const Text('Удалить курс?'),
                      content: Text('«$resolvedName» будет удалён.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(d, false),
                          child: const Text('Отмена'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(d, true),
                          child: const Text('Удалить'),
                        ),
                      ],
                    ),
                  );
                  return ok ?? false;
                },
                onDismissed: (_) =>
                    context.read<CoursesCubit>().delete(c.id),
                child: Card(
                  child: ListTile(
                    title: Text(resolvedName.isEmpty ? 'Курс' : resolvedName),
                    subtitle: Text(
                      '$period\n${c.timesPerDay} раз/день\n${c.note}',
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _addDialog(context),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Future<void> _addDialog(BuildContext context) async {
    final cubit = context.read<CoursesCubit>();
    final meds = cubit.medsState.medicines;

    String? selectedMedId; // null = вручную
    final nameCtrl = TextEditingController();
    final timesCtrl = TextEditingController(text: '1');
    final noteCtrl = TextEditingController();

    DateTime start = DateUtils.dateOnly(DateTime.now());
    DateTime? end;

    await showDialog(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (c, setState) => AlertDialog(
          title: const Text('Новый курс'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ✅ выбор из лекарств
                DropdownButtonFormField<String?>(
                  value: selectedMedId,
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Ввести вручную'),
                    ),
                    ...meds.map(
                          (m) => DropdownMenuItem<String?>(
                        value: m.id,
                        child: Text(m.name),
                      ),
                    ),
                  ],
                  onChanged: (v) {
                    setState(() => selectedMedId = v);
                    if (v != null) {
                      final m = meds.firstWhere((e) => e.id == v);
                      nameCtrl.text = m.name;
                    } else {
                      nameCtrl.text = '';
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Лекарство',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Название (если вручную)',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: timesCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Сколько раз в день',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Старт: '),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: c,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          initialDate: start,
                        );
                        if (picked != null) setState(() => start = picked);
                      },
                      child: Text(MaterialLocalizations.of(c).formatMediumDate(start)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Финиш: '),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: c,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          initialDate: end ?? start,
                        );
                        setState(() => end = picked);
                      },
                      child: Text(end == null
                          ? 'не задан'
                          : MaterialLocalizations.of(c).formatMediumDate(end!)),
                    ),
                    if (end != null)
                      IconButton(
                        tooltip: 'Сбросить',
                        onPressed: () => setState(() => end = null),
                        icon: const Icon(Icons.close),
                      ),
                  ],
                ),
                TextField(
                  controller: noteCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Заметка'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: const Text('Отмена'),
            ),
            FilledButton(
              onPressed: () {
                final name = nameCtrl.text.trim();
                final times = int.tryParse(timesCtrl.text.trim()) ?? 1;

                final entry = MedCourse(
                  id: '${DateTime.now().microsecondsSinceEpoch}_${Random().nextInt(9999)}',
                  medicineId: selectedMedId,
                  medicineName: name,
                  startDate: start,
                  endDate: end,
                  timesPerDay: times.clamp(1, 24),
                  note: noteCtrl.text.trim(),
                );

                cubit.add(entry);
                Navigator.pop(c);
              },
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}