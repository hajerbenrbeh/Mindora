import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system.dart';

/// Temporary placeholder destination for each of the five independent experiences
/// during Milestone 3 (before recording workflows are implemented).
class ExperiencePlaceholderScreen extends StatelessWidget {
  const ExperiencePlaceholderScreen({
    required this.title,
    required this.description,
    required this.icon,
    required this.milestoneNote,
    super.key,
  });

  final String title;
  final String description;
  final IconData icon;
  final String milestoneNote;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
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
                    MindoraIconBadge(icon: icon, size: 48),
                    const SizedBox(height: MindoraSpacing.base),
                    Text(title, style: textTheme.headlineMedium),
                    const SizedBox(height: MindoraSpacing.xs),
                    Text(description, style: textTheme.bodyLarge),
                    const MindoraDivider(),
                    Text(milestoneNote, style: textTheme.bodyMedium),
                    const SizedBox(height: MindoraSpacing.lg),
                    MindoraSecondaryButton(
                      label: 'Return to Home',
                      icon: Icons.arrow_back_rounded,
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
