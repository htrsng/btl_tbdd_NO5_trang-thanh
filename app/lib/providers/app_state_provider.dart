import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/skin_analysis_model.dart';

class AppState {
  final int currentStep; // 0: intro, 1: upload, 2: survey, 3: results
  final SkinAnalysis? analysis;

  const AppState({required this.currentStep, this.analysis});

  factory AppState.initial() => const AppState(currentStep: 0);

  AppState copyWith({int? currentStep, SkinAnalysis? analysis}) {
    return AppState(
      currentStep: currentStep ?? this.currentStep,
      analysis: analysis ?? this.analysis,
    );
  }
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(AppState.initial());

  void setStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  // [SỬA LỖI TẠI ĐÂY]
  // Hàm này giờ đây sẽ không chỉ lưu dữ liệu mà còn tự động chuyển sang bước 3.
  void setAnalysis(SkinAnalysis analysis) {
    state = state.copyWith(
      analysis: analysis,
      currentStep: 3, // <-- Dòng quan trọng nhất
    );
  }
}

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>(
  (ref) => AppStateNotifier(),
);
