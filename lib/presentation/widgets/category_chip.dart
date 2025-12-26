/// Category chip widget for scenario selection.
library;

import 'package:flutter/material.dart';

import 'package:excuse_me/core/theme/app_theme.dart';
import 'package:excuse_me/domain/entities/excuse_options.dart';

/// A selectable chip for category/scenario selection.
class CategoryChip extends StatelessWidget {
  /// The category this chip represents.
  final ExcuseCategory category;

  /// Whether this chip is currently selected.
  final bool isSelected;

  /// Callback when the chip is tapped.
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withValues(alpha: 0.15)
              : AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          border: Border.all(
            color: isSelected
                ? AppTheme.primary
                : AppTheme.textHint.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _iconForCategory(category),
              size: 20,
              color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              _labelForCategory(category),
              style: TextStyle(
                color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForCategory(ExcuseCategory category) {
    switch (category) {
      case ExcuseCategory.work:
        return Icons.work_outline;
      case ExcuseCategory.school:
        return Icons.school_outlined;
      case ExcuseCategory.social:
        return Icons.people_outline;
      case ExcuseCategory.family:
        return Icons.family_restroom_outlined;
      case ExcuseCategory.general:
        return Icons.chat_bubble_outline;
    }
  }

  String _labelForCategory(ExcuseCategory category) {
    switch (category) {
      case ExcuseCategory.work:
        return 'Work';
      case ExcuseCategory.school:
        return 'School';
      case ExcuseCategory.social:
        return 'Social';
      case ExcuseCategory.family:
        return 'Family';
      case ExcuseCategory.general:
        return 'General';
    }
  }
}
