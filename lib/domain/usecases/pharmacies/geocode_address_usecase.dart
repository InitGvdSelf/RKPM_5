import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';
import 'package:rkpm_5/data/datasources/remote/dadata/dadata_datasource.dart';

class GeocodeAddressUseCase {
  final DadataDataSource datasource;

  GeocodeAddressUseCase(this.datasource);

  Future<Either<Failure, (double lat, double lon, String formatted)>> call(
    String address,
  ) async {
    try {
      final result = await datasource.geocode(address);
      return Either.right(result);
    } catch (e) {
      return Either.left(NetworkFailure(e.toString()));
    }
  }
}

