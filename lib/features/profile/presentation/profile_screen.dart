import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router.dart';
import '../../../core/design_system.dart';

/// Placeholder screen for the Profile destination (Milestone 2).
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
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
                  title: 'Your Space & Control',
                  subtitle:
                      'Identity, preferences, privacy controls, and local '
                      'data ownership.',
                ),
                const SizedBox(height: MindoraSpacing.lg),
                MindoraSurface(
                  child: Row(
                    children: [
                      const MindoraIconBadge(icon: Icons.lock_outline_rounded),
                      const SizedBox(width: MindoraSpacing.base),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Local-first by design',
                              style: textTheme.titleMedium,
                            ),
                            const SizedBox(height: MindoraSpacing.xs),
                            Text(
                              'Placeholder for Milestone 2. Privacy, export, '
                              'and personal preferences will live here.',
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const MindoraDivider(),
                MindoraSurface(
                  tone: MindoraSurfaceTone.secondary,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Appearance preview',
                              style: textTheme.titleMedium,
                            ),
                            const SizedBox(height: MindoraSpacing.xs),
                            Text(
                              isDark
                                  ? 'Dark organic theme active'
                                  : 'Warm ivory light theme active',
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: MindoraSpacing.sm),
                      MindoraSecondaryButton(
                        label: isDark ? 'Light' : 'Dark',
                        icon: isDark
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                        onPressed: () => ref
                            .read(themeModeProvider.notifier)
                            .setDarkMode(!isDark),
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
