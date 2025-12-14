import 'package:rkpm_5/domain/repositories/auth_repository.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String email,
    required String password,
  }) {
    return repository.signIn(email: email, password: password);
  }
}

