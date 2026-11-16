import 'package:flutter/material.dart';

import '../../app/theme/mind_tokens.dart';

/// Organic landscape artwork with rolling wavy hills and glowing sun driven by [MindTokens].
class OrganicWaveArt extends StatelessWidget {
  const OrganicWaveArt({super.key, this.height = 140});

  final double height;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ExcludeSemantics(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(tokens.tileRadius),
          child: CustomPaint(
            size: Size(double.infinity, height),
            painter: _OrganicWavePainter(),
          ),
        ),
      ),
    );
  }
}

class _OrganicWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [MindTokens.waveSkyTop, MindTokens.waveSkyBottom],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), skyPaint);

    final sunCenter = Offset(w * 0.78, h * 0.32);
    final sunGlowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          MindTokens.waveSunHighlight.withValues(alpha: 0.85),
          MindTokens.waveSunGlow.withValues(alpha: 0.40),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: sunCenter, radius: h * 0.45));
    canvas.drawCircle(sunCenter, h * 0.45, sunGlowPaint);

    final sunCorePaint = Paint()
      ..color = MindTokens.waveSunCore.withValues(alpha: 0.70);
    canvas.drawCircle(sunCenter, h * 0.16, sunCorePaint);

    final ridge1 = Path()
      ..moveTo(0, h * 0.65)
      ..cubicTo(w * 0.25, h * 0.50, w * 0.55, h * 0.70, w, h * 0.48)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    final ridge1Paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          MindTokens.waveRidgeLightTop.withValues(alpha: 0.85),
          MindTokens.waveRidgeLightBottom,
        ],
      ).createShader(Rect.fromLTWH(0, h * 0.48, w, h * 0.52));
    canvas.drawPath(ridge1, ridge1Paint);

    final ridge2 = Path()
      ..moveTo(0, h * 0.74)
      ..cubicTo(w * 0.30, h * 0.62, w * 0.60, h * 0.78, w, h * 0.60)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    final ridge2Paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [MindTokens.waveRidgeMidTop, MindTokens.waveRidgeMidBottom],
      ).createShader(Rect.fromLTWH(0, h * 0.60, w, h * 0.40));
    canvas.drawPath(ridge2, ridge2Paint);

    final ridge3 = Path()
      ..moveTo(0, h * 0.86)
      ..cubicTo(w * 0.35, h * 0.76, w * 0.70, h * 0.88, w, h * 0.78)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    final ridge3Paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [MindTokens.moodCalm, MindTokens.waveRidgeDeepBottom],
      ).createShader(Rect.fromLTWH(0, h * 0.76, w, h * 0.24));
    canvas.drawPath(ridge3, ridge3Paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
