import 'package:flutter/material.dart';

import '../../../core/design_system.dart';

/// Placeholder screen for the Home destination (Milestone 2).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: MindoraDimensions.maxReadableWidth,
            ),
            child: ListView(
              padding: MindoraSpacing.pagePadding,
              children: [
                Text('A quiet space to begin', style: textTheme.headlineMedium),
                const SizedBox(height: MindoraSpacing.sm),
                Text(
                  'Home will offer a calm overview of your wellbeing and '
                  'gentle ways to explore without pressure.',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: MindoraSpacing.lg),
                MindoraSurface(
                  tone: MindoraSurfaceTone.secondary,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const MindoraIconBadge(icon: Icons.spa_outlined),
                      const SizedBox(width: MindoraSpacing.base),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Overview Space',
                              style: textTheme.titleMedium,
                            ),
                            const SizedBox(height: MindoraSpacing.xs),
                            Text(
                              'Placeholder for Milestone 2. Your Living '
                              'Tapestry and gentle entry points will arrive '
                              'in the next milestone.',
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
