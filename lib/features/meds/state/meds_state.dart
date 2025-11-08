import 'dart:collection';
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

  // Храним как обычные списки, наружу отдаём read-only
  List<Medicine> _medicines = [];
  List<DoseEntry> _doses = [];

  UnmodifiableListView<Medicine> get medicines =>
      UnmodifiableListView(_medicines);
  UnmodifiableListView<DoseEntry> get doses =>
      UnmodifiableListView(_doses);

  Future<void> init() async {
    _medicines = await repository.loadMeds();
    _doses     = await repository.loadDoses();

    // Генерируем будущие дозы и сразу сохраняем изменения.
    final beforeLen = _doses.length;
    scheduler.ensureFutureDoses(_medicines, _doses);
    if (_doses.length != beforeLen) {
      await repository.save(_medicines, _doses);
    }

    _loaded = true;
    notifyListeners();
  }

  Future<void> _persist() async {
    await repository.save(_medicines, _doses);
    notifyListeners();
  }

  // ---- CRUD по лекарствам ----
  void addMedicine(Medicine m) {
    _medicines.add(m);
    scheduler.ensureFutureDoses(_medicines, _doses);
    _persist();
  }

  void updateMedicine(Medicine m) {
    final i = _medicines.indexWhere((e) => e.id == m.id);
    if (i >= 0) {
      _medicines[i] = m;

      // Пересобираем будущие дозы для этого лекарства
      _doses.removeWhere((e) =>
      e.medicineId == m.id &&
          e.plannedAt.isAfter(DateTime.now()) &&
          e.status == DoseStatus.pending);

      scheduler.ensureFutureDoses(_medicines, _doses);
      _persist();
    }
  }

  Medicine? deleteMedicine(String id) {
    final i = _medicines.indexWhere((e) => e.id == id);
    if (i < 0) return null;
    final removed = _medicines.removeAt(i);
    _doses.removeWhere((e) => e.medicineId == id);
    _persist();
    return removed;
  }

  void restoreMedicine(Medicine m) {
    _medicines.add(m);
    scheduler.ensureFutureDoses(_medicines, _doses);
    _persist();
  }

  // ---- Дозы ----
  void markDose(String doseId, DoseStatus status) {
    final i = _doses.indexWhere((e) => e.id == doseId);
    if (i < 0) return;
    final d = _doses[i];
    _doses[i] = DoseEntry(
      id: d.id,
      medicineId: d.medicineId,
      plannedAt: d.plannedAt,
      status: status,
      factAt: DateTime.now(),
      note: d.note,
    );
    _persist();
  }

  void setDoseNote(String doseId, String note) {
    final i = _doses.indexWhere((e) => e.id == doseId);
    if (i < 0) return;
    final d = _doses[i];
    _doses[i] = DoseEntry(
      id: d.id,
      medicineId: d.medicineId,
      plannedAt: d.plannedAt,
      status: d.status,
      factAt: d.factAt,
      note: note,
    );
    _persist();
  }

  List<DoseEntry> dosesForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end   = start.add(const Duration(days: 1));
    final list = _doses.where(
          (d) => !d.plannedAt.isBefore(start) && d.plannedAt.isBefore(end),
    ).toList()
      ..sort((a, b) => a.plannedAt.compareTo(b.plannedAt));
    return list;
  }

  // ---- Форматирование дат ----
  String fmtDate (DateTime d) => DateFormat('dd.MM.yyyy', 'ru').format(d);
  String fmtMonth(DateTime d) => DateFormat('LLLL yyyy', 'ru').format(d);
  String fmtTime (DateTime d) => DateFormat('HH:mm', 'ru').format(d);

  /// Явный ручной вызов пересборки будущих доз + сохранение.
  void ensureFutureDoses() {
    scheduler.ensureFutureDoses(_medicines, _doses);
    _persist();
  }
}