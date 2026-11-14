import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/app_strings.dart';
import '../../../../app/theme/lab_colors.dart';
import '../../../profile/controllers/profile_controller.dart';
import '../../controllers/observatory_controllers.dart';
import '../../domain/symptom_entry.dart';
import '../../domain/symptom_report.dart';
import 'custom_symptom_sheet.dart';
import 'symptom_assessment_sheet.dart';

class SymptomLibraryView extends ConsumerStatefulWidget {
  const SymptomLibraryView({super.key});

  @override
  ConsumerState<SymptomLibraryView> createState() => _SymptomLibraryViewState();
}

class _SymptomLibraryViewState extends ConsumerState<SymptomLibraryView> {
  bool _showHistory = false;

  Future<void> _confirmDeleteReport(
    BuildContext context,
    SymptomReport report,
    AppStrings strings,
    bool isDark,
  ) async {
    final isAr = strings.isArabic;
    final dialogBg = isDark ? LabColors.nightSurface : LabColors.daylightSurface;
    final borderColor = isDark ? LabColors.nightBorder : LabColors.daylightBorder;
    final textPrimary = isDark ? LabColors.nightTextPrimary : LabColors.daylightTextPrimary;
    final textSecondary = isDark ? LabColors.nightTextSecondary : LabColors.daylightTextSecondary;
    final deleteColor = isDark ? LabColors.safetyWarmthDark : LabColors.safetyWarmth;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: dialogBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: borderColor),
        ),
        title: Text(
          isAr
              ? 'حذف سجل العرض؟'
              : (strings.isFrench
                  ? 'Supprimer ce bilan ?'
                  : 'Delete symptom log?'),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        content: Text(
          isAr
              ? 'سيتم حذف هذا التقييم من سجلك المحلي بشكل نهائي.'
              : (strings.isFrench
                  ? 'Ce rapport sera supprimé définitivement de votre historique local.'
                  : 'This logged symptom check will be permanently removed from local history.'),
          style: TextStyle(
            fontSize: 13,
            height: 1.45,
            color: textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              strings.cancelBtn,
              style: TextStyle(color: textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              strings.deleteEntryBtn,
              style: TextStyle(
                color: deleteColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref
          .read(symptomReportsControllerProvider.notifier)
          .deleteReport(report.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final strings = ref.watch(appStringsProvider);
    final isAr = strings.isArabic;

    final surfaceColor = isDark ? LabColors.nightSurface : LabColors.daylightSurface;
    final borderColor = isDark ? LabColors.nightBorder : LabColors.daylightBorder;
    final textPrimary = isDark ? LabColors.nightTextPrimary : LabColors.daylightTextPrimary;
    final textSecondary = isDark ? LabColors.nightTextSecondary : LabColors.daylightTextSecondary;

    final filteredSymptoms = ref.watch(filteredSymptomsProvider);
    final selectedIds = ref.watch(selectedSymptomIdsProvider);
    final activeDomain = ref.watch(selectedDomainFilterProvider);
    final profile = ref.watch(profileControllerProvider).value;
    final reports = ref.watch(symptomReportsControllerProvider).value ?? const <SymptomReport>[];
    final allSymptoms = ref.watch(symptomListControllerProvider).value ?? const <SymptomEntry>[];

    return Column(
      children: [
        // 0. Library vs Saved Reports Switcher
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: Text(
                    isAr
                        ? 'مكتبة الأعراض'
                        : (strings.isFrench ? 'Bibliothèque' : 'Symptom Library'),
                  ),
                  selected: !_showHistory,
                  onSelected: (_) => setState(() => _showHistory = false),
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: !_showHistory ? FontWeight.w700 : FontWeight.w500,
                    color: !_showHistory ? textPrimary : textSecondary,
                  ),
                  backgroundColor: surfaceColor,
                  selectedColor: LabColors.sageGreen.withValues(alpha: 0.22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: !_showHistory ? LabColors.sageGreen : borderColor,
                    ),
                  ),
                  showCheckmark: false,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ChoiceChip(
                  label: Text(
                    isAr
                        ? 'السجل المحفوظ (${reports.length})'
                        : (strings.isFrench
                            ? 'Historique (${reports.length})'
                            : 'Saved Logs (${reports.length})'),
                  ),
                  selected: _showHistory,
                  onSelected: (_) => setState(() => _showHistory = true),
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: _showHistory ? FontWeight.w700 : FontWeight.w500,
                    color: _showHistory ? textPrimary : textSecondary,
                  ),
                  backgroundColor: surfaceColor,
                  selectedColor: LabColors.sageGreen.withValues(alpha: 0.22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: _showHistory ? LabColors.sageGreen : borderColor,
                    ),
                  ),
                  showCheckmark: false,
                ),
              ),
            ],
          ),
        ),
        if (_showHistory) ...[
          const SizedBox(height: 10),
          Expanded(
            child: reports.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        isAr
                            ? 'لم يتم حفظ أي تقييم للأعراض بعد. اختر عرضاً من المكتبة لتسجيل ملاحظة.'
                            : (strings.isFrench
                                ? 'Aucun bilan enregistré pour le moment. Sélectionnez un ressenti dans la bibliothèque pour le noter.'
                                : 'No symptom logs saved yet. Select one or more items from the library to record an observation.'),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: textSecondary, fontSize: 12.5, height: 1.45),
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                    itemCount: reports.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final r = reports[index];
                      final symptomTitles = r.symptomIds.map((id) {
                        final match = allSymptoms.where((s) => s.id == id);
                        return match.isNotEmpty ? match.first.title(strings) : id;
                      }).join(', ');
                      final timeStr =
                          '${r.createdAt.hour.toString().padLeft(2, '0')}:${r.createdAt.minute.toString().padLeft(2, '0')}';

                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${r.dateKey} • $timeStr',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: textSecondary,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: LabColors.sageGreen.withValues(alpha: 0.16),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '${r.intensity}/10',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: LabColors.sageGreen,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  tooltip: strings.deleteEntryBtn,
                                  icon: Icon(Icons.delete_outline_rounded, size: 18, color: textSecondary),
                                  onPressed: () => _confirmDeleteReport(context, r, strings, isDark),
                                ),
                              ],
                            ),
                            if (symptomTitles.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                symptomTitles,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: textPrimary,
                                ),
                              ),
                            ],
                            if (r.aiAnalysis != null && r.aiAnalysis!.trim().isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                r.aiAnalysis!.trim(),
                                style: TextStyle(
                                  fontSize: 12,
                                  height: 1.4,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                            if (r.stabilizingStrategy != null &&
                                r.stabilizingStrategy!.trim().isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: LabColors.sageGreen.withValues(alpha: 0.10),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: LabColors.sageGreen.withValues(alpha: 0.35),
                                  ),
                                ),
                                child: Text(
                                  r.stabilizingStrategy!.trim(),
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    height: 1.35,
                                    color: textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ] else ...[
        // 1. Search Bar & Add Custom Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (q) => ref.read(symptomSearchQueryProvider.notifier).setQuery(q),
                  style: TextStyle(color: textPrimary, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: isAr
                        ? 'ابحث في كافة الأعراض والتجارب...'
                        : (strings.isFrench
                            ? 'Rechercher parmi tous les ressentis...'
                            : 'Search across all symptoms...'),
                    hintStyle: TextStyle(
                      color: textSecondary.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                    prefixIcon: Icon(Icons.search_rounded, size: 18, color: textSecondary),
                    filled: true,
                    fillColor: surfaceColor,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: LabColors.sageGreen, width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.outlined(
                tooltip: isAr
                    ? 'إضافة تجربة خاصة'
                    : (strings.isFrench
                        ? 'Ajouter un ressenti personnalisé'
                        : 'Add custom symptom'),
                icon: const Icon(Icons.add_rounded, size: 20),
                style: IconButton.styleFrom(
                  foregroundColor: textPrimary,
                  side: BorderSide(color: borderColor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => CustomSymptomSheet.show(context),
              ),
            ],
          ),
        ),

        // 2. Domain / Category Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              ChoiceChip(
                label: Text(isAr ? 'الكل' : (strings.isFrench ? 'Tout' : 'All')),
                selected: activeDomain == null,
                onSelected: (_) =>
                    ref.read(selectedDomainFilterProvider.notifier).select(null),
                labelStyle: TextStyle(
                  fontSize: 11,
                  fontWeight: activeDomain == null ? FontWeight.w700 : FontWeight.w500,
                  color: activeDomain == null ? textPrimary : textSecondary,
                ),
                backgroundColor: surfaceColor,
                selectedColor: LabColors.sageGreen.withValues(alpha: 0.25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  side: BorderSide(
                    color: activeDomain == null ? LabColors.sageGreen : borderColor,
                  ),
                ),
                showCheckmark: false,
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(width: 6),
              ...SymptomDomain.values.map((d) {
                final isSelected = activeDomain == d;
                return Padding(
                  padding: const EdgeInsetsDirectional.only(end: 6),
                  child: ChoiceChip(
                    label: Text(d.localized(strings)),
                    selected: isSelected,
                    onSelected: (_) =>
                        ref.read(selectedDomainFilterProvider.notifier).select(
                            isSelected ? null : d),
                    labelStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? textPrimary : textSecondary,
                    ),
                    backgroundColor: surfaceColor,
                    selectedColor: LabColors.sageGreen.withValues(alpha: 0.25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(
                        color: isSelected ? LabColors.sageGreen : borderColor,
                      ),
                    ),
                    showCheckmark: false,
                    visualDensity: VisualDensity.compact,
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // 3. Symptoms List
        Expanded(
          child: filteredSymptoms.isEmpty
              ? Center(
                  child: Text(
                    isAr
                        ? 'لم يتم العثور على أعراض مطابقة'
                        : (strings.isFrench
                            ? 'Aucun ressenti correspondant trouvé'
                            : 'No matching symptoms found'),
                    style: TextStyle(color: textSecondary, fontSize: 12.5),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                  itemCount: filteredSymptoms.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final symptom = filteredSymptoms[index];
                    final isSelected = selectedIds.contains(symptom.id);

                    return InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        HapticFeedback.selectionClick();
                        ref.read(selectedSymptomIdsProvider.notifier).toggle(symptom.id);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? LabColors.sageGreen.withValues(alpha: 0.12)
                              : surfaceColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? LabColors.sageGreen : borderColor,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: isSelected,
                              activeColor: LabColors.sageGreen,
                              checkColor: Colors.black,
                              visualDensity: VisualDensity.compact,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              onChanged: (_) {
                                ref.read(selectedSymptomIdsProvider.notifier).toggle(symptom.id);
                              },
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          symptom.title(strings),
                                          style: TextStyle(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w700,
                                            color: textPrimary,
                                          ),
                                        ),
                                      ),
                                      if (symptom.isCustom)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: LabColors.warmBeige.withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            isAr
                                                ? 'خاص'
                                                : (strings.isFrench
                                                    ? 'PERSO'
                                                    : 'CUSTOM'),
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w800,
                                              color: textSecondary,
                                            ),
                                          ),
                                        ),
                                      if (profile?.selectedSymptoms.contains(symptom.id) == true) ...[
                                        const SizedBox(width: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: LabColors.sageGreenGlow.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            isAr
                                                ? 'من ملفك'
                                                : (strings.isFrench
                                                    ? 'PROFIL'
                                                    : 'INTAKE'),
                                            style: const TextStyle(
                                              fontSize: 8.5,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 0.3,
                                              color: LabColors.sageGreenGlow,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    symptom.description(strings),
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: textSecondary,
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),

        // 4. Floating Multi-Symptom Action Bar
        if (selectedIds.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: surfaceColor,
              border: Border(top: BorderSide(color: borderColor)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAr
                              ? '${selectedIds.length} تجارب محددة'
                              : '${selectedIds.length} symptoms selected',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                        InkWell(
                          onTap: () =>
                              ref.read(selectedSymptomIdsProvider.notifier).clear(),
                          child: Text(
                            isAr
                                ? 'إلغاء التحديد'
                                : (strings.isFrench
                                    ? 'Tout désélectionner'
                                    : 'Clear selection'),
                            style: TextStyle(fontSize: 11, color: textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      final all = ref.read(filteredSymptomsProvider);
                      final selected =
                          all.where((s) => selectedIds.contains(s.id)).toList();
                      SymptomAssessmentSheet.show(context, selectedSymptoms: selected);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: textPrimary,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    ),
                    child: Text(
                      isAr
                          ? 'تقييم الأعراض الآن'
                          : (strings.isFrench
                              ? 'Évaluer ces ressentis'
                              : 'Assess Symptoms'),
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
