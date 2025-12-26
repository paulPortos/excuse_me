/// Text processing utilities for excuse generation.
///
/// Pure Dart utilities with no Flutter dependencies.
library;

/// Normalizes input text for keyword matching.
///
/// Converts to lowercase, trims whitespace, and removes punctuation.
String normalizeText(String input) {
  return input
      .toLowerCase()
      .trim()
      .replaceAll(RegExp(r'[^\w\s]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ');
}

/// Extracts potential event name from a message.
///
/// Looks for quoted text, text after "to" or "for", or capitalized phrases.
/// Returns empty string if no event name found.
String extractEventName(String input) {
  // Try to find quoted text first
  final quotedMatch = RegExp(r'"([^"]+)"').firstMatch(input);
  if (quotedMatch != null) {
    return quotedMatch.group(1) ?? '';
  }

  // Try to find text after common prepositions
  final prepositionMatch = RegExp(
    r'\b(?:to|for|at)\s+(?:the\s+)?([A-Z][a-zA-Z\s]+)',
  ).firstMatch(input);
  if (prepositionMatch != null) {
    return prepositionMatch.group(1)?.trim() ?? '';
  }

  return '';
}

/// Fills placeholder tokens in a template string.
///
/// Supported placeholders:
/// - `{event}` - Event name
/// - `{day}` - Day of the week or date
/// - `{time}` - Time of the event
/// - `{name}` - Person's name
Map<String, String> defaultPlaceholders = {
  '{event}': 'the event',
  '{day}': 'that day',
  '{time}': 'that time',
  '{name}': 'you',
};

/// Fills placeholders in a template with provided values.
///
/// Uses [defaultPlaceholders] for any missing values.
String fillPlaceholders(String template, [Map<String, String>? values]) {
  String result = template;
  final mergedValues = {...defaultPlaceholders, ...?values};

  for (final entry in mergedValues.entries) {
    result = result.replaceAll(entry.key, entry.value);
  }

  return result;
}

/// Capitalizes the first letter of a string.
String capitalize(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}

/// Ensures the text ends with proper punctuation.
String ensurePunctuation(String input) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) return trimmed;

  final lastChar = trimmed[trimmed.length - 1];
  if (lastChar == '.' || lastChar == '!' || lastChar == '?') {
    return trimmed;
  }

  return '$trimmed.';
}
