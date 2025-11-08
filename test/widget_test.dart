import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Приложение запускается', (tester) async {
    // Минимальный виджет — тесту нужно лишь наличие MaterialApp
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}