import 'package:flutter/material.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';
import 'package:rkpm_5/features/meds/screens/med_form_screen.dart';

class MedDetailsScreen extends StatelessWidget {
  final Medicine medicine;
  final Medicine? Function(String id) onDelete;
  final void Function(Medicine med) onRestore;
  final void Function(Medicine med) onUpdate;

  const MedDetailsScreen({
    super.key,
    required this.medicine,
    required this.onDelete,
    required this.onRestore,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final m = medicine;

    return Scaffold(
      appBar: AppBar(title: Text(m.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              const Icon(Icons.medication, size: 36),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  m.name,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _kv('Форма', m.form),
          _kv('Дозировка', m.dose),
          if (m.notes.trim().isNotEmpty) _kv('Заметки', m.notes),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          _scheduleBlock(m),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FilledButton.icon(
                onPressed: () async {
                  final removed = onDelete(m.id);
                  if (removed != null && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Удалено: ${removed.name}'),
                        action: SnackBarAction(
                          label: 'Отмена',
                          onPressed: () => onRestore(removed),
                        ),
                      ),
                    );
                    Navigator.of(context).pop(); // закрываем детали
                  }
                },
                icon: const Icon(Icons.delete),
                label: const Text('Удалить'),
              ),
              FilledButton.icon(
                onPressed: () async {
                  // В твоей форме используется параметр existing (не existingMedicine!)
                  final updated = await Navigator.of(context).push<Medicine>(
                    MaterialPageRoute(
                      builder: (_) => MedFormScreen(existing: m),
                    ),
                  );
                  if (updated != null && context.mounted) {
                    onUpdate(updated);
                    Navigator.of(context).pop(updated);
                  }
                },
                icon: const Icon(Icons.edit),
                label: const Text('Редактировать'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _kv(String k, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 120, child: Text(k, style: const TextStyle(color: Colors.black54))),
        const SizedBox(width: 8),
        Expanded(child: Text(v)),
      ],
    ),
  );

  Widget _scheduleBlock(Medicine m) {
    final s = m.schedule;
    final mode = s.mode.name == 'weekly' ? 'Еженедельно' : 'По датам';
    final times = s.times.map((t) => t.toString()).join(', ');
    final days = s.daysOfWeek.isEmpty ? '—' : s.daysOfWeek.join(', ');
    final dates = s.dates.isEmpty ? '—' : s.dates.map((d) => d.toIso8601String().split('T').first).join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Расписание', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        _kv('Режим', mode),
        _kv('Время', times),
        if (s.mode.name == 'weekly') _kv('Дни недели', days) else _kv('Даты', dates),
      ],
    );
  }
}