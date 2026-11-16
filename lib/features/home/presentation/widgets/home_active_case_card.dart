import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/localization/app_strings.dart';
import '../../../../app/theme/mind_tokens.dart';
import '../../../../core/widgets/mind_badge.dart';
import '../../../../core/widgets/mind_button.dart';
import '../../../../core/widgets/mind_card.dart';
import '../../../investigation/domain/case_model.dart';

/// Clean, modular Active Case Card for HomeScreen.
/// Displays active investigation progress, stage indicator, and resume button.
class HomeActiveCaseCard extends StatelessWidget {
  const HomeActiveCaseCard({
    super.key,
    required this.caseModel,
    required this.tokens,
    required this.strings,
    required this.isDark,
    required this.onResume,
  });

  final CaseModel caseModel;
  final MindTokens tokens;
  final AppStrings strings;
  final bool isDark;
  final VoidCallback onResume;

  @override
  Widget build(BuildContext context) {
    final progress = caseModel.currentStage.stepNumber / 6.0;

    return MindCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              MindBadge(
                label:
                    '${strings.formatSessionNumber(caseModel.caseNumber)}  •  ${strings.stageNumberLabel(caseModel.currentStage.stepNumber)}',
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_ios_rounded, size: 12, color: tokens.ink2),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            caseModel.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15.5,
              color: tokens.ink,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: tokens.surface2,
              valueColor: AlwaysStoppedAnimation<Color>(tokens.m1),
            ),
          ),
          const SizedBox(height: 14),
          MindButton(
            text: strings.resumeInvestigation,
            variant: MindButtonVariant.primary,
            onPressed: () {
              HapticFeedback.mediumImpact();
              onResume();
            },
          ),
        ],
      ),
    );
  }
}
