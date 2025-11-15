import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';

class MedsRepository {
  Future<List<Medicine>> loadMeds() async {
    final sp = await SharedPreferences.getInstance();
    final m = sp.getString('meds');
    if (m == null) return [];
    return (jsonDecode(m) as List).map((e) => Medicine.fromJson(e)).toList();
  }

  Future<List<DoseEntry>> loadDoses() async {
    final sp = await SharedPreferences.getInstance();
    final d = sp.getString('doses');
    if (d == null) return [];
    return (jsonDecode(d) as List).map((e) => DoseEntry.fromJson(e)).toList();
  }

  Future<void> save(List<Medicine> meds, List<DoseEntry> doses) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('meds', jsonEncode(meds.map((e) => e.toJson()).toList()));
    await sp.setString('doses', jsonEncode(doses.map((e) => e.toJson()).toList()));
  }
}