import 'package:rkpm_5/domain/repositories/schedule_repository.dart';
import 'package:rkpm_5/core/models/medicine_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';
import 'package:rkpm_5/data/datasources/meds/meds_local_data_source.dart';
import 'package:rkpm_5/data/datasources/meds/mappers/dose_mapper.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final MedsLocalDataSource dataSource;

  ScheduleRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<DoseEntry>>> getDaySchedule(DateTime day) async {
    try {
      final doseDtos = await dataSource.getDoses();
      final doses = DoseMapper.toDomainList(doseDtos);
      
      final start = DateTime(day.year, day.month, day.day);
      final end = start.add(const Duration(days: 1));
      
      final dayDoses = doses.where((d) {
        return !d.plannedAt.isBefore(start) && d.plannedAt.isBefore(end);
      }).toList()
        ..sort((a, b) => a.plannedAt.compareTo(b.plannedAt));
      
      return Either.right(dayDoses);
    } catch (e) {
      return Either.left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markDose(String doseId, DoseStatus status) async {
    try {
      final doseDtos = await dataSource.getDoses();
      final doses = DoseMapper.toDomainList(doseDtos);
      
      final index = doses.indexWhere((d) => d.id == doseId);
      if (index < 0) {
        return Either.left(CacheFailure('Dose not found'));
      }
      
      final d = doses[index];
      doses[index] = DoseEntry(
        id: d.id,
        medicineId: d.medicineId,
        plannedAt: d.plannedAt,
        status: status,
        factAt: DateTime.now(),
        note: d.note,
      );
      
      await dataSource.saveDoses(DoseMapper.toDtoList(doses));
      return Either.right(null);
    } catch (e) {
      return Either.left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setDoseNote(String doseId, String note) async {
    try {
      final doseDtos = await dataSource.getDoses();
      final doses = DoseMapper.toDomainList(doseDtos);
      
      final index = doses.indexWhere((d) => d.id == doseId);
      if (index < 0) {
        return Either.left(CacheFailure('Dose not found'));
      }
      
      final d = doses[index];
      doses[index] = DoseEntry(
        id: d.id,
        medicineId: d.medicineId,
        plannedAt: d.plannedAt,
        status: d.status,
        factAt: d.factAt,
        note: note,
      );
      
      await dataSource.saveDoses(DoseMapper.toDtoList(doses));
      return Either.right(null);
    } catch (e) {
      return Either.left(CacheFailure(e.toString()));
    }
  }
}

