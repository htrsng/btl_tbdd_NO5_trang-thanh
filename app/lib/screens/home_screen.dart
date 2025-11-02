import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/skin_analysis_model.dart';
import '../providers/app_state_provider.dart';
import '../providers/analysis_flow_provider.dart';
import '../providers/history_provider.dart';
import '../providers/navigation_provider.dart';
import '../l10n/app_localizations.dart';

// Import các widget bước
import 'steps/intro_step.dart';
import 'steps/upload_step.dart';
import 'steps/survey_step.dart';
import 'steps/results_step.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final history = ref.watch(historyProvider);
    final l10n = AppLocalizations.of(context)!;

    // Kiểm tra xem người dùng có đang ở giữa một luồng phân tích hay không
    if (appState.currentStep != 0) {
      // Nếu CÓ, hiển thị luồng phân tích (Upload, Survey, Results)
      return _buildAnalysisFlow(context, ref, appState);
    } else {
      // Nếu KHÔNG, kiểm tra xem họ đã có lịch sử chưa
      if (history.isEmpty) {
        // Nếu chưa có lịch sử -> Đây là người dùng mới
        return const IntroStep(); // Hiển thị màn hình giới thiệu
      } else {
        // Nếu đã có lịch sử -> Đây là người dùng cũ
        return _buildDashboard(
            context, ref, history.first, l10n); // Hiển thị Dashboard
      }
    }
  }

  // --- GIAO DIỆN BẢNG ĐIỀU KHIỂN (DASHBOARD) MỚI ---
  Widget _buildDashboard(BuildContext context, WidgetRef ref,
      SkinAnalysis lastAnalysis, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final lastScore = lastAnalysis.skinScore.toStringAsFixed(1);
    final lastDate = DateFormat('dd/MM/yyyy').format(lastAnalysis.date!);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTab),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. Thẻ Tóm tắt & CTA chính
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l10n.welcomeBack,
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    l10n.lastSkinScore(lastScore, lastDate),
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(analysisFlowProvider.notifier).resetFlow();
                      ref.read(appStateProvider.notifier).setStep(1);
                    },
                    child: Text(l10n.startNewAnalysis),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 2. Giới thiệu các Tính năng
          _buildFeatureCard(
            context,
            ref,
            icon: Icons.lightbulb_outline,
            title: l10n.suggestionsReady,
            subtitle: l10n.suggestionsTeaser,
            buttonText: l10n.viewSuggestions,
            onPressed: () => ref.read(mainTabIndexProvider.notifier).state = 1,
          ),
          const SizedBox(height: 16),
          _buildFeatureCard(
            context,
            ref,
            icon: Icons.timeline,
            title: l10n.trackProgress,
            subtitle: l10n.trackProgressTeaser,
            buttonText: l10n.viewHistory,
            onPressed: () => ref.read(mainTabIndexProvider.notifier).state = 2,
          ),
          const SizedBox(height: 16),
          _buildFeatureCard(
            context,
            ref,
            icon: Icons.settings_outlined,
            title: l10n.customizeExperience,
            subtitle: l10n.customizeExperienceTeaser,
            buttonText: l10n.openSettings,
            onPressed: () => ref.read(mainTabIndexProvider.notifier).state = 3,
          ),
        ],
      ),
    );
  }

  // Widget con cho thẻ giới thiệu tính năng
  Widget _buildFeatureCard(BuildContext context, WidgetRef ref,
      {required IconData icon,
      required String title,
      required String subtitle,
      required String buttonText,
      required VoidCallback onPressed}) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary, size: 28),
                const SizedBox(width: 12),
                Text(title,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            Text(subtitle,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: Colors.grey.shade700, height: 1.4)),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onPressed,
                child: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- LUỒNG PHÂN TÍCH ---
  Widget _buildAnalysisFlow(
      BuildContext context, WidgetRef ref, AppState appState) {
    final analysis = appState.analysis;
    final isLoading =
        ref.watch(analysisFlowProvider.select((s) => s.isAnalyzing));
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: _buildAppBar(appState.currentStep, l10n, ref),
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildCurrentStep(appState.currentStep, analysis),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withAlpha(128),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Đang phân tích...',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            decoration: TextDecoration.none)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar(
      int step, AppLocalizations l10n, WidgetRef ref) {
    if (step == 0) return null; // IntroStep không có AppBar

    String title;
    switch (step) {
      case 1:
        title = l10n.uploadTitle;
        break;
      case 2:
        title = l10n.surveyTitle;
        break;
      case 3:
        title = l10n.resultsTitle;
        break;
      default:
        title = 'SkinAI';
    }
    return AppBar(
      title: Text(title),
      leading: (step == 1 || step == 2)
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () =>
                  ref.read(appStateProvider.notifier).setStep(step - 1),
            )
          : null,
      actions: [
        if (step == 3)
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              ref.read(analysisFlowProvider.notifier).resetFlow();
              ref.read(appStateProvider.notifier).setStep(0);
            },
          )
      ],
    );
  }

  // [SỬA LỖI] - Đảm bảo hàm này luôn trả về một Widget
  Widget _buildCurrentStep(int step, SkinAnalysis? analysis) {
    switch (step) {
      case 0:
        return const IntroStep();
      case 1:
        return const UploadStep();
      case 2:
        return const SurveyStep();
      case 3:
        if (analysis != null) {
          return ResultsStep(analysis: analysis);
        } else {
          // Trường hợp lỗi: quay về bước 1
          return const UploadStep();
        }
      // Trường hợp dự phòng: luôn quay về Intro
      default:
        return const IntroStep();
    }
  }
}
