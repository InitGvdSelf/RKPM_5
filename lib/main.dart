import 'package:flutter/material.dart';
import 'package:rkpm_5/dependency_container.dart';
import 'package:rkpm_5/weather_screen.dart';

void main() {
  runApp(const Pr13RetrofitDemoApp());
}

class Pr13RetrofitDemoApp extends StatelessWidget {
  const Pr13RetrofitDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final di = Pr13DependencyContainer();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PR13 Retrofit Demo',
      home: WeatherScreen(di: di),
    );
  }
}
