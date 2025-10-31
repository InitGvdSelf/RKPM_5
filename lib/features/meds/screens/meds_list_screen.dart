import 'package:flutter/material.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';
import 'package:rkpm_5/features/meds/screens/med_form_screen.dart';
import 'package:rkpm_5/features/meds/screens/med_details_screen.dart';
import 'package:rkpm_5/features/meds/widgets/med_tile.dart';
import 'package:rkpm_5/shared/widgets/empty_state.dart';

class MedsListScreen extends StatefulWidget {
  final List<Medicine> medicines;
  final void Function(Medicine) onAddMedicine;
  final void Function(Medicine) onUpdateMedicine;
  final Medicine? Function(String id) onDeleteMedicine;
  final void Function(Medicine) onRestoreMedicine;

  const MedsListScreen({
    super.key,
    required this.medicines,
    required this.onAddMedicine,
    required this.onUpdateMedicine,
    required this.onDeleteMedicine,
    required this.onRestoreMedicine,
  });

  @override
  State<MedsListScreen> createState() => _MedsListScreenState();
}

class _MedsListScreenState extends State<MedsListScreen> {
  @override
  Widget build(BuildContext context) {
    final list = widget.medicines;
    return Column(
      children: [
        Expanded(
          child: list.isEmpty
              ? EmptyState(
            icon: Icons.medication,
            title: 'Нет лекарств',
            subtitle: 'Добавьте первое лекарство',
            action: FilledButton.icon(
              onPressed: () async {
                final created = await Navigator.of(context).push<Medicine>(
                  MaterialPageRoute(builder: (_) => const MedFormScreen()),
                );
                if (created != null) {
                  widget.onAddMedicine(created);
                  setState(() {});
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Добавить лекарство'),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final m = list[i];
              return Dismissible(
                key: ValueKey(m.id),
                background: Container(color: Colors.red),
                confirmDismiss: (_) async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (c) => AlertDialog(
                      title: const Text('Удалить лекарство?'),
                      content: Text('«${m.name}» будет удалено.'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(c, false),
                            child: const Text('Отмена')),
                        FilledButton(
                            onPressed: () => Navigator.pop(c, true),
                            child: const Text('Удалить')),
                      ],
                    ),
                  );
                  return ok ?? false;
                },
                onDismissed: (_) {
                  final removed = widget.onDeleteMedicine(m.id);
                  if (removed != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Удалено: ${removed.name}'),
                        action: SnackBarAction(
                          label: 'Отмена',
                          onPressed: () =>
                              widget.onRestoreMedicine(removed),
                        ),
                      ),
                    );
                  }
                  setState(() {});
                },
                child: MedTile(
                  med: m,
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MedDetailsScreen(medId: m.id),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: FilledButton.icon(
              onPressed: () async {
                final created = await Navigator.of(context).push<Medicine>(
                  MaterialPageRoute(builder: (_) => const MedFormScreen()),
                );
                if (created != null) {
                  widget.onAddMedicine(created);
                  setState(() {});
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Добавить лекарство'),
            ),
          ),
        ),
      ],
    );
  }
}