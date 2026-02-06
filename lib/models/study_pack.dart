class MCQ {
  final String question;
  final List<String> options;
  final String answer;
  final String explanation;
  final String difficulty;

  MCQ({
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
    this.difficulty = 'medium',
  });

  factory MCQ.fromJson(Map<String, dynamic> json) {
    return MCQ(
      question: json['q'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      answer: json['answer'] ?? '',
      explanation: json['explanation'] ?? '',
      difficulty: json['difficulty'] ?? 'medium',
    );
  }

  Map<String, dynamic> toJson() => {
    'q': question,
    'options': options,
    'answer': answer,
    'explanation': explanation,
    'difficulty': difficulty,
  };
}

class Formula {
  final String formula;
  final String meaning;
  final String notes;

  Formula({
    required this.formula,
    required this.meaning,
    this.notes = '',
  });

  factory Formula.fromJson(Map<String, dynamic> json) {
    return Formula(
      formula: json['formula'] ?? '',
      meaning: json['meaning'] ?? '',
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'formula': formula,
    'meaning': meaning,
    'notes': notes,
  };
}

class Concept {
  final String subtopic;
  final String explanation;
  final List<String> keyTerms;
  final String exampleProblem;

  Concept({
    required this.subtopic,
    required this.explanation,
    this.keyTerms = const [],
    this.exampleProblem = '',
  });

  factory Concept.fromJson(Map<String, dynamic> json) {
    return Concept(
      subtopic: json['subtopic'] ?? '',
      explanation: json['explanation'] ?? '',
      keyTerms: List<String>.from(json['key_terms'] ?? []),
      exampleProblem: json['example_problem'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'subtopic': subtopic,
    'explanation': explanation,
    'key_terms': keyTerms,
    'example_problem': exampleProblem,
  };
}

class QuestionAnswer {
  final String question;
  final String answer;

  QuestionAnswer({
    required this.question,
    required this.answer,
  });

  factory QuestionAnswer.fromJson(Map<String, dynamic> json) {
    return QuestionAnswer(
      question: json['q'] ?? '',
      answer: json['a'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'q': question,
    'a': answer,
  };
}

class Numerical {
  final String question;
  final String steps;
  final String answer;

  Numerical({
    required this.question,
    required this.steps,
    required this.answer,
  });

  factory Numerical.fromJson(Map<String, dynamic> json) {
    return Numerical(
      question: json['q'] ?? '',
      steps: json['steps'] ?? '',
      answer: json['ans'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'q': question,
    'steps': steps,
    'ans': answer,
  };
}

class PYQAnalysis {
  final List<Map<String, dynamic>> pastYearsPattern;
  final List<String> mostFrequentTopics;
  final List<Map<String, dynamic>> predictedQuestions;
  final List<String> commonMistakes;

  PYQAnalysis({
    this.pastYearsPattern = const [],
    this.mostFrequentTopics = const [],
    this.predictedQuestions = const [],
    this.commonMistakes = const [],
  });

  factory PYQAnalysis.fromJson(Map<String, dynamic> json) {
    return PYQAnalysis(
      pastYearsPattern: List<Map<String, dynamic>>.from(json['past_years_pattern'] ?? []),
      mostFrequentTopics: List<String>.from(json['most_frequent_topics'] ?? []),
      predictedQuestions: List<Map<String, dynamic>>.from(json['top_predicted_questions'] ?? []),
      commonMistakes: List<String>.from(json['common_mistakes'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'past_years_pattern': pastYearsPattern,
    'most_frequent_topics': mostFrequentTopics,
    'top_predicted_questions': predictedQuestions,
    'common_mistakes': commonMistakes,
  };
}

class StudyPack {
  final String chapter;
  final String className;
  final String subject;
  final String language;
  final String generatedOn;
  final String summary;
  final List<String> importantPoints;
  final List<Formula> formulas;
  final List<Concept> concepts;
  final List<MCQ> mcqEasy;
  final List<MCQ> mcqMedium;
  final List<MCQ> mcqHard;
  final List<QuestionAnswer> shortAnswers;
  final List<QuestionAnswer> longAnswers;
  final List<Numerical> numericals;
  final PYQAnalysis pyqAnalysis;
  final List<String> revisionSummary;
  final List<String> practiceTips;
  final List<String> referenceBooks;
  final String estimatedReadingTime;

  StudyPack({
    required this.chapter,
    required this.className,
    required this.subject,
    required this.language,
    required this.generatedOn,
    required this.summary,
    this.importantPoints = const [],
    this.formulas = const [],
    this.concepts = const [],
    this.mcqEasy = const [],
    this.mcqMedium = const [],
    this.mcqHard = const [],
    this.shortAnswers = const [],
    this.longAnswers = const [],
    this.numericals = const [],
    required this.pyqAnalysis,
    this.revisionSummary = const [],
    this.practiceTips = const [],
    this.referenceBooks = const [],
    this.estimatedReadingTime = '30 minutes',
  });

  factory StudyPack.fromJson(Map<String, dynamic> json) {
    return StudyPack(
      chapter: json['chapter'] ?? '',
      className: json['class'] ?? '',
      subject: json['subject'] ?? '',
      language: json['language'] ?? 'English',
      generatedOn: json['generated_on'] ?? DateTime.now().toIso8601String(),
      summary: json['summary'] ?? '',
      importantPoints: List<String>.from(json['important_points'] ?? []),
      formulas: (json['formulas'] as List<dynamic>?)
          ?.map((e) => Formula.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      concepts: (json['concepts_with_subtopics'] as List<dynamic>?)
          ?.map((e) => Concept.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      mcqEasy: (json['mcq_easy'] as List<dynamic>?)
          ?.map((e) => MCQ.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      mcqMedium: (json['mcq_medium'] as List<dynamic>?)
          ?.map((e) => MCQ.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      mcqHard: (json['mcq_hard'] as List<dynamic>?)
          ?.map((e) => MCQ.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      shortAnswers: (json['short_answer_questions'] as List<dynamic>?)
          ?.map((e) => QuestionAnswer.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      longAnswers: (json['long_answer_questions'] as List<dynamic>?)
          ?.map((e) => QuestionAnswer.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      numericals: (json['numericals'] as List<dynamic>?)
          ?.map((e) => Numerical.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      pyqAnalysis: json['pyq_analysis'] != null
          ? PYQAnalysis.fromJson(json['pyq_analysis'] as Map<String, dynamic>)
          : PYQAnalysis(),
      revisionSummary: List<String>.from(json['revision_summary'] ?? []),
      practiceTips: List<String>.from(json['practice_tips'] ?? []),
      referenceBooks: List<String>.from(json['reference_books'] ?? []),
      estimatedReadingTime: json['estimated_reading_time_minutes']?.toString() ?? '30',
    );
  }

  Map<String, dynamic> toJson() => {
    'chapter': chapter,
    'class': className,
    'subject': subject,
    'language': language,
    'generated_on': generatedOn,
    'summary': summary,
    'important_points': importantPoints,
    'formulas': formulas.map((e) => e.toJson()).toList(),
    'concepts_with_subtopics': concepts.map((e) => e.toJson()).toList(),
    'mcq_easy': mcqEasy.map((e) => e.toJson()).toList(),
    'mcq_medium': mcqMedium.map((e) => e.toJson()).toList(),
    'mcq_hard': mcqHard.map((e) => e.toJson()).toList(),
    'short_answer_questions': shortAnswers.map((e) => e.toJson()).toList(),
    'long_answer_questions': longAnswers.map((e) => e.toJson()).toList(),
    'numericals': numericals.map((e) => e.toJson()).toList(),
    'pyq_analysis': pyqAnalysis.toJson(),
    'revision_summary': revisionSummary,
    'practice_tips': practiceTips,
    'reference_books': referenceBooks,
    'estimated_reading_time_minutes': estimatedReadingTime,
  };
}
