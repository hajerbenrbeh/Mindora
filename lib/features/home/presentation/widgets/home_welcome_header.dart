import 'package:flutter/material.dart';

import '../../../../core/design_system.dart';

/// Understated, welcoming introduction at the top of Home.
class HomeWelcomeHeader extends StatelessWidget {
  const HomeWelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Welcome to your space', style: textTheme.headlineMedium),
        const SizedBox(height: MindoraSpacing.xs),
        Text(
          'Take what feels helpful today. Nothing here is required or scored.',
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}
