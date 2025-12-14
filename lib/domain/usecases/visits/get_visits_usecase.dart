import 'package:rkpm_5/domain/repositories/visits_repository.dart';
import 'package:rkpm_5/core/models/visit_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

class GetVisitsUseCase {
  final VisitsRepository repository;

  GetVisitsUseCase(this.repository);

  Future<Either<Failure, List<Visit>>> call() {
    return repository.getVisits();
  }
}

