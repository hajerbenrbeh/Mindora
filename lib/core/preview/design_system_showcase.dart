import 'package:flutter/material.dart';

import '../design_system.dart';

/// Temporary Milestone 1 showcase screen for verifying the Mindora design system.
///
/// Demonstrates light/dark themes, palette, typography, and reusable components.
class DesignSystemShowcaseScreen extends StatefulWidget {
  const DesignSystemShowcaseScreen({
    required this.isDarkMode,
    required this.onToggleTheme,
    super.key,
  });

  final bool isDarkMode;
  final ValueChanged<bool> onToggleTheme;

  @override
  State<DesignSystemShowcaseScreen> createState() =>
      _DesignSystemShowcaseScreenState();
}

class _DesignSystemShowcaseScreenState
    extends State<DesignSystemShowcaseScreen> {
  final Set<String> _selectedQualities = {'Calm', 'Grounded'};
  final TextEditingController _noteController = TextEditingController();
  bool _showLoading = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.mindoraColors;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mindora Design System'),
        actions: [
          Semantics(
            label: 'Toggle dark theme',
            child: IconButton(
              tooltip: widget.isDarkMode
                  ? 'Switch to light theme'
                  : 'Switch to dark theme',
              onPressed: () => widget.onToggleTheme(!widget.isDarkMode),
              icon: Icon(
                widget.isDarkMode
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: MindoraDimensions.maxReadableWidth,
            ),
            child: ListView(
              padding: MindoraSpacing.pagePadding,
              children: [
                Text('Editorial Calm', style: textTheme.displaySmall),
                const SizedBox(height: MindoraSpacing.xs),
                Text(
                  'Milestone 1 preview — verifying palette, typography, '
                  'surfaces, and accessible interactions.',
                  style: textTheme.bodyMedium,
                ),
                const MindoraDivider(),

                // Color Palette
                const MindoraSectionHeading(
                  title: 'Color Palette',
                  subtitle: 'Approved foundation and current theme tokens.',
                ),
                const SizedBox(height: MindoraSpacing.md),
                const Wrap(
                  spacing: MindoraSpacing.sm,
                  runSpacing: MindoraSpacing.sm,
                  children: [
                    _SwatchTile(
                      name: 'Warm Ivory',
                      hex: '#F7EFE3',
                      color: MindoraPalette.warmIvory,
                    ),
                    _SwatchTile(
                      name: 'Natural Beige',
                      hex: '#EAE1D0',
                      color: MindoraPalette.naturalBeige,
                    ),
                    _SwatchTile(
                      name: 'Soft Sage',
                      hex: '#D8D9BF',
                      color: MindoraPalette.softSage,
                    ),
                    _SwatchTile(
                      name: 'Botanical',
                      hex: '#A8B18A',
                      color: MindoraPalette.mutedBotanicalGreen,
                    ),
                    _SwatchTile(
                      name: 'Forest',
                      hex: '#35452B',
                      color: MindoraPalette.deepForestGreen,
                      darkBackground: true,
                    ),
                  ],
                ),
                const MindoraDivider(),

                // Typography
                const MindoraSectionHeading(
                  title: 'Typography Hierarchy',
                  subtitle:
                      'Lora for editorial headings, Inter for functional copy.',
                ),
                const SizedBox(height: MindoraSpacing.md),
                MindoraSurface(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Display Heading (Lora)',
                        style: textTheme.displaySmall,
                      ),
                      const SizedBox(height: MindoraSpacing.xs),
                      Text(
                        'Screen Heading (Lora)',
                        style: textTheme.headlineMedium,
                      ),
                      const SizedBox(height: MindoraSpacing.xs),
                      Text(
                        'Section Heading (Lora)',
                        style: textTheme.titleLarge,
                      ),
                      const SizedBox(height: MindoraSpacing.xs),
                      Text('Card Title (Lora)', style: textTheme.titleMedium),
                      const SizedBox(height: MindoraSpacing.sm),
                      Text(
                        'Body text (Inter): A calm, readable rhythm designed '
                        'for long-form reflection without visual strain.',
                        style: textTheme.bodyLarge,
                      ),
                      const SizedBox(height: MindoraSpacing.xs),
                      Text(
                        'Secondary text (Inter): Supporting context and gentle guidance.',
                        style: textTheme.bodyMedium,
                      ),
                      const SizedBox(height: MindoraSpacing.xs),
                      Text('Label style (Inter)', style: textTheme.labelMedium),
                      const SizedBox(height: MindoraSpacing.xs),
                      Text(
                        'Metadata · Updated just now',
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const MindoraDivider(),

                // Surfaces & Selection
                const MindoraSectionHeading(
                  title: 'Surfaces & Selection',
                  subtitle: 'Layered surfaces and 48dp accessible chips.',
                ),
                const SizedBox(height: MindoraSpacing.md),
                MindoraSurface(
                  tone: MindoraSurfaceTone.secondary,
                  onTap: () {},
                  semanticLabel: 'Interactive secondary surface sample',
                  child: Row(
                    children: [
                      const MindoraIconBadge(icon: Icons.spa_outlined),
                      const SizedBox(width: MindoraSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tappable Surface',
                              style: textTheme.titleMedium,
                            ),
                            Text(
                              'Uses subtle border and ink feedback.',
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: colors.textSecondary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: MindoraSpacing.md),
                Wrap(
                  spacing: MindoraSpacing.sm,
                  runSpacing: MindoraSpacing.sm,
                  children: ['Calm', 'Grounded', 'Reflective', 'Tired'].map((
                    q,
                  ) {
                    final isSelected = _selectedQualities.contains(q);
                    return MindoraSelectableChip(
                      label: q,
                      selected: isSelected,
                      onSelected: (next) {
                        setState(() {
                          if (next) {
                            _selectedQualities.add(q);
                          } else {
                            _selectedQualities.remove(q);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const MindoraDivider(),

                // Buttons & Inputs
                const MindoraSectionHeading(title: 'Buttons & Inputs'),
                const SizedBox(height: MindoraSpacing.md),
                MindoraTextField(
                  controller: _noteController,
                  label: 'Reflection note',
                  hintText: 'Write a few unhurried words...',
                  helperText: 'Optional — nothing here is required.',
                  minLines: 2,
                  maxLines: 4,
                ),
                const SizedBox(height: MindoraSpacing.base),
                Wrap(
                  spacing: MindoraSpacing.sm,
                  runSpacing: MindoraSpacing.sm,
                  children: [
                    MindoraPrimaryButton(
                      label: 'Primary Action',
                      icon: Icons.check_rounded,
                      onPressed: () {},
                    ),
                    MindoraSecondaryButton(
                      label: 'Secondary',
                      onPressed: () =>
                          setState(() => _showLoading = !_showLoading),
                    ),
                    MindoraTextButton(
                      label: _showLoading ? 'Show Empty' : 'Show Loading',
                      onPressed: () =>
                          setState(() => _showLoading = !_showLoading),
                    ),
                  ],
                ),
                const MindoraDivider(),

                // States
                const MindoraSectionHeading(title: 'Empty & Loading States'),
                const SizedBox(height: MindoraSpacing.md),
                MindoraSurface(
                  child: _showLoading
                      ? const MindoraLoadingIndicator(
                          message: 'Gathering your space...',
                        )
                      : MindoraEmptyState(
                          title: 'A quiet space for now',
                          description:
                              'Nothing is waiting on you. Return whenever it '
                              'feels helpful.',
                          action: MindoraSecondaryButton(
                            label: 'Toggle Loading',
                            onPressed: () =>
                                setState(() => _showLoading = true),
                          ),
                        ),
                ),
                const SizedBox(height: MindoraSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SwatchTile extends StatelessWidget {
  const _SwatchTile({
    required this.name,
    required this.hex,
    required this.color,
    this.darkBackground = false,
  });

  final String name;
  final String hex;
  final Color color;
  final bool darkBackground;

  @override
  Widget build(BuildContext context) {
    final colors = context.mindoraColors;
    final textTheme = Theme.of(context).textTheme;
    final ink = darkBackground
        ? MindoraPalette.warmIvory
        : MindoraPalette.deepForestGreen;

    return Container(
      width: 112,
      padding: const EdgeInsets.all(MindoraSpacing.sm),
      decoration: BoxDecoration(
        color: color,
        borderRadius: MindoraRadii.control,
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: textTheme.labelMedium?.copyWith(color: ink)),
          const SizedBox(height: MindoraSpacing.xs),
          Text(hex, style: textTheme.bodySmall?.copyWith(color: ink)),
        ],
      ),
    );
  }
}
