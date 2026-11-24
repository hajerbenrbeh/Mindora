import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system.dart';

/// Metadata for one of Mindora's five independent exploration portals.
class ExplorationPortalInfo {
  const ExplorationPortalInfo({
    required this.title,
    required this.description,
    required this.route,
    required this.icon,
  });

  final String title;
  final String description;
  final String route;
  final IconData icon;
}

const List<ExplorationPortalInfo> mindoraPortals = [
  ExplorationPortalInfo(
    title: 'Feelings',
    description: 'Explore and record emotions in your own words.',
    route: '/experiences/feelings',
    icon: Icons.water_drop_outlined,
  ),
  ExplorationPortalInfo(
    title: 'My State',
    description: 'Notice mood, energy, anxiety, stress, focus, or clarity.',
    route: '/experiences/my-state',
    icon: Icons.tune_rounded,
  ),
  ExplorationPortalInfo(
    title: 'My Body',
    description: 'Check in with physical sensations, sleep, or tension.',
    route: '/experiences/my-body',
    icon: Icons.accessibility_new_rounded,
  ),
  ExplorationPortalInfo(
    title: 'What Shaped Today',
    description: 'Note events, routines, relationships, or surroundings.',
    route: '/experiences/what-shaped-today',
    icon: Icons.eco_outlined,
  ),
  ExplorationPortalInfo(
    title: 'My Thoughts',
    description: 'A quiet, private space for free writing and reflection.',
    route: '/experiences/my-thoughts',
    icon: Icons.menu_book_outlined,
  ),
];

/// Five independent, non-sequential exploration portals on Home.
class ExplorationPortalsSection extends StatelessWidget {
  const ExplorationPortalsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final feelings = mindoraPortals[0];
    final myState = mindoraPortals[1];
    final myBody = mindoraPortals[2];
    final shapedToday = mindoraPortals[3];
    final myThoughts = mindoraPortals[4];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MindoraSectionHeading(
          title: 'Explore at Your Own Pace',
          subtitle:
              'Five independent spaces. Open any one whenever it feels right.',
        ),
        const SizedBox(height: MindoraSpacing.md),

        // 1. Featured emotional portal (secondary sage surface)
        _PortalRowCard(portal: feelings, tone: MindoraSurfaceTone.secondary),
        const SizedBox(height: MindoraSpacing.sm),

        // 2 & 3. Paired compact portals on wider layouts, stacked on small phones
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 420) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _PortalCompactCard(portal: myState)),
                  const SizedBox(width: MindoraSpacing.sm),
                  Expanded(child: _PortalCompactCard(portal: myBody)),
                ],
              );
            }
            return Column(
              children: [
                _PortalRowCard(portal: myState),
                const SizedBox(height: MindoraSpacing.sm),
                _PortalRowCard(portal: myBody),
              ],
            );
          },
        ),
        const SizedBox(height: MindoraSpacing.sm),

        // 4. Context portal
        _PortalRowCard(portal: shapedToday),
        const SizedBox(height: MindoraSpacing.sm),

        // 5. Private writing sanctuary — distinct open editorial treatment
        _MyThoughtsSanctuaryCard(portal: myThoughts),
      ],
    );
  }
}

class _PortalRowCard extends StatelessWidget {
  const _PortalRowCard({
    required this.portal,
    this.tone = MindoraSurfaceTone.primary,
  });

  final ExplorationPortalInfo portal;
  final MindoraSurfaceTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = context.mindoraColors;
    final textTheme = Theme.of(context).textTheme;

    return MindoraSurface(
      tone: tone,
      padding: const EdgeInsets.all(MindoraSpacing.base),
      semanticLabel: '${portal.title}. ${portal.description}',
      onTap: () => context.push(portal.route),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: MindoraDimensions.minTouchTarget,
        ),
        child: Row(
          children: [
            MindoraIconBadge(icon: portal.icon),
            const SizedBox(width: MindoraSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(portal.title, style: textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(portal.description, style: textTheme.bodyMedium),
                ],
              ),
            ),
            const SizedBox(width: MindoraSpacing.sm),
            Icon(
              Icons.chevron_right_rounded,
              color: colors.textSecondary,
              size: MindoraDimensions.iconMd,
            ),
          ],
        ),
      ),
    );
  }
}

class _PortalCompactCard extends StatelessWidget {
  const _PortalCompactCard({required this.portal});

  final ExplorationPortalInfo portal;

  @override
  Widget build(BuildContext context) {
    final colors = context.mindoraColors;
    final textTheme = Theme.of(context).textTheme;

    return MindoraSurface(
      padding: const EdgeInsets.all(MindoraSpacing.base),
      semanticLabel: '${portal.title}. ${portal.description}',
      onTap: () => context.push(portal.route),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              MindoraIconBadge(icon: portal.icon, size: 36),
              const Spacer(),
              Icon(
                Icons.arrow_forward_rounded,
                size: MindoraDimensions.iconSm,
                color: colors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: MindoraSpacing.md),
          Text(portal.title, style: textTheme.titleMedium),
          const SizedBox(height: MindoraSpacing.xs),
          Text(portal.description, style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _MyThoughtsSanctuaryCard extends StatelessWidget {
  const _MyThoughtsSanctuaryCard({required this.portal});

  final ExplorationPortalInfo portal;

  @override
  Widget build(BuildContext context) {
    final colors = context.mindoraColors;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      label: '${portal.title}. ${portal.description}',
      child: Material(
        color: Colors.transparent,
        borderRadius: MindoraRadii.card,
        child: InkWell(
          onTap: () => context.push(portal.route),
          borderRadius: MindoraRadii.card,
          child: Ink(
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: MindoraRadii.card,
              border: Border.all(
                color: colors.primaryAction.withValues(alpha: 0.35),
                width: MindoraBorders.thin,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(MindoraSpacing.lg),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              portal.icon,
                              size: MindoraDimensions.iconMd,
                              color: colors.textPrimary,
                            ),
                            const SizedBox(width: MindoraSpacing.sm),
                            Expanded(
                              child: Text(
                                portal.title,
                                style: textTheme.titleLarge,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: MindoraSpacing.xs),
                        Text(portal.description, style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  const SizedBox(width: MindoraSpacing.sm),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: colors.textPrimary,
                    size: MindoraDimensions.iconMd,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
