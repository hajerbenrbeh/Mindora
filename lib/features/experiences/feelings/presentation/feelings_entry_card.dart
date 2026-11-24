import 'package:flutter/material.dart';

import '../../../../core/design_system.dart';
import '../domain/feelings_entry.dart';

/// Restrained card displaying a saved [FeelingsEntry].
class FeelingsEntryCard extends StatelessWidget {
  const FeelingsEntryCard({
    required this.entry,
    this.onEdit,
    this.onTap,
    this.compact = false,
    super.key,
  });

  final FeelingsEntry entry;
  final VoidCallback? onEdit;
  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.mindoraColors;
    final textTheme = Theme.of(context).textTheme;
    final localTime = entry.originalLocalDateTime;
    final hh = localTime.hour.toString().padLeft(2, '0');
    final mm = localTime.minute.toString().padLeft(2, '0');
    final wasEdited = entry.updatedAtUtc.isAfter(entry.recordedAtUtc);

    return MindoraSurface(
      onTap: onTap,
      padding: const EdgeInsets.all(MindoraSpacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${entry.localCalendarDate} · $hh:$mm'
                  '${wasEdited ? ' · Edited' : ''}',
                  style: textTheme.bodySmall,
                ),
              ),
              if (entry.overallTone != null) ...[
                const SizedBox(width: MindoraSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: MindoraSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surfaceSecondary,
                    borderRadius: MindoraRadii.chip,
                    border: Border.all(color: colors.border),
                  ),
                  child: Text(
                    entry.overallTone!.label,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
              if (onEdit != null) ...[
                const SizedBox(width: MindoraSpacing.xs),
                MindoraTextButton(label: 'Edit', onPressed: onEdit),
              ],
            ],
          ),
          const SizedBox(height: MindoraSpacing.xs),
          if (entry.isEmotionUnsure)
            Text(
              'Unsure what I am feeling',
              style: textTheme.titleMedium?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            )
          else if (entry.emotions.isNotEmpty)
            Wrap(
              spacing: MindoraSpacing.xs,
              runSpacing: MindoraSpacing.xs,
              children: entry.emotions.map((emotion) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: MindoraSpacing.md,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colors.accentSoft,
                    borderRadius: MindoraRadii.chip,
                    border: Border.all(color: colors.border),
                  ),
                  child: Text(
                    emotion.label,
                    style: textTheme.labelMedium?.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                );
              }).toList(),
            )
          else
            Text('No specific emotions selected', style: textTheme.bodyMedium),
          if (entry.description != null) ...[
            const SizedBox(height: MindoraSpacing.sm),
            Text(
              entry.description!,
              maxLines: compact ? 2 : null,
              overflow: compact ? TextOverflow.ellipsis : null,
              style: textTheme.bodyLarge,
            ),
          ],
          if (!compact && entry.contextNote != null) ...[
            const SizedBox(height: MindoraSpacing.xs),
            Text('Context: ${entry.contextNote!}', style: textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
