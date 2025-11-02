// quản lý 2 việc: người dùng đang ở bước nào (currentStep) và kết quả phân tích cuối cùng là gì (SkinAnalysis? analysis).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/skin_analysis_model.dart';

class AppState {
  final int currentStep;
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

  void setAnalysis(SkinAnalysis analysis) {
    state = state.copyWith(
      analysis: analysis,
      currentStep: 3,
    );
  }
}

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>(
  (ref) => AppStateNotifier(),
);
