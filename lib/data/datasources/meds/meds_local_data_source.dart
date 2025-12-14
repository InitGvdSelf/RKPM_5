import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rkpm_5/data/datasources/meds/dto/medicine_dto.dart';
import 'package:rkpm_5/data/datasources/meds/dto/dose_dto.dart';

class MedsLocalDataSource {
  static const _kMeds = 'meds';
  static const _kDoses = 'doses';

  Future<List<MedicineDto>> getMeds() async {
    final sp = await SharedPreferences.getInstance();
    final m = sp.getString(_kMeds);
    if (m == null) return [];
    return (jsonDecode(m) as List)
        .map((e) => MedicineDto.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  Future<List<DoseDto>> getDoses() async {
    final sp = await SharedPreferences.getInstance();
    final d = sp.getString(_kDoses);
    if (d == null) return [];
    return (jsonDecode(d) as List)
        .map((e) => DoseDto.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  Future<void> saveMeds(List<MedicineDto> meds) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kMeds, jsonEncode(meds.map((e) => e.toJson()).toList()));
  }

  Future<void> saveDoses(List<DoseDto> doses) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kDoses, jsonEncode(doses.map((e) => e.toJson()).toList()));
  }

  Future<void> saveMedsAndDoses(List<MedicineDto> meds, List<DoseDto> doses) async {
    final sp = await SharedPreferences.getInstance();
    await Future.wait([
      sp.setString(_kMeds, jsonEncode(meds.map((e) => e.toJson()).toList())),
      sp.setString(_kDoses, jsonEncode(doses.map((e) => e.toJson()).toList())),
    ]);
  }
}

