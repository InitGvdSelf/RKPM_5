import 'package:rkpm_5/features/meds/models/medicine.dart';

/// Простая логика планирования доз — добавляет будущие приёмы.
class DoseScheduler {
  void ensureFutureDoses(List<Medicine> meds, List<DoseEntry> doses) {
    final now = DateTime.now();
    for (final med in meds) {
      for (int i = 1; i <= 3; i++) {
        final t = now.add(Duration(hours: 8 * i));
        if (!doses.any((d) => d.medicineId == med.id && d.plannedAt == t)) {
          doses.add(DoseEntry(
            id: '${med.id}_${t.toIso8601String()}',
            medicineId: med.id,
            plannedAt: t,
            status: DoseStatus.pending,
            note: '',
          ));
        }
      }
    }
  }
}