import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pintar_bersama/main.dart';

void main() {
  testWidgets('App initialization test', (WidgetTester tester) async {
    await tester.pumpWidget(const PintarBersamaApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
