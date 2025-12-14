import 'package:rkpm_5/domain/repositories/visits_repository.dart';
import 'package:rkpm_5/core/models/visit_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

class AddVisitUseCase {
  final VisitsRepository repository;

  AddVisitUseCase(this.repository);

  Future<Either<Failure, void>> call(Visit visit) {
    return repository.addVisit(visit);
  }
}

