import 'package:flutter/material.dart';

import '../../app/theme/mind_tokens.dart';

/// Soft rounded icon square (`44×44` default) tinted via `tokens.blobTintFor(color)`.
class IconBlob extends StatelessWidget {
  const IconBlob({
    super.key,
    required this.icon,
    this.color,
    this.iconColor,
    this.size = 44.0,
    this.iconSize = 20.0,
    this.radius,
  });

  final IconData icon;
  final Color? color;
  final Color? iconColor;
  final double size;
  final double iconSize;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final tintBase = color ?? tokens.m1;
    final cornerRadius = radius ?? tokens.iconButtonRadius;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: tokens.blobTintFor(tintBase),
        borderRadius: BorderRadius.circular(cornerRadius),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: iconSize, color: iconColor ?? tokens.ink),
    );
  }
}
