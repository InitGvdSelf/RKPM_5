import 'package:rkpm_5/features/meds/models/medicine.dart';

/// Простейшее in-memory хранилище лекарств и доз.
/// В норме — тут могла бы быть работа с БД или файлом.
class MedsRepository {
  final List<Medicine> _meds = [];
  final List<DoseEntry> _doses = [];

  Future<List<Medicine>> loadMeds() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.of(_meds);
  }

  Future<List<DoseEntry>> loadDoses() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.of(_doses);
  }

  Future<void> save(List<Medicine> meds, List<DoseEntry> doses) async {
    _meds
      ..clear()
      ..addAll(meds);
    _doses
      ..clear()
      ..addAll(doses);
    await Future.delayed(const Duration(milliseconds: 100));
  }
}