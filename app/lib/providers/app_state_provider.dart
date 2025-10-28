import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/skin_analysis_model.dart';

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(AppState.initial());

  void setStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void setAnalysis(SkinAnalysis analysis) {
    state = state.copyWith(analysis: analysis);
  }
}

class AppState {
  final int currentStep; // 0: intro, 1: upload, 2: survey, 3: results
  final SkinAnalysis? analysis;

  AppState({required this.currentStep, this.analysis});

  factory AppState.initial() => AppState(currentStep: 0);

  AppState copyWith({int? currentStep, SkinAnalysis? analysis}) {
    return AppState(
      currentStep: currentStep ?? this.currentStep,
      analysis: analysis ?? this.analysis,
    );
  }
}

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>(
  (ref) => AppStateNotifier(),
);
