import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';
import 'package:rkpm_5/features/meds/screens/home_screen.dart';

class MedsContainer extends StatefulWidget {
  const MedsContainer({super.key});
  @override
  MedsContainerState createState() => MedsContainerState();
}

class MedsContainerState extends State<MedsContainer> {
  final _uuid = const Uuid();
  bool loaded = false;
  List<Medicine> medicines = [];
  List<DoseEntry> doses = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final sp = await SharedPreferences.getInstance();
    final m = sp.getString('meds');
    final d = sp.getString('doses');
    if (m != null) medicines = (jsonDecode(m) as List).map((e) => Medicine.fromJson(e)).toList();
    if (d != null) doses = (jsonDecode(d) as List).map((e) => DoseEntry.fromJson(e)).toList();
    _ensureFutureDoses();
    setState(() => loaded = true);
  }

  Future<void> _save() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('meds', jsonEncode(medicines.map((e) => e.toJson()).toList()));
    await sp.setString('doses', jsonEncode(doses.map((e) => e.toJson()).toList()));
  }

  void _ensureFutureDoses() {
    final now = DateTime.now();
    final startDay = DateTime(now.year, now.month, now.day);
    final horizon = startDay.add(const Duration(days: 29));
    final existing = <String>{for (var d in doses) _doseKey(d.medicineId, d.plannedAt)};
    for (final med in medicines) {
      if (!med.schedule.active) continue;
      if (med.schedule.mode == ScheduleMode.weekly) {
        DateTime day = startDay;
        while (!day.isAfter(horizon)) {
          if (med.schedule.daysOfWeek.contains(day.weekday)) {
            for (final t in med.schedule.times) {
              final planned = DateTime(day.year, day.month, day.day, t.hour, t.minute);
              final key = _doseKey(med.id, planned);
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
      } else {
        for (final date in med.schedule.dates) {
          for (final t in med.schedule.times) {
            final d = DateTime(date.year, date.month, date.day, t.hour, t.minute);
            if (d.isBefore(startDay) || d.isAfter(horizon)) continue;
            final key = _doseKey(med.id, d);
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
    doses.sort((a, b) => a.plannedAt.compareTo(b.plannedAt));
  }

  String _doseKey(String medId, DateTime dt) => '$medId@${dt.toIso8601String()}';

  void addMedicine(Medicine m) {
    medicines.add(m);
    _ensureFutureDoses();
    _save();
    setState(() {});
  }

  void updateMedicine(Medicine m) {
    final i = medicines.indexWhere((e) => e.id == m.id);
    if (i >= 0) medicines[i] = m;
    doses.removeWhere((e) => e.medicineId == m.id && e.plannedAt.isAfter(DateTime.now()) && e.status == DoseStatus.pending);
    _ensureFutureDoses();
    _save();
    setState(() {});
  }

  Medicine? deleteMedicine(String id) {
    final i = medicines.indexWhere((e) => e.id == id);
    if (i < 0) return null;
    final removed = medicines.removeAt(i);
    doses.removeWhere((e) => e.medicineId == id);
    _save();
    setState(() {});
    return removed;
  }

  void restoreMedicine(Medicine m) {
    medicines.add(m);
    _ensureFutureDoses();
    _save();
    setState(() {});
  }

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
    _save();
    setState(() {});
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
    _save();
    setState(() {});
  }

  List<DoseEntry> dosesForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return doses.where((d) => !d.plannedAt.isBefore(start) && d.plannedAt.isBefore(end)).toList();
  }

  Map<String, int> stats() {
    final totalMeds = medicines.length;
    final totalDoses = doses.length;
    final taken = doses.where((e) => e.status == DoseStatus.taken).length;
    final skipped = doses.where((e) => e.status == DoseStatus.skipped).length;
    final pending = doses.where((e) => e.status == DoseStatus.pending).length;
    return {'meds': totalMeds, 'doses': totalDoses, 'taken': taken, 'skipped': skipped, 'pending': pending};
  }

  String fmtDate(DateTime d) => DateFormat('dd.MM.yyyy', 'ru').format(d);
  String fmtMonth(DateTime d) => DateFormat('LLLL yyyy', 'ru').format(d);
  String fmtTime(DateTime d) => DateFormat('HH:mm', 'ru').format(d);

  @override
  Widget build(BuildContext context) {
    if (!loaded) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return HomeScreen(
      medicines: medicines,
      doses: doses,
      dosesForDay: dosesForDay,
      onAddMedicine: addMedicine,
      onUpdateMedicine: updateMedicine,
      onDeleteMedicine: deleteMedicine,
      onRestoreMedicine: restoreMedicine,
      onMarkDose: markDose,
      onSetDoseNote: setDoseNote,
      fmtDate: fmtDate,
      fmtMonth: fmtMonth,
      fmtTime: fmtTime,
    );
  }
}