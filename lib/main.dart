import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'package:rkpm_5/app_router.dart';
import 'package:rkpm_5/features/meds/domain/app_theme.dart';

import 'package:rkpm_5/features/meds/domain/meds_state.dart';
import 'package:rkpm_5/features/meds/domain/meds_repository.dart';
import 'package:rkpm_5/features/meds/domain/dose_scheduler.dart';
import 'package:rkpm_5/features/meds/domain/auth_service.dart';
import 'package:rkpm_5/features/meds/domain/image_service.dart';
import 'package:rkpm_5/core/app_dependencies.dart';
import 'package:rkpm_5/core/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  final appRouter = AppRouter(medsState);

  final theme = ThemeController(); // по умолчанию светлая

  runApp(
    AppDependencies(
      state: medsState,
      auth: auth,
      images: images,
      theme: theme,
      child: RKPMApp(router: appRouter.router, theme: theme),
    ),
  );
}

class RKPMApp extends StatelessWidget {
  final GoRouter router;
  final ThemeController theme;

  const RKPMApp({super.key, required this.router, required this.theme});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: theme,
      builder: (context, _) {
        return MaterialApp.router(
          theme: buildLightTheme(),
          darkTheme: buildDarkTheme(),
          themeMode: theme.mode,

          locale: const Locale('ru'),
          supportedLocales: const [Locale('ru'), Locale('en')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: router,
        );
      },
    );
  }
}