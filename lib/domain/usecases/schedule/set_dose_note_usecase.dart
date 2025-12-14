import 'package:rkpm_5/domain/repositories/schedule_repository.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

class SetDoseNoteUseCase {
  final ScheduleRepository repository;

  SetDoseNoteUseCase(this.repository);

  Future<Either<Failure, void>> call(String doseId, String note) {
    return repository.setDoseNote(doseId, note);
  }
}

