import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

/// Repository interface for app settings.
abstract class SettingsRepository {
  Future<Either<Failure, bool>> getDarkTheme();
  Future<Either<Failure, void>> setDarkTheme(bool value);
  Future<Either<Failure, bool>> getNotificationsEnabled();
  Future<Either<Failure, void>> setNotificationsEnabled(bool value);
}

