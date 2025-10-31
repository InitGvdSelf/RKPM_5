import 'package:flutter/material.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';
import 'package:rkpm_5/features/meds/screens/med_form_screen.dart';
import 'package:rkpm_5/shared/widgets/empty_state.dart';

class TakenDosesScreen extends StatelessWidget {
  final void Function(Medicine) onAddMedicine;

  const TakenDosesScreen({
    super.key,
    required this.onAddMedicine,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: EmptyState(
          icon: Icons.check_circle_outline,
          title: 'Нет принятых доз',
          subtitle: 'Отмечайте приём, чтобы видеть его здесь',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.of(context).push<Medicine>(
            MaterialPageRoute(builder: (_) => const MedFormScreen()),
          );
          if (created != null) {
            onAddMedicine(created);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}