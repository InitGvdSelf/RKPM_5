import 'package:rkpm_5/domain/repositories/schedule_repository.dart';
import 'package:rkpm_5/core/models/medicine_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

class GetDayScheduleUseCase {
  final ScheduleRepository repository;

  GetDayScheduleUseCase(this.repository);

  Future<Either<Failure, List<DoseEntry>>> call(DateTime day) {
    return repository.getDaySchedule(day);
  }
}

