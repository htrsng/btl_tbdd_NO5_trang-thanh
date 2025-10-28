// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/skin_analysis_model.dart'; // Đảm bảo bạn import model
import '../providers/app_state_provider.dart';
import '../providers/analysis_flow_provider.dart';

// Import các widget bước mới từ thư mục con 'steps'
import 'steps/intro_step.dart';
import 'steps/upload_step.dart';
import 'steps/survey_step.dart';
import 'steps/results_step.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final analysis = appState.analysis;
    // Lắng nghe trạng thái loading từ provider mới
    final isLoading = ref.watch(
      analysisFlowProvider.select((s) => s.isAnalyzing),
    );

    // Lắng nghe lỗi từ provider và hiển thị SnackBar nếu có
    ref.listen<String?>(analysisFlowProvider.select((s) => s.error), (
      previous,
      next,
    ) {
      if (next != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next), backgroundColor: Colors.red),
        );
        // Bạn có thể thêm một hàm trong notifier để xóa lỗi sau khi hiển thị
        // ref.read(analysisFlowProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text(
          'SkinAI — ${appState.currentStep == 0 ? "Giới thiệu" : "Bước ${appState.currentStep}"}',
        ),
        backgroundColor: Colors.green[100],
        leading:
            appState.currentStep > 0 &&
                appState.currentStep !=
                    3 // Không cho back từ màn kết quả
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                // Quay lại bước trước, vô hiệu hóa nút khi đang loading
                onPressed: isLoading
                    ? null
                    : () {
                        final currentStep = ref
                            .read(appStateProvider)
                            .currentStep;
                        ref
                            .read(appStateProvider.notifier)
                            .setStep(currentStep - 1);
                      },
              )
            : null,
      ),
      // Dùng Stack để hiển thị lớp loading che phủ toàn màn hình
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              // Đảm bảo key là duy nhất cho mỗi bước
              key: ValueKey(appState.currentStep),
              child: _buildCurrentStep(appState.currentStep, analysis),
            ),
          ),

          // Lớp loading che phủ
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Đang phân tích...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Hàm helper để làm gọn hàm build
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
        }
        // Trường hợp lỗi (ví dụ: reload app ở bước 3 mà không có data)
        // quay về bước 1
        return const UploadStep();
      default:
        return const IntroStep();
    }
  }
}
