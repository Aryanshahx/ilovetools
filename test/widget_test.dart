import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ilovetools/app.dart';

void main() {
  testWidgets('Home screen shows tool grid', (WidgetTester tester) async {
    await tester.pumpWidget(const ILoveToolsApp());

    expect(find.text('iLoveTools'), findsOneWidget);
  });
}
