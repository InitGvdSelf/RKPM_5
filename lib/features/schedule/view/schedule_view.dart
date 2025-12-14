import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rkpm_5/app/app_router.dart';
import 'package:rkpm_5/core/models/medicine_model.dart';
import 'package:rkpm_5/core/utils/date_utils.dart' as app_utils;
import 'package:rkpm_5/features/schedule/cubit/schedule_cubit.dart';
import 'package:rkpm_5/features/schedule/cubit/schedule_state.dart';
import 'package:rkpm_5/app/di.dart';

class ScheduleView extends StatelessWidget {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, scheduleState) {
        final selected = scheduleState.selectedDate;

        return FutureBuilder(
          future: DI.getDayScheduleUseCase(selected),
          builder: (context, snapshot) {
            final items = snapshot.data?.fold(
                  (_) => <DoseEntry>[],
                  (doses) => doses..sort((a, b) => a.plannedAt.compareTo(b.plannedAt)),
                ) ?? <DoseEntry>[];

            // Get medicines for display
            final medsFuture = DI.getMedsUseCase();
            
            return FutureBuilder(
              future: medsFuture,
              builder: (context, medsSnapshot) {
                final meds = medsSnapshot.data?.fold(
                      (_) => <Medicine>[],
                      (m) => m,
                    ) ?? <Medicine>[];

                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Расписание'),
                    actions: [
                      IconButton(
                        tooltip: 'Статистика',
                        onPressed: () => context.push(Routes.stats),
                        icon: const Icon(Icons.query_stats),
                      ),
                    ],
                  ),
                  body: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                app_utils.DateUtils.formatMonth(selected),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  context.read<ScheduleCubit>().previousMonth(),
                              icon: const Icon(Icons.chevron_left),
                            ),
                            IconButton(
                              onPressed: () =>
                                  context.read<ScheduleCubit>().nextMonth(),
                              icon: const Icon(Icons.chevron_right),
                            ),
                            TextButton(
                              onPressed: () => context.read<ScheduleCubit>().goToday(),
                              child: const Text('Сегодня'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: app_utils.DateUtils.getDaysInMonth(
                            selected.year,
                            selected.month,
                          ),
                          itemBuilder: (context, index) {
                            final day = index + 1;
                            final date = DateTime(selected.year, selected.month, day);
                            final isSelected = date.year == selected.year &&
                                date.month == selected.month &&
                                date.day == selected.day;

                            return GestureDetector(
                              onTap: () =>
                                  context.read<ScheduleCubit>().setSelectedDate(date),
                              child: Container(
                                width: 56,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).dividerColor,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '$day',
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.color,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            app_utils.DateUtils.formatDate(selected),
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
                                  final m = meds.firstWhere(
                                    (e) => e.id == d.medicineId,
                                    orElse: () => Medicine(
                                      id: d.medicineId,
                                      name: 'Неизвестное лекарство',
                                      form: '',
                                      dose: '',
                                      notes: '',
                                      schedule: Schedule.weekly(
                                        active: false,
                                        daysOfWeek: const {},
                                        times: const [],
                                      ),
                                    ),
                                  );

                                  final color = switch (d.status) {
                                    DoseStatus.pending => Colors.orange,
                                    DoseStatus.taken => Colors.green,
                                    DoseStatus.skipped => Colors.red,
                                  };

                                  return Card(
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: color,
                                        child: const Icon(
                                          Icons.medication,
                                          color: Colors.white,
                                        ),
                                      ),
                                      title: Text(m.name),
                                      subtitle: Text(
                                        '${m.dose} • ${m.form} • ${app_utils.DateUtils.formatTime(d.plannedAt)}',
                                      ),
                                      trailing: PopupMenuButton<String>(
                                        onSelected: (v) async {
                                          final cubit = context.read<ScheduleCubit>();

                                          if (v == 'take') {
                                            await cubit.markDose(d.id, DoseStatus.taken);
                                          }
                                          if (v == 'skip') {
                                            await cubit.markDose(d.id, DoseStatus.skipped);
                                          }
                                          if (v == 'note') {
                                            final newNote = await _editNote(context, d.id, d.note);
                                            if (newNote != null) {
                                              await cubit.updateDoseNote(d.id, newNote);
                                            }
                                          }
                                        },
                                        itemBuilder: (c) => const [
                                          PopupMenuItem(
                                            value: 'take',
                                            child: Text('Принято'),
                                          ),
                                          PopupMenuItem(
                                            value: 'skip',
                                            child: Text('Пропущено'),
                                          ),
                                          PopupMenuItem(
                                            value: 'note',
                                            child: Text('Заметка'),
                                          ),
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
              },
            );
          },
        );
      },
    );
  }

  Future<String?> _editNote(
    BuildContext context,
    String doseId,
    String initialNote,
  ) async {
    final ctrl = TextEditingController(text: initialNote);
    String? result;

    await showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Заметка к приёму'),
        content: TextField(
          controller: ctrl,
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () {
              result = ctrl.text.trim();
              Navigator.pop(c);
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );

    return result;
  }
}

