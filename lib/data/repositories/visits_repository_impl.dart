import 'package:rkpm_5/domain/repositories/visits_repository.dart';
import 'package:rkpm_5/core/models/visit_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';
import 'package:rkpm_5/data/datasources/visits/visits_local_data_source.dart';
import 'package:rkpm_5/data/datasources/visits/mappers/visit_mapper.dart';

class VisitsRepositoryImpl implements VisitsRepository {
  final VisitsLocalDataSource dataSource;

  VisitsRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<Visit>>> getVisits() async {
    try {
      final dtos = await dataSource.getVisits();
      return Either.right(VisitMapper.toDomainList(dtos));
    } catch (e) {
      return Either.left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addVisit(Visit visit) async {
    try {
      final dtos = await dataSource.getVisits();
      final visits = VisitMapper.toDomainList(dtos);
      visits.add(visit);
      await dataSource.saveVisits(VisitMapper.toDtoList(visits));
      return Either.right(null);
    } catch (e) {
      return Either.left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteVisit(String id) async {
    try {
      final dtos = await dataSource.getVisits();
      final visits = VisitMapper.toDomainList(dtos);
      visits.removeWhere((v) => v.id == id);
      await dataSource.saveVisits(VisitMapper.toDtoList(visits));
      return Either.right(null);
    } catch (e) {
      return Either.left(CacheFailure(e.toString()));
    }
  }
}

