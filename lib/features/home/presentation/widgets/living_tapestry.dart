import 'package:flutter/material.dart';

import '../../../../core/design_system.dart';

/// Hybrid organic visual centerpiece representing the Living Tapestry.
///
/// Communicates four interconnected wellbeing dimensions without scores,
/// percentages, or clinical framing.
class LivingTapestryCard extends StatelessWidget {
  const LivingTapestryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.mindoraColors;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MindoraSurface(
      padding: const EdgeInsets.all(MindoraSpacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            image: true,
            label:
                'The Living Tapestry: an organic visual of four connected '
                'wellbeing dimensions — mental wellbeing, physical wellbeing, '
                'lifestyle, and personal understanding.',
            child: ClipRRect(
              borderRadius: MindoraRadii.control,
              child: SizedBox(
                height: 176,
                width: double.infinity,
                child: CustomPaint(
                  painter: _LivingTapestryPainter(
                    colors: colors,
                    isDark: isDark,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: MindoraSpacing.md),
          Text('The Living Tapestry', style: textTheme.titleMedium),
          const SizedBox(height: MindoraSpacing.xs),
          Text(
            'Your wellbeing is an evolving landscape of connected '
            'experiences — never a single number.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: MindoraSpacing.md),
          Wrap(
            spacing: MindoraSpacing.md,
            runSpacing: MindoraSpacing.xs,
            children: [
              _LegendItem(label: 'Mental', dotColor: colors.accent),
              _LegendItem(label: 'Physical', dotColor: colors.surfaceSecondary),
              _LegendItem(
                label: 'Lifestyle',
                dotColor: colors.primaryAction.withValues(alpha: 0.65),
              ),
              _LegendItem(
                label: 'Understanding',
                dotColor: colors.textSecondary.withValues(alpha: 0.75),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.label, required this.dotColor});

  final String label;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.mindoraColors;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
            border: Border.all(color: colors.border, width: 0.8),
          ),
        ),
        const SizedBox(width: 6),
        Flexible(child: Text(label, style: textTheme.bodySmall)),
      ],
    );
  }
}

class _LivingTapestryPainter extends CustomPainter {
  const _LivingTapestryPainter({required this.colors, required this.isDark});

  final MindoraColorTokens colors;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    // Soft organic canvas backdrop
    final bgPaint = Paint()..color = colors.background;
    canvas.drawRect(Offset.zero & size, bgPaint);

    final w = size.width;
    final h = size.height;

    // 1. Mental wellbeing — soft botanical wash (top-left)
    final mentalPath = Path()
      ..moveTo(w * 0.04, h * 0.42)
      ..cubicTo(w * 0.08, h * 0.10, w * 0.36, h * 0.04, w * 0.48, h * 0.28)
      ..cubicTo(w * 0.56, h * 0.48, w * 0.34, h * 0.76, w * 0.16, h * 0.66)
      ..cubicTo(w * 0.06, h * 0.60, w * 0.02, h * 0.54, w * 0.04, h * 0.42)
      ..close();
    canvas.drawPath(
      mentalPath,
      Paint()..color = colors.accent.withValues(alpha: isDark ? 0.34 : 0.42),
    );

    // 2. Physical wellbeing — warm sage layer (top-right)
    final physicalPath = Path()
      ..moveTo(w * 0.42, h * 0.22)
      ..cubicTo(w * 0.58, h * 0.04, w * 0.88, h * 0.12, w * 0.92, h * 0.40)
      ..cubicTo(w * 0.95, h * 0.66, w * 0.68, h * 0.78, w * 0.50, h * 0.60)
      ..cubicTo(w * 0.36, h * 0.46, w * 0.32, h * 0.34, w * 0.42, h * 0.22)
      ..close();
    canvas.drawPath(
      physicalPath,
      Paint()
        ..color = colors.surfaceSecondary.withValues(
          alpha: isDark ? 0.58 : 0.78,
        ),
    );

    // 3. Lifestyle — grounded earth-botanical curve (bottom-left)
    final lifestylePath = Path()
      ..moveTo(w * 0.14, h * 0.78)
      ..cubicTo(w * 0.18, h * 0.50, w * 0.48, h * 0.44, w * 0.58, h * 0.66)
      ..cubicTo(w * 0.66, h * 0.84, w * 0.44, h * 0.96, w * 0.24, h * 0.90)
      ..cubicTo(w * 0.14, h * 0.87, w * 0.12, h * 0.84, w * 0.14, h * 0.78)
      ..close();
    canvas.drawPath(
      lifestylePath,
      Paint()
        ..color = colors.primaryAction.withValues(alpha: isDark ? 0.26 : 0.16),
    );

    // 4. Personal understanding — quiet overlapping petal (bottom-right)
    final understandingPath = Path()
      ..moveTo(w * 0.48, h * 0.56)
      ..cubicTo(w * 0.60, h * 0.36, w * 0.88, h * 0.46, w * 0.88, h * 0.72)
      ..cubicTo(w * 0.88, h * 0.92, w * 0.60, h * 0.94, w * 0.48, h * 0.78)
      ..cubicTo(w * 0.42, h * 0.70, w * 0.43, h * 0.64, w * 0.48, h * 0.56)
      ..close();
    canvas.drawPath(
      understandingPath,
      Paint()
        ..color = colors.textSecondary.withValues(alpha: isDark ? 0.24 : 0.14),
    );

    // Delicate interwoven threads linking all four dimensions
    final threadPaint = Paint()
      ..color = colors.textPrimary.withValues(alpha: isDark ? 0.36 : 0.26)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.25
      ..strokeCap = StrokeCap.round;

    final primaryThread = Path()
      ..moveTo(w * 0.08, h * 0.52)
      ..cubicTo(w * 0.28, h * 0.24, w * 0.46, h * 0.74, w * 0.68, h * 0.42)
      ..cubicTo(w * 0.78, h * 0.28, w * 0.86, h * 0.44, w * 0.92, h * 0.56);
    canvas.drawPath(primaryThread, threadPaint);

    final secondaryThread = Path()
      ..moveTo(w * 0.20, h * 0.78)
      ..cubicTo(w * 0.38, h * 0.46, w * 0.56, h * 0.32, w * 0.80, h * 0.68);
    canvas.drawPath(
      secondaryThread,
      threadPaint
        ..color = colors.textSecondary.withValues(alpha: isDark ? 0.32 : 0.22),
    );
  }

  @override
  bool shouldRepaint(covariant _LivingTapestryPainter oldDelegate) {
    return oldDelegate.isDark != isDark || oldDelegate.colors != colors;
  }
}
