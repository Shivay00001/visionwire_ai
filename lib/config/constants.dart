// API Key for OpenRouter
const String openRouterApiKey = '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';
const String openRouterBaseUrl = 'https://openrouter.ai/api/v1';

// App Info
const String appName = 'VisionWire AI';
const String appVersion = '1.0.0';
const String appTagline = 'Your AI Study Partner';

// Supported Exams
const List<String> supportedExams = [
  'NEET',
  'JEE Main',
  'JEE Advanced',
  'CBSE Board',
  'ICSE Board',
  'State Board',
  'CUET',
  'NTSE',
  'Olympiad',
  'Class Annual Exam',
];

// Supported Classes
const List<String> supportedClasses = [
  'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5',
  'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10',
  'Class 11', 'Class 12',
];

// Supported Languages
const List<String> supportedLanguages = [
  'English',
  'Hindi',
  'Hinglish',
  'Tamil',
  'Telugu',
  'Marathi',
  'Bengali',
  'Gujarati',
  'Kannada',
  'Malayalam',
];

// Age mapping for classes
const Map<String, int> classAgeMapping = {
  'Class 1': 6, 'Class 2': 7, 'Class 3': 8, 'Class 4': 9, 'Class 5': 10,
  'Class 6': 11, 'Class 7': 12, 'Class 8': 13, 'Class 9': 14, 'Class 10': 15,
  'Class 11': 16, 'Class 12': 17,
};

// Difficulty percentages
const Map<String, int> difficultyPercentages = {
  'easy': 30,
  'medium': 50,
  'hard': 20,
};
