import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mindora/app/app.dart';
import 'package:mindora/app/shell/mindora_shell_scaffold.dart';

void main() {
  testWidgets('all five destinations render and switch screens accurately', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MindoraApp()));
    await tester.pumpAndSettle();

    for (final dest in mindoraDestinations) {
      expect(find.text(dest.label), findsWidgets);
    }

    // Initial screen is Home
    expect(find.text('A quiet space to begin'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Track records and history'));
    await tester.pumpAndSettle();
    expect(find.text('Personal Records'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Clarity patterns and insights'));
    await tester.pumpAndSettle();
    expect(find.text('Gentle Pattern Discovery'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Toolkit wellbeing tools'));
    await tester.pumpAndSettle();
    expect(find.text('Supportive Tools'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Profile and preferences'));
    await tester.pumpAndSettle();
    expect(find.text('Your Space & Control'), findsOneWidget);
  });

  testWidgets(
    'switching tabs preserves nested navigation state and back pops',
    (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MindoraApp()));
      await tester.pumpAndSettle();

      // Go to Track and push nested route
      await tester.tap(find.bySemanticsLabel('Track records and history'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Preview nested view'));
      await tester.pumpAndSettle();
      expect(find.text('Nested Route Preview'), findsOneWidget);

      // Switch to Clarity and back to Track -> nested route must be preserved
      await tester.tap(find.bySemanticsLabel('Clarity patterns and insights'));
      await tester.pumpAndSettle();
      expect(find.text('Gentle Pattern Discovery'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('Track records and history'));
      await tester.pumpAndSettle();
      expect(find.text('Nested Route Preview'), findsOneWidget);

      // Pop back to Track root
      await tester.tap(find.text('Back to Track'));
      await tester.pumpAndSettle();
      expect(find.text('Personal Records'), findsOneWidget);
    },
  );

  testWidgets(
    'bottom nav items meet touch targets, semantics, and theme switch',
    (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MindoraApp()));
      await tester.pumpAndSettle();

      final homeNode = tester.getSemantics(
        find.bySemanticsLabel('Home overview'),
      );
      expect(homeNode.flagsCollection.isSelected, Tristate.isTrue);

      final navBarSize = tester.getSize(find.byType(MindoraBottomNavBar));
      expect(navBarSize.height, greaterThanOrEqualTo(64));

      // Switch to Profile and toggle dark theme
      await tester.tap(find.bySemanticsLabel('Profile and preferences'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      final theme = Theme.of(tester.element(find.byType(MindoraBottomNavBar)));
      expect(theme.brightness, Brightness.dark);
    },
  );

  testWidgets('shell renders without overflow on small screens at 1.6x scale', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const ProviderScope(
        child: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(1.6)),
          child: MindoraApp(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    for (final dest in mindoraDestinations) {
      await tester.tap(find.bySemanticsLabel(dest.semanticHint));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });
}
