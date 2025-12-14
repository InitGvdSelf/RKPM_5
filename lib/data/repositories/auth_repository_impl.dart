import 'package:rkpm_5/domain/repositories/auth_repository.dart';
import 'package:rkpm_5/core/models/user_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';
import 'package:rkpm_5/data/datasources/auth/auth_local_data_source.dart';
import 'package:rkpm_5/data/datasources/auth/auth_secure_data_source.dart';
import 'package:rkpm_5/data/datasources/auth/mappers/auth_session_mapper.dart';
import 'package:rkpm_5/data/datasources/auth/dto/auth_session_dto.dart';
import 'package:flutter/foundation.dart'; // debugPrint

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final AuthSecureDataSource secureDataSource;

  AuthRepositoryImpl({
    required this.localDataSource,
    required this.secureDataSource,
  });

  @override
  Future<Either<Failure, UserAccount?>> getCurrentUser() async {
    try {
      final session = await localDataSource.getCurrentSession();
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
      // Check if secure tokens exist (primary auth check)
      final hasTokens = await secureDataSource.hasTokens();
      if (hasTokens) {
        return Either.right(true);
      }
      // Fallback to local session check for backward compatibility
      final signedIn = await localDataSource.isSignedIn();
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
      // Save session info to local storage (non-sensitive)
      final session = AuthSessionDto(email: email);
      await localDataSource.saveSession(session);

      // Save tokens to secure storage (sensitive)
      // In a real app, these would come from the API response
      // For now, we generate mock tokens
      final accessToken = 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}';
      final refreshToken = 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}';
      await secureDataSource.saveTokens(
        access: accessToken,
        refresh: refreshToken,
        userId: email, // Using email as userId for now
      );
      final has = await secureDataSource.hasTokens();
      debugPrint('[SECURE] Tokens saved, hasTokens=$has');
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
      // Save session info to local storage (non-sensitive)
      final session = AuthSessionDto(email: email, name: name);
      await localDataSource.saveSession(session);

      // Save tokens to secure storage (sensitive)
      // In a real app, these would come from the API response
      final accessToken = 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}';
      final refreshToken = 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}';
      await secureDataSource.saveTokens(
        access: accessToken,
        refresh: refreshToken,
        userId: email,
      );

      return Either.right(null);
    } catch (e) {
      return Either.left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      // Clear local session (non-sensitive)
      await localDataSource.clearSession();
      // Clear secure tokens (sensitive)
      await secureDataSource.clearTokens();
      final has = await secureDataSource.hasTokens();
      debugPrint('[SECURE] Tokens cleared, hasTokens=$has');
      return Either.right(null);
    } catch (e) {
      return Either.left(CacheFailure(e.toString()));
    }
  }
}

