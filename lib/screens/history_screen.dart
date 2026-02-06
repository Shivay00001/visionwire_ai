import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/themes.dart';
import '../providers/study_pack_provider.dart';
import 'result_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

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
        title: const Text(
          'Study Pack History',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Consumer<StudyPackProvider>(
            builder: (context, provider, _) {
              if (provider.history.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.white54),
                onPressed: () => _showClearDialog(context, provider),
              );
            },
          ),
        ],
      ),
      body: Consumer<StudyPackProvider>(
        builder: (context, provider, _) {
          if (provider.history.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 80,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No study packs generated yet',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Start generating to see your history',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.history.length,
            itemBuilder: (context, index) {
              final pack = provider.history[index];
              return GestureDetector(
                onTap: () {
                  provider.setCurrentStudyPack(pack);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ResultScreen()),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.cardBackground,
                        AppTheme.cardBackground.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Center(
                            child: Icon(Icons.book, color: Colors.white, size: 24),
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
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${pack.className} • ${pack.subject}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  _buildBadge('${pack.mcqEasy.length + pack.mcqMedium.length + pack.mcqHard.length} MCQs', AppTheme.primaryColor),
                                  const SizedBox(width: 8),
                                  _buildBadge(pack.language, AppTheme.secondaryColor),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white38,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: (80 * index).ms).slideX(begin: 0.1),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showClearDialog(BuildContext context, StudyPackProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Clear History?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This will delete all saved study packs. This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.clearHistory();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Clear All', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
