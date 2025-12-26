/// Haptic feedback utilities.
library;

import 'package:flutter/services.dart';

/// Provides haptic feedback for various interactions.
class Haptics {
  Haptics._();

  /// Light haptic for selections (chips, toggles).
  static void lightTap() {
    HapticFeedback.lightImpact();
  }

  /// Medium haptic for button presses.
  static void mediumTap() {
    HapticFeedback.mediumImpact();
  }

  /// Heavy haptic for important actions.
  static void heavyTap() {
    HapticFeedback.heavyImpact();
  }

  /// Success haptic (selection click).
  static void success() {
    HapticFeedback.selectionClick();
  }

  /// Vibrate for errors or warnings.
  static void error() {
    HapticFeedback.vibrate();
  }
}
