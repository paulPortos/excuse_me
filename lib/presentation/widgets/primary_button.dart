/// Primary button widget with loading state and animations.
library;

import 'package:flutter/material.dart';

import 'package:excuse_me/core/theme/app_theme.dart';
import 'package:excuse_me/core/utils/haptics.dart';

/// A styled primary button with optional loading state and press animation.
class PrimaryButton extends StatefulWidget {
  /// Button label text.
  final String label;

  /// Callback when button is pressed.
  final VoidCallback? onPressed;

  /// Whether the button is in loading state.
  final bool isLoading;

  /// Optional icon to display before the label.
  final IconData? icon;

  /// Whether to use outlined style instead of filled.
  final bool outlined;

  /// Whether this button shows a success state.
  final bool showSuccess;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.outlined = false,
    this.showSuccess = false,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.onPressed != null && !widget.isLoading) {
      Haptics.mediumTap();
      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveIcon = widget.showSuccess ? Icons.check : widget.icon;
    final effectiveLabel = widget.showSuccess ? 'Copied!' : widget.label;

    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.outlined ? AppTheme.primary : Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ] else if (effectiveIcon != null) ...[
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(effectiveIcon, size: 20, key: ValueKey(effectiveIcon)),
          ),
          const SizedBox(width: 8),
        ],
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(effectiveLabel, key: ValueKey(effectiveLabel)),
        ),
      ],
    );

    final button = widget.outlined
        ? OutlinedButton(
            onPressed: widget.isLoading ? null : _handleTap,
            child: child,
          )
        : ElevatedButton(
            onPressed: widget.isLoading ? null : _handleTap,
            style: widget.showSuccess
                ? ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.success,
                  )
                : null,
            child: child,
          );

    return GestureDetector(
      onTapDown: (_) {
        if (widget.onPressed != null && !widget.isLoading) {
          _controller.forward();
        }
      },
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: SizedBox(
          width: double.infinity,
          child: button,
        ),
      ),
    );
  }
}
