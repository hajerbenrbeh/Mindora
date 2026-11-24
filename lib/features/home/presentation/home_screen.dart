import 'package:flutter/material.dart';

import '../../../core/design_system.dart';
import 'widgets/dimensions_overview.dart';
import 'widgets/exploration_portals.dart';
import 'widgets/home_welcome_header.dart';
import 'widgets/living_tapestry.dart';
import 'widgets/recent_activity_section.dart';

/// Mindora's welcoming Home experience featuring the Hybrid Living Tapestry,
/// four wellbeing dimensions, five independent portals, and recent activity.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: MindoraDimensions.maxReadableWidth,
            ),
            child: ListView(
              padding: MindoraSpacing.pagePadding,
              children: const [
                HomeWelcomeHeader(),
                SizedBox(height: MindoraSpacing.lg),
                LivingTapestryCard(),
                SizedBox(height: MindoraSpacing.xl),
                DimensionsOverviewSection(),
                SizedBox(height: MindoraSpacing.xl),
                ExplorationPortalsSection(),
                SizedBox(height: MindoraSpacing.xl),
                RecentActivitySection(),
                SizedBox(height: MindoraSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
