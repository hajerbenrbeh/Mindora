import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'mood_emblem.dart';

/// Expressive, organically shaped 3D-shaded mood orb rendered via pure vector geometry.
///
/// Each emotional state (`calm`, `anxious`, `frustrated`, `heavy`, `restless`) maps
/// to a distinct closed Fourier silhouette whose undulation responds smoothly to
/// self-reported `intensity` (`1..10`) without continuous tickers that could stall
/// widget test settling.
class OrganicMoodOrb extends StatefulWidget {
  const OrganicMoodOrb({
    super.key,
    required this.moodKey,
    required this.intensity,
    required this.color,
    this.size = 96.0,
    this.isDark = false,
    this.onTap,
    this.semanticLabel,
  });

  final String moodKey;
  final int intensity;
  final Color color;
  final double size;
  final bool isDark;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  State<OrganicMoodOrb> createState() => _OrganicMoodOrbState();
}

class _OrbShapeSpec {
  const _OrbShapeSpec({
    required this.harmonicA,
    required this.ampA,
    required this.harmonicB,
    required this.ampB,
    required this.phaseOffset,
    required this.verticalSquash,
    required this.color,
  });

  final double harmonicA;
  final double ampA;
  final double harmonicB;
  final double ampB;
  final double phaseOffset;
  final double verticalSquash;
  final Color color;

  factory _OrbShapeSpec.forState({
    required String moodKey,
    required int intensity,
    required Color color,
  }) {
    final normKey = MoodEmblem.normalizeKey(moodKey);
    final t = ((intensity.clamp(1, 10) - 1) / 9.0);

    switch (normKey) {
      case 'calm':
        return _OrbShapeSpec(
          harmonicA: 2.0,
          ampA: 0.025 + t * 0.015,
          harmonicB: 3.0,
          ampB: 0.012 + t * 0.010,
          phaseOffset: 0.35,
          verticalSquash: 0.96,
          color: color,
        );
      case 'anxious':
        return _OrbShapeSpec(
          harmonicA: 5.0,
          ampA: 0.040 + t * 0.042,
          harmonicB: 7.0,
          ampB: 0.020 + t * 0.028,
          phaseOffset: 0.70,
          verticalSquash: 1.0,
          color: color,
        );
      case 'frustrated':
        return _OrbShapeSpec(
          harmonicA: 4.0,
          ampA: 0.065 + t * 0.075,
          harmonicB: 6.0,
          ampB: 0.032 + t * 0.040,
          phaseOffset: 1.15,
          verticalSquash: 0.98,
          color: color,
        );
      case 'heavy':
        return _OrbShapeSpec(
          harmonicA: 2.0,
          ampA: 0.045 + t * 0.035,
          harmonicB: 3.0,
          ampB: 0.025 + t * 0.022,
          phaseOffset: 1.55,
          verticalSquash: 0.90,
          color: color,
        );
      case 'restless':
      default:
        return _OrbShapeSpec(
          harmonicA: 3.0,
          ampA: 0.055 + t * 0.048,
          harmonicB: 5.0,
          ampB: 0.030 + t * 0.032,
          phaseOffset: 2.05,
          verticalSquash: 0.97,
          color: color,
        );
    }
  }

  static _OrbShapeSpec lerp(_OrbShapeSpec a, _OrbShapeSpec b, double t) {
    return _OrbShapeSpec(
      harmonicA: b.harmonicA,
      ampA: a.ampA + (b.ampA - a.ampA) * t,
      harmonicB: b.harmonicB,
      ampB: a.ampB + (b.ampB - a.ampB) * t,
      phaseOffset: a.phaseOffset + (b.phaseOffset - a.phaseOffset) * t,
      verticalSquash: a.verticalSquash + (b.verticalSquash - a.verticalSquash) * t,
      color: Color.lerp(a.color, b.color, t) ?? b.color,
    );
  }
}

