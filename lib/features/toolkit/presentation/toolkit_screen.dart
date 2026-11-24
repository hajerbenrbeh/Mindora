import 'package:flutter/material.dart';

import '../../../core/design_system.dart';

/// Placeholder screen for the Toolkit destination (Milestone 2).
class ToolkitScreen extends StatelessWidget {
  const ToolkitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Toolkit')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: MindoraDimensions.maxReadableWidth,
            ),
            child: ListView(
              padding: MindoraSpacing.pagePadding,
              children: [
                const MindoraSectionHeading(
                  title: 'Supportive Tools',
                  subtitle:
                      'Practical grounding, breathing, and reflection '
                      'activities available offline.',
                ),
                const SizedBox(height: MindoraSpacing.lg),
                MindoraSurface(
                  tone: MindoraSurfaceTone.secondary,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const MindoraIconBadge(
                        icon: Icons.self_improvement_outlined,
                      ),
                      const SizedBox(height: MindoraSpacing.md),
                      Text(
                        'Practical wellbeing space',
                        style: textTheme.titleMedium,
                      ),
                      const SizedBox(height: MindoraSpacing.xs),
                      Text(
                        'Placeholder for Milestone 2. Interactive grounding '
                        'and regulation exercises will be introduced in a '
                        'later milestone.',
                        style: textTheme.bodyMedium,
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
