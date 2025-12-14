import 'package:rkpm_5/core/models/medicine_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

abstract class MedsRepository {
  Future<Either<Failure, List<Medicine>>> getMeds();
  Future<Either<Failure, List<DoseEntry>>> getDoses();
  Future<Either<Failure, void>> saveMeds(List<Medicine> meds);
  Future<Either<Failure, void>> saveDoses(List<DoseEntry> doses);
  Future<Either<Failure, void>> saveMedsAndDoses(List<Medicine> meds, List<DoseEntry> doses);
}

