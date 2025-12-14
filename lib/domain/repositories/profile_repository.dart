import 'package:rkpm_5/core/models/profile_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Profile?>> getProfile();
  Future<Either<Failure, void>> updateProfile(Profile profile);
}