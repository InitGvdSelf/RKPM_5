import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';
import 'package:rkpm_5/data/datasources/remote/dadata/dadata_datasource.dart';

class ReverseGeocodeUseCase {
  final DadataDataSource datasource;

  ReverseGeocodeUseCase(this.datasource);

  Future<Either<Failure, String>> call(double lat, double lon) async {
    try {
      final address = await datasource.reverseGeocode(lat, lon);
      return Either.right(address);
    } catch (e) {
      return Either.left(NetworkFailure(e.toString()));
    }
  }
}

