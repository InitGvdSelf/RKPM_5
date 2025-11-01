import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'package:rkpm_5/features/meds/models/medicine.dart';
import 'package:rkpm_5/features/meds/state/meds_repository.dart';
import 'package:rkpm_5/features/meds/state/dose_scheduler.dart';

class MedsState extends ChangeNotifier {
  final MedsRepository repository;
  final DoseScheduler scheduler;

  MedsState({
    required this.repository,
    required this.scheduler,
  });

  bool _loaded = false;
  bool get loaded => _loaded;

  List<Medicine> medicines = [];
  List<DoseEntry> doses = [];

  Future<void> init() async {
    medicines = await repository.loadMeds();
    doses     = await repository.loadDoses();
    scheduler.ensureFutureDoses(medicines, doses);
    _loaded = true;
    notifyListeners();
  }

  Future<void> _persist() async {
    await repository.save(medicines, doses);
    notifyListeners();
  }

  // ---- CRUD по лекарствам ----
  void addMedicine(Medicine m) {
    medicines.add(m);
    scheduler.ensureFutureDoses(medicines, doses);
    _persist();
  }

  void updateMedicine(Medicine m) {
    final i = medicines.indexWhere((e) => e.id == m.id);
    if (i >= 0) {
      medicines[i] = m;
      // Пересобираем будущие дозы для этого лекарства
      doses.removeWhere((e) =>
      e.medicineId == m.id &&
          e.plannedAt.isAfter(DateTime.now()) &&
          e.status == DoseStatus.pending);
      scheduler.ensureFutureDoses(medicines, doses);
      _persist();
    }
  }

  Medicine? deleteMedicine(String id) {
    final i = medicines.indexWhere((e) => e.id == id);
    if (i < 0) return null;
    final removed = medicines.removeAt(i);
    doses.removeWhere((e) => e.medicineId == id);
    _persist();
    return removed;
  }

  void restoreMedicine(Medicine m) {
    medicines.add(m);
    scheduler.ensureFutureDoses(medicines, doses);
    _persist();
  }

  // ---- Дозы ----
  void markDose(String doseId, DoseStatus status) {
    final i = doses.indexWhere((e) => e.id == doseId);
    if (i < 0) return;
    doses[i] = DoseEntry(
      id: doses[i].id,
      medicineId: doses[i].medicineId,
      plannedAt: doses[i].plannedAt,
      status: status,
      factAt: DateTime.now(),
      note: doses[i].note,
    );
    _persist();
  }

  void setDoseNote(String doseId, String note) {
    final i = doses.indexWhere((e) => e.id == doseId);
    if (i < 0) return;
    doses[i] = DoseEntry(
      id: doses[i].id,
      medicineId: doses[i].medicineId,
      plannedAt: doses[i].plannedAt,
      status: doses[i].status,
      factAt: doses[i].factAt,
      note: note,
    );
    _persist();
  }

  List<DoseEntry> dosesForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end   = start.add(const Duration(days: 1));
    return doses.where((d) => !d.plannedAt.isBefore(start) && d.plannedAt.isBefore(end)).toList();
  }

  // ---- Форматирование дат ----
  String fmtDate (DateTime d) => DateFormat('dd.MM.yyyy', 'ru').format(d);
  String fmtMonth(DateTime d) => DateFormat('LLLL yyyy', 'ru').format(d);
  String fmtTime (DateTime d) => DateFormat('HH:mm', 'ru').format(d);
  void ensureFutureDoses() {
    scheduler.ensureFutureDoses(medicines, doses);
    notifyListeners();
  }
}