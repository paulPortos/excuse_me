/// Immutable state class for excuse generation.
library;

import 'package:excuse_me/domain/entities/excuse_options.dart';

/// Represents the current state of the excuse generation flow.
class ExcuseState {
  /// User's pasted event message.
  final String eventMessage;

  /// Manually selected category (overrides detection if set).
  final ExcuseCategory? selectedCategory;

  /// Selected tone for the excuse.
  final ExcuseTone selectedTone;

  /// Selected length for the excuse.
  final ExcuseLength selectedLength;

  /// Whether to offer rescheduling in the excuse.
  final bool wantReschedule;

  /// The generated excuse text.
  final String? generatedExcuse;

  /// Whether generation is in progress.
  final bool isLoading;

  /// Error message if generation failed.
  final String? errorMessage;

  const ExcuseState({
    this.eventMessage = '',
    this.selectedCategory,
    this.selectedTone = ExcuseTone.polite,
    this.selectedLength = ExcuseLength.short,
    this.wantReschedule = false,
    this.generatedExcuse,
    this.isLoading = false,
    this.errorMessage,
  });

  /// Creates a copy with the given fields replaced.
  ExcuseState copyWith({
    String? eventMessage,
    ExcuseCategory? selectedCategory,
    bool clearCategory = false,
    ExcuseTone? selectedTone,
    ExcuseLength? selectedLength,
    bool? wantReschedule,
    String? generatedExcuse,
    bool clearExcuse = false,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ExcuseState(
      eventMessage: eventMessage ?? this.eventMessage,
      selectedCategory:
          clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      selectedTone: selectedTone ?? this.selectedTone,
      selectedLength: selectedLength ?? this.selectedLength,
      wantReschedule: wantReschedule ?? this.wantReschedule,
      generatedExcuse:
          clearExcuse ? null : (generatedExcuse ?? this.generatedExcuse),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  /// Whether the user has provided input (message or category).
  bool get hasInput => eventMessage.isNotEmpty || selectedCategory != null;

  /// Initial/default state.
  static const ExcuseState initial = ExcuseState();
}
