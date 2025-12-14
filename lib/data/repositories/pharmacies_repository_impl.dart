import 'package:rkpm_5/domain/repositories/pharmacies_repository.dart';
import 'package:rkpm_5/core/models/pharmacy_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';
import 'package:rkpm_5/data/datasources/pharmacies/pharmacies_local_data_source.dart';
import 'package:rkpm_5/data/datasources/pharmacies/mappers/pharmacy_mapper.dart';

class PharmaciesRepositoryImpl implements PharmaciesRepository {
  final PharmaciesLocalDataSource dataSource;

  PharmaciesRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<Pharmacy>>> getPharmacies() async {
    try {
      final dtos = await dataSource.getPharmacies();
      return Either.right(PharmacyMapper.toDomainList(dtos));
    } catch (e) {
      return Either.left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Pharmacy>>> searchPharmacies(String query) async {
    try {
      final dtos = await dataSource.searchPharmacies(query);
      return Either.right(PharmacyMapper.toDomainList(dtos));
    } catch (e) {
      return Either.left(CacheFailure(e.toString()));
    }
  }
}

