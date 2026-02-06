import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/themes.dart';
import '../config/constants.dart';
import '../data/subjects_data.dart';
import '../providers/study_pack_provider.dart';
import 'result_screen.dart';

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
          ).createShader(bounds),
          child: const Text(
            'Generate Study Pack',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<StudyPackProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return _buildLoadingView();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Select Class'),
                const SizedBox(height: 12),
                _buildDropdown(
                  value: provider.selectedClass,
                  items: supportedClasses,
                  hint: 'Choose your class',
                  onChanged: (value) => provider.setClass(value),
                  icon: Icons.school,
                ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1),

                const SizedBox(height: 24),
                _buildSectionTitle('Select Exam'),
                const SizedBox(height: 12),
                _buildDropdown(
                  value: provider.selectedExam,
                  items: supportedExams,
                  hint: 'Choose exam type',
                  onChanged: (value) => provider.setExam(value),
                  icon: Icons.assignment,
                ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),

                const SizedBox(height: 24),
                _buildSectionTitle('Select Subject'),
                const SizedBox(height: 12),
                _buildDropdown(
                  value: provider.selectedSubject,
                  items: provider.selectedClass != null
                      ? subjectsByClass[provider.selectedClass] ?? []
                      : [],
                  hint: provider.selectedClass == null
                      ? 'Select class first'
                      : 'Choose subject',
                  onChanged: provider.selectedClass != null
                      ? (value) => provider.setSubject(value)
                      : null,
                  icon: Icons.menu_book,
                ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1),

                const SizedBox(height: 24),
                _buildSectionTitle('Select Chapter'),
                const SizedBox(height: 12),
                _buildDropdown(
                  value: provider.selectedChapter,
                  items: provider.selectedClass != null && provider.selectedSubject != null
                      ? getChapters(provider.selectedClass!, provider.selectedSubject!)
                      : [],
                  hint: provider.selectedSubject == null
                      ? 'Select subject first'
                      : 'Choose chapter',
                  onChanged: provider.selectedSubject != null
                      ? (value) => provider.setChapter(value)
                      : null,
                  icon: Icons.bookmark,
                ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1),

                const SizedBox(height: 24),
                _buildSectionTitle('Select Language'),
                const SizedBox(height: 12),
                _buildLanguageChips(provider).animate().fadeIn(delay: 500.ms),

                if (provider.error != null) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.errorColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.errorColor.withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: AppTheme.errorColor),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            provider.error!,
                            style: const TextStyle(color: AppTheme.errorColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 40),
                _buildGenerateButton(context, provider).animate().fadeIn(delay: 600.ms).scale(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 30,
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryColor.withOpacity(0.8),
                    ),
                  ),
                ).animate(onPlay: (controller) => controller.repeat())
                  .shimmer(duration: 1500.ms, color: AppTheme.secondaryColor.withOpacity(0.3)),
                const SizedBox(height: 24),
                const Text(
                  'Generating Study Pack...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'AI is preparing your personalized content',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9)),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                _buildLoadingStep('Analyzing chapter content', true),
                _buildLoadingStep('Generating MCQs', true),
                _buildLoadingStep('Creating formulas list', true),
                _buildLoadingStep('Analyzing PYQ patterns', false),
                _buildLoadingStep('Preparing revision notes', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingStep(String text, bool active) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? AppTheme.primaryColor.withOpacity(0.3) : Colors.white12,
            ),
            child: active
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.secondaryColor),
                    ),
                  )
                : Icon(Icons.circle, size: 8, color: Colors.white.withOpacity(0.3)),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: active ? Colors.white : Colors.white38,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required void Function(String?)? onChanged,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppTheme.secondaryColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        dropdownColor: AppTheme.cardBackground,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        hint: Text(hint, style: TextStyle(color: Colors.white.withOpacity(0.4))),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: onChanged,
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
      ),
    );
  }

  Widget _buildLanguageChips(StudyPackProvider provider) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: supportedLanguages.take(5).map((language) {
        final isSelected = provider.selectedLanguage == language;
        return GestureDetector(
          onTap: () => provider.setLanguage(language),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                    )
                  : null,
              color: isSelected ? null : AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isSelected ? Colors.transparent : Colors.white24,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.4),
                        blurRadius: 12,
                      ),
                    ]
                  : null,
            ),
            child: Text(
              language,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGenerateButton(BuildContext context, StudyPackProvider provider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: provider.canGenerate
            ? () async {
                await provider.generateStudyPack();
                if (provider.currentStudyPack != null && context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ResultScreen()),
                  );
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: provider.canGenerate ? AppTheme.primaryColor : Colors.grey.shade800,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome,
              color: provider.canGenerate ? Colors.white : Colors.white38,
            ),
            const SizedBox(width: 12),
            Text(
              'Generate Study Pack',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: provider.canGenerate ? Colors.white : Colors.white38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
