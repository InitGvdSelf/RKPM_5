import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:rkpm_5/app/theme/app_theme.dart';
import 'package:rkpm_5/core/theme_controller.dart';

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

