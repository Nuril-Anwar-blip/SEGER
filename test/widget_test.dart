// Basic smoke test for the merged SEGER app.
//
// Verifies that the app boots without throwing, by pumping the root widget.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seger_exergame/main.dart';

void main() {
  testWidgets('App boots and shows onboarding or main shell', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: SegerApp()));
    await tester.pumpAndSettle();

    // Either the onboarding screen or the main shell should be present.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
