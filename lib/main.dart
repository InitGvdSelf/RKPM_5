import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:rkpm_5/features/meds/screens/login_screen.dart';

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
    return MaterialApp(
      title: 'RKPM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('ru', 'RU'), Locale('en', 'US')],
      home: const LoginScreen(),
    );
  }
}