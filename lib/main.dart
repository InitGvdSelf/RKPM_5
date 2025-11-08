import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'package:rkpm_5/app_router.dart';
import 'package:rkpm_5/shared/app_theme.dart';

// state & services
import 'package:rkpm_5/features/meds/state/meds_state.dart';
import 'package:rkpm_5/features/meds/state/meds_repository.dart';
import 'package:rkpm_5/features/meds/state/dose_scheduler.dart';
import 'package:rkpm_5/features/meds/state/auth_service.dart';
import 'package:rkpm_5/features/meds/state/image_service.dart';
import 'package:rkpm_5/core/app_dependencies.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Глобальные сервисы/состояние
  final medsState = MedsState(
    repository: MedsRepository(),
    scheduler: DoseScheduler(),
  );

  final auth = AuthService.instance;
  final images = ImageService.instance;

  await Future.wait([
    medsState.init(),
    AuthService.instance.restore(),
    ImageService.instance.initialize(),
  ]);

  // Роутер на общем состоянии
  final appRouter = AppRouter(medsState);

  runApp(
    AppDependencies(
      state: medsState,
      auth: auth,
      images: images,
      child: RKPMApp(
        router: appRouter.router,
      ),
    ),
  );
}

class RKPMApp extends StatelessWidget {
  final GoRouter router;
  const RKPMApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: buildAppTheme(),
      locale: const Locale('ru'),
      supportedLocales: const [Locale('ru'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
    );
  }
}