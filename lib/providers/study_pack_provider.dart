import 'package:flutter/material.dart';
import '../models/study_pack.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class StudyPackProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  // Form State
  String? selectedClass;
  String? selectedExam;
  String? selectedSubject;
  String? selectedChapter;
  String selectedLanguage = 'English';

  // Generation State
  bool isLoading = false;
  String? error;
  StudyPack? currentStudyPack;
  List<StudyPack> history = [];

  StudyPackProvider() {
    _loadHistory();
  }

  void _loadHistory() {
    history = _storageService.getHistory();
    notifyListeners();
  }

  void setClass(String? value) {
    selectedClass = value;
    selectedSubject = null;
    selectedChapter = null;
    notifyListeners();
  }

  void setExam(String? value) {
    selectedExam = value;
    notifyListeners();
  }

  void setSubject(String? value) {
    selectedSubject = value;
    selectedChapter = null;
    notifyListeners();
  }

  void setChapter(String? value) {
    selectedChapter = value;
    notifyListeners();
  }

  void setLanguage(String value) {
    selectedLanguage = value;
    notifyListeners();
  }

  bool get canGenerate =>
      selectedClass != null &&
      selectedExam != null &&
      selectedSubject != null &&
      selectedChapter != null;

  Future<void> generateStudyPack() async {
    if (!canGenerate) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      currentStudyPack = await _apiService.generateStudyPack(
        className: selectedClass!,
        exam: selectedExam!,
        subject: selectedSubject!,
        chapter: selectedChapter!,
        language: selectedLanguage,
      );

      if (currentStudyPack != null) {
        await _storageService.saveStudyPack(currentStudyPack!);
        _loadHistory();
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      error = e.toString();
      notifyListeners();
    }
  }

  void clearCurrentPack() {
    currentStudyPack = null;
    notifyListeners();
  }

  void setCurrentStudyPack(StudyPack pack) {
    currentStudyPack = pack;
    notifyListeners();
  }

  Future<void> clearHistory() async {
    await _storageService.clearHistory();
    history.clear();
    notifyListeners();
  }
}
