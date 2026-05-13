import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:our_story/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const OurStoryApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
