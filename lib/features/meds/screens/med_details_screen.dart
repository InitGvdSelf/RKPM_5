import 'package:flutter/material.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';
import 'package:rkpm_5/features/meds/screens/med_form_screen.dart';

class MedDetailsScreen extends StatelessWidget {
  final String medId;
  const MedDetailsScreen({super.key, required this.medId});

  @override
  Widget build(BuildContext context) {
    final med = _findMed(context, medId);
    return Scaffold(
      appBar: AppBar(title: Text(med?.name ?? 'Лекарство')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(med?.notes ?? 'Без примечаний'),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MedFormScreen(existing: med),
                  ),
                );
              },
              child: const Text('Редактировать (push)'),
            ),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: () async {
                await Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => MedFormScreen(existing: med),
                  ),
                );
              },
              child: const Text('Редактировать (replace)'),
            ),
          ],
        ),
      ),
    );
  }

  Medicine? _findMed(BuildContext context, String id) {
    return null;
  }
}