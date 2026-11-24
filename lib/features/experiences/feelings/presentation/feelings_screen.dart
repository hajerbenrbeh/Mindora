import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system.dart';
import '../domain/emotion_catalogue.dart';
import '../domain/feelings_entry.dart';
import 'feelings_entry_card.dart';
import 'feelings_providers.dart';

/// Complete offline-first Feelings experience: creation, editing, and history.
class FeelingsScreen extends ConsumerStatefulWidget {
  const FeelingsScreen({super.key});

  @override
  ConsumerState<FeelingsScreen> createState() => _FeelingsScreenState();
}

class _FeelingsScreenState extends ConsumerState<FeelingsScreen> {
  final TextEditingController _customEmotionController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contextController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<EmotionItem> _selectedEmotions = [];
  bool _isEmotionUnsure = false;
  EmotionalTone? _overallTone;
  FeelingsEntry? _editingEntry;
  bool _isSaving = false;

  @override
  void dispose() {
    _customEmotionController.dispose();
    _descriptionController.dispose();
    _contextController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool get _hasAnyInput =>
      _selectedEmotions.isNotEmpty ||
      _isEmotionUnsure ||
      _overallTone != null ||
      _descriptionController.text.trim().isNotEmpty ||
      _contextController.text.trim().isNotEmpty;

  void _toggleEmotion(EmotionItem emotion) {
    setState(() {
      _isEmotionUnsure = false;
      final index = _selectedEmotions.indexWhere((e) => e.key == emotion.key);
      if (index >= 0) {
        _selectedEmotions.removeAt(index);
      } else {
        _selectedEmotions.add(emotion);
      }
    });
  }

  void _toggleUnsure(bool next) {
    setState(() {
      _isEmotionUnsure = next;
      if (next) {
        _selectedEmotions.clear();
      }
    });
  }

  Future<void> _addCustomEmotion() async {
    final created = EmotionCatalogue.createCustom(
      _customEmotionController.text,
    );
    if (created == null) return;

    final resolved = created.isCustom
        ? await ref.read(customEmotionsProvider.notifier).addOrReuse(created)
        : created;

    if (!mounted) return;
    setState(() {
      _isEmotionUnsure = false;
      if (!_selectedEmotions.any((e) => e.key == resolved.key)) {
        _selectedEmotions.add(resolved);
      }
      _customEmotionController.clear();
    });
  }

  void _startEditing(FeelingsEntry entry) {
    setState(() {
      _editingEntry = entry;
      _selectedEmotions
        ..clear()
        ..addAll(entry.emotions);
      _isEmotionUnsure = entry.isEmotionUnsure;
      _overallTone = entry.overallTone;
      _descriptionController.text = entry.description ?? '';
      _contextController.text = entry.contextNote ?? '';
    });

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: MindoraMotion.normal,
        curve: MindoraMotion.curve,
      );
    }
  }

  void _resetForm() {
    setState(() {
      _editingEntry = null;
      _selectedEmotions.clear();
      _isEmotionUnsure = false;
      _overallTone = null;
      _descriptionController.clear();
      _contextController.clear();
      _customEmotionController.clear();
    });
  }

  Future<void> _save() async {
    if (!_hasAnyInput || _isSaving) return;
    setState(() => _isSaving = true);

    try {
      final notifier = ref.read(feelingsHistoryProvider.notifier);
      final editing = _editingEntry;
      if (editing == null) {
        final entry = FeelingsEntry.create(
          emotions: List<EmotionItem>.from(_selectedEmotions),
          isEmotionUnsure: _isEmotionUnsure,
          overallTone: _overallTone,
          description: _descriptionController.text,
          contextNote: _contextController.text,
        );
        await notifier.saveNew(entry);
      } else {
        final updated = editing.copyForEdit(
          emotions: List<EmotionItem>.from(_selectedEmotions),
          isEmotionUnsure: _isEmotionUnsure,
          overallTone: _overallTone,
          description: _descriptionController.text,
          contextNote: _contextController.text,
        );
        await notifier.updateExisting(updated);
      }

      if (!mounted) return;
      final message = editing == null
          ? 'Saved to your space.'
          : 'Entry updated.';
      _resetForm();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final historyAsync = ref.watch(feelingsHistoryProvider);
    final customEmotions =
        ref.watch(customEmotionsProvider).asData?.value ??
        const <EmotionItem>[];
    final allEmotions = [...EmotionCatalogue.baseEmotions, ...customEmotions];

    return Scaffold(
      appBar: AppBar(title: const Text('Feelings')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: MindoraDimensions.maxReadableWidth,
            ),
            child: ListView(
              controller: _scrollController,
              padding: MindoraSpacing.pagePadding,
              children: [
                Text(
                  _editingEntry == null
                      ? 'What feels present right now?'
                      : 'Editing entry from ${_editingEntry!.localCalendarDate}',
                  style: textTheme.headlineMedium,
                ),
                const SizedBox(height: MindoraSpacing.xs),
                Text(
                  'Choose as many words as fit, add your own, or leave '
                  'emotions blank if words do not quite capture it.',
                  style: textTheme.bodyMedium,
                ),
                if (_editingEntry != null) ...[
                  const SizedBox(height: MindoraSpacing.sm),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: MindoraTextButton(
                      label: 'Cancel editing',
                      onPressed: _resetForm,
                    ),
                  ),
                ],
                const SizedBox(height: MindoraSpacing.lg),

                // Unsure option (explicitly distinct from empty selection)
                MindoraSelectableChip(
                  label: "I'm not sure",
                  selected: _isEmotionUnsure,
                  onSelected: _toggleUnsure,
                ),
                const SizedBox(height: MindoraSpacing.md),

                // Emotion chips
                Wrap(
                  spacing: MindoraSpacing.sm,
                  runSpacing: MindoraSpacing.sm,
                  children: allEmotions.map((emotion) {
                    final isSelected = _selectedEmotions.any(
                      (e) => e.key == emotion.key,
                    );
                    return MindoraSelectableChip(
                      label: emotion.label,
                      selected: isSelected,
                      onSelected: (_) => _toggleEmotion(emotion),
                    );
                  }).toList(),
                ),
                const SizedBox(height: MindoraSpacing.md),

                // Custom emotion input
                LayoutBuilder(
                  builder: (context, constraints) {
                    final input = MindoraTextField(
                      controller: _customEmotionController,
                      label: 'Add your own emotion word (optional)',
                      hintText: 'e.g., bittersweet, tender, foggy',
                      textInputAction: TextInputAction.done,
                    );
                    final addButton = MindoraSecondaryButton(
                      label: 'Add',
                      icon: Icons.add_rounded,
                      onPressed: _addCustomEmotion,
                    );

                    if (constraints.maxWidth < 360) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          input,
                          const SizedBox(height: MindoraSpacing.sm),
                          addButton,
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(child: input),
                        const SizedBox(width: MindoraSpacing.sm),
                        addButton,
                      ],
                    );
                  },
                ),
                const MindoraDivider(),

                // Optional overall emotional tone
                const MindoraSectionHeading(
                  title: 'Overall tone (optional)',
                  subtitle: 'Only if it helps — tap again to clear.',
                ),
                const SizedBox(height: MindoraSpacing.md),
                Wrap(
                  spacing: MindoraSpacing.sm,
                  runSpacing: MindoraSpacing.sm,
                  children: EmotionalTone.values.map((tone) {
                    return MindoraSelectableChip(
                      label: tone.label,
                      selected: _overallTone == tone,
                      onSelected: (selected) {
                        setState(() {
                          _overallTone = selected ? tone : null;
                        });
                      },
                    );
                  }).toList(),
                ),
                const MindoraDivider(),

                // Description & Context
                MindoraTextField(
                  controller: _descriptionController,
                  label: 'In your own words (optional)',
                  hintText: 'Describe what this feels like...',
                  minLines: 2,
                  maxLines: 5,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: MindoraSpacing.base),
                MindoraTextField(
                  controller: _contextController,
                  label: 'Context (optional)',
                  hintText: 'Anything happening around this moment...',
                  minLines: 2,
                  maxLines: 4,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: MindoraSpacing.lg),

                MindoraPrimaryButton(
                  label: _isSaving
                      ? 'Saving...'
                      : (_editingEntry == null
                            ? 'Save feeling'
                            : 'Update entry'),
                  icon: Icons.check_rounded,
                  isExpanded: true,
                  onPressed: _hasAnyInput && !_isSaving ? _save : null,
                ),
                const MindoraDivider(),

                // History section
                const MindoraSectionHeading(
                  title: 'Saved Feelings',
                  subtitle: 'Your recorded moments, most recent first.',
                ),
                const SizedBox(height: MindoraSpacing.md),
                historyAsync.when(
                  loading: () => const MindoraLoadingIndicator(
                    message: 'Loading your saved feelings...',
                  ),
                  error: (error, _) => MindoraSurface(
                    child: Text(
                      'Could not load saved entries right now.',
                      style: textTheme.bodyMedium,
                    ),
                  ),
                  data: (entries) {
                    if (entries.isEmpty) {
                      return const MindoraSurface(
                        child: MindoraEmptyState(
                          icon: Icons.water_drop_outlined,
                          title: 'No feelings saved yet',
                          description:
                              'Whenever you choose to save a moment above, it '
                              'will appear here with its timestamp.',
                        ),
                      );
                    }

                    return Column(
                      children: [
                        for (var i = 0; i < entries.length; i++) ...[
                          FeelingsEntryCard(
                            entry: entries[i],
                            onEdit: () => _startEditing(entries[i]),
                          ),
                          if (i < entries.length - 1)
                            const SizedBox(height: MindoraSpacing.sm),
                        ],
                      ],
                    );
                  },
                ),
                const SizedBox(height: MindoraSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
