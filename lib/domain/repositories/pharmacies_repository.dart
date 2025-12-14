import 'package:rkpm_5/core/models/pharmacy_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

abstract class PharmaciesRepository {
  Future<Either<Failure, List<Pharmacy>>> getPharmacies();
  Future<Either<Failure, List<Pharmacy>>> searchPharmacies(String query);
}

