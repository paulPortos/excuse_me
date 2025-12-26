/// Options screen for fine-tuning excuse settings.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:excuse_me/core/theme/app_theme.dart';
import 'package:excuse_me/core/utils/haptics.dart';
import 'package:excuse_me/core/utils/page_transitions.dart';
import 'package:excuse_me/presentation/screens/result_screen.dart';
import 'package:excuse_me/presentation/viewmodels/excuse_providers.dart';
import 'package:excuse_me/presentation/widgets/primary_button.dart';
import 'package:excuse_me/presentation/widgets/tone_selector.dart';

/// Screen for adjusting tone, length, and reschedule options.
class OptionsScreen extends ConsumerWidget {
  const OptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(excuseNotifierProvider);
    final notifier = ref.read(excuseNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Options'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tone section
              Text(
                'Tone',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'How formal should your excuse sound?',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              ToneSelector(
                selectedTone: state.selectedTone,
                onChanged: (tone) {
                  Haptics.lightTap();
                  notifier.setTone(tone);
                },
              ),

              const SizedBox(height: AppTheme.paddingXL),

              // Length section
              Text(
                'Length',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Short and sweet, or with more context?',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              LengthSelector(
                selectedLength: state.selectedLength,
                onChanged: (length) {
                  Haptics.lightTap();
                  notifier.setLength(length);
                },
              ),

              const SizedBox(height: AppTheme.paddingXL),

              // Reschedule toggle
              Container(
                padding: const EdgeInsets.all(AppTheme.padding),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  border: Border.all(
                    color: AppTheme.textHint.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Offer to reschedule?',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Suggest meeting another time',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: state.wantReschedule,
                      onChanged: (value) {
                        Haptics.lightTap();
                        notifier.setReschedule(value);
                      },
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Generate button
              PrimaryButton(
                label: 'Generate Excuse',
                icon: Icons.auto_awesome,
                isLoading: state.isLoading,
                onPressed: () async {
                  await notifier.generateExcuse();
                  if (context.mounted) {
                    final newState = ref.read(excuseNotifierProvider);
                    if (newState.generatedExcuse != null) {
                      Haptics.success();
                      Navigator.of(context).push(
                        SlidePageRoute(page: const ResultScreen()),
                      );
                    }
                  }
                },
              ),

              const SizedBox(height: AppTheme.padding),
            ],
          ),
        ),
      ),
    );
  }
}
