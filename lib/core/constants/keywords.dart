/// Category detection keywords for excuse classification.
///
/// These keyword lists are used by [CategoryDetector] to determine
/// the most appropriate category for a given input message.
library;

/// Keywords associated with work-related excuses.
const List<String> workKeywords = [
  'meeting',
  'deadline',
  'project',
  'boss',
  'office',
  'presentation',
  'work',
  'client',
  'conference',
  'report',
  'colleague',
  'team',
  'manager',
  'shift',
  'overtime',
];

/// Keywords associated with school-related excuses.
const List<String> schoolKeywords = [
  'class',
  'exam',
  'homework',
  'professor',
  'lecture',
  'assignment',
  'school',
  'university',
  'college',
  'study',
  'test',
  'quiz',
  'thesis',
  'presentation',
  'lab',
  'tutorial',
];

/// Keywords associated with social events.
const List<String> socialKeywords = [
  'party',
  'hangout',
  'drinks',
  'dinner',
  'event',
  'gathering',
  'celebration',
  'birthday',
  'wedding',
  'club',
  'bar',
  'night out',
  'get together',
  'brunch',
  'lunch',
];

/// Keywords associated with family events.
const List<String> familyKeywords = [
  'family',
  'mom',
  'dad',
  'mother',
  'father',
  'relative',
  'visit',
  'reunion',
  'grandma',
  'grandpa',
  'sibling',
  'brother',
  'sister',
  'uncle',
  'aunt',
  'cousin',
];

/// Map of category names to their keyword lists for easy lookup.
const Map<String, List<String>> categoryKeywordMap = {
  'work': workKeywords,
  'school': schoolKeywords,
  'social': socialKeywords,
  'family': familyKeywords,
};
