import 'package:rkpm_5/domain/repositories/settings_repository.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

/// Use case to get all app settings.
class GetSettingsUseCase {
  final SettingsRepository repository;

  GetSettingsUseCase(this.repository);

  Future<({Either<Failure, bool> darkTheme, Either<Failure, bool> notificationsEnabled})> call() async {
    final darkTheme = await repository.getDarkTheme();
    final notificationsEnabled = await repository.getNotificationsEnabled();
    return (
      darkTheme: darkTheme,
      notificationsEnabled: notificationsEnabled,
    );
  }
}

