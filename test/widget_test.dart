import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mindora/app/app.dart';

void main() {
  testWidgets('MindoraApp initializes with ProviderScope and GoRouter', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MindoraApp()));
    await tester.pumpAndSettle();

    expect(find.text('Mindora'), findsOneWidget);
    expect(find.text('Foundation initialized.'), findsOneWidget);

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    final theme = Theme.of(tester.element(find.byType(Scaffold)));
    expect(
      scaffold.backgroundColor ?? theme.scaffoldBackgroundColor,
      const Color(0xFFF7EFE3),
    );
  });
}
