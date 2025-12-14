import 'package:rkpm_5/domain/repositories/profile_repository.dart';
import 'package:rkpm_5/core/models/profile_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, void>> call(Profile profile) {
    return repository.updateProfile(profile);
  }
}

