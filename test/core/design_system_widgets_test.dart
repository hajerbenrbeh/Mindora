import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mindora/core/design_system.dart';

Widget _wrapWithTheme(
  Widget child, {
  ThemeData? theme,
  double textScale = 1.0,
}) {
  return MaterialApp(
    theme: theme ?? MindoraTheme.light(),
    home: MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
      child: Scaffold(body: SingleChildScrollView(child: child)),
    ),
  );
}

void main() {
  testWidgets('buttons meet minimum touch target and trigger callbacks', (
    tester,
  ) async {
    var primaryTapped = false;
    var secondaryTapped = false;
    var textTapped = false;

    await tester.pumpWidget(
      _wrapWithTheme(
        Column(
          children: [
            MindoraPrimaryButton(
              label: 'Save',
              onPressed: () => primaryTapped = true,
            ),
            MindoraSecondaryButton(
              label: 'Cancel',
              onPressed: () => secondaryTapped = true,
            ),
            MindoraTextButton(
              label: 'Skip',
              onPressed: () => textTapped = true,
            ),
          ],
        ),
      ),
    );

    expect(
      tester.getSize(find.byType(MindoraPrimaryButton)).height,
      greaterThanOrEqualTo(48),
    );
    expect(
      tester.getSize(find.byType(MindoraSecondaryButton)).height,
      greaterThanOrEqualTo(48),
    );

    await tester.tap(find.text('Save'));
    await tester.tap(find.text('Cancel'));
    await tester.tap(find.text('Skip'));
    await tester.pump();

    expect(primaryTapped, isTrue);
    expect(secondaryTapped, isTrue);
    expect(textTapped, isTrue);
  });

  testWidgets('selectable chip exposes semantic selection state and toggles', (
    tester,
  ) async {
    var selected = false;

    await tester.pumpWidget(
      _wrapWithTheme(
        StatefulBuilder(
          builder: (context, setState) {
            return MindoraSelectableChip(
              label: 'Grounded',
              selected: selected,
              onSelected: (next) => setState(() => selected = next),
            );
          },
        ),
      ),
    );

    expect(
      tester.getSize(find.byType(MindoraSelectableChip)).height,
      greaterThanOrEqualTo(48),
    );
    await tester.tap(find.text('Grounded'));
    await tester.pump();

    expect(selected, isTrue);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
  });

  testWidgets('components render without overflow under 1.8x text scaling', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrapWithTheme(
        theme: MindoraTheme.dark(),
        textScale: 1.8,
        Padding(
          padding: MindoraSpacing.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MindoraSectionHeading(
                title: 'Longer Section Title',
                subtitle: 'Supporting calm description text',
              ),
              const SizedBox(height: MindoraSpacing.md),
              const MindoraTextField(
                label: 'Reflection',
                hintText: 'Write freely',
              ),
              const SizedBox(height: MindoraSpacing.md),
              MindoraPrimaryButton(
                label: 'Continue gently',
                icon: Icons.arrow_forward_rounded,
                isExpanded: true,
                onPressed: () {},
              ),
              const MindoraEmptyState(
                title: 'Nothing here yet',
                description: 'Come back whenever you feel ready.',
              ),
              const MindoraLoadingIndicator(message: 'Loading...'),
            ],
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
