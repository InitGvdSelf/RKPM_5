import 'package:rkpm_5/domain/repositories/meds_repository.dart';
import 'package:rkpm_5/core/models/medicine_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

class UpsertMedUseCase {
  final MedsRepository repository;

  UpsertMedUseCase(this.repository);

  Future<Either<Failure, void>> call(Medicine medicine) async {
    final medsResult = await repository.getMeds();
    return medsResult.fold(
      (failure) => Either.left(failure),
      (meds) async {
        final index = meds.indexWhere((m) => m.id == medicine.id);
        if (index >= 0) {
          meds[index] = medicine;
        } else {
          meds.add(medicine);
        }
        return repository.saveMeds(meds);
      },
    );
  }
}

