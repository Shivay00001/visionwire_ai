import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/themes.dart';
import '../config/constants.dart';
import '../providers/study_pack_provider.dart';
import 'generator_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.darkBackground,
              Color(0xFF1A1A2E),
              AppTheme.darkBackground,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(context),
                const SizedBox(height: 40),
                
                // Main Action Card
                _buildMainActionCard(context),
                const SizedBox(height: 30),
                
                // Features Grid
                _buildFeaturesGrid(),
                const SizedBox(height: 30),
                
                // Supported Exams
                _buildExamsSection(),
                const SizedBox(height: 30),
                
                // Recent History
                _buildHistorySection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
              ).createShader(bounds),
              child: const Text(
                appName,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              appTagline,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.history, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HistoryScreen()),
                );
              },
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2);
  }

  Widget _buildMainActionCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.3),
            AppTheme.secondaryColor.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: AppTheme.secondaryColor,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Generate Study Pack',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'AI-powered complete study material',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GeneratorScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                backgroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.rocket_launch, color: Colors.white),
                  SizedBox(width: 12),
                  Text(
                    'Start Generating',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.2);
  }

  Widget _buildFeaturesGrid() {
    final features = [
      {'icon': Icons.quiz, 'title': 'MCQs', 'subtitle': 'Easy/Medium/Hard'},
      {'icon': Icons.functions, 'title': 'Formulas', 'subtitle': 'With meanings'},
      {'icon': Icons.history_edu, 'title': 'PYQ Analysis', 'subtitle': '15+ years'},
      {'icon': Icons.lightbulb, 'title': 'Predictions', 'subtitle': 'AI-powered'},
      {'icon': Icons.note_alt, 'title': 'Revision', 'subtitle': 'Quick notes'},
      {'icon': Icons.picture_as_pdf, 'title': 'PDF Export', 'subtitle': 'Download'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Features',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            final feature = features[index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    feature['icon'] as IconData,
                    color: AppTheme.secondaryColor,
                    size: 28,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    feature['title'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    feature['subtitle'] as String,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms, delay: (100 * index).ms).scale(begin: const Offset(0.8, 0.8));
          },
        ),
      ],
    );
  }

  Widget _buildExamsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Supported Exams',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: supportedExams.map((exam) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.2),
                    AppTheme.secondaryColor.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
              ),
              child: Text(
                exam,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms, delay: 400.ms);
  }

  Widget _buildHistorySection(BuildContext context) {
    return Consumer<StudyPackProvider>(
      builder: (context, provider, _) {
        if (provider.history.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Study Packs',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HistoryScreen()),
                    );
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...provider.history.take(3).map((pack) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.book,
                        color: AppTheme.secondaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pack.chapter,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${pack.className} • ${pack.subject}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white38,
                      size: 16,
                    ),
                  ],
                ),
              );
            }),
          ],
        ).animate().fadeIn(duration: 500.ms, delay: 500.ms);
      },
    );
  }
}
