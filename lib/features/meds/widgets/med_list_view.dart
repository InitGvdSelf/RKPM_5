import 'package:flutter/material.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';
import 'package:rkpm_5/features/meds/widgets/med_tile.dart';

class MedListView extends StatelessWidget {
  final List<Medicine> items;
  final ValueChanged<Medicine> onTap;
  final DismissDirectionCallback? onDismiss;
  const MedListView({super.key, required this.items, required this.onTap, this.onDismiss});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final m = items[i];
        return Dismissible(
          key: ValueKey(m.id),
          background: Container(color: Colors.red),
          onDismissed: onDismiss,
          child: MedTile(med: m, onTap: () => onTap(m)),
        );
      },
    );
  }
}