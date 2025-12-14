import 'package:rkpm_5/domain/repositories/diary_repository.dart';
import 'package:rkpm_5/core/models/diary_entry_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

class AddDiaryEntryUseCase {
  final DiaryRepository repository;

  AddDiaryEntryUseCase(this.repository);

  Future<Either<Failure, void>> call(DiaryEntry entry) {
    return repository.addDiaryEntry(entry);
  }
}

