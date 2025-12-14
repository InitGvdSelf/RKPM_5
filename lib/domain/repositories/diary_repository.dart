import 'package:rkpm_5/core/models/diary_entry_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

abstract class DiaryRepository {
  Future<Either<Failure, List<DiaryEntry>>> getDiary();
  Future<Either<Failure, void>> addDiaryEntry(DiaryEntry entry);
  Future<Either<Failure, void>> deleteDiaryEntry(String id);
}

