import 'package:rkpm_5/core/models/user_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserAccount?>> getCurrentUser();
  Future<Either<Failure, bool>> isSignedIn();
  Future<Either<Failure, void>> signIn({
    required String email,
    required String password,
  });
  Future<Either<Failure, void>> signUp({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failure, void>> signOut();
}

