/// Result screen for displaying the generated excuse.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:excuse_me/core/theme/app_theme.dart';
import 'package:excuse_me/core/utils/haptics.dart';
import 'package:excuse_me/presentation/viewmodels/excuse_providers.dart';
import 'package:excuse_me/presentation/widgets/editable_text_card.dart';
import 'package:excuse_me/presentation/widgets/primary_button.dart';
import 'package:excuse_me/presentation/widgets/skeleton_card.dart';

/// Screen displaying the generated excuse with copy/regenerate actions.
class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({super.key});

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen>
    with SingleTickerProviderStateMixin {
  bool _showCopied = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
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
    _fadeController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    Haptics.success();
    setState(() => _showCopied = true);

    // Revert after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _showCopied = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
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
              ),

              const SizedBox(height: AppTheme.paddingLarge),

              // Hint
              Text(
                'Tap to edit if needed',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 12),

              // Excuse text card or skeleton
              Expanded(
                child: state.isLoading
                    ? const SkeletonCard()
                    : FadeTransition(
                        opacity: _fadeAnimation,
                        child: EditableTextCard(
                          text: state.generatedExcuse ?? '',
                          onChanged: notifier.updateExcuseText,
                        ),
                      ),
              ),

              const SizedBox(height: AppTheme.paddingLarge),

              // Copy button with success state
              PrimaryButton(
                label: _showCopied ? 'Copied!' : 'Copy to Clipboard',
                icon: _showCopied ? Icons.check : Icons.copy,
                showSuccess: _showCopied,
                onPressed: () {
                  _copyToClipboard(state.generatedExcuse ?? '');
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
                  // Trigger fade out/in animation
                  await _fadeController.reverse();
                  await notifier.regenerate();
                  _fadeController.forward();
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
