import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rkpm_5/main.dart';

void main() {
  testWidgets('Приложение запускается', (tester) async {
    await tester.pumpWidget(const RKPMApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
