import 'dart:convert';
import 'package:dio/dio.dart';
import '../config/constants.dart';
import '../models/study_pack.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late Dio _dio;

  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: openRouterBaseUrl,
      connectTimeout: const Duration(seconds: 120),
      receiveTimeout: const Duration(seconds: 120),
      headers: {
        'Authorization': 'Bearer $openRouterApiKey',
        'Content-Type': 'application/json',
        'HTTP-Referer': 'https://visionwire.ai',
        'X-Title': 'VisionWire AI',
      },
    ));
  }

  String _buildPrompt({
    required String className,
    required String exam,
    required String subject,
    required String chapter,
    required String language,
    required int age,
  }) {
    final today = DateTime.now().toIso8601String().split('T')[0];
    
    return '''SYSTEM: You are an expert exam tutor, curriculum designer, and exam-analyst. You must produce machine-parseable JSON only, no extra commentary or text outside the JSON. Follow the exact schema and rules below. If you cannot answer something exactly (like verbatim past-year question), mark it 'UNVERIFIED_PYQ' — do NOT hallucinate.

USER: Generate a full study packet for:
- CLASS: "$className"
- EXAM: "$exam"
- SUBJECT: "$subject"
- CHAPTER: "$chapter"
- LANGUAGE: "$language"
- STUDENT_AGE: "$age"
- DIFFICULTY_SPLIT: {"easy": 30, "medium": 50, "hard": 20}

Output must be valid JSON only, exactly matching this schema (no extra keys):

{
  "chapter": "$chapter",
  "class": "$className",
  "subject": "$subject",
  "language": "$language",
  "generated_on": "$today",
  "summary": "400-600 words: simple explanation for a student of age $age; include 2-3 real-life examples and 1 suggestion for a visual diagram (describe it).",
  "important_points": ["bullet1","bullet2", "..."] (max 12 bullets),
  "formulas": [{"formula":"...","meaning":"...","notes":"..."}],
  "concepts_with_subtopics":[
    {"subtopic":"...","explanation":"150-300 words","key_terms":["..."],"example_problem":"question; solution steps; final answer"}
  ],
  "mcq_easy": [{"q":"...","options":["A","B","C","D"],"answer":"A","explanation":"..."}] (10 questions),
  "mcq_medium": [{"q":"...","options":["A","B","C","D"],"answer":"B","explanation":"..."}] (10 questions),
  "mcq_hard": [{"q":"...","options":["A","B","C","D"],"answer":"C","explanation":"..."}] (10 questions),
  "short_answer_questions": [{"q":"...","a":"..."}] (8-12 questions),
  "long_answer_questions": [{"q":"...","a":"..."}] (5-8 questions),
  "numericals": [{"q":"...","steps":"...","ans":"..."}] (5-8 problems),
  "pyq_analysis":{
    "past_years_pattern":[
      {"year":"YYYY","paper":"1/2","category":"MCQ/SA/LA/Numerical","topic_tag":"...","difficulty":"Easy/Med/Hard","notes":"(do not include verbatim PYQ unless verified)"}
    ],
    "most_frequent_topics":["t1","t2","t3","t4","t5","t6"],
    "top_predicted_questions":[{"q":"...","reason":"why likely based on past trend"}],
    "common_mistakes":["..."]
  },
  "revision_summary":["10 concise bullets for quick revision"],
  "practice_tips":["...","..."],
  "reference_books":["NCERT (chapter & page reference if known)","Other ref (pages)"],
  "estimated_reading_time_minutes": "XX"
}

RULES:
1. Do NOT hallucinate exact past-year questions. If unsure, use 'UNVERIFIED_PYQ'.
2. Keep language and examples age-appropriate for $age year old student.
3. For MCQs include one correct answer and 3 plausible distractors.
4. Return valid JSON only. Escape any quotes inside strings.
5. For formulas, always include units and variable definitions.
6. For numericals, include clear step-by-step solution.
7. Use $language language for explanations and questions.

Now produce the JSON for the chapter.''';
  }

  Future<StudyPack?> generateStudyPack({
    required String className,
    required String exam,
    required String subject,
    required String chapter,
    required String language,
  }) async {
    try {
      final age = classAgeMapping[className] ?? 15;
      final prompt = _buildPrompt(
        className: className,
        exam: exam,
        subject: subject,
        chapter: chapter,
        language: language,
        age: age,
      );

      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'deepseek/deepseek-chat',
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
          'temperature': 0.7,
          'max_tokens': 8000,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final content = data['choices'][0]['message']['content'] as String;
        
        // Extract JSON from the response
        String jsonStr = content;
        
        // Try to find JSON in the response if it's wrapped in markdown
        final jsonMatch = RegExp(r'```json?\s*([\s\S]*?)\s*```').firstMatch(content);
        if (jsonMatch != null) {
          jsonStr = jsonMatch.group(1) ?? content;
        }
        
        // Clean up the JSON string
        jsonStr = jsonStr.trim();
        if (jsonStr.startsWith('{') && jsonStr.endsWith('}')) {
          final jsonData = json.decode(jsonStr) as Map<String, dynamic>;
          return StudyPack.fromJson(jsonData);
        }
        
        // Try parsing the entire content as JSON
        final jsonData = json.decode(jsonStr) as Map<String, dynamic>;
        return StudyPack.fromJson(jsonData);
      }
      
      return null;
    } on DioException catch (e) {
      print('API Error: ${e.message}');
      print('Response: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('Error generating study pack: $e');
      rethrow;
    }
  }
}
