import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'main_bloc.dart';
import 'main_screen.dart';

void main() {
  runApp(const RkpmBlocExampleApp());
}

class RkpmBlocExampleApp extends StatelessWidget {
  const RkpmBlocExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RKPM_5 – Bloc пример',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const MainScreen(),
      ),
    );
  }
}