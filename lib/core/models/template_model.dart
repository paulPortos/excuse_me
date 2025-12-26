/// Template data model for excuse templates.
///
/// Represents a single excuse template with its metadata.
library;

import 'package:excuse_me/domain/entities/excuse_options.dart';

/// Represents an excuse template.
class ExcuseTemplate {
  /// The category this template belongs to.
  final ExcuseCategory category;

  /// The tone of this template.
  final ExcuseTone tone;

  /// The length of this template.
  final ExcuseLength length;

  /// The template text with placeholders.
  final String text;

  /// Whether this template offers to reschedule.
  final bool offersReschedule;

  const ExcuseTemplate({
    required this.category,
    required this.tone,
    required this.length,
    required this.text,
    this.offersReschedule = false,
  });

  /// Creates an [ExcuseTemplate] from a JSON map.
  factory ExcuseTemplate.fromJson(Map<String, dynamic> json) {
    return ExcuseTemplate(
      category: ExcuseCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => ExcuseCategory.general,
      ),
      tone: ExcuseTone.values.firstWhere(
        (t) => t.name == json['tone'],
        orElse: () => ExcuseTone.polite,
      ),
      length: ExcuseLength.values.firstWhere(
        (l) => l.name == json['length'],
        orElse: () => ExcuseLength.short,
      ),
      text: json['text'] as String,
      offersReschedule: json['offersReschedule'] as bool? ?? false,
    );
  }

  /// Converts this template to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'category': category.name,
      'tone': tone.name,
      'length': length.name,
      'text': text,
      'offersReschedule': offersReschedule,
    };
  }

  @override
  String toString() {
    return 'ExcuseTemplate(category: $category, tone: $tone, length: $length)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExcuseTemplate &&
        other.category == category &&
        other.tone == tone &&
        other.length == length &&
        other.text == text &&
        other.offersReschedule == offersReschedule;
  }

  @override
  int get hashCode {
    return Object.hash(category, tone, length, text, offersReschedule);
  }
}
