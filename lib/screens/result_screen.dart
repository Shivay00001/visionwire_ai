import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/themes.dart';
import '../models/study_pack.dart';
import '../providers/study_pack_provider.dart';
import '../services/pdf_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PdfService _pdfService = PdfService();
  bool _isExporting = false;

  final List<String> _tabs = [
    'Summary',
    'MCQs',
    'Formulas',
    'Q&A',
    'PYQ',
    'Revision',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudyPackProvider>(
      builder: (context, provider, _) {
        final studyPack = provider.currentStudyPack;
        if (studyPack == null) {
          return Scaffold(
            backgroundColor: AppTheme.darkBackground,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: const Center(
              child: Text(
                'No study pack available',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppTheme.darkBackground,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                provider.clearCurrentPack();
                Navigator.pop(context);
              },
            ),
            title: Column(
              children: [
                Text(
                  studyPack.chapter,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${studyPack.className} • ${studyPack.subject}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: _isExporting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.secondaryColor),
                        ),
                      )
                    : const Icon(Icons.share, color: Colors.white),
                onPressed: _isExporting ? null : () => _exportPdf(studyPack),
              ),
              IconButton(
                icon: const Icon(Icons.download, color: Colors.white),
                onPressed: _isExporting ? null : () => _downloadPdf(studyPack),
              ),
            ],
          ),
          body: Column(
            children: [
              // Tab Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white54,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
                ),
              ).animate().fadeIn().slideY(begin: -0.2),

              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildSummaryTab(studyPack),
                    _buildMcqsTab(studyPack),
                    _buildFormulasTab(studyPack),
                    _buildQATab(studyPack),
                    _buildPyqTab(studyPack),
                    _buildRevisionTab(studyPack),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryTab(StudyPack studyPack) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            title: 'Summary',
            icon: Icons.article,
            child: Text(
              studyPack.summary,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 20),
          _buildInfoCard(
            title: 'Important Points',
            icon: Icons.star,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: studyPack.importantPoints.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            '${entry.key + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ).animate().fadeIn(delay: 200.ms),
        ],
      ),
    );
  }

  Widget _buildMcqsTab(StudyPack studyPack) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildDifficultyChip('Easy', AppTheme.easyColor, studyPack.mcqEasy.length),
                const SizedBox(width: 8),
                _buildDifficultyChip('Medium', AppTheme.mediumColor, studyPack.mcqMedium.length),
                const SizedBox(width: 8),
                _buildDifficultyChip('Hard', AppTheme.hardColor, studyPack.mcqHard.length),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (studyPack.mcqEasy.isNotEmpty) ...[
                  _buildMcqSection('Easy', studyPack.mcqEasy, AppTheme.easyColor),
                ],
                if (studyPack.mcqMedium.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildMcqSection('Medium', studyPack.mcqMedium, AppTheme.mediumColor),
                ],
                if (studyPack.mcqHard.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildMcqSection('Hard', studyPack.mcqHard, AppTheme.hardColor),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyChip(String label, Color color, int count) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: color.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMcqSection(String difficulty, List<MCQ> mcqs, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '$difficulty Questions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...mcqs.asMap().entries.map((entry) {
          return _buildMcqCard(entry.key + 1, entry.value, color);
        }),
      ],
    );
  }

  Widget _buildMcqCard(int number, MCQ mcq, Color accentColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(16),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              '$number',
              style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          mcq.question,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconColor: Colors.white54,
        collapsedIconColor: Colors.white54,
        children: [
          ...mcq.options.asMap().entries.map((opt) {
            final optionLabel = String.fromCharCode(65 + opt.key);
            final isCorrect = mcq.answer == optionLabel;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isCorrect ? AppTheme.successColor.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isCorrect ? AppTheme.successColor.withOpacity(0.5) : Colors.transparent,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isCorrect ? AppTheme.successColor : Colors.white12,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        optionLabel,
                        style: TextStyle(
                          color: isCorrect ? Colors.white : Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      opt.value,
                      style: TextStyle(
                        color: isCorrect ? Colors.white : Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  if (isCorrect)
                    const Icon(Icons.check_circle, color: AppTheme.successColor, size: 20),
                ],
              ),
            );
          }),
          if (mcq.explanation.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb, color: AppTheme.secondaryColor, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      mcq.explanation,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(delay: (50 * number).ms);
  }

  Widget _buildFormulasTab(StudyPack studyPack) {
    if (studyPack.formulas.isEmpty) {
      return _buildEmptyState('No formulas available', Icons.functions);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: studyPack.formulas.length,
      itemBuilder: (context, index) {
        final formula = studyPack.formulas[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor.withOpacity(0.15),
                AppTheme.secondaryColor.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.darkBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    formula.formula,
                    style: const TextStyle(
                      color: AppTheme.secondaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  formula.meaning,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                if (formula.notes.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline, color: AppTheme.warningColor, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          formula.notes,
                          style: const TextStyle(
                            color: AppTheme.warningColor,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.1);
      },
    );
  }

  Widget _buildQATab(StudyPack studyPack) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              tabs: [
                Tab(text: 'Short'),
                Tab(text: 'Long'),
                Tab(text: 'Numerical'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildQAList(studyPack.shortAnswers),
                _buildQAList(studyPack.longAnswers),
                _buildNumericalsList(studyPack.numericals),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQAList(List<QuestionAnswer> qaList) {
    if (qaList.isEmpty) {
      return _buildEmptyState('No questions available', Icons.quiz);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: qaList.length,
      itemBuilder: (context, index) {
        final qa = qaList[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.all(16),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Q${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            title: Text(
              qa.question,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            iconColor: Colors.white54,
            collapsedIconColor: Colors.white54,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: AppTheme.successColor, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Answer',
                          style: TextStyle(
                            color: AppTheme.successColor.withOpacity(0.9),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      qa.answer,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: (80 * index).ms);
      },
    );
  }

  Widget _buildNumericalsList(List<Numerical> numericals) {
    if (numericals.isEmpty) {
      return _buildEmptyState('No numerical problems available', Icons.calculate);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: numericals.length,
      itemBuilder: (context, index) {
        final numerical = numericals[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.all(16),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Icon(Icons.calculate, color: AppTheme.accentColor, size: 18),
              ),
            ),
            title: Text(
              numerical.question,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            iconColor: Colors.white54,
            collapsedIconColor: Colors.white54,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Solution Steps:',
                      style: TextStyle(
                        color: AppTheme.secondaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      numerical.steps,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check, color: AppTheme.successColor, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Answer: ${numerical.answer}',
                            style: const TextStyle(
                              color: AppTheme.successColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: (80 * index).ms);
      },
    );
  }

  Widget _buildPyqTab(StudyPack studyPack) {
    final pyq = studyPack.pyqAnalysis;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Most Frequent Topics
          if (pyq.mostFrequentTopics.isNotEmpty)
            _buildInfoCard(
              title: 'Most Frequent Topics',
              icon: Icons.trending_up,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: pyq.mostFrequentTopics.map((topic) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor.withOpacity(0.3),
                          AppTheme.secondaryColor.withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      topic,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ).animate().fadeIn(delay: 100.ms),

          const SizedBox(height: 20),

          // Predicted Questions
          if (pyq.predictedQuestions.isNotEmpty)
            _buildInfoCard(
              title: 'Predicted Questions',
              icon: Icons.auto_awesome,
              child: Column(
                children: pyq.predictedQuestions.asMap().entries.map((entry) {
                  final pq = entry.value;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.warningColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.warningColor.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.warningColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'PREDICTED',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          pq['q'] ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Reason: ${pq['reason'] ?? ''}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 20),

          // Common Mistakes
          if (pyq.commonMistakes.isNotEmpty)
            _buildInfoCard(
              title: 'Common Mistakes to Avoid',
              icon: Icons.warning_amber,
              child: Column(
                children: pyq.commonMistakes.map((mistake) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.close, color: AppTheme.errorColor, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            mistake,
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ).animate().fadeIn(delay: 300.ms),
        ],
      ),
    );
  }

  Widget _buildRevisionTab(StudyPack studyPack) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Revision Summary
          if (studyPack.revisionSummary.isNotEmpty)
            _buildInfoCard(
              title: 'Quick Revision',
              icon: Icons.flash_on,
              child: Column(
                children: studyPack.revisionSummary.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppTheme.successColor, Color(0xFF00E5CC)],
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Center(
                            child: Icon(Icons.check, color: Colors.white, size: 14),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ).animate().fadeIn(delay: 100.ms),

          const SizedBox(height: 20),

          // Practice Tips
          if (studyPack.practiceTips.isNotEmpty)
            _buildInfoCard(
              title: 'Practice Tips',
              icon: Icons.tips_and_updates,
              child: Column(
                children: studyPack.practiceTips.asMap().entries.map((entry) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lightbulb, color: AppTheme.secondaryColor, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 20),

          // Reference Books
          if (studyPack.referenceBooks.isNotEmpty)
            _buildInfoCard(
              title: 'Reference Books',
              icon: Icons.menu_book,
              child: Column(
                children: studyPack.referenceBooks.map((book) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.book, color: AppTheme.secondaryColor, size: 16),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            book,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ).animate().fadeIn(delay: 300.ms),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: AppTheme.secondaryColor, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white12, height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white24, size: 64),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: Colors.white38, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Future<void> _exportPdf(StudyPack studyPack) async {
    setState(() => _isExporting = true);
    try {
      final pdfBytes = await _pdfService.generatePdf(studyPack);
      final fileName = '${studyPack.className}_${studyPack.subject}_${studyPack.chapter}.pdf'
          .replaceAll(' ', '_');
      await _pdfService.sharePdf(pdfBytes, fileName);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error exporting PDF: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _downloadPdf(StudyPack studyPack) async {
    setState(() => _isExporting = true);
    try {
      final pdfBytes = await _pdfService.generatePdf(studyPack);
      final directory = await getApplicationDocumentsDirectory();
      final fileName = '${studyPack.className}_${studyPack.subject}_${studyPack.chapter}.pdf'
          .replaceAll(' ', '_');
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(pdfBytes);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF saved to: ${file.path}'),
            backgroundColor: AppTheme.successColor,
            action: SnackBarAction(
              label: 'Share',
              textColor: Colors.white,
              onPressed: () => _exportPdf(studyPack),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving PDF: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }
}
