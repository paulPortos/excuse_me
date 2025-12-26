/// Riverpod providers for excuse generation.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:excuse_me/data/repositories/template_repository.dart';
import 'package:excuse_me/domain/services/excuse_engine.dart';
import 'package:excuse_me/presentation/viewmodels/excuse_notifier.dart';
import 'package:excuse_me/presentation/viewmodels/excuse_state.dart';

/// Provider for the template repository.
final templateRepositoryProvider = Provider<TemplateRepository>((ref) {
  return TemplateRepository();
});

/// Provider for the excuse engine.
final excuseEngineProvider = Provider<ExcuseEngine>((ref) {
  final repository = ref.watch(templateRepositoryProvider);
  return ExcuseEngine(repository: repository);
});

/// Provider for the excuse state notifier.
final excuseNotifierProvider =
    StateNotifierProvider<ExcuseNotifier, ExcuseState>((ref) {
  final engine = ref.watch(excuseEngineProvider);
  return ExcuseNotifier(engine);
});
