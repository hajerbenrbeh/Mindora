import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/preview/design_system_showcase.dart';
import '../features/clarity/presentation/clarity_screen.dart';
import '../features/experiences/feelings/presentation/feelings_screen.dart';
import '../features/experiences/presentation/experience_placeholder_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/home/presentation/widgets/exploration_portals.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/toolkit/presentation/toolkit_screen.dart';
import '../features/track/presentation/track_screen.dart';
import 'shell/mindora_shell_scaffold.dart';

/// Holds the active [ThemeMode] for in-memory theme switching.
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

/// Provides the root [GoRouter] instance with a persistent 5-tab shell
/// and independent experience placeholder routes.
final appRouterProvider = Provider<GoRouter>((ref) {
  final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MindoraShellScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: GlobalKey<NavigatorState>(debugLabel: 'homeBranch'),
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: GlobalKey<NavigatorState>(debugLabel: 'trackBranch'),
            routes: [
              GoRoute(
                path: '/track',
                builder: (context, state) => const TrackScreen(),
                routes: [
                  GoRoute(
                    path: 'detail',
                    builder: (context, state) =>
                        const TrackNestedPlaceholderScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: GlobalKey<NavigatorState>(
              debugLabel: 'clarityBranch',
            ),
            routes: [
              GoRoute(
                path: '/clarity',
                builder: (context, state) => const ClarityScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: GlobalKey<NavigatorState>(
              debugLabel: 'toolkitBranch',
            ),
            routes: [
              GoRoute(
                path: '/toolkit',
                builder: (context, state) => const ToolkitScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: GlobalKey<NavigatorState>(
              debugLabel: 'profileBranch',
            ),
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // Feelings experience (Milestone 4)
      GoRoute(
        path: '/experiences/feelings',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const FeelingsScreen(),
      ),

      // Remaining four experience placeholder routes (Milestone 5)
      for (final portal in mindoraPortals.where(
        (p) => p.route != '/experiences/feelings',
      ))
        GoRoute(
          path: portal.route,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => ExperiencePlaceholderScreen(
            title: portal.title,
            description: portal.description,
            icon: portal.icon,
            milestoneNote:
                'Placeholder for Milestone 3. The full ${portal.title} '
                'recording experience will be implemented in a later milestone.',
          ),
        ),

      GoRoute(
        path: '/design-system',
        parentNavigatorKey: rootNavigatorKey,
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
