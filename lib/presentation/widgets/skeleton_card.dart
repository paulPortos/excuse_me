/// Shimmer skeleton card for loading states.
library;

import 'package:flutter/material.dart';

import 'package:excuse_me/core/theme/app_theme.dart';

/// A shimmer loading placeholder card.
class SkeletonCard extends StatefulWidget {
  const SkeletonCard({super.key});

  @override
  State<SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<SkeletonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.padding),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        border: Border.all(
          color: AppTheme.textHint.withValues(alpha: 0.2),
        ),
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildShimmerLine(width: double.infinity, animation: _animation),
              const SizedBox(height: 12),
              _buildShimmerLine(width: double.infinity, animation: _animation),
              const SizedBox(height: 12),
              _buildShimmerLine(
                  width: MediaQuery.of(context).size.width * 0.7,
                  animation: _animation),
              const SizedBox(height: 12),
              _buildShimmerLine(
                  width: MediaQuery.of(context).size.width * 0.5,
                  animation: _animation),
              const SizedBox(height: 12),
              _buildShimmerLine(
                  width: MediaQuery.of(context).size.width * 0.6,
                  animation: _animation),
            ],
          );
        },
      ),
    );
  }

  Widget _buildShimmerLine(
      {required double width, required Animation<double> animation}) {
    return Container(
      width: width,
      height: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppTheme.textHint.withValues(alpha: 0.1),
            AppTheme.textHint.withValues(alpha: 0.2),
            AppTheme.textHint.withValues(alpha: 0.1),
          ],
          stops: [
            (animation.value - 0.3).clamp(0.0, 1.0),
            animation.value.clamp(0.0, 1.0),
            (animation.value + 0.3).clamp(0.0, 1.0),
          ],
        ),
      ),
    );
  }
}
