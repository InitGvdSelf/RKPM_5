import 'package:rkpm_5/domain/repositories/schedule_repository.dart';
import 'package:rkpm_5/core/models/medicine_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

class MarkDoseUseCase {
  final ScheduleRepository repository;

  MarkDoseUseCase(this.repository);

  Future<Either<Failure, void>> call(String doseId, DoseStatus status) {
    return repository.markDose(doseId, status);
  }
}

