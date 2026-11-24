import 'package:flutter/material.dart';

import '../../../../core/design_system.dart';

/// Metadata for one of Mindora's four organizing wellbeing dimensions.
class WellbeingDimensionInfo {
  const WellbeingDimensionInfo({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}

const List<WellbeingDimensionInfo> mindoraDimensions = [
  WellbeingDimensionInfo(
    title: 'Mental wellbeing',
    description: 'Emotions, mood, stress, focus, and mental clarity.',
    icon: Icons.psychology_alt_outlined,
  ),
  WellbeingDimensionInfo(
    title: 'Physical wellbeing',
    description: 'Body sensations, sleep, energy, and physical tension.',
    icon: Icons.favorite_border_rounded,
  ),
  WellbeingDimensionInfo(
    title: 'Lifestyle',
    description: 'Daily routines, movement, rest, and social connection.',
    icon: Icons.wb_twilight_outlined,
  ),
  WellbeingDimensionInfo(
    title: 'Personal understanding',
    description: 'Thoughts, context, values, and personal patterns.',
    icon: Icons.auto_stories_outlined,
  ),
];

/// Balanced personal overview of Mindora's four wellbeing dimensions.
class DimensionsOverviewSection extends StatelessWidget {
  const DimensionsOverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.mindoraColors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MindoraSectionHeading(
          title: 'Four Dimensions',
          subtitle:
              'Lenses for noticing your wellbeing — explore only what feels '
              'relevant.',
        ),
        const SizedBox(height: MindoraSpacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            final useTwoColumns = constraints.maxWidth >= 520;
            final itemWidth = useTwoColumns
                ? (constraints.maxWidth - MindoraSpacing.md) / 2
                : constraints.maxWidth;

            return Wrap(
              spacing: MindoraSpacing.md,
              runSpacing: MindoraSpacing.sm,
              children: mindoraDimensions.map((dimension) {
                return SizedBox(
                  width: itemWidth,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: MindoraSpacing.base,
                      vertical: MindoraSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: colors.background,
                      borderRadius: MindoraRadii.control,
                      border: Border.all(
                        color: colors.divider,
                        width: MindoraBorders.thin,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          dimension.icon,
                          size: MindoraDimensions.iconMd,
                          color: colors.textSecondary,
                        ),
                        const SizedBox(width: MindoraSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dimension.title,
                                style: textTheme.titleMedium,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                dimension.description,
                                style: textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
