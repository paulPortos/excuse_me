import 'package:flutter_test/flutter_test.dart';

import 'package:excuse_me/data/repositories/template_repository.dart';
import 'package:excuse_me/domain/entities/excuse_options.dart';

void main() {
  group('TemplateRepository', () {
    late TemplateRepository repository;

    const testTemplatesJson = '''
{
  "templates": [
    {
      "category": "work",
      "tone": "polite",
      "length": "short",
      "text": "I'm sorry, but I won't be able to make it to {event}.",
      "offersReschedule": false
    },
    {
      "category": "work",
      "tone": "polite",
      "length": "long",
      "text": "I'm sorry, but I won't be able to make it to {event} on {day}. Something urgent came up at work.",
      "offersReschedule": true
    },
    {
      "category": "social",
      "tone": "casual",
      "length": "short",
      "text": "Can't make it, sorry!",
      "offersReschedule": false
    },
    {
      "category": "general",
      "tone": "formal",
      "length": "short",
      "text": "I regret that I will be unable to attend.",
      "offersReschedule": false
    }
  ]
}
''';

    setUp(() {
      repository = TemplateRepository();
      repository.loadFromJson(testTemplatesJson);
    });

    tearDown(() {
      repository.clearCache();
    });

    group('loadFromJson', () {
      test('loads templates from JSON string', () async {
        final templates = await repository.loadTemplates();

        expect(templates, hasLength(4));
      });

      test('parses template properties correctly', () async {
        final templates = await repository.loadTemplates();
        final workTemplate = templates.first;

        expect(workTemplate.category, ExcuseCategory.work);
        expect(workTemplate.tone, ExcuseTone.polite);
        expect(workTemplate.length, ExcuseLength.short);
        expect(workTemplate.offersReschedule, isFalse);
      });
    });

    group('getTemplates', () {
      test('filters by category', () async {
        final templates = await repository.getTemplates(
          category: ExcuseCategory.work,
        );

        expect(templates, hasLength(2));
        expect(
          templates.every((t) => t.category == ExcuseCategory.work),
          isTrue,
        );
      });

      test('filters by tone', () async {
        final templates = await repository.getTemplates(
          tone: ExcuseTone.polite,
        );

        expect(templates, hasLength(2));
        expect(
          templates.every((t) => t.tone == ExcuseTone.polite),
          isTrue,
        );
      });

      test('filters by length', () async {
        final templates = await repository.getTemplates(
          length: ExcuseLength.short,
        );

        expect(templates, hasLength(3));
        expect(
          templates.every((t) => t.length == ExcuseLength.short),
          isTrue,
        );
      });

      test('filters by multiple criteria', () async {
        final templates = await repository.getTemplates(
          category: ExcuseCategory.work,
          tone: ExcuseTone.polite,
          length: ExcuseLength.short,
        );

        expect(templates, hasLength(1));
        expect(templates.first.category, ExcuseCategory.work);
        expect(templates.first.tone, ExcuseTone.polite);
        expect(templates.first.length, ExcuseLength.short);
      });

      test('returns empty list when no matches', () async {
        final templates = await repository.getTemplates(
          category: ExcuseCategory.family,
        );

        expect(templates, isEmpty);
      });

      test('filters by offersReschedule', () async {
        final templates = await repository.getTemplates(
          offersReschedule: true,
        );

        expect(templates, hasLength(1));
        expect(templates.first.offersReschedule, isTrue);
      });
    });

    group('getTemplate', () {
      test('returns single matching template', () async {
        final template = await repository.getTemplate(
          category: ExcuseCategory.social,
          tone: ExcuseTone.casual,
          length: ExcuseLength.short,
        );

        expect(template, isNotNull);
        expect(template!.category, ExcuseCategory.social);
      });

      test('returns null when no match', () async {
        final template = await repository.getTemplate(
          category: ExcuseCategory.family,
          tone: ExcuseTone.formal,
          length: ExcuseLength.long,
        );

        expect(template, isNull);
      });
    });

    group('clearCache', () {
      test('clears cached templates', () async {
        // Load initial templates
        await repository.loadTemplates();

        // Clear and reload with different data
        repository.clearCache();
        repository.loadFromJson('''
{
  "templates": [
    {
      "category": "family",
      "tone": "casual",
      "length": "short",
      "text": "Family stuff, can't come!",
      "offersReschedule": false
    }
  ]
}
''');

        final templates = await repository.loadTemplates();

        expect(templates, hasLength(1));
        expect(templates.first.category, ExcuseCategory.family);
      });
    });
  });
}
