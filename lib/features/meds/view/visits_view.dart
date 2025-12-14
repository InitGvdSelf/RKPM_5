import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rkpm_5/features/meds/domain/empty_state.dart';
import 'package:rkpm_5/features/meds/models/visit.dart';
import 'package:rkpm_5/features/meds/state/visits/visits_cubit.dart';
import 'package:rkpm_5/features/meds/state/visits/visits_state.dart';

class VisitsView extends StatelessWidget {
  const VisitsView({super.key});

  String _fmtDateTime(BuildContext context, DateTime d) {
    final l = MaterialLocalizations.of(context);
    return '${l.formatMediumDate(d)} • ${l.formatTimeOfDay(TimeOfDay.fromDateTime(d))}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VisitsCubit, VisitsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final entries = state.entries;

        return Scaffold(
          appBar: AppBar(title: const Text('Записи к врачу')),
          body: entries.isEmpty
              ? const EmptyState(
            icon: Icons.medical_information,
            title: 'Пока нет записей',
            subtitle: 'Добавьте первый визит',
          )
              : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: entries.length,
            itemBuilder: (context, i) {
              final v = entries[i];
              return Dismissible(
                key: ValueKey(v.id),
                background: Container(color: Colors.red),
                confirmDismiss: (_) async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (c) => AlertDialog(
                      title: const Text('Удалить визит?'),
                      content: const Text('Запись будет удалена.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(c, false),
                          child: const Text('Отмена'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(c, true),
                          child: const Text('Удалить'),
                        ),
                      ],
                    ),
                  );
                  return ok ?? false;
                },
                onDismissed: (_) => context.read<VisitsCubit>().delete(v.id),
                child: Card(
                  child: ListTile(
                    title: Text(v.doctor.isEmpty ? 'Врач' : v.doctor),
                    subtitle: Text(
                      '${_fmtDateTime(context, v.dateTime)}\n${v.reason}\n${v.note}',
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
    final doctorCtrl = TextEditingController();
    final reasonCtrl = TextEditingController();
    final noteCtrl = TextEditingController();

    DateTime dt = DateTime.now();

    await showDialog(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (c, setState) => AlertDialog(
          title: const Text('Новый визит'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text('Дата/время: '),
                    TextButton(
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: c,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          initialDate: dt,
                        );
                        if (pickedDate == null) return;

                        final pickedTime = await showTimePicker(
                          context: c,
                          initialTime: TimeOfDay.fromDateTime(dt),
                        );
                        if (pickedTime == null) return;

                        setState(() {
                          dt = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                        });
                      },
                      child: Text(
                        '${MaterialLocalizations.of(c).formatMediumDate(dt)} '
                            '${MaterialLocalizations.of(c).formatTimeOfDay(TimeOfDay.fromDateTime(dt))}',
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: doctorCtrl,
                  decoration: const InputDecoration(labelText: 'Врач/специалист'),
                ),
                TextField(
                  controller: reasonCtrl,
                  decoration: const InputDecoration(labelText: 'Причина/жалобы'),
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
                final entry = Visit(
                  id: '${DateTime.now().microsecondsSinceEpoch}_${DateTime.now().millisecondsSinceEpoch % 9999}',
                  dateTime: dt,
                  doctor: doctorCtrl.text.trim(),
                  reason: reasonCtrl.text.trim(),
                  note: noteCtrl.text.trim(),
                );
                context.read<VisitsCubit>().add(entry);
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