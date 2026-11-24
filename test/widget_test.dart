import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mindora/app/app.dart';
import 'package:mindora/app/shell/mindora_shell_scaffold.dart';

void main() {
  testWidgets('MindoraApp initializes with 5-tab shell on Home', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MindoraApp()));
    await tester.pumpAndSettle();

    expect(find.byType(MindoraBottomNavBar), findsOneWidget);
    expect(find.text('Welcome to your space'), findsOneWidget);

    final lightTheme = Theme.of(tester.element(find.byType(Scaffold).first));
    expect(lightTheme.brightness, Brightness.light);
  });
}
