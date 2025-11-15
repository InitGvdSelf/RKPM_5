// lib/features/meds/view/meds_list_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rkpm_5/features/meds/models/medicine.dart';
import 'package:rkpm_5/features/meds/screens/form_screen.dart';
import 'package:rkpm_5/features/meds/state/list/list_cubit.dart';
import 'package:rkpm_5/features/meds/state/list/list_state.dart';
import 'package:rkpm_5/features/meds/domain/med_tile.dart';
import 'package:rkpm_5/features/meds/domain/empty_state.dart';

class MedsListView extends StatelessWidget {
  const MedsListView({super.key});

  Future<void> _add(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final created = await Navigator.of(context).push<Medicine>(
      MaterialPageRoute(builder: (_) => const MedFormScreen()),
    );
    if (!context.mounted || created == null) return;

    final cubit = context.read<MedsListCubit>();
    cubit.addMedicine(created);
  }

  Future<void> _edit(BuildContext context, Medicine m) async {
    FocusScope.of(context).unfocus();

    final updated = await Navigator.of(context).push<Medicine>(
      MaterialPageRoute(builder: (_) => MedFormScreen(existing: m)),
    );
    if (!context.mounted || updated == null) return;

    final cubit = context.read<MedsListCubit>();
    cubit.updateMedicine(updated);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedsListCubit, MedsListState>(
      builder: (context, state) {
        final meds = state.medicines;
        final hasMeds = meds.isNotEmpty;

        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

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
                    final cubit = context.read<MedsListCubit>();
                    final removed = cubit.deleteMedicine(m.id);
                    if (removed != null && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Удалено: ${removed.name}'),
                          action: SnackBarAction(
                            label: 'Отмена',
                            onPressed: () {
                              cubit.restoreMedicine(removed);
                            },
                          ),
                        ),
                      );
                    }
                  },
                  child: MedTile(
                    med: m,
                    onTap: () => _edit(context, m),
                  ),
                );
              },
            )
                : EmptyState(
              icon: Icons.medication,
              title: 'Нет лекарств',
              subtitle: 'Добавьте первое лекарство',
              action: FilledButton.icon(
                onPressed: () => _add(context),
                icon: const Icon(Icons.add),
                label: const Text('Добавить лекарство'),
              ),
            ),
          ),
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
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
                onPressed: () => _add(context),
                icon: const Icon(Icons.add),
                label: const Text('Добавить лекарство'),
              ),
            ),
          )
              : null,
        );
      },
    );
  }
}