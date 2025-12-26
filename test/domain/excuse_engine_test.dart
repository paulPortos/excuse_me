import 'package:flutter_test/flutter_test.dart';

import 'package:excuse_me/data/repositories/template_repository.dart';
import 'package:excuse_me/domain/entities/excuse_options.dart';
import 'package:excuse_me/domain/services/excuse_engine.dart';

void main() {
  group('ExcuseEngine', () {
    late TemplateRepository repository;
    late ExcuseEngine engine;

    const testTemplatesJson = '''
{
  "templates": [
    {
      "category": "work",
      "tone": "polite",
      "length": "short",
      "text": "I'm sorry, but I won't be able to make it to {event}. Work deadline.",
      "offersReschedule": false
    },
    {
      "category": "work",
      "tone": "polite",
      "length": "long",
      "text": "I'm sorry, but I won't be able to make it to {event} on {day}. Something urgent came up at work and I really need to take care of it.",
      "offersReschedule": true
    },
    {
      "category": "school",
      "tone": "polite",
      "length": "short",
      "text": "I can't make it to {event}. I have a big exam coming up.",
      "offersReschedule": false
    },
    {
      "category": "general",
      "tone": "polite",
      "length": "short",
      "text": "I'm sorry, but I won't be able to make it to {event}. Something came up.",
      "offersReschedule": false
    },
    {
      "category": "general",
      "tone": "casual",
      "length": "short",
      "text": "Sorry, can't make it to {event}!",
      "offersReschedule": false
    }
  ]
}
''';

    setUp(() {
      repository = TemplateRepository();
      repository.loadFromJson(testTemplatesJson);
      engine = ExcuseEngine(repository: repository, seed: 42);
    });

    tearDown(() {
      repository.clearCache();
    });

    group('generate', () {
      test('generates excuse with detected category', () async {
        final result = await engine.generate(
          const ExcuseRequest(
            eventMessage: 'Can you come to the meeting tomorrow?',
            tone: ExcuseTone.polite,
            length: ExcuseLength.short,
          ),
        );

        expect(result.category, ExcuseCategory.work);
        expect(result.text, isNotEmpty);
      });

      test('uses specified category over detection', () async {
        final result = await engine.generate(
          const ExcuseRequest(
            eventMessage: 'Can you come to the meeting?',
            category: ExcuseCategory.school, // Override
            tone: ExcuseTone.polite,
            length: ExcuseLength.short,
          ),
        );

        expect(result.category, ExcuseCategory.school);
      });

      test('fills placeholders in template', () async {
        final result = await engine.generate(
          const ExcuseRequest(
            eventMessage: 'Come to the party',
            category: ExcuseCategory.general,
            tone: ExcuseTone.casual,
            length: ExcuseLength.short,
            placeholders: {'{event}': 'the birthday party'},
          ),
        );

        expect(result.text, contains('the birthday party'));
        expect(result.text, isNot(contains('{event}')));
      });

      test('falls back to general category when no matches', () async {
        final result = await engine.generate(
          const ExcuseRequest(
            category: ExcuseCategory.family, // No family templates
            tone: ExcuseTone.polite,
            length: ExcuseLength.short,
          ),
        );

        // Should fall back to general
        expect(result.text, isNotEmpty);
      });

      test('returns result with template reference', () async {
        final result = await engine.generate(
          const ExcuseRequest(
            category: ExcuseCategory.work,
            tone: ExcuseTone.polite,
            length: ExcuseLength.short,
          ),
        );

        expect(result.template, isNotNull);
        expect(result.template.category, ExcuseCategory.work);
      });
    });

    group('generateOptions', () {
      test('generates multiple excuse options', () async {
        final results = await engine.generateOptions(
          const ExcuseRequest(
            category: ExcuseCategory.general,
            tone: ExcuseTone.polite,
            length: ExcuseLength.short,
          ),
          count: 3,
        );

        expect(results, hasLength(3));
      });
    });

    group('detectCategory', () {
      test('detects work category', () {
        expect(
          engine.detectCategory('Meeting with boss tomorrow'),
          ExcuseCategory.work,
        );
      });

      test('detects school category', () {
        expect(
          engine.detectCategory('Big exam on Friday'),
          ExcuseCategory.school,
        );
      });

      test('returns general for unknown input', () {
        expect(
          engine.detectCategory('Hello there'),
          ExcuseCategory.general,
        );
      });
    });
  });
}
