/// StateNotifier for managing excuse generation state.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:excuse_me/domain/entities/excuse_options.dart';
import 'package:excuse_me/domain/services/excuse_engine.dart';
import 'package:excuse_me/presentation/viewmodels/excuse_state.dart';

/// Manages the excuse generation flow state.
class ExcuseNotifier extends StateNotifier<ExcuseState> {
  final ExcuseEngine _engine;

  ExcuseNotifier(this._engine) : super(ExcuseState.initial);

  /// Sets the event message from user input.
  void setEventMessage(String message) {
    state = state.copyWith(
      eventMessage: message,
      clearError: true,
    );
  }

  /// Sets the selected category (or null to use detection).
  void setCategory(ExcuseCategory? category) {
    if (category == null) {
      state = state.copyWith(clearCategory: true, clearError: true);
    } else {
      state = state.copyWith(selectedCategory: category, clearError: true);
    }
  }

  /// Sets the desired tone.
  void setTone(ExcuseTone tone) {
    state = state.copyWith(selectedTone: tone, clearError: true);
  }

  /// Sets the desired length.
  void setLength(ExcuseLength length) {
    state = state.copyWith(selectedLength: length, clearError: true);
  }

  /// Sets whether to offer rescheduling.
  void setReschedule(bool value) {
    state = state.copyWith(wantReschedule: value, clearError: true);
  }

  /// Updates the generated excuse text (for user edits).
  void updateExcuseText(String text) {
    state = state.copyWith(generatedExcuse: text);
  }

  /// Generates an excuse based on current state.
  Future<void> generateExcuse() async {
    if (!state.hasInput) {
      state = state.copyWith(
        errorMessage: 'Please enter a message or select a category',
      );
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final request = ExcuseRequest(
        eventMessage:
            state.eventMessage.isNotEmpty ? state.eventMessage : null,
        category: state.selectedCategory,
        tone: state.selectedTone,
        length: state.selectedLength,
      );

      final result = await _engine.generate(request);

      state = state.copyWith(
        generatedExcuse: result.text,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to generate excuse. Please try again.',
      );
    }
  }

  /// Regenerates an excuse with the same options.
  Future<void> regenerate() async {
    await generateExcuse();
  }

  /// Clears all state back to initial.
  void clear() {
    state = ExcuseState.initial;
  }

  /// Clears just the generated excuse (to go back to options).
  void clearExcuse() {
    state = state.copyWith(clearExcuse: true);
  }
}
