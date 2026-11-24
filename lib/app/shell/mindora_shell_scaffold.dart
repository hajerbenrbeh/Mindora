import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/design_system.dart';

/// Metadata for each of Mindora's five permanent top-level destinations.
class MindoraDestination {
  const MindoraDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.semanticHint,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String semanticHint;
}

const List<MindoraDestination> mindoraDestinations = [
  MindoraDestination(
    label: 'Home',
    icon: Icons.spa_outlined,
    selectedIcon: Icons.spa_rounded,
    semanticHint: 'Home overview',
  ),
  MindoraDestination(
    label: 'Track',
    icon: Icons.edit_note_outlined,
    selectedIcon: Icons.edit_note_rounded,
    semanticHint: 'Track records and history',
  ),
  MindoraDestination(
    label: 'Clarity',
    icon: Icons.insights_outlined,
    selectedIcon: Icons.insights_rounded,
    semanticHint: 'Clarity patterns and insights',
  ),
  MindoraDestination(
    label: 'Toolkit',
    icon: Icons.self_improvement_outlined,
    selectedIcon: Icons.self_improvement_rounded,
    semanticHint: 'Toolkit wellbeing tools',
  ),
  MindoraDestination(
    label: 'Profile',
    icon: Icons.person_outline_rounded,
    selectedIcon: Icons.person_rounded,
    semanticHint: 'Profile and preferences',
  ),
];

/// Persistent application shell hosting the five top-level branches.
class MindoraShellScaffold extends StatelessWidget {
  const MindoraShellScaffold({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: MindoraBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onSelect: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}

/// Custom Mindora bottom navigation bar aligned with the design system.
class MindoraBottomNavBar extends StatelessWidget {
  const MindoraBottomNavBar({
    required this.currentIndex,
    required this.onSelect,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = context.mindoraColors;
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(color: colors.divider, width: MindoraBorders.thin),
        ),
      ),
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: MindoraSpacing.xs,
              vertical: MindoraSpacing.xs,
            ),
            child: Row(
              children: List.generate(mindoraDestinations.length, (index) {
                final destination = mindoraDestinations[index];
                final isSelected = index == currentIndex;

                return Expanded(
                  child: Semantics(
                    button: true,
                    selected: isSelected,
                    label: destination.semanticHint,
                    excludeSemantics: true,
                    child: InkWell(
                      onTap: () => onSelect(index),
                      borderRadius: MindoraRadii.control,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: MindoraDimensions.minTouchTarget,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: MindoraSpacing.xs,
                            horizontal: 2,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedContainer(
                                duration: MindoraMotion.fast,
                                curve: MindoraMotion.curve,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: MindoraSpacing.md,
                                  vertical: MindoraSpacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? colors.accentSoft
                                      : Colors.transparent,
                                  borderRadius: MindoraRadii.chip,
                                ),
                                child: Icon(
                                  isSelected
                                      ? destination.selectedIcon
                                      : destination.icon,
                                  size: MindoraDimensions.iconMd,
                                  color: isSelected
                                      ? colors.textPrimary
                                      : colors.textMuted,
                                ),
                              ),
                              const SizedBox(height: 2),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  destination.label,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: isSelected
                                        ? colors.textPrimary
                                        : colors.textMuted,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
