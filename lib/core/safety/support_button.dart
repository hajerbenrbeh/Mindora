import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/localization/app_strings.dart';
import '../../app/theme/mind_tokens.dart';
import '../widgets/mind_pressable.dart';
import 'safety_model.dart';

/// Persistent, low-noise one-tap safety shield reachable from every mode.
class SupportButton extends ConsumerWidget {
  const SupportButton({super.key, this.compact = false});

  /// Retained for caller compatibility; [SupportButton] always renders a calm
  /// icon-only 48x48dp shield badge without intrusive navigation banner copy.
  final bool compact;

  void _openSupportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const SupportModalSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final tokens = context.tokens;

    return Tooltip(
      message: strings.needSupportBtn,
      excludeFromSemantics: true,
      child: MindPressable(
        onPressed: () => _openSupportSheet(context),
        semanticLabel: strings.needSupportBtn,
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: tokens.safetySoft,
                shape: BoxShape.circle,
                border: Border.all(
                  color: tokens.safety.withValues(alpha: 0.35),
                  width: 1.0,
                ),
              ),
              child: Icon(
                Icons.shield_outlined,
                size: 19,
                color: tokens.safety,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The modal bottom sheet presenting Tunisian crisis and supportive resources.
class SupportModalSheet extends ConsumerWidget {
  const SupportModalSheet({super.key});

  /// Static entry point to display the support crisis sheet from any context.
  static Future<void> show(BuildContext context) {
    HapticFeedback.lightImpact();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const SupportModalSheet(),
    );
  }

  Future<void> _makeCall(
    BuildContext context,
    AppStrings strings,
    String phone,
  ) async {
    HapticFeedback.mediumImpact();
    final uri = Uri.parse('tel:$phone');
    var launched = false;
    try {
      if (await canLaunchUrl(uri)) {
        launched = await launchUrl(uri);
      }
    } catch (_) {
      launched = false;
    }
    if (!launched) {
      await Clipboard.setData(ClipboardData(text: _formatPhone(phone)));
      if (context.mounted) {
        final msg = strings.isArabic
            ? 'تعذر فتح الاتصال — تم نسخ الرقم: ${_formatPhone(phone)}'
            : (strings.isFrench
                ? 'Appel indisponible — numéro copié : ${_formatPhone(phone)}'
                : 'Dialer unavailable — number copied: ${_formatPhone(phone)}');
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(content: Text(msg)),
        );
      }
    }
  }

  Future<void> _openWeb(
    BuildContext context,
    AppStrings strings,
    String url,
  ) async {
    final uri = Uri.parse(url);
    var launched = false;
    try {
      if (await canLaunchUrl(uri)) {
        launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      launched = false;
    }
    if (!launched) {
      await Clipboard.setData(ClipboardData(text: url));
      if (context.mounted) {
        final msg = strings.isArabic
            ? 'تم نسخ الرابط: $url'
            : (strings.isFrench
                ? 'Lien copié : $url'
                : 'Link copied: $url');
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(content: Text(msg)),
        );
      }
    }
  }

  String _formatPhone(String raw) {
    if (raw == '80105050') return '80 10 50 50';
    return raw;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final strings = ref.watch(appStringsProvider);
    final resources = CrisisResource.tunisianResources;

    final sheetBg = tokens.surface;
    final cardBg = tokens.surface2;
    final borderColor = tokens.line;
    final textPrimary = tokens.ink;
    final textSecondary = tokens.ink2;

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
          border: Border.all(color: borderColor, width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: tokens.safetySoft,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.shield_outlined,
                    color: tokens.safety, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.supportModalTitle,
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: textPrimary),
                    ),
                    Text(
                      strings.supportModalSub,
                      style: TextStyle(fontSize: 11.5, color: textSecondary),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, size: 18, color: textSecondary),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            strings.supportModalBody,
            style: TextStyle(
              fontSize: 12.5,
              color: textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: resources.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (ctx, index) {
                final res = resources[index];
                final hasPhone = res.phone.isNotEmpty;

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor, width: 1),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              res.localizedName(strings),
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              res.localizedDescription(strings),
                              style: TextStyle(
                                fontSize: 11.5,
                                color: textSecondary,
                              ),
                            ),
                            if (res.isTollFree) ...[
                              const SizedBox(height: 2),
                              Text(
                                strings.isArabic
                                    ? 'مجاني 24/7'
                                    : (strings.isFrench
                                        ? 'Gratuit 24/7'
                                        : 'Toll-free 24/7'),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: tokens.m1,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (hasPhone)
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: tokens.safety,
                            foregroundColor: tokens.bg,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.phone_outlined, size: 14),
                          label: Text(
                            _formatPhone(res.phone),
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
                          ),
                          onPressed: () => _makeCall(context, strings, res.phone),
                        )
                      else if (res.website != null)
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: borderColor),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          onPressed: () => _openWeb(context, strings, res.website!),
                          child: Text(
                            strings.isArabic
                                ? 'معلومات'
                                : (strings.isFrench ? 'INFO' : 'INFO'),
                            style: TextStyle(color: textPrimary, fontSize: 11, fontWeight: FontWeight.w700),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    ),
  );
}
}
