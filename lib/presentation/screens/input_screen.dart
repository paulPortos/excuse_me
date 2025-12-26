/// Input screen for collecting event message or category.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:excuse_me/core/theme/app_theme.dart';
import 'package:excuse_me/core/utils/page_transitions.dart';
import 'package:excuse_me/domain/entities/excuse_options.dart';
import 'package:excuse_me/presentation/screens/options_screen.dart';
import 'package:excuse_me/presentation/viewmodels/excuse_providers.dart';
import 'package:excuse_me/presentation/widgets/category_chip.dart';
import 'package:excuse_me/presentation/widgets/primary_button.dart';

/// Screen where users paste a message or select a scenario.
class InputScreen extends ConsumerStatefulWidget {
  const InputScreen({super.key});

  @override
  ConsumerState<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends ConsumerState<InputScreen>
    with SingleTickerProviderStateMixin {
  final _textController = TextEditingController();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _textController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(excuseNotifierProvider);
    final notifier = ref.read(excuseNotifierProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppTheme.paddingLarge),

                // Header
                Text(
                  'Excuse Me 👋',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Paste an event message or pick a scenario',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: AppTheme.paddingXL),

                // Text input
                TextField(
                  controller: _textController,
                  onChanged: notifier.setEventMessage,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Paste the event message here...',
                    alignLabelWithHint: true,
                  ),
                ),

                const SizedBox(height: AppTheme.paddingLarge),

                // OR divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: AppTheme.textHint.withValues(alpha: 0.3),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR pick a scenario',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: AppTheme.textHint.withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppTheme.paddingLarge),

                // Category chips
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ExcuseCategory.work,
                    ExcuseCategory.school,
                    ExcuseCategory.social,
                    ExcuseCategory.family,
                  ].map((category) {
                    return CategoryChip(
                      category: category,
                      isSelected: state.selectedCategory == category,
                      onTap: () {
                        if (state.selectedCategory == category) {
                          notifier.setCategory(null);
                        } else {
                          notifier.setCategory(category);
                        }
                      },
                    );
                  }).toList(),
                ),

                const Spacer(),

                // Error message
                if (state.errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.error.withValues(alpha: 0.1),
                      borderRadius:
                          BorderRadius.circular(AppTheme.borderRadiusSmall),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: AppTheme.error, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            state.errorMessage!,
                            style: const TextStyle(color: AppTheme.error),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.padding),
                ],

                // Continue button
                PrimaryButton(
                  label: 'Continue',
                  icon: Icons.arrow_forward,
                  onPressed: state.hasInput
                      ? () {
                          Navigator.of(context).push(
                            SlidePageRoute(page: const OptionsScreen()),
                          );
                        }
                      : null,
                ),

                const SizedBox(height: AppTheme.padding),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
