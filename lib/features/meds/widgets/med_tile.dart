import 'package:flutter/material.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';

class MedTile extends StatelessWidget {
  final Medicine med;
  final VoidCallback? onTap;
  const MedTile({super.key, required this.med, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.medication),
        title: Text(med.name),
        subtitle: Text('${med.dose} • ${med.form}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}