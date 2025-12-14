import 'package:rkpm_5/domain/repositories/diary_repository.dart';
import 'package:rkpm_5/core/models/diary_entry_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

class GetDiaryUseCase {
  final DiaryRepository repository;

  GetDiaryUseCase(this.repository);

  Future<Either<Failure, List<DiaryEntry>>> call() {
    return repository.getDiary();
  }
}

