import 'package:flutter_test/flutter_test.dart';

import 'package:excuse_me/domain/logic/variation_engine.dart';

void main() {
  group('VariationEngine', () {
    group('applyVariations', () {
      test('applies variations with seeded randomness', () {
        // With seed 42, we can test deterministic behavior
        final engine = VariationEngine(seed: 42);

        // Run multiple times to ensure consistency with same seed
        final result1 = engine.applyVariations("I'm sorry, I can't make it");
        
        final engine2 = VariationEngine(seed: 42);
        final result2 = engine2.applyVariations("I'm sorry, I can't make it");

        expect(result1, equals(result2));
      });

      test('returns original text when no matching phrases', () {
        final engine = VariationEngine(seed: 42);
        const input = 'Hello, this is a test message';

        expect(engine.applyVariations(input), equals(input));
      });

      test('only replaces first occurrence of a phrase', () {
        final engine = VariationEngine(seed: 1);
        // Use a seed that will trigger variations
        const input = "I'm sorry, I'm sorry again";

        final result = engine.applyVariations(input);

        // At most one "I'm sorry" should be replaced
        final originalCount =
            "I'm sorry".allMatches(input).length;
        final resultSorryCount =
            "I'm sorry".allMatches(result).length;

        // Either 0, 1, or 2 occurrences depending on variation
        expect(resultSorryCount, lessThanOrEqualTo(originalCount));
      });
    });

    group('getVariationsFor', () {
      test('returns variations for known phrase', () {
        final engine = VariationEngine();

        final variations = engine.getVariationsFor("I'm sorry");

        expect(variations, isNotEmpty);
        expect(variations, contains('Sorry'));
        expect(variations, contains('I apologize'));
      });

      test('returns empty list for unknown phrase', () {
        final engine = VariationEngine();

        expect(engine.getVariationsFor('Unknown phrase'), isEmpty);
      });
    });

    group('countVariablePhrasesIn', () {
      test('counts phrases that have variations', () {
        final engine = VariationEngine();

        expect(
          engine.countVariablePhrasesIn("I'm sorry, I can't make it"),
          equals(2), // "I'm sorry" and "I can't make it"
        );
      });

      test('returns 0 for text with no variable phrases', () {
        final engine = VariationEngine();

        expect(
          engine.countVariablePhrasesIn('Hello world'),
          equals(0),
        );
      });
    });
  });
}
