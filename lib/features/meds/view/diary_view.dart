import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rkpm_5/features/meds/domain/empty_state.dart';
import 'package:rkpm_5/features/meds/models/diary_entry.dart';
import 'package:rkpm_5/features/meds/state/diary/diary_cubit.dart';
import 'package:rkpm_5/features/meds/state/diary/diary_state.dart';

class DiaryView extends StatelessWidget {
  const DiaryView({super.key});

  String _fmtDate(BuildContext context, DateTime d) =>
      MaterialLocalizations.of(context).formatMediumDate(d);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiaryCubit, DiaryState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final entries = state.entries;

        return Scaffold(
          appBar: AppBar(title: const Text('Дневник самочувствия')),
          body: entries.isEmpty
              ? const EmptyState(
            icon: Icons.book,
            title: 'Пока пусто',
            subtitle: 'Добавьте запись о самочувствии',
          )
              : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: entries.length,
            itemBuilder: (context, i) {
              final e = entries[i];
              return Dismissible(
                key: ValueKey(e.id),
                background: Container(color: Colors.red),
                confirmDismiss: (_) async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (c) => AlertDialog(
                      title: const Text('Удалить запись?'),
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
                onDismissed: (_) => context.read<DiaryCubit>().delete(e.id),
                child: Card(
                  child: ListTile(
                    title: Text(_fmtDate(context, e.date)),
                    subtitle: Text(
                      'Настроение: ${e.mood}/5\n${e.note}',
                      maxLines: 3,
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
    final noteCtrl = TextEditingController();
    int mood = 3;
    DateTime date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    await showDialog(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (c, setState) => AlertDialog(
          title: const Text('Новая запись'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text('Дата: '),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: c,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        initialDate: date,
                      );
                      if (picked != null) setState(() => date = picked);
                    },
                    child: Text(MaterialLocalizations.of(c).formatMediumDate(date)),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Самочувствие: '),
                  Expanded(
                    child: Slider(
                      value: mood.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: '$mood',
                      onChanged: (v) => setState(() => mood = v.round()),
                    ),
                  ),
                ],
              ),
              TextField(
                controller: noteCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Комментарий',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: const Text('Отмена'),
            ),
            FilledButton(
              onPressed: () {
                final entry = DiaryEntry(
                  id: '${DateTime.now().microsecondsSinceEpoch}_${DateTime.now().millisecondsSinceEpoch % 9999}',
                  date: date,
                  mood: mood,
                  note: noteCtrl.text.trim(),
                );
                context.read<DiaryCubit>().add(entry);
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