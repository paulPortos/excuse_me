/// Editable text card for displaying and editing excuse text.
library;

import 'package:flutter/material.dart';

import 'package:excuse_me/core/theme/app_theme.dart';

/// A card with an editable text field for the generated excuse.
class EditableTextCard extends StatefulWidget {
  /// The initial text to display.
  final String text;

  /// Callback when the text is changed.
  final ValueChanged<String>? onChanged;

  /// Whether the text is editable.
  final bool editable;

  const EditableTextCard({
    super.key,
    required this.text,
    this.onChanged,
    this.editable = true,
  });

  @override
  State<EditableTextCard> createState() => _EditableTextCardState();
}

class _EditableTextCardState extends State<EditableTextCard> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
  }

  @override
  void didUpdateWidget(EditableTextCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text && widget.text != _controller.text) {
      _controller.text = widget.text;
    }
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        enabled: widget.editable,
        maxLines: null,
        minLines: 6,
        style: const TextStyle(
          fontSize: 18,
          height: 1.6,
          color: AppTheme.textPrimary,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: false,
          contentPadding: EdgeInsets.zero,
          hintText: 'Your excuse will appear here...',
          hintStyle: TextStyle(
            color: AppTheme.textHint,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
