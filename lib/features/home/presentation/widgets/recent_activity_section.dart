import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system.dart';
import '../../../experiences/feelings/presentation/feelings_entry_card.dart';
import '../../../experiences/feelings/presentation/feelings_providers.dart';

/// Restrained recent-activity section displaying actual saved entries or a
/// genuine empty state when nothing has been recorded yet.
class RecentActivitySection extends ConsumerWidget {
  const RecentActivitySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(feelingsHistoryProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MindoraSectionHeading(
          title: 'Recent Reflections',
          subtitle: 'Your recorded moments will gather here over time.',
        ),
        const SizedBox(height: MindoraSpacing.md),
        historyAsync.when(
          loading: () => _buildEmptyState(),
          error: (_, _) => _buildEmptyState(),
          data: (entries) {
            if (entries.isEmpty) {
              return _buildEmptyState();
            }

            final recent = entries.take(3).toList();
            return Column(
              children: [
                for (var i = 0; i < recent.length; i++) ...[
                  FeelingsEntryCard(
                    entry: recent[i],
                    compact: true,
                    onTap: () => context.push('/experiences/feelings'),
                  ),
                  if (i < recent.length - 1)
                    const SizedBox(height: MindoraSpacing.sm),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const MindoraSurface(
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
    );
  }
}
