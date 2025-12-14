import 'package:rkpm_5/domain/repositories/visits_repository.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

class DeleteVisitUseCase {
  final VisitsRepository repository;

  DeleteVisitUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteVisit(id);
  }
}

