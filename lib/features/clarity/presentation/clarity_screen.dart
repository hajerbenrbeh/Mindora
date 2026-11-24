import 'package:flutter/material.dart';

import '../../../core/design_system.dart';

/// Placeholder screen for the Clarity destination (Milestone 2).
class ClarityScreen extends StatelessWidget {
  const ClarityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Clarity')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: MindoraDimensions.maxReadableWidth,
            ),
            child: ListView(
              padding: MindoraSpacing.pagePadding,
              children: [
                Row(
                  children: [
                    const MindoraIconBadge(
                      icon: Icons.insights_outlined,
                      size: 44,
                    ),
                    const SizedBox(width: MindoraSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gentle Pattern Discovery',
                            style: textTheme.titleLarge,
                          ),
                          Text(
                            'Observations without conclusions',
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const MindoraDivider(),
                MindoraSurface(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Offline-first insights',
                        style: textTheme.titleMedium,
                      ),
                      const SizedBox(height: MindoraSpacing.sm),
                      Text(
                        'Placeholder for Milestone 2. Clarity will surface '
                        'transparent, local pattern observations across '
                        'wellbeing dimensions without clinical claims or '
                        'required AI.',
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
