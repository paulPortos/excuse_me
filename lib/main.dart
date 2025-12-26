import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:excuse_me/core/theme/app_theme.dart';
import 'package:excuse_me/presentation/screens/input_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: ExcuseMeApp(),
    ),
  );
}

/// Main app widget for Excuse Me.
class ExcuseMeApp extends StatelessWidget {
  const ExcuseMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Excuse Me',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const InputScreen(),
    );
  }
}
