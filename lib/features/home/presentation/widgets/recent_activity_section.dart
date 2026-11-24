import 'package:flutter/material.dart';

import '../../../../core/design_system.dart';

/// Restrained recent-activity section with a genuine empty state.
class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MindoraSectionHeading(
          title: 'Recent Reflections',
          subtitle: 'Your recorded moments will gather here over time.',
        ),
        SizedBox(height: MindoraSpacing.md),
        MindoraSurface(
          padding: EdgeInsets.symmetric(
            horizontal: MindoraSpacing.base,
            vertical: MindoraSpacing.sm,
          ),
          child: MindoraEmptyState(
            icon: Icons.spa_outlined,
            title: 'Nothing recorded yet',
            description:
                'When you choose to save a feeling, body note, or thought, '
                'it will appear here gently.',
          ),
        ),
      ],
    );
  }
}
