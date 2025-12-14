import 'package:rkpm_5/domain/repositories/auth_repository.dart';
import 'package:rkpm_5/core/models/user_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';
import 'package:rkpm_5/data/datasources/auth/auth_local_data_source.dart';
import 'package:rkpm_5/data/datasources/auth/mappers/auth_session_mapper.dart';
import 'package:rkpm_5/data/datasources/auth/dto/auth_session_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, UserAccount?>> getCurrentUser() async {
    try {
      final session = await dataSource.getCurrentSession();
      if (session == null) {
        return Either.right(null);
      }
      return Either.right(AuthSessionMapper.toDomain(session));
    } catch (e) {
      return Either.left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isSignedIn() async {
    try {
      final signedIn = await dataSource.isSignedIn();
      return Either.right(signedIn);
    } catch (e) {
      return Either.left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final session = AuthSessionDto(email: email);
      await dataSource.saveSession(session);
      return Either.right(null);
    } catch (e) {
      return Either.left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final session = AuthSessionDto(email: email, name: name);
      await dataSource.saveSession(session);
      return Either.right(null);
    } catch (e) {
      return Either.left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await dataSource.clearSession();
      return Either.right(null);
    } catch (e) {
      return Either.left(CacheFailure(e.toString()));
    }
  }
}

