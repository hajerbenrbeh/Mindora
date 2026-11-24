import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Provides the root [GoRouter] instance for Mindora.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const _MilestoneZeroLandingScreen(),
      ),
    ],
  );
});

class _MilestoneZeroLandingScreen extends StatelessWidget {
  const _MilestoneZeroLandingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Mindora',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF35452B),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Foundation initialized.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Color(0xFF35452B)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
