import 'package:uuid/uuid.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';

class DoseScheduler {
  final _uuid = const Uuid();

  void ensureFutureDoses(List<Medicine> medicines, List<DoseEntry> doses) {
    final now = DateTime.now();
    final startDay = DateTime(now.year, now.month, now.day);
    final horizon = startDay.add(const Duration(days: 29));
    final existing = <String>{for (var d in doses) '${d.medicineId}@${d.plannedAt.toIso8601String()}'};

    for (final med in medicines) {
      if (!med.schedule.active) continue;

      if (med.schedule.mode == ScheduleMode.weekly) {
        _generateWeekly(med, doses, existing, startDay, horizon);
      } else {
        _generateManual(med, doses, existing, startDay, horizon);
      }
    }

    doses.sort((a, b) => a.plannedAt.compareTo(b.plannedAt));
  }

  void _generateWeekly(
      Medicine med,
      List<DoseEntry> doses,
      Set<String> existing,
      DateTime start,
      DateTime horizon,
      ) {
    final effectiveDays = (med.schedule.daysOfWeek.isEmpty)
        ? {1, 2, 3, 4, 5, 6, 7}
        : med.schedule.daysOfWeek;

    DateTime day = start;
    while (!day.isAfter(horizon)) {
      if (effectiveDays.contains(day.weekday)) {
        for (final t in med.schedule.times) {
          final planned = DateTime(day.year, day.month, day.day, t.hour, t.minute);
          final key = '${med.id}@${planned.toIso8601String()}';
          if (!existing.contains(key)) {
            doses.add(DoseEntry(
              id: _uuid.v4(),
              medicineId: med.id,
              plannedAt: planned,
              status: DoseStatus.pending,
              note: '',
            ));
          }
        }
      }
      day = day.add(const Duration(days: 1));
    }
  }

  void _generateManual(
      Medicine med,
      List<DoseEntry> doses,
      Set<String> existing,
      DateTime start,
      DateTime horizon,
      ) {
    for (final date in med.schedule.dates) {
      for (final t in med.schedule.times) {
        final d = DateTime(date.year, date.month, date.day, t.hour, t.minute);
        if (d.isBefore(start) || d.isAfter(horizon)) continue;
        final key = '${med.id}@${d.toIso8601String()}';
        if (!existing.contains(key)) {
          doses.add(DoseEntry(
            id: _uuid.v4(),
            medicineId: med.id,
            plannedAt: d,
            status: DoseStatus.pending,
            note: '',
          ));
        }
      }
    }
  }
}