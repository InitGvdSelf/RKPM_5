import 'package:rkpm_5/domain/repositories/settings_repository.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

/// Use case to update dark theme setting.
class UpdateDarkThemeUseCase {
  final SettingsRepository repository;

  UpdateDarkThemeUseCase(this.repository);

  Future<Either<Failure, void>> call(bool value) {
    return repository.setDarkTheme(value);
  }
}

