import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system.dart';

/// Placeholder screen for the Track destination (Milestone 2).
class TrackScreen extends StatelessWidget {
  const TrackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Track')),
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
                  title: 'Personal Records',
                  subtitle:
                      'A chronological home for your reflections, experiences, '
                      'and edits over time.',
                ),
                const MindoraDivider(),
                MindoraSurface(
                  child: MindoraEmptyState(
                    icon: Icons.edit_note_outlined,
                    title: 'Your timeline will live here',
                    description:
                        'Placeholder for Milestone 2. Independent experiences '
                        'and history views will be added in later milestones.',
                    action: MindoraSecondaryButton(
                      label: 'Preview nested view',
                      icon: Icons.arrow_forward_rounded,
                      onPressed: () => context.go('/track/detail'),
                    ),
                  ),
                ),
                const SizedBox(height: MindoraSpacing.md),
                Text(
                  'Nothing here is ever required or marked incomplete.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Minimal nested placeholder route used to verify independent branch stacks.
class TrackNestedPlaceholderScreen extends StatelessWidget {
  const TrackNestedPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Record Detail')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: MindoraDimensions.maxReadableWidth,
            ),
            child: Padding(
              padding: MindoraSpacing.pagePadding,
              child: MindoraSurface(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nested Route Preview', style: textTheme.titleMedium),
                    const SizedBox(height: MindoraSpacing.sm),
                    Text(
                      'This placeholder verifies that navigating deeper inside '
                      'Track preserves its stack when you switch tabs and '
                      'returns cleanly on Back.',
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: MindoraSpacing.lg),
                    MindoraSecondaryButton(
                      label: 'Back to Track',
                      onPressed: () => context.pop(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
