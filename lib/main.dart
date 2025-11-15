import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'package:rkpm_5/app_router.dart';
import 'package:rkpm_5/features/meds/domain/app_theme.dart';

// state & services
import 'package:rkpm_5/features/meds/domain/meds_state.dart';
import 'package:rkpm_5/features/meds/domain/meds_repository.dart';
import 'package:rkpm_5/features/meds/domain/dose_scheduler.dart';
import 'package:rkpm_5/features/meds/domain/auth_service.dart';
import 'package:rkpm_5/features/meds/domain/image_service.dart';
import 'package:rkpm_5/core/app_dependencies.dart';

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