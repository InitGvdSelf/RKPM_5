import 'package:rkpm_5/domain/repositories/meds_repository.dart';
import 'package:rkpm_5/core/models/medicine_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

class DeleteMedUseCase {
  final MedsRepository repository;

  DeleteMedUseCase(this.repository);

  Future<Either<Failure, Medicine?>> call(String id) async {
    final medsResult = await repository.getMeds();
    return medsResult.fold(
      (failure) => Either.left(failure),
      (meds) async {
        final index = meds.indexWhere((m) => m.id == id);
        if (index < 0) {
          return Either.right(null);
        }
        final removed = meds.removeAt(index);
        final saveResult = await repository.saveMeds(meds);
        return saveResult.fold(
          (failure) => Either.left(failure),
          (_) => Either.right(removed),
        );
      },
    );
  }
}

