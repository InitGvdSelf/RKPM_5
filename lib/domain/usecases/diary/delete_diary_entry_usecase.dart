import 'package:rkpm_5/domain/repositories/diary_repository.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

class DeleteDiaryEntryUseCase {
  final DiaryRepository repository;

  DeleteDiaryEntryUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteDiaryEntry(id);
  }
}

