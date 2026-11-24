import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';

/// Root widget for the Mindora application.
class MindoraApp extends ConsumerWidget {
  const MindoraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Mindora',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7EFE3),
        colorScheme: const ColorScheme.light(
          surface: Color(0xFFF7EFE3),
          onSurface: Color(0xFF35452B),
          primary: Color(0xFF35452B),
          onPrimary: Color(0xFFF7EFE3),
          secondary: Color(0xFFA8B18A),
          onSecondary: Color(0xFF35452B),
        ),
      ),
    );
  }
}
