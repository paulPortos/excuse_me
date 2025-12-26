/// Tone selector widget for excuse tone selection.
library;

import 'package:flutter/material.dart';

import 'package:excuse_me/core/theme/app_theme.dart';
import 'package:excuse_me/domain/entities/excuse_options.dart';

/// A segmented control for selecting excuse tone.
class ToneSelector extends StatelessWidget {
  /// Currently selected tone.
  final ExcuseTone selectedTone;

  /// Callback when tone is changed.
  final ValueChanged<ExcuseTone> onChanged;

  const ToneSelector({
    super.key,
    required this.selectedTone,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        border: Border.all(
          color: AppTheme.textHint.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: ExcuseTone.values.map((tone) {
          final isSelected = tone == selectedTone;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(tone),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius - 2),
                ),
                child: Text(
                  _labelForTone(tone),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _labelForTone(ExcuseTone tone) {
    switch (tone) {
      case ExcuseTone.formal:
        return 'Formal';
      case ExcuseTone.polite:
        return 'Polite';
      case ExcuseTone.casual:
        return 'Casual';
    }
  }
}

/// A segmented control for selecting excuse length.
class LengthSelector extends StatelessWidget {
  /// Currently selected length.
  final ExcuseLength selectedLength;

  /// Callback when length is changed.
  final ValueChanged<ExcuseLength> onChanged;

  const LengthSelector({
    super.key,
    required this.selectedLength,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        border: Border.all(
          color: AppTheme.textHint.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: ExcuseLength.values.map((length) {
          final isSelected = length == selectedLength;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(length),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius - 2),
                ),
                child: Text(
                  length == ExcuseLength.short ? 'Short' : 'Long',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
