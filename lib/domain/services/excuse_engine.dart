/// Main excuse generation engine.
///
/// Orchestrates category detection, template selection, and variation.
library;

import 'dart:math';

import 'package:excuse_me/core/models/template_model.dart';
import 'package:excuse_me/core/utils/text_utils.dart';
import 'package:excuse_me/data/repositories/template_repository.dart';
import 'package:excuse_me/domain/entities/excuse_options.dart';
import 'package:excuse_me/domain/logic/category_detector.dart';
import 'package:excuse_me/domain/logic/variation_engine.dart';

/// Configuration for excuse generation.
class ExcuseRequest {
  /// The original event message (optional).
  final String? eventMessage;

  /// Manually selected category (overrides detection).
  final ExcuseCategory? category;

  /// Desired tone of the excuse.
  final ExcuseTone tone;

  /// Desired length of the excuse.
  final ExcuseLength length;

  /// Custom placeholder values.
  final Map<String, String>? placeholders;

  const ExcuseRequest({
    this.eventMessage,
    this.category,
    this.tone = ExcuseTone.polite,
    this.length = ExcuseLength.short,
    this.placeholders,
  });
}

/// Result of excuse generation.
class ExcuseResult {
  /// The generated excuse text.
  final String text;

  /// The detected/used category.
  final ExcuseCategory category;

  /// The template that was used.
  final ExcuseTemplate template;

  const ExcuseResult({
    required this.text,
    required this.category,
    required this.template,
  });
}

/// Main excuse generation engine.
///
/// Coordinates all components to generate excuses:
/// 1. Detects category from input (if not specified)
/// 2. Selects a matching template
/// 3. Fills placeholders
/// 4. Applies phrase variations
class ExcuseEngine {
  final TemplateRepository _repository;
  final CategoryDetector _detector;
  final VariationEngine _variationEngine;
  final Random _random;

  /// Creates an excuse engine with the given dependencies.
  ExcuseEngine({
    required TemplateRepository repository,
    CategoryDetector? detector,
    VariationEngine? variationEngine,
    int? seed,
  })  : _repository = repository,
        _detector = detector ?? CategoryDetector(),
        _variationEngine = variationEngine ?? VariationEngine(seed: seed),
        _random = Random(seed);

  /// Generates an excuse based on the request.
  Future<ExcuseResult> generate(ExcuseRequest request) async {
    // Step 1: Determine category
    final category = request.category ??
        (request.eventMessage != null
            ? _detector.detect(request.eventMessage!)
            : ExcuseCategory.general);

    // Step 2: Get matching templates
    var templates = await _repository.getTemplates(
      category: category,
      tone: request.tone,
      length: request.length,
    );

    // Fallback to general category if no matches
    if (templates.isEmpty) {
      templates = await _repository.getTemplates(
        category: ExcuseCategory.general,
        tone: request.tone,
        length: request.length,
      );
    }

    // If still empty, get any template with matching tone/length
    if (templates.isEmpty) {
      templates = await _repository.getTemplates(
        tone: request.tone,
        length: request.length,
      );
    }

    // Last resort: get any template
    if (templates.isEmpty) {
      templates = await _repository.loadTemplates();
    }

    // Step 3: Select a random template
    final template = templates[_random.nextInt(templates.length)];

    // Step 4: Build placeholder values
    final placeholderValues = <String, String>{};
    if (request.eventMessage != null) {
      final eventName = extractEventName(request.eventMessage!);
      if (eventName.isNotEmpty) {
        placeholderValues['{event}'] = eventName;
      }
    }
    if (request.placeholders != null) {
      placeholderValues.addAll(request.placeholders!);
    }

    // Step 5: Fill placeholders
    var text = fillPlaceholders(template.text, placeholderValues);

    // Step 6: Apply variations
    text = _variationEngine.applyVariations(text);

    // Step 7: Ensure proper formatting
    text = ensurePunctuation(text);

    return ExcuseResult(
      text: text,
      category: category,
      template: template,
    );
  }

  /// Generates multiple excuse options for the user to choose from.
  Future<List<ExcuseResult>> generateOptions(
    ExcuseRequest request, {
    int count = 3,
  }) async {
    final results = <ExcuseResult>[];

    for (var i = 0; i < count; i++) {
      final result = await generate(request);
      results.add(result);
    }

    return results;
  }

  /// Detects the category of an event message without generating an excuse.
  ExcuseCategory detectCategory(String eventMessage) {
    return _detector.detect(eventMessage);
  }
}
