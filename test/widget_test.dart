import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mindora/app/app.dart';

void main() {
  testWidgets('MindoraApp renders showcase and toggles light/dark theme', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MindoraApp()));
    await tester.pumpAndSettle();

    expect(find.text('Mindora Design System'), findsOneWidget);
    expect(find.text('Color Palette'), findsOneWidget);
    expect(find.text('Typography Hierarchy'), findsOneWidget);

    final lightTheme = Theme.of(tester.element(find.byType(Scaffold)));
    expect(lightTheme.brightness, Brightness.light);

    await tester.tap(find.byIcon(Icons.dark_mode_outlined));
    await tester.pumpAndSettle();

    final darkTheme = Theme.of(tester.element(find.byType(Scaffold)));
    expect(darkTheme.brightness, Brightness.dark);
    expect(tester.takeException(), isNull);
  });
}
