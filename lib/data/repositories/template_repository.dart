/// Template repository for loading and caching excuse templates.
///
/// Loads templates from local JSON asset and provides filtered access.
library;

import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'package:excuse_me/core/models/template_model.dart';
import 'package:excuse_me/domain/entities/excuse_options.dart';

/// Repository for accessing excuse templates.
class TemplateRepository {
  static const String _templatePath = 'lib/data/templates/templates.json';

  /// Cached templates, loaded on first access.
  List<ExcuseTemplate>? _cachedTemplates;

  /// Loads all templates from the JSON asset.
  ///
  /// Templates are cached after first load.
  Future<List<ExcuseTemplate>> loadTemplates() async {
    if (_cachedTemplates != null) {
      return _cachedTemplates!;
    }

    final jsonString = await rootBundle.loadString(_templatePath);
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    final templateList = jsonData['templates'] as List<dynamic>;

    _cachedTemplates = templateList
        .map((t) => ExcuseTemplate.fromJson(t as Map<String, dynamic>))
        .toList();

    return _cachedTemplates!;
  }

  /// Gets templates filtered by the specified criteria.
  ///
  /// All parameters are optional. If not specified, templates of any
  /// value for that parameter will be included.
  Future<List<ExcuseTemplate>> getTemplates({
    ExcuseCategory? category,
    ExcuseTone? tone,
    ExcuseLength? length,
    bool? offersReschedule,
  }) async {
    final templates = await loadTemplates();

    return templates.where((t) {
      if (category != null && t.category != category) return false;
      if (tone != null && t.tone != tone) return false;
      if (length != null && t.length != length) return false;
      if (offersReschedule != null && t.offersReschedule != offersReschedule) {
        return false;
      }
      return true;
    }).toList();
  }

  /// Gets a single template matching the exact criteria.
  ///
  /// Returns null if no matching template is found.
  Future<ExcuseTemplate?> getTemplate({
    required ExcuseCategory category,
    required ExcuseTone tone,
    required ExcuseLength length,
  }) async {
    final templates = await getTemplates(
      category: category,
      tone: tone,
      length: length,
    );

    return templates.isNotEmpty ? templates.first : null;
  }

  /// Clears the cached templates.
  ///
  /// Useful for testing or forcing a reload.
  void clearCache() {
    _cachedTemplates = null;
  }

  /// Loads templates from a JSON string (for testing).
  void loadFromJson(String jsonString) {
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    final templateList = jsonData['templates'] as List<dynamic>;

    _cachedTemplates = templateList
        .map((t) => ExcuseTemplate.fromJson(t as Map<String, dynamic>))
        .toList();
  }
}
