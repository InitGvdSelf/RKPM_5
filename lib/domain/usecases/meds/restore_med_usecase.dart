import 'package:rkpm_5/domain/repositories/meds_repository.dart';
import 'package:rkpm_5/core/models/medicine_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

class RestoreMedUseCase {
  final MedsRepository repository;

  RestoreMedUseCase(this.repository);

  Future<Either<Failure, void>> call(Medicine medicine) async {
    final medsResult = await repository.getMeds();
    return medsResult.fold(
      (failure) => Either.left(failure),
      (meds) async {
        if (!meds.any((m) => m.id == medicine.id)) {
          meds.add(medicine);
          return repository.saveMeds(meds);
        }
        return Either.right(null);
      },
    );
  }
}

