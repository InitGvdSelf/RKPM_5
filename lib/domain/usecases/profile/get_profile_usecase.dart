import 'package:rkpm_5/domain/repositories/profile_repository.dart';
import 'package:rkpm_5/core/models/profile_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<Either<Failure, Profile?>> call() {
    return repository.getProfile();
  }
}

