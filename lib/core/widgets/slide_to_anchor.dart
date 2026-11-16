import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/lab_theme.dart';
import '../../app/theme/mind_tokens.dart';

/// Tactile "Slide-to-Anchor" swipe confirmation driven exclusively by [MindTokens].
class SlideToAnchor extends StatefulWidget {
  const SlideToAnchor({
    super.key,
    required this.label,
    required this.onCompleted,
    this.accentColor,
    this.backgroundColor,
    this.height = 54.0,
  });

  final String label;
  final Future<void> Function() onCompleted;
  final Color? accentColor;
  final Color? backgroundColor;
  final double height;

  @override
  State<SlideToAnchor> createState() => _SlideToAnchorState();
}

class _SlideToAnchorState extends State<SlideToAnchor>
    with SingleTickerProviderStateMixin {
  double _dragPosition = 0.0;
  bool _isCompleted = false;
  late final AnimationController _resetController;
  late Animation<double> _resetAnimation;
  int _lastHapticStep = 0;

  @override
  void initState() {
    super.initState();
    _resetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    )..addListener(() {
        setState(() => _dragPosition = _resetAnimation.value);
      });
  }

  @override
  void dispose() {
    _resetController.dispose();
    super.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details, double maxDrag) {
    if (_isCompleted) return;

    setState(() {
      _dragPosition = (_dragPosition + details.delta.dx).clamp(0.0, maxDrag);
      final progress = maxDrag > 0 ? _dragPosition / maxDrag : 0.0;
      final step = (progress * 4).floor();
      if (step != _lastHapticStep && step > 0) {
        _lastHapticStep = step;
        HapticFeedback.selectionClick();
      }
    });
  }

  Future<void> _completeAnchor(double maxDrag) async {
    if (_isCompleted) return;
    setState(() {
      _dragPosition = maxDrag;
      _isCompleted = true;
    });
    HapticFeedback.heavyImpact();
    await widget.onCompleted();
  }

  Future<void> _onHorizontalDragEnd(
    DragEndDetails details,
    double maxDrag,
  ) async {
    if (_isCompleted) return;

    final progress = maxDrag > 0 ? _dragPosition / maxDrag : 0.0;
    if (progress >= 0.85) {
      await _completeAnchor(maxDrag);
    } else {
      _lastHapticStep = 0;
      if (MediaQuery.disableAnimationsOf(context)) {
        setState(() => _dragPosition = 0.0);
        return;
      }
      _resetAnimation = Tween<double>(begin: _dragPosition, end: 0.0).animate(
        CurvedAnimation(parent: _resetController, curve: Curves.easeOutCubic),
      );
      _resetController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final accent = widget.accentColor ?? tokens.m1;
    final trackHeight = widget.height;
    final thumbSize = trackHeight - 8.0;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxDrag = (constraints.maxWidth - thumbSize - 8.0).clamp(
          0.0,
          double.infinity,
        );
        final progress =
            maxDrag > 0 ? (_dragPosition / maxDrag).clamp(0.0, 1.0) : 0.0;

        final trackBg = widget.backgroundColor ?? tokens.surface2;

        return Semantics(
          container: true,
          button: true,
          enabled: !_isCompleted,
          label: widget.label,
          onTap: _isCompleted ? null : () => _completeAnchor(maxDrag),
          child: ExcludeSemantics(
            child: Container(
              height: trackHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                color: trackBg,
                borderRadius: BorderRadius.circular(tokens.buttonRadius),
                border: Border.all(color: tokens.line, width: 1),
              ),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    width: _dragPosition + thumbSize + 4.0,
                    height: trackHeight,
                    decoration: BoxDecoration(
                      color: tokens.tint(accent, tokens.tintSelected),
                      borderRadius: BorderRadius.circular(
                        tokens.buttonRadius - 1,
                      ),
                    ),
                  ),
                  Center(
                    child: Opacity(
                      opacity: (1.0 - (progress * 1.4)).clamp(0.0, 1.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.label.toUpperCase(),
                            style: TextStyle(
                              fontFamily: LabTheme.fontFamily,
                              fontFamilyFallback: LabTheme.fontFallback,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
                              color: tokens.ink2,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 11,
                            color: tokens.ink2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 4.0 + _dragPosition,
                    child: GestureDetector(
                      onHorizontalDragUpdate: (details) =>
                          _onHorizontalDragUpdate(details, maxDrag),
                      onHorizontalDragEnd: (details) =>
                          _onHorizontalDragEnd(details, maxDrag),
                      child: AnimatedContainer(
                        duration: reduceMotion
                            ? Duration.zero
                            : const Duration(milliseconds: 140),
                        width: thumbSize,
                        height: thumbSize,
                        decoration: BoxDecoration(
                          color: _isCompleted ? accent : tokens.ink,
                          borderRadius: BorderRadius.circular(
                            tokens.iconButtonRadius,
                          ),
                          boxShadow: tokens.glow > 0
                              ? [
                                  BoxShadow(
                                    color: accent.withValues(
                                      alpha: progress * 0.4,
                                    ),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : const <BoxShadow>[],
                        ),
                        child: Center(
                          child: Icon(
                            _isCompleted
                                ? Icons.check_rounded
                                : Icons.anchor_rounded,
                            size: 20,
                            color: _isCompleted ? tokens.onMood : tokens.bg,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
