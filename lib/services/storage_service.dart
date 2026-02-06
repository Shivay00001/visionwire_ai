import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/study_pack.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const String _historyBoxName = 'study_pack_history';
  Box<String>? _historyBox;

  Future<void> init() async {
    // Skip Hive on web - it causes hanging issues
    if (!kIsWeb) {
      await Hive.initFlutter();
      _historyBox = await Hive.openBox<String>(_historyBoxName);
    }
  }

  Future<void> saveStudyPack(StudyPack studyPack) async {
    if (_historyBox == null) await init();
    
    final key = '${studyPack.className}_${studyPack.subject}_${studyPack.chapter}_${DateTime.now().millisecondsSinceEpoch}';
    await _historyBox!.put(key, json.encode(studyPack.toJson()));
  }

  List<StudyPack> getHistory() {
    if (_historyBox == null) return [];
    
    final List<StudyPack> history = [];
    for (final key in _historyBox!.keys) {
      final jsonStr = _historyBox!.get(key);
      if (jsonStr != null) {
        try {
          final data = json.decode(jsonStr) as Map<String, dynamic>;
          history.add(StudyPack.fromJson(data));
        } catch (e) {
          print('Error parsing saved study pack: $e');
        }
      }
    }
    return history.reversed.toList();
  }

  Future<void> deleteStudyPack(String key) async {
    if (_historyBox == null) await init();
    await _historyBox!.delete(key);
  }

  Future<void> clearHistory() async {
    if (_historyBox == null) await init();
    await _historyBox!.clear();
  }
}
