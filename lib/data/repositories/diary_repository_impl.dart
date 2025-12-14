import 'package:rkpm_5/domain/repositories/diary_repository.dart';
import 'package:rkpm_5/core/models/diary_entry_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';
import 'package:rkpm_5/data/datasources/diary/diary_local_data_source.dart';
import 'package:rkpm_5/data/datasources/diary/mappers/diary_entry_mapper.dart';

class DiaryRepositoryImpl implements DiaryRepository {
  final DiaryLocalDataSource dataSource;

  DiaryRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<DiaryEntry>>> getDiary() async {
    try {
      final dtos = await dataSource.getDiary();
      return Either.right(DiaryEntryMapper.toDomainList(dtos));
    } catch (e) {
      return Either.left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addDiaryEntry(DiaryEntry entry) async {
    try {
      final dtos = await dataSource.getDiary();
      final entries = DiaryEntryMapper.toDomainList(dtos);
      entries.add(entry);
      await dataSource.saveDiary(DiaryEntryMapper.toDtoList(entries));
      return Either.right(null);
    } catch (e) {
      return Either.left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDiaryEntry(String id) async {
    try {
      final dtos = await dataSource.getDiary();
      final entries = DiaryEntryMapper.toDomainList(dtos);
      entries.removeWhere((e) => e.id == id);
      await dataSource.saveDiary(DiaryEntryMapper.toDtoList(entries));
      return Either.right(null);
    } catch (e) {
      return Either.left(CacheFailure(e.toString()));
    }
  }
}

