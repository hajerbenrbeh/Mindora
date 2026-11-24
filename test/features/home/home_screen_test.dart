import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mindora/app/app.dart';
import 'package:mindora/app/router.dart';
import 'package:mindora/features/home/presentation/home_screen.dart';
import 'package:mindora/features/home/presentation/widgets/dimensions_overview.dart';
import 'package:mindora/features/home/presentation/widgets/exploration_portals.dart';
import 'package:mindora/features/home/presentation/widgets/living_tapestry.dart';

Finder _homeScrollable() => find
    .descendant(of: find.byType(HomeScreen), matching: find.byType(Scrollable))
    .first;

void main() {
  testWidgets(
    'Home renders welcome, Living Tapestry, dimensions, and empty state',
    (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MindoraApp()));
      await tester.pumpAndSettle();

      expect(find.text('Welcome to your space'), findsOneWidget);
      expect(find.byType(LivingTapestryCard), findsOneWidget);
      expect(find.text('The Living Tapestry'), findsOneWidget);

      for (final dim in mindoraDimensions) {
        final dimFinder = find.descendant(
          of: find.byType(DimensionsOverviewSection),
          matching: find.text(dim.title),
        );
        await tester.scrollUntilVisible(
          dimFinder,
          200,
          scrollable: _homeScrollable(),
        );
        expect(dimFinder, findsOneWidget);
      }

      await tester.scrollUntilVisible(
        find.text('Nothing recorded yet'),
        250,
        scrollable: _homeScrollable(),
      );
      expect(find.text('Nothing recorded yet'), findsOneWidget);
    },
  );

  testWidgets('all five independent portals navigate and return to Home', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MindoraApp()));
    await tester.pumpAndSettle();

    for (final portal in mindoraPortals) {
      final portalFinder = find.text(portal.title);
      await tester.scrollUntilVisible(
        portalFinder,
        250,
        scrollable: _homeScrollable(),
      );
      await tester.tap(portalFinder);
      await tester.pumpAndSettle();

      expect(find.text(portal.title), findsWidgets);

      if (portal.route == '/experiences/feelings') {
        await tester.pageBack();
      } else {
        expect(find.text('Return to Home'), findsOneWidget);
        await tester.tap(find.text('Return to Home'));
      }
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
    }

    // Existing 5-tab navigation continues working after portal round-trips
    await tester.tap(find.bySemanticsLabel('Track records and history'));
    await tester.pumpAndSettle();
    expect(find.text('Personal Records'), findsOneWidget);
  });

  testWidgets(
    'Home renders cleanly in dark mode and small screen at 1.6x scale',
    (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ProviderScope(
          child: Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.6)),
              child: const MindoraApp(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Switch to dark mode via themeModeProvider and verify Home renders cleanly
      final container = ProviderScope.containerOf(
        tester.element(find.byType(MindoraApp)),
      );
      container.read(themeModeProvider.notifier).setDarkMode(true);
      await tester.pumpAndSettle();

      final theme = Theme.of(tester.element(find.byType(HomeScreen)));
      expect(theme.brightness, Brightness.dark);

      // Scroll through entire Home screen under 320px + 1.6x text scale
      await tester.scrollUntilVisible(
        find.text('Nothing recorded yet'),
        200,
        scrollable: _homeScrollable(),
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Living Tapestry and portals expose clear accessibility semantics',
    (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MindoraApp()));
      await tester.pumpAndSettle();

      final tapestrySemantics = tester.getSemantics(
        find.descendant(
          of: find.byType(LivingTapestryCard),
          matching: find.byType(CustomPaint),
        ),
      );
      expect(
        tapestrySemantics.label,
        contains('The Living Tapestry: an organic visual of four connected'),
      );

      for (final portal in mindoraPortals) {
        final portalFinder = find.text(portal.title);
        await tester.scrollUntilVisible(
          portalFinder,
          250,
          scrollable: _homeScrollable(),
        );
        final semantics = tester.getSemantics(portalFinder);
        expect(semantics.label, contains(portal.title));
      }
    },
  );
}
