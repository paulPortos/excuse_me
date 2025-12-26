/// Category chip widget for scenario selection with animations.
library;

import 'package:flutter/material.dart';

import 'package:excuse_me/core/theme/app_theme.dart';
import 'package:excuse_me/core/utils/haptics.dart';
import 'package:excuse_me/domain/entities/excuse_options.dart';

/// A selectable chip for category/scenario selection with bounce animation.
class CategoryChip extends StatefulWidget {
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
  State<CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<CategoryChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    Haptics.lightTap();
    _controller.forward().then((_) {
      _controller.reverse();
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppTheme.primary.withValues(alpha: 0.15)
                : AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            border: Border.all(
              color: widget.isSelected
                  ? AppTheme.primary
                  : AppTheme.textHint.withValues(alpha: 0.3),
              width: widget.isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _iconForCategory(widget.category),
                size: 20,
                color: widget.isSelected
                    ? AppTheme.primary
                    : AppTheme.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                _labelForCategory(widget.category),
                style: TextStyle(
                  color: widget.isSelected
                      ? AppTheme.primary
                      : AppTheme.textPrimary,
                  fontWeight:
                      widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
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
