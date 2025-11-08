// lib/core/di.dart
import 'package:get_it/get_it.dart';

import 'package:rkpm_5/features/meds/state/meds_state.dart';
import 'package:rkpm_5/features/meds/state/meds_repository.dart';
import 'package:rkpm_5/features/meds/state/dose_scheduler.dart';
import 'package:rkpm_5/features/meds/state/auth_service.dart';
import 'package:rkpm_5/features/meds/state/image_service.dart';

final GetIt getIt = GetIt.instance;

// фикс: T должен соответствовать bound 'Object'
T sl<T extends Object>({String? instanceName}) =>
    getIt.get<T>(instanceName: instanceName);

Future<void> initDi() async {
  // базовые сервисы
  getIt.registerLazySingleton<MedsRepository>(() => MedsRepository());
  getIt.registerLazySingleton<DoseScheduler>(() => DoseScheduler());
  getIt.registerLazySingleton<AuthService>(() => AuthService.instance);

  // ImageService: один и тот же инстанс под разными именами
  getIt.registerLazySingleton<ImageService>(() => ImageService.instance);
  getIt.registerLazySingleton<ImageService>(
        () => ImageService.instance,
    instanceName: 'avatars',
  );
  getIt.registerLazySingleton<ImageService>(
        () => ImageService.instance,
    instanceName: 'meds',
  );

  // состояние
  getIt.registerSingleton<MedsState>(
    MedsState(
      repository: getIt<MedsRepository>(),
      scheduler:  getIt<DoseScheduler>(),
    ),
  );

  // инициализация
  await Future.wait(<Future<void>>[
    getIt<MedsState>().init(),                         // Future<void>
    Future.sync(() => getIt<ImageService>().initialize()), // может быть void/Future
  ]);
}

Future<void> disposeDi() async {
  await getIt.reset(dispose: true);
}