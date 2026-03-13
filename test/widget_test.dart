import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:marcelly_franca_personal/main.dart';

void main() {
  testWidgets('App starts without crash', (WidgetTester tester) async {
    await tester.pumpWidget(const MarcellyApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