class _OrganicMoodOrbState extends State<OrganicMoodOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _morphController;
  late _OrbShapeSpec _fromSpec;
  late _OrbShapeSpec _toSpec;
  double _tapScale = 1.0;

  @override
  void initState() {
    super.initState();
    _toSpec = _OrbShapeSpec.forState(
      moodKey: widget.moodKey,
      intensity: widget.intensity,
      color: widget.color,
    );
    _fromSpec = _toSpec;
    _morphController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    )..value = 1.0;
  }

  @override
  void didUpdateWidget(covariant OrganicMoodOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.moodKey != widget.moodKey ||
        oldWidget.intensity != widget.intensity ||
        oldWidget.color != widget.color) {
      final currentT = Curves.easeOutCubic.transform(_morphController.value);
      _fromSpec = _OrbShapeSpec.lerp(_fromSpec, _toSpec, currentT);
      _toSpec = _OrbShapeSpec.forState(
        moodKey: widget.moodKey,
        intensity: widget.intensity,
        color: widget.color,
      );
      final reduceMotion = MediaQuery.disableAnimationsOf(context);
      if (reduceMotion) {
        _morphController.value = 1.0;
      } else {
        _morphController
          ..value = 0.0
          ..forward();
      }
    }
  }

  @override
  void dispose() {
    _morphController.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.selectionClick();
    if (!MediaQuery.disableAnimationsOf(context)) {
      setState(() => _tapScale = 0.94);
      Future<void>.delayed(const Duration(milliseconds: 120), () {
        if (mounted) {
          setState(() => _tapScale = 1.0);
        }
      });
    }
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    final orb = AnimatedScale(
      scale: _tapScale,
      duration:
          reduceMotion ? Duration.zero : const Duration(milliseconds: 140),
      curve: Curves.easeOutCubic,
      child: AnimatedBuilder(
        animation: _morphController,
        builder: (context, _) {
          final t = Curves.easeOutCubic.transform(_morphController.value);
          final spec = _OrbShapeSpec.lerp(_fromSpec, _toSpec, t);
          return CustomPaint(
            size: Size.square(widget.size),
            painter: _OrganicMoodOrbPainter(
              spec: spec,
              isDark: widget.isDark,
            ),
          );
        },
      ),
    );

    if (widget.onTap == null) {
      return ExcludeSemantics(child: orb);
    }

    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _handleTap,
        child: SizedBox(
          width: math.max(48.0, widget.size),
          height: math.max(48.0, widget.size),
          child: Center(child: orb),
        ),
      ),
    );
  }
}

class _OrganicMoodOrbPainter extends CustomPainter {
  const _OrganicMoodOrbPainter({
    required this.spec,
    required this.isDark,
  });

  final _OrbShapeSpec spec;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width * 0.37;
    const steps = 64;
    final pts = <Offset>[];

    for (var i = 0; i < steps; i++) {
      final theta = (i / steps) * 2 * math.pi;
      final waveA =
          spec.ampA * math.sin(spec.harmonicA * theta + spec.phaseOffset);
      final waveB =
          spec.ampB * math.cos(spec.harmonicB * theta - spec.phaseOffset * 0.7);
      final r = baseRadius * (1.0 + waveA + waveB);
      final dx = center.dx + r * math.cos(theta);
      final dy = center.dy + r * spec.verticalSquash * math.sin(theta);
      pts.add(Offset(dx, dy));
    }

    // Build smooth closed cubic path via mid-point quadratic smoothing.
    final path = Path();
    if (pts.isNotEmpty) {
      final firstMid = Offset(
        (pts.last.dx + pts.first.dx) / 2,
        (pts.last.dy + pts.first.dy) / 2,
      );
      path.moveTo(firstMid.dx, firstMid.dy);
      for (var i = 0; i < pts.length; i++) {
        final curr = pts[i];
        final next = pts[(i + 1) % pts.length];
        final mid = Offset((curr.dx + next.dx) / 2, (curr.dy + next.dy) / 2);
        path.quadraticBezierTo(curr.dx, curr.dy, mid.dx, mid.dy);
      }
      path.close();
    }

    // Soft ambient halo beneath the orb.
    final haloPaint = Paint()
      ..color = spec.color.withValues(alpha: isDark ? 0.24 : 0.16)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, size.width * 0.14);
    canvas.drawPath(path, haloPaint);

    // Sculpted 3D radial gradient sphere shading.
    final highlightColor =
        Color.lerp(spec.color, Colors.white, isDark ? 0.44 : 0.56) ?? spec.color;
    final midColor = spec.color;
    final deepColor =
        Color.lerp(spec.color, Colors.black, isDark ? 0.28 : 0.18) ?? spec.color;

    final bodyRect = Rect.fromCircle(center: center, radius: baseRadius * 1.15);
    final fillPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.32, -0.36),
        radius: 1.05,
        colors: [highlightColor, midColor, deepColor],
        stops: const [0.0, 0.54, 1.0],
      ).createShader(bodyRect);
    canvas.drawPath(path, fillPaint);

    // Subtle crisp translucent rim stroke.
    final rimPaint = Paint()
      ..color = highlightColor.withValues(alpha: isDark ? 0.28 : 0.36)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(path, rimPaint);

    // Delicate inner pearlescent gleam at upper-left shoulder.
    final gleamPaint = Paint()
      ..color = Colors.white.withValues(alpha: isDark ? 0.22 : 0.34)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, size.width * 0.04);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(
          center.dx - baseRadius * 0.28,
          center.dy - baseRadius * 0.30,
        ),
        width: baseRadius * 0.36,
        height: baseRadius * 0.22,
      ),
      gleamPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _OrganicMoodOrbPainter oldDelegate) {
    return oldDelegate.spec.harmonicA != spec.harmonicA ||
        oldDelegate.spec.ampA != spec.ampA ||
        oldDelegate.spec.harmonicB != spec.harmonicB ||
        oldDelegate.spec.ampB != spec.ampB ||
        oldDelegate.spec.phaseOffset != spec.phaseOffset ||
        oldDelegate.spec.verticalSquash != spec.verticalSquash ||
        oldDelegate.spec.color != spec.color ||
        oldDelegate.isDark != isDark;
  }
}
