import 'package:rkpm_5/core/models/visit_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

abstract class VisitsRepository {
  Future<Either<Failure, List<Visit>>> getVisits();
  Future<Either<Failure, void>> addVisit(Visit visit);
  Future<Either<Failure, void>> deleteVisit(String id);
}

