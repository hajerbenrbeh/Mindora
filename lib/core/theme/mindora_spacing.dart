import 'package:flutter/material.dart';

/// Consistent 4dp-based spacing tokens.
abstract final class MindoraSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;

  static const EdgeInsets pagePadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: base,
  );
  static const EdgeInsets cardPadding = EdgeInsets.all(20);
}

/// Controlled, organic corner radii (never overly rounded or sharp).
abstract final class MindoraRadii {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double pill = 999;

  static const BorderRadius card = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius control = BorderRadius.all(Radius.circular(md));
  static const BorderRadius chip = BorderRadius.all(Radius.circular(pill));
}

/// Subtle border widths used in place of heavy drop shadows.
abstract final class MindoraBorders {
  static const double thin = 1;
  static const double medium = 1.5;
}

/// Restrained elevation values.
abstract final class MindoraElevation {
  static const double none = 0;
  static const double subtle = 1;
}

/// Accessible component dimensions.
abstract final class MindoraDimensions {
  static const double minTouchTarget = 48;
  static const double buttonHeight = 48;
  static const double inputMinHeight = 52;
  static const double iconSm = 18;
  static const double iconMd = 22;
  static const double iconLg = 28;
  static const double maxReadableWidth = 640;
}

/// Calm, unhurried motion tokens.
abstract final class MindoraMotion {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration gentle = Duration(milliseconds: 400);
  static const Curve curve = Curves.easeOutCubic;
}
