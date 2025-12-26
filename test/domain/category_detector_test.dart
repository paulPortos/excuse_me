import 'package:flutter_test/flutter_test.dart';

import 'package:excuse_me/domain/entities/excuse_options.dart';
import 'package:excuse_me/domain/logic/category_detector.dart';

void main() {
  late CategoryDetector detector;

  setUp(() {
    detector = CategoryDetector();
  });

  group('CategoryDetector', () {
    group('detect', () {
      test('returns work category for work-related input', () {
        expect(
          detector.detect('Can you attend the meeting tomorrow?'),
          ExcuseCategory.work,
        );
        expect(
          detector.detect('We have a deadline next week'),
          ExcuseCategory.work,
        );
        expect(
          detector.detect('The boss wants everyone at the office'),
          ExcuseCategory.work,
        );
      });

      test('returns school category for school-related input', () {
        expect(
          detector.detect('Did you finish the homework?'),
          ExcuseCategory.school,
        );
        expect(
          detector.detect('We have an exam on Friday'),
          ExcuseCategory.school,
        );
        expect(
          detector.detect('Professor wants us in class early'),
          ExcuseCategory.school,
        );
      });

      test('returns social category for social event input', () {
        expect(
          detector.detect('Are you coming to the party?'),
          ExcuseCategory.social,
        );
        expect(
          detector.detect('Let\'s meet for drinks tonight'),
          ExcuseCategory.social,
        );
        expect(
          detector.detect('We\'re having a dinner gathering'),
          ExcuseCategory.social,
        );
      });

      test('returns family category for family-related input', () {
        expect(
          detector.detect('The family reunion is this weekend'),
          ExcuseCategory.family,
        );
        expect(
          detector.detect('Mom wants you to visit'),
          ExcuseCategory.family,
        );
        expect(
          detector.detect('My uncle is coming to visit'),
          ExcuseCategory.family,
        );
      });

      test('returns general category for empty input', () {
        expect(detector.detect(''), ExcuseCategory.general);
        expect(detector.detect('   '), ExcuseCategory.general);
      });

      test('returns general category when no keywords match', () {
        expect(
          detector.detect('Hello, how are you doing today?'),
          ExcuseCategory.general,
        );
        expect(
          detector.detect('Random text with no keywords'),
          ExcuseCategory.general,
        );
      });

      test('picks category with highest score when multiple match', () {
        // Work has more keywords in this message
        expect(
          detector.detect('Meeting with colleagues about the project deadline'),
          ExcuseCategory.work,
        );
      });

      test('handles case insensitivity', () {
        expect(
          detector.detect('MEETING with BOSS at OFFICE'),
          ExcuseCategory.work,
        );
        expect(
          detector.detect('EXAM and HOMEWORK due'),
          ExcuseCategory.school,
        );
      });
    });

    group('getMatchedKeywords', () {
      test('returns matched keywords for each category', () {
        final matches = detector.getMatchedKeywords(
          'Meeting with the team about the project deadline',
        );

        expect(matches[ExcuseCategory.work], isNotNull);
        expect(
          matches[ExcuseCategory.work],
          containsAll(['meeting', 'team', 'project', 'deadline']),
        );
      });

      test('returns empty map when no keywords match', () {
        final matches = detector.getMatchedKeywords(
          'Hello world',
        );

        expect(matches, isEmpty);
      });
    });
  });
}
