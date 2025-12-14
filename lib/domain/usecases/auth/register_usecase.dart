import 'package:rkpm_5/domain/repositories/auth_repository.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String name,
    required String email,
    required String password,
  }) {
    return repository.signUp(name: name, email: email, password: password);
  }
}

