/// Phrase variations for natural excuse output.
///
/// These variation maps are used by [VariationEngine] to swap common
/// phrases with alternatives, making excuses feel less repetitive.
library;

/// Apology phrase variations.
const Map<String, List<String>> apologyVariations = {
  "I'm sorry": [
    "Sorry",
    "I apologize",
    "My apologies",
    "I'm really sorry",
  ],
  "I apologize": [
    "Sorry",
    "I'm sorry",
    "My apologies",
  ],
};

/// Decline phrase variations.
const Map<String, List<String>> declineVariations = {
  "I can't make it": [
    "I won't be able to attend",
    "I'll have to skip this one",
    "I won't be able to come",
    "I'm unable to make it",
  ],
  "I won't be able to come": [
    "I can't make it",
    "I'll have to miss this",
    "I won't be able to attend",
  ],
  "I have to decline": [
    "I'll have to pass",
    "I need to pass on this",
    "I'm going to have to decline",
  ],
};

/// Reason phrase variations.
const Map<String, List<String>> reasonVariations = {
  "I have a prior commitment": [
    "I already have plans",
    "I have something scheduled",
    "I'm already committed to something",
  ],
  "I'm not feeling well": [
    "I'm feeling under the weather",
    "I'm not in the best shape",
    "I haven't been feeling great",
  ],
  "something came up": [
    "an unexpected situation arose",
    "something urgent came up",
    "I have an unexpected obligation",
  ],
};

/// Closing phrase variations.
const Map<String, List<String>> closingVariations = {
  "Maybe next time": [
    "Let's catch up soon",
    "Hope to join next time",
    "Rain check?",
    "Let's reschedule",
  ],
  "Thank you for understanding": [
    "Thanks for being understanding",
    "I appreciate your understanding",
    "Thanks for getting it",
  ],
};

/// All variation maps combined for easy access.
const List<Map<String, List<String>>> allVariations = [
  apologyVariations,
  declineVariations,
  reasonVariations,
  closingVariations,
];
