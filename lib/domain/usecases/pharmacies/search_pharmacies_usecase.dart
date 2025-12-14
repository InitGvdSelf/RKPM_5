import 'package:rkpm_5/domain/repositories/pharmacies_repository.dart';
import 'package:rkpm_5/core/models/pharmacy_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

class SearchPharmaciesUseCase {
  final PharmaciesRepository repository;

  SearchPharmaciesUseCase(this.repository);

  Future<Either<Failure, List<Pharmacy>>> call(String query) {
    return repository.searchPharmacies(query);
  }
}

