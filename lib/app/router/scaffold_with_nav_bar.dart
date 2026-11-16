import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../localization/app_strings.dart';
import '../theme/lab_theme.dart';
import '../theme/mind_tokens.dart';

/// Floating frosted-glass bottom navigation shell matching prototype-v2 + Vercel Dark:
/// - Detached pill (`12px` inset, height `70`, radius `30`, `navGlass` + blur `20`, `1px line`)
/// - 5 balanced items (`Home`, `Track`, `AI Guide` center hero, `Insights`, `Profile`)
/// - Active capsule uses `tokens.navCapsuleFill` (`22%` Light / `14%` Dark `m1` tint)
/// - Center AI Guide button: `50px` `m2 -> m1` gradient circle with `4px bg` ring
class ScaffoldWithNavBar extends ConsumerWidget {
  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    HapticFeedback.lightImpact();
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final strings = ref.watch(appStringsProvider);
    final currentIndex = navigationShell.currentIndex;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Scaffold(
      backgroundColor: tokens.bg,
      body: navigationShell,
      bottomNavigationBar: ColoredBox(
        color: tokens.bg,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
            child: MediaQuery.withClampedTextScaling(
              minScaleFactor: 0.85,
              maxScaleFactor: 1.15,
              child: SizedBox(
                height: 82,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 70,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: tokens.navPillShadows,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: tokens.navGlass,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: tokens.line,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildStandardItem(
                              index: 0,
                              currentIndex: currentIndex,
                              icon: Icons.home_outlined,
                              activeIcon: Icons.home_rounded,
                              label: strings.navHome,
                              tokens: tokens,
                              reduceMotion: reduceMotion,
                            ),
                            _buildStandardItem(
                              index: 1,
                              currentIndex: currentIndex,
                              icon: Icons.adjust_outlined,
                              activeIcon: Icons.adjust_rounded,
                              label: strings.navTrack,
                              tokens: tokens,
                              reduceMotion: reduceMotion,
                            ),
                            _buildCenterHeroItem(
                              index: 2,
                              currentIndex: currentIndex,
                              icon: Icons.psychology_alt_outlined,
                              activeIcon: Icons.psychology_alt_rounded,
                              label: strings.navAiGuide,
                              tokens: tokens,
                              reduceMotion: reduceMotion,
                            ),
                            _buildStandardItem(
                              index: 3,
                              currentIndex: currentIndex,
                              icon: Icons.auto_stories_outlined,
                              activeIcon: Icons.auto_stories_rounded,
                              label: strings.navInsights,
                              tokens: tokens,
                              reduceMotion: reduceMotion,
                            ),
                            _buildStandardItem(
                              index: 4,
                              currentIndex: currentIndex,
                              icon: Icons.person_outline_rounded,
                              activeIcon: Icons.person_rounded,
                              label: strings.navProfile,
                              tokens: tokens,
                              reduceMotion: reduceMotion,
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildStandardItem({
    required int index,
    required int currentIndex,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required MindTokens tokens,
    required bool reduceMotion,
  }) {
    final isSelected = index == currentIndex;

    return Expanded(
      child: Semantics(
        button: true,
        selected: isSelected,
        child: MergeSemantics(
          child: InkWell(
            onTap: () => _onTap(index),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: SizedBox(
              height: 70,
              child: Center(
                child: AnimatedContainer(
                  duration: reduceMotion
                      ? Duration.zero
                      : const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  height: 58,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? tokens.navCapsuleFill
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isSelected ? activeIcon : icon,
                        size: 20,
                        color: isSelected ? tokens.ink : tokens.ink3,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: LabTheme.fontFamily,
                          fontFamilyFallback: LabTheme.fontFallback,
                          fontSize: 11.5,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: isSelected ? tokens.ink : tokens.ink3,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCenterHeroItem({
    required int index,
    required int currentIndex,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required MindTokens tokens,
    required bool reduceMotion,
  }) {
    final isSelected = index == currentIndex;

    return Expanded(
      child: Semantics(
        button: true,
        selected: isSelected,
        child: MergeSemantics(
          child: InkWell(
            onTap: () => _onTap(index),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: SizedBox(
              height: 82,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedScale(
                    scale: isSelected && !reduceMotion ? 1.06 : 1.0,
                    duration: reduceMotion
                        ? Duration.zero
                        : const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [tokens.m2, tokens.m1],
                        ),
                        border: Border.all(color: tokens.bg, width: 4.0),
                        boxShadow: tokens.navCenterShadows,
                      ),
                      child: Icon(
                        isSelected ? activeIcon : icon,
                        size: 21,
                        color: tokens.onMood,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: LabTheme.fontFamily,
                        fontFamilyFallback: LabTheme.fontFallback,
                        fontSize: 11.5,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w600,
                        color: isSelected ? tokens.ink : tokens.ink3,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
