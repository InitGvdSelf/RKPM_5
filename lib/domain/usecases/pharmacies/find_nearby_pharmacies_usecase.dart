import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/models/pharmacy_model.dart';
import 'package:rkpm_5/core/utils/either.dart';
import 'package:rkpm_5/data/datasources/remote/overpass/mappers/overpass_pharmacy_mapper.dart';
import 'package:rkpm_5/data/datasources/remote/overpass/overpass_datasource.dart';

class FindNearbyPharmaciesUseCase {
  final OverpassDataSource datasource;

  FindNearbyPharmaciesUseCase(this.datasource);

  Future<Either<Failure, List<Pharmacy>>> call(
    double lat,
    double lon,
    int radiusMeters,
  ) async {
    try {
      final elements = await datasource.pharmaciesNearby(lat, lon, radiusMeters);
      final pharmacies = OverpassPharmacyMapper.toDomainList(elements);
      return Either.right(pharmacies);
    } catch (e) {
      return Either.left(const NetworkFailure(
        'Не удалось получить аптеки рядом. Повторите позже.',
      ));
    }
  }
}

