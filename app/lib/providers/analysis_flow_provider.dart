import 'dart:math' as math;
// [SỬA LỖI] - Sửa 'package.' thành 'package:'
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../models/skin_analysis_model.dart';
import 'app_state_provider.dart';

// Lớp AnalysisFlowState (Giữ nguyên)
class AnalysisFlowState {
  final List<XFile?> images;
  final Map<String, String> surveyAnswers;
  final bool isAnalyzing;
  final String? error;

  const AnalysisFlowState({
    this.images = const [null, null, null],
    this.surveyAnswers = const {
      "q1": "",
      "q2": "",
      "q3": "",
      "q4": "",
      "q5": ""
    },
    this.isAnalyzing = false,
    this.error,
  });

  AnalysisFlowState copyWith({
    List<XFile?>? images,
    Map<String, String>? surveyAnswers,
    bool? isAnalyzing,
    String? error,
    bool clearError = false,
  }) {
    return AnalysisFlowState(
      images: images ?? this.images,
      surveyAnswers: surveyAnswers ?? this.surveyAnswers,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      error: clearError ? null : error ?? this.error,
    );
  }
}

// Class AnalysisFlowNotifier (Giữ nguyên)
class AnalysisFlowNotifier extends StateNotifier<AnalysisFlowState> {
  final Ref _ref;
  AnalysisFlowNotifier(this._ref) : super(const AnalysisFlowState());

  Future<void> setImage(int index, XFile image) async {
    final newImages = List<XFile?>.from(state.images);
    newImages[index] = image;
    state = state.copyWith(images: newImages);
  }

  void removeImage(int index) {
    final newImages = List<XFile?>.from(state.images);
    newImages[index] = null;
    state = state.copyWith(images: newImages);
  }

  void setSurveyAnswer(String questionId, String answer) {
    final newAnswers = Map<String, String>.from(state.surveyAnswers);
    newAnswers[questionId] = answer;
    state = state.copyWith(surveyAnswers: newAnswers);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void resetFlow() {
    state = const AnalysisFlowState();
  }

  Future<void> analyze() async {
    if (state.images.any((img) => img == null) ||
        state.surveyAnswers.values.any((ans) => ans.isEmpty)) {
      state = state.copyWith(error: "Vui lòng hoàn thành tất cả các bước.");
      return;
    }

    state = state.copyWith(isAnalyzing: true, clearError: true);
    await Future.delayed(const Duration(seconds: 2));

    try {
      final SkinAnalysis fakeResult = _generateFakeAnalysis();
      _ref.read(appStateProvider.notifier).setAnalysis(fakeResult);
      state = state.copyWith(isAnalyzing: false);
    } catch (e) {
      state = state.copyWith(isAnalyzing: false, error: "Lỗi bất ngờ: $e");
    }
  }

  SkinAnalysis _generateFakeAnalysis() {
    final random = math.Random();
    final detailedScores = {
      'acne': random.nextInt(10) + 1,
      'pores': random.nextInt(10) + 1,
      'pigmentation': random.nextInt(10) + 1,
      'wrinkles': random.nextInt(10) + 1,
      'texture': random.nextInt(10) + 1,
      'redness': random.nextInt(10) + 1,
    };
    final double averageScore =
        detailedScores.values.reduce((a, b) => a + b) / detailedScores.length;

    final String determinedSkinType =
        _determineSkinTypeFromSurvey(state.surveyAnswers);

    return SkinAnalysis(
      skinScore: averageScore,
      skinType: determinedSkinType,
      analysis: AnalysisDetail(
        overallIssues: [
          SkinIssueDetail(
              label: ['Mụn viêm', 'Sợi bã nhờn'][random.nextInt(2)],
              severity: "Cao")
        ],
        acne: detailedScores['acne']!,
        pores: detailedScores['pores']!,
        pigmentation: detailedScores['pigmentation']!,
        wrinkles: detailedScores['wrinkles']!,
        texture: detailedScores['texture']!,
        redness: detailedScores['redness']!,
      ),
      improvements: {
        "Cải thiện chung": ["Uống đủ nước", "Ngủ sớm"],
        "Vấn đề da": ["Giảm mụn ẩn", "Sử dụng BHA"],
      },
      lifestyleTips: {
        "🧘 1. Giấc ngủ & quản lý căng thẳng": [
          "Ngủ đủ 7-8 tiếng/đêm.",
          "Thiền 10 phút mỗi ngày."
        ],
        "🥗 2. Dinh dưỡng & bổ sung": [
          "Ăn nhiều rau xanh.",
          "Hạn chế đồ ngọt."
        ],
      },
      products: [
        ProductSuggestion(
            name: "Serum B5",
            brand: "La Roche-Posay",
            reason: "Phục hồi",
            image: "assets/images/shopping.webp"),
        ProductSuggestion(
            name: "Kem chống nắng Anessa",
            brand: "Shiseido",
            reason: "Bảo vệ da",
            image: "assets/images/kcn.webp"),
        ProductSuggestion(
            name: "Sữa rửa mặt Cetaphil",
            brand: "Galderma",
            reason: "Làm sạch da",
            image: "assets/images/srm.webp"),
      ],
      date: DateTime.now(),
    );
  }

  String _determineSkinTypeFromSurvey(Map<String, String> answers) {
    Map<String, int> scores = {'dầu': 0, 'khô': 0, 'nhạy cảm': 0};
    answers.forEach((key, answer) {
      if (answer.contains('dầu') ||
          answer.contains('nhờn') ||
          answer.contains('To rõ')) {
        scores['dầu'] = (scores['dầu'] ?? 0) + 3;
      }
      if (answer.contains('khô') ||
          answer.contains('căng') ||
          answer.contains('bong tróc')) {
        scores['khô'] = (scores['khô'] ?? 0) + 3;
      }
      if (answer.contains('ngứa') ||
          answer.contains('rát') ||
          answer.contains('đỏ') ||
          answer.contains('kích ứng') ||
          answer.contains('châm chích')) {
        scores['nhạy cảm'] = (scores['nhạy cảm'] ?? 0) + 4;
      }
      if (key == 'q1' || key == 'q2' || key == 'q4') {
        if (answer.contains('vùng chữ T') && answer.contains('má')) {
          scores['dầu'] = (scores['dầu'] ?? 0) + 2;
          scores['khô'] = (scores['khô'] ?? 0) + 1;
        }
      }
    });
    List<String> descriptions = [];
    String primaryType;
    if ((scores['dầu'] ?? 0) > (scores['khô'] ?? 0) + 2) {
      primaryType = 'Da Dầu';
    } else if ((scores['khô'] ?? 0) > (scores['dầu'] ?? 0) + 2) {
      primaryType = 'Da Khô';
    } else if ((scores['dầu'] ?? 0) > 0 || (scores['khô'] ?? 0) > 0) {
      primaryType = 'Da Hỗn Hợp';
    } else {
      if ((scores['nhạy cảm'] ?? 0) >= 5) {
        primaryType = 'Da Nhạy Cảm';
      } else {
        primaryType = 'Da Thường';
      }
    }
    descriptions.add(primaryType);
    if ((scores['nhạy cảm'] ?? 0) >= 5 && primaryType != 'Da Nhạy Cảm') {
      descriptions.add('thiên nhạy cảm');
    }
    return descriptions.join(', ');
  }
}

final analysisFlowProvider =
    StateNotifierProvider<AnalysisFlowNotifier, AnalysisFlowState>(
  (ref) => AnalysisFlowNotifier(ref),
);
