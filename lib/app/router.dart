import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/preview/design_system_showcase.dart';

/// Holds the active [ThemeMode] for Milestone 1 preview verification.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.light;

  void setDarkMode(bool isDark) {
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

/// Provides the root [GoRouter] instance for Mindora.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Consumer(
          builder: (context, ref, _) {
            final mode = ref.watch(themeModeProvider);
            return DesignSystemShowcaseScreen(
              isDarkMode: mode == ThemeMode.dark,
              onToggleTheme: (isDark) =>
                  ref.read(themeModeProvider.notifier).setDarkMode(isDark),
            );
          },
        ),
      ),
    ],
  );
});
