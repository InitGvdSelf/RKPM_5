// lib/features/meds/screens/meds_list_screen.dart
import 'package:flutter/material.dart';
import 'package:rkpm_5/core/app_dependencies.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';
import 'package:rkpm_5/features/meds/screens/med_form_screen.dart';
import 'package:rkpm_5/features/meds/widgets/med_tile.dart';
import 'package:rkpm_5/shared/widgets/empty_state.dart';

class MedsListScreen extends StatefulWidget {
  const MedsListScreen({super.key});

  @override
  State<MedsListScreen> createState() => _MedsListScreenState();
}

class _MedsListScreenState extends State<MedsListScreen> {
  Future<void> _add() async {
    FocusScope.of(context).unfocus();

    final created = await Navigator.of(context).push<Medicine>(
      MaterialPageRoute(builder: (_) => const MedFormScreen()),
    );
    if (!mounted || created == null) return;

    final state = AppDependencies.of(context).state;
    state.addMedicine(created);
    setState(() {});
  }

  Future<void> _edit(Medicine m) async {
    FocusScope.of(context).unfocus();

    final updated = await Navigator.of(context).push<Medicine>(
      MaterialPageRoute(builder: (_) => MedFormScreen(existing: m)),
    );
    if (!mounted || updated == null) return;

    final state = AppDependencies.of(context).state;
    state.updateMedicine(updated);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final state = AppDependencies.of(context).state;
    final meds = state.medicines;
    final hasMeds = meds.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Лекарства')),
      body: SafeArea(
        child: hasMeds
            ? ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: meds.length,
          itemBuilder: (context, i) {
            final m = meds[i];
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
              onDismissed: (_) {
                final removed = state.deleteMedicine(m.id);
                if (removed != null && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Удалено: ${removed.name}'),
                      action: SnackBarAction(
                        label: 'Отмена',
                        onPressed: () => state.restoreMedicine(removed),
                      ),
                    ),
                  );
                }
                setState(() {});
              },
              child: MedTile(
                med: m,
                onTap: () => _edit(m),
              ),
            );
          },
        )
            : EmptyState(
          icon: Icons.medication,
          title: 'Нет лекарств',
          subtitle: 'Добавьте первое лекарство',
          action: FilledButton.icon(
            onPressed: _add,
            icon: const Icon(Icons.add),
            label: const Text('Добавить лекарство'),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: hasMeds
          ? Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewPadding.bottom + 8,
          left: 12,
          right: 12,
        ),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _add,
            icon: const Icon(Icons.add),
            label: const Text('Добавить лекарство'),
          ),
        ),
      )
          : null,
    );
  }
}