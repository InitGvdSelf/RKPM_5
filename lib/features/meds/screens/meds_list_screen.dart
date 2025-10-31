import 'package:flutter/material.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';
import 'package:rkpm_5/features/meds/screens/med_details_screen.dart';
import 'package:rkpm_5/features/meds/screens/med_form_screen.dart';

class MedsListScreen extends StatelessWidget {
  final List<Medicine> medicines;
  final void Function(Medicine) onAddMedicine;
  final void Function(Medicine) onUpdateMedicine;
  final Medicine? Function(String) onDeleteMedicine;
  final void Function(Medicine) onRestoreMedicine;
  final bool embedded;

  const MedsListScreen({
    super.key,
    required this.medicines,
    required this.onAddMedicine,
    required this.onUpdateMedicine,
    required this.onDeleteMedicine,
    required this.onRestoreMedicine,
    this.embedded = false,
  });

  Future<void> _add(BuildContext context) async {
    final created = await Navigator.of(context).push<Medicine>(
      MaterialPageRoute(builder: (_) => const MedFormScreen()),
    );
    if (created != null) onAddMedicine(created);
  }

  void _openDetails(BuildContext context, Medicine m) async {
    final updated = await Navigator.of(context).push<Medicine>(
      MaterialPageRoute(
        builder: (_) => MedDetailsScreen(
          medicine: m,
          onDelete: onDeleteMedicine,
          onRestore: onRestoreMedicine,
          onUpdate: onUpdateMedicine,
        ),
      ),
    );
    if (updated != null) onUpdateMedicine(updated);
  }

  @override
  Widget build(BuildContext context) {
    final hasMeds = medicines.isNotEmpty;

    return Scaffold(
      appBar: embedded ? null : AppBar(title: const Text('Лекарства')),
      body: hasMeds
          ? ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: medicines.length,
        itemBuilder: (context, i) {
          final m = medicines[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.medication, color: Colors.teal),
              title: Text(
                m.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text('${m.dose} • ${m.form}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _openDetails(context, m),
            ),
          );
        },
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.medication, size: 60, color: Colors.black54),
            const SizedBox(height: 16),
            const Text(
              'Нет лекарств',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Добавьте первое лекарство',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => _add(context),
              icon: const Icon(Icons.add),
              label: const Text('Добавить лекарство'),
            ),
          ],
        ),
      ),
    );
  }
}