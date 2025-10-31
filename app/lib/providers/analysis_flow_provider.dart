import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../models/skin_analysis_model.dart';
import 'app_state_provider.dart';

// Lớp AnalysisFlowState không thay đổi, giữ nguyên
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

class AnalysisFlowNotifier extends StateNotifier<AnalysisFlowState> {
  final Ref _ref;
  AnalysisFlowNotifier(this._ref) : super(const AnalysisFlowState());

  // Các hàm setImage, removeImage, setSurveyAnswer, clearError, resetFlow không đổi...
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

  // Hàm analyze không đổi
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

  // Hàm _generateFakeAnalysis giờ đây gọi một helper "thông minh" hơn
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

    // [CẢI TIẾN] - Gọi hàm helper để xác định loại da một cách thông minh
    final String determinedSkinType =
        _determineSkinTypeFromSurvey(state.surveyAnswers);

    return SkinAnalysis(
      skinScore: averageScore,
      skinType: determinedSkinType, // <-- Sử dụng kết quả thông minh
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
        "Cải thiện chung": ["Uống đủ nước", "Ngủ sớm"]
      },
      products: [
        ProductSuggestion(
            name: "Serum B5",
            brand: "La Roche-Posay",
            reason: "Phục hồi",
            image: "https://via.placeholder.com/150")
      ],
      date: DateTime.now(),
    );
  }

  // [NÂNG CẤP "TRÍ TUỆ"] - Hàm này giờ đây sử dụng hệ thống tính điểm
  String _determineSkinTypeFromSurvey(Map<String, String> answers) {
    // 1. Khởi tạo điểm số cho các đặc tính
    Map<String, int> scores = {
      'dầu': 0,
      'khô': 0,
      'nhạy cảm': 0,
      'mụn': 0,
      'lão hóa': 0,
    };

    // 2. Tính điểm dựa trên TẤT CẢ các câu trả lời
    // Câu 1: Loại da
    switch (answers['q1']) {
      case 'Da dầu':
        scores['dầu'] = (scores['dầu'] ?? 0) + 5;
        break;
      case 'Da khô':
        scores['khô'] = (scores['khô'] ?? 0) + 5;
        break;
      case 'Da hỗn hợp':
        scores['dầu'] = (scores['dầu'] ?? 0) + 3;
        scores['khô'] = (scores['khô'] ?? 0) + 2;
        break;
      case 'Da nhạy cảm':
        scores['nhạy cảm'] = (scores['nhạy cảm'] ?? 0) + 5;
        break;
    }

    // Câu 2: Mối quan tâm
    switch (answers['q2']) {
      case 'Mụn':
        scores['mụn'] = (scores['mụn'] ?? 0) + 5;
        break;
      case 'Lão hóa':
        scores['lão hóa'] = (scores['lão hóa'] ?? 0) + 5;
        break;
      case 'Sắc tố':
        scores['lão hóa'] = (scores['lão hóa'] ?? 0) + 2;
        break; // Sắc tố liên quan đến lão hóa do nắng
      case 'Lỗ chân lông':
        scores['dầu'] = (scores['dầu'] ?? 0) + 2;
        break; // Lỗ chân lông to thường đi với da dầu
    }

    // Câu 3: Tiếp xúc nắng
    if (answers['q3'] == 'Hàng ngày') {
      scores['lão hóa'] = (scores['lão hóa'] ?? 0) + 3;
    }

    // Câu 5: Giấc ngủ
    if (answers['q5'] == 'Dưới 5 tiếng') {
      scores['lão hóa'] = (scores['lão hóa'] ?? 0) + 2;
      scores['nhạy cảm'] = (scores['nhạy cảm'] ?? 0) + 1;
    }

    // 3. Tổng hợp kết quả thành một chuỗi mô tả
    List<String> descriptions = [];

    // Xác định loại da chính (dầu/khô/hỗn hợp)
    if ((scores['dầu'] ?? 0) > (scores['khô'] ?? 0) + 2) {
      descriptions.add('Da Dầu');
    } else if ((scores['khô'] ?? 0) > (scores['dầu'] ?? 0) + 2) {
      descriptions.add('Da Khô');
    } else if ((scores['dầu'] ?? 0) > 0 || (scores['khô'] ?? 0) > 0) {
      descriptions.add('Da Hỗn Hợp');
    } else {
      descriptions.add('Da Thường');
    }

    // Thêm các đặc tính phụ nếu điểm số đủ cao
    if ((scores['nhạy cảm'] ?? 0) >= 5) {
      descriptions.add('nhạy cảm');
    }
    if ((scores['mụn'] ?? 0) >= 5) {
      descriptions.add('có xu hướng bị mụn');
    }
    if ((scores['lão hóa'] ?? 0) >= 5) {
      descriptions.add('có dấu hiệu lão hóa');
    }

    // Nếu không có đặc tính phụ, chỉ trả về loại da chính
    if (descriptions.length == 1) return descriptions.first;

    // Nối các mô tả lại với nhau, ví dụ: "Da Dầu, nhạy cảm, có xu hướng bị mụn"
    return descriptions.join(', ');
  }
}

final analysisFlowProvider =
    StateNotifierProvider<AnalysisFlowNotifier, AnalysisFlowState>(
  (ref) => AnalysisFlowNotifier(ref),
);
