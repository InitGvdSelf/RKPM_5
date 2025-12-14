import 'package:rkpm_5/domain/repositories/pharmacies_repository.dart';
import 'package:rkpm_5/core/models/pharmacy_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

class GetPharmaciesUseCase {
  final PharmaciesRepository repository;

  GetPharmaciesUseCase(this.repository);

  Future<Either<Failure, List<Pharmacy>>> call() {
    return repository.getPharmacies();
  }
}

