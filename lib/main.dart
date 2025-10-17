import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:rkpm_5/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru');
  runApp(const MedsApp());
}