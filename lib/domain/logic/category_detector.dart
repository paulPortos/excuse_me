/// Category detection logic using keyword matching.
///
/// Pure Dart with no Flutter dependencies - fully unit testable.
library;

import 'package:excuse_me/core/constants/keywords.dart';
import 'package:excuse_me/core/utils/text_utils.dart';
import 'package:excuse_me/domain/entities/excuse_options.dart';

/// Detects the most appropriate [ExcuseCategory] from input text.
class CategoryDetector {
  /// Detects the category from the given input.
  ///
  /// Uses keyword matching with scoring. Returns [ExcuseCategory.general]
  /// if no strong match is found.
  ExcuseCategory detect(String input) {
    if (input.trim().isEmpty) {
      return ExcuseCategory.general;
    }

    final normalizedInput = normalizeText(input);
    final scores = _calculateScores(normalizedInput);

    // Find the category with the highest score
    ExcuseCategory bestCategory = ExcuseCategory.general;
    int bestScore = 0;

    for (final entry in scores.entries) {
      if (entry.value > bestScore) {
        bestScore = entry.value;
        bestCategory = entry.key;
      }
    }

    // Require at least one keyword match
    if (bestScore == 0) {
      return ExcuseCategory.general;
    }

    return bestCategory;
  }

  /// Calculates match scores for each category.
  Map<ExcuseCategory, int> _calculateScores(String normalizedInput) {
    final scores = <ExcuseCategory, int>{
      ExcuseCategory.work: _countMatches(normalizedInput, workKeywords),
      ExcuseCategory.school: _countMatches(normalizedInput, schoolKeywords),
      ExcuseCategory.social: _countMatches(normalizedInput, socialKeywords),
      ExcuseCategory.family: _countMatches(normalizedInput, familyKeywords),
    };

    return scores;
  }

  /// Counts how many keywords from the list appear in the input.
  int _countMatches(String input, List<String> keywords) {
    int count = 0;
    for (final keyword in keywords) {
      // Use word boundary matching to avoid partial matches
      // e.g., "work" should not match inside "homework"
      final pattern = RegExp(r'\b' + RegExp.escape(keyword.toLowerCase()) + r'\b');
      if (pattern.hasMatch(input)) {
        count++;
      }
    }
    return count;
  }

  /// Gets detailed match information for debugging.
  Map<ExcuseCategory, List<String>> getMatchedKeywords(String input) {
    final normalizedInput = normalizeText(input);
    final matches = <ExcuseCategory, List<String>>{};

    for (final entry in categoryKeywordMap.entries) {
      final categoryName = entry.key;
      final keywords = entry.value;
      final matchedKeywords = <String>[];

      for (final keyword in keywords) {
        final pattern = RegExp(r'\b' + RegExp.escape(keyword.toLowerCase()) + r'\b');
        if (pattern.hasMatch(normalizedInput)) {
          matchedKeywords.add(keyword);
        }
      }

      if (matchedKeywords.isNotEmpty) {
        final category = ExcuseCategory.values.firstWhere(
          (c) => c.name == categoryName,
          orElse: () => ExcuseCategory.general,
        );
        matches[category] = matchedKeywords;
      }
    }

    return matches;
  }
}
