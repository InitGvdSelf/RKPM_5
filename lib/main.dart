import 'package:flutter/material.dart';

import 'mobx/counter_page.dart';

void main() {
  runApp(const MobxCounterApp());
}

class MobxCounterApp extends StatelessWidget {
  const MobxCounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RKPM_5 – MobX пример',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: MobxCounterPage(),
    );
  }
}