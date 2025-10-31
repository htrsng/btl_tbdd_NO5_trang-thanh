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
    Map<String, int> scores = {'dầu': 0, 'khô': 0, 'nhạy cảm': 0};

    // 2. Phân tích từng câu trả lời và cộng điểm
    answers.forEach((key, answer) {
      // Logic cho da dầu
      if (answer.contains('dầu') ||
          answer.contains('nhờn') ||
          answer.contains('To rõ')) {
        scores['dầu'] = (scores['dầu'] ?? 0) + 3;
      }
      // Logic cho da khô
      if (answer.contains('khô') ||
          answer.contains('căng') ||
          answer.contains('bong tróc')) {
        scores['khô'] = (scores['khô'] ?? 0) + 3;
      }
      // Logic cho da nhạy cảm
      if (answer.contains('ngứa') ||
          answer.contains('rát') ||
          answer.contains('đỏ') ||
          answer.contains('kích ứng') ||
          answer.contains('châm chích')) {
        scores['nhạy cảm'] = (scores['nhạy cảm'] ?? 0) + 4;
      }

      // Logic đặc biệt cho các câu trả lời hỗn hợp
      if (key == 'q1' || key == 'q2' || key == 'q4') {
        if (answer.contains('vùng chữ T') && answer.contains('má')) {
          scores['dầu'] =
              (scores['dầu'] ?? 0) + 2; // Tăng nhẹ điểm dầu cho da hỗn hợp
          scores['khô'] =
              (scores['khô'] ?? 0) + 1; // Tăng nhẹ điểm khô cho da hỗn hợp
        }
      }
    });

    // 3. Tổng hợp kết quả thành một chuỗi mô tả
    List<String> descriptions = [];
    String primaryType;

    // Xác định loại da chính dựa trên điểm số cao nhất
    if ((scores['dầu'] ?? 0) > (scores['khô'] ?? 0) + 2) {
      primaryType = 'Da Dầu';
    } else if ((scores['khô'] ?? 0) > (scores['dầu'] ?? 0) + 2) {
      primaryType = 'Da Khô';
    } else if ((scores['dầu'] ?? 0) > 0 || (scores['khô'] ?? 0) > 0) {
      primaryType = 'Da Hỗn Hợp';
    } else {
      // Nếu không có dấu hiệu dầu hay khô rõ rệt, kiểm tra độ nhạy cảm
      if ((scores['nhạy cảm'] ?? 0) >= 5) {
        primaryType = 'Da Nhạy Cảm';
      } else {
        primaryType = 'Da Thường';
      }
    }
    descriptions.add(primaryType);

    // Thêm các đặc tính phụ nếu điểm số đủ cao và chưa được mô tả
    if ((scores['nhạy cảm'] ?? 0) >= 5 && primaryType != 'Da Nhạy Cảm') {
      descriptions.add('thiên nhạy cảm');
    }

    // Nối các mô tả lại với nhau, ví dụ: "Da Dầu, thiên nhạy cảm"
    return descriptions.join(', ');
  }
}

final analysisFlowProvider =
    StateNotifierProvider<AnalysisFlowNotifier, AnalysisFlowState>(
  (ref) => AnalysisFlowNotifier(ref),
);
