/// Excuse options entities - enums for category, tone, and length.
///
/// Pure Dart enums with no Flutter dependencies.
library;

/// Categories of excuses based on context.
enum ExcuseCategory {
  /// Work-related excuses (meetings, deadlines, etc.)
  work,

  /// School-related excuses (classes, exams, etc.)
  school,

  /// Social event excuses (parties, gatherings, etc.)
  social,

  /// Family-related excuses (reunions, visits, etc.)
  family,

  /// General fallback category
  general,
}

/// Tone/formality level of the excuse.
enum ExcuseTone {
  /// Formal and professional tone
  formal,

  /// Friendly and polite tone (default)
  polite,

  /// Relaxed and casual tone
  casual,
}

/// Length of the generated excuse.
enum ExcuseLength {
  /// Brief, to-the-point excuse
  short,

  /// More detailed excuse with context
  long,
}
