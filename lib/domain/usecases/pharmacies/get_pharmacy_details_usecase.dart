import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';
import 'package:rkpm_5/data/datasources/remote/overpass/dto/overpass_response_dto.dart';
import 'package:rkpm_5/data/datasources/remote/overpass/overpass_datasource.dart';

class GetPharmacyDetailsUseCase {
  final OverpassDataSource datasource;

  GetPharmacyDetailsUseCase(this.datasource);

  Future<Either<Failure, OverpassElementDto?>> call(
    String osmType,
    String osmId,
  ) async {
    try {
      final element = await datasource.pharmacyDetails(osmType, osmId);
      return Either.right(element);
    } catch (e) {
      return Either.left(const NetworkFailure(
        'Не удалось получить детали аптеки. Повторите позже.',
      ));
    }
  }
}

