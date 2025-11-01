import 'package:rkpm_5/features/meds/models/medicine.dart';
import 'package:rkpm_5/features/meds/data/meds_repository.dart';
import 'package:rkpm_5/features/meds/data/dose_scheduler.dart';
import 'package:intl/intl.dart';

class MedsState {
  final _repo = MedsRepository();
  final _scheduler = DoseScheduler();

  List<Medicine> medicines = [];
  List<DoseEntry> doses = [];

  Future<void> load() async {
    medicines = await _repo.loadMeds();
    doses = await _repo.loadDoses();
    _scheduler.ensureFutureDoses(medicines, doses);
  }

  Future<void> save() async => _repo.save(medicines, doses);

  void addMedicine(Medicine m) {
    medicines.add(m);
    _scheduler.ensureFutureDoses(medicines, doses);
  }

  void updateMedicine(Medicine m) {
    final i = medicines.indexWhere((e) => e.id == m.id);
    if (i >= 0) medicines[i] = m;
    _scheduler.ensureFutureDoses(medicines, doses);
  }

  Medicine? deleteMedicine(String id) {
    final i = medicines.indexWhere((e) => e.id == id);
    if (i < 0) return null;
    final removed = medicines.removeAt(i);
    doses.removeWhere((e) => e.medicineId == id);
    return removed;
  }

  void restoreMedicine(Medicine m) => medicines.add(m);

  String fmtDate(DateTime d) => DateFormat('dd.MM.yyyy', 'ru').format(d);
  String fmtMonth(DateTime d) => DateFormat('LLLL yyyy', 'ru').format(d);
  String fmtTime(DateTime d) => DateFormat('HH:mm', 'ru').format(d);
}