// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'package:rkpm_5/app_router.dart';
import 'package:rkpm_5/features/meds/state/meds_state.dart';
import 'package:rkpm_5/features/meds/state/meds_repository.dart';
import 'package:rkpm_5/features/meds/state/dose_scheduler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru_RU', null);
  Intl.defaultLocale = 'ru_RU';
  runApp(const RKPMApp());
}

class RKPMApp extends StatelessWidget {
  const RKPMApp({super.key});

  @override
  Widget build(BuildContext context) {
    final medsState = MedsState(
      repository: MedsRepository(),
      scheduler: DoseScheduler(),
    );
    final appRouter = AppRouter(medsState);

    return MaterialApp.router(
      title: 'RKPM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      routerConfig: appRouter.router,
      locale: const Locale('ru', 'RU'),
      supportedLocales: const [Locale('ru', 'RU'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}