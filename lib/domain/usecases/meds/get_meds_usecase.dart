import 'package:rkpm_5/domain/repositories/meds_repository.dart';
import 'package:rkpm_5/core/models/medicine_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

class GetMedsUseCase {
  final MedsRepository repository;

  GetMedsUseCase(this.repository);

  Future<Either<Failure, List<Medicine>>> call() {
    return repository.getMeds();
  }
}

