import 'package:rkpm_5/core/models/medicine_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

abstract class ScheduleRepository {
  Future<Either<Failure, List<DoseEntry>>> getDaySchedule(DateTime day);
  Future<Either<Failure, void>> markDose(String doseId, DoseStatus status);
  Future<Either<Failure, void>> setDoseNote(String doseId, String note);
}

