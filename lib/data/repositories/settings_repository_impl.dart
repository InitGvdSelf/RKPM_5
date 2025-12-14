import 'package:rkpm_5/domain/repositories/settings_repository.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';
import 'package:rkpm_5/data/datasources/settings/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource dataSource;

  SettingsRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, bool>> getDarkTheme() async {
    try {
      final value = await dataSource.getDarkTheme();
      return Either.right(value);
    } catch (e) {
      return Either.left(CacheFailure('Failed to get dark theme: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> setDarkTheme(bool value) async {
    try {
      await dataSource.setDarkTheme(value);
      return Either.right(null);
    } catch (e) {
      return Either.left(CacheFailure('Failed to set dark theme: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> getNotificationsEnabled() async {
    try {
      final value = await dataSource.getNotificationsEnabled();
      return Either.right(value);
    } catch (e) {
      return Either.left(CacheFailure('Failed to get notifications: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> setNotificationsEnabled(bool value) async {
    try {
      await dataSource.setNotificationsEnabled(value);
      return Either.right(null);
    } catch (e) {
      return Either.left(CacheFailure('Failed to set notifications: ${e.toString()}'));
    }
  }
}

