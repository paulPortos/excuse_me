/// Variation engine for phrase swapping.
///
/// Pure Dart with no Flutter dependencies - fully unit testable.
library;

import 'dart:math';

import 'package:excuse_me/core/constants/variations.dart';

/// Applies phrase variations to excuse text for natural output.
class VariationEngine {
  /// Random number generator for selecting variations.
  final Random _random;

  /// Creates a variation engine with an optional seed for testing.
  VariationEngine({int? seed}) : _random = Random(seed);

  /// Applies random phrase variations to the input text.
  ///
  /// Scans the text for known phrases and randomly replaces some
  /// with alternatives from the variation maps.
  String applyVariations(String input) {
    String result = input;

    for (final variationMap in allVariations) {
      for (final entry in variationMap.entries) {
        final original = entry.key;
        final alternatives = entry.value;

        if (result.contains(original)) {
          // 50% chance to apply a variation
          if (_random.nextBool()) {
            final replacement = alternatives[_random.nextInt(alternatives.length)];
            result = result.replaceFirst(original, replacement);
          }
        }
      }
    }

    return result;
  }

  /// Gets all possible variations for a given phrase.
  ///
  /// Returns an empty list if the phrase has no known variations.
  List<String> getVariationsFor(String phrase) {
    for (final variationMap in allVariations) {
      if (variationMap.containsKey(phrase)) {
        return variationMap[phrase]!;
      }
    }
    return [];
  }

  /// Counts how many phrases in the text have available variations.
  int countVariablePhrasesIn(String text) {
    int count = 0;

    for (final variationMap in allVariations) {
      for (final phrase in variationMap.keys) {
        if (text.contains(phrase)) {
          count++;
        }
      }
    }

    return count;
  }
}
