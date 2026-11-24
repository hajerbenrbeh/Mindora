import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/mindora_theme.dart';
import 'router.dart';

/// Root widget for the Mindora application.
class MindoraApp extends ConsumerWidget {
  const MindoraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Mindora',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      themeMode: themeMode,
      theme: MindoraTheme.light(),
      darkTheme: MindoraTheme.dark(),
    );
  }
}
