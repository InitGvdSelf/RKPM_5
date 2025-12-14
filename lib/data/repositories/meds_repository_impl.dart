import 'package:rkpm_5/domain/repositories/meds_repository.dart';
import 'package:rkpm_5/core/models/medicine_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';
import 'package:rkpm_5/data/datasources/meds/meds_local_data_source.dart';
import 'package:rkpm_5/data/datasources/meds/mappers/medicine_mapper.dart';
import 'package:rkpm_5/data/datasources/meds/mappers/dose_mapper.dart';

class MedsRepositoryImpl implements MedsRepository {
  final MedsLocalDataSource dataSource;

  MedsRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<Medicine>>> getMeds() async {
    try {
      final dtos = await dataSource.getMeds();
      return Either.right(MedicineMapper.toDomainList(dtos));
    } catch (e) {
      return Either.left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DoseEntry>>> getDoses() async {
    try {
      final dtos = await dataSource.getDoses();
      return Either.right(DoseMapper.toDomainList(dtos));
    } catch (e) {
      return Either.left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveMeds(List<Medicine> meds) async {
    try {
      final dtos = MedicineMapper.toDtoList(meds);
      await dataSource.saveMeds(dtos);
      return Either.right(null);
    } catch (e) {
      return Either.left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveDoses(List<DoseEntry> doses) async {
    try {
      final dtos = DoseMapper.toDtoList(doses);
      await dataSource.saveDoses(dtos);
      return Either.right(null);
    } catch (e) {
      return Either.left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveMedsAndDoses(
      List<Medicine> meds,
      List<DoseEntry> doses,
      ) async {
    try {
      final medDtos = MedicineMapper.toDtoList(meds);
      final doseDtos = DoseMapper.toDtoList(doses);
      await dataSource.saveMedsAndDoses(medDtos, doseDtos);
      return Either.right(null);
    } catch (e) {
      return Either.left(CacheFailure(e.toString()));
    }
  }
}

