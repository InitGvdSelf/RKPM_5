import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:rkpm_5/app_router.dart';
import 'package:rkpm_5/shared/app_theme.dart';
import 'package:rkpm_5/core/di.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDi();
  final appRouter = AppRouter();
  runApp(RKPMApp(router: appRouter.router));
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