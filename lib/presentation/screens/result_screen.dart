/// Result screen for displaying the generated excuse.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:excuse_me/core/theme/app_theme.dart';
import 'package:excuse_me/presentation/viewmodels/excuse_providers.dart';
import 'package:excuse_me/presentation/widgets/editable_text_card.dart';
import 'package:excuse_me/presentation/widgets/primary_button.dart';

/// Screen displaying the generated excuse with copy/regenerate actions.
class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(excuseNotifierProvider);
    final notifier = ref.read(excuseNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Excuse'),
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
              // Success indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppTheme.success,
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Excuse ready!',
                      style: TextStyle(
                        color: AppTheme.success,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppTheme.paddingLarge),

              // Hint
              Text(
                'Tap to edit if needed',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 12),

              // Excuse text card
              Expanded(
                child: EditableTextCard(
                  text: state.generatedExcuse ?? '',
                  onChanged: notifier.updateExcuseText,
                ),
              ),

              const SizedBox(height: AppTheme.paddingLarge),

              // Copy button
              PrimaryButton(
                label: 'Copy to Clipboard',
                icon: Icons.copy,
                onPressed: () async {
                  final text = state.generatedExcuse ?? '';
                  await Clipboard.setData(ClipboardData(text: text));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.check, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text('Copied to clipboard!'),
                          ],
                        ),
                        backgroundColor: AppTheme.success,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),

              const SizedBox(height: 12),

              // Regenerate button
              PrimaryButton(
                label: 'Regenerate',
                icon: Icons.refresh,
                outlined: true,
                isLoading: state.isLoading,
                onPressed: () async {
                  await notifier.regenerate();
                },
              ),

              const SizedBox(height: 12),

              // Start over button
              TextButton(
                onPressed: () {
                  notifier.clear();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Center(
                  child: Text('Start Over'),
                ),
              ),

              const SizedBox(height: AppTheme.padding),
            ],
          ),
        ),
      ),
    );
  }
}
