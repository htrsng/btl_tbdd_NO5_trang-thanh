import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../models/skin_analysis_model.dart';
import 'app_state_provider.dart';

// [CẢI TIẾN #3] - Loại bỏ 'imageBytes' khỏi State để tiết kiệm bộ nhớ
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

  // [CẢI TIẾN #3] - Đơn giản hóa hàm setImage
  Future<void> setImage(int index, XFile image) async {
    final newImages = List<XFile?>.from(state.images);
    newImages[index] = image;
    state = state.copyWith(images: newImages);
  }

  // [CẢI TIẾN #3] - Đơn giản hóa hàm removeImage
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

  // [CẢI TIẾN #1] - Hàm analyze giờ đây rất gọn gàng, chỉ làm nhiệm vụ điều phối
  Future<void> analyze() async {
    if (state.images.any((img) => img == null)) {
      state = state.copyWith(error: "Vui lòng tải đủ 3 ảnh.");
      return;
    }
    if (state.surveyAnswers.values.any((ans) => ans.isEmpty)) {
      state = state.copyWith(error: "Vui lòng trả lời đủ khảo sát.");
      return;
    }

    state = state.copyWith(isAnalyzing: true, clearError: true);
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Gọi hàm để tạo kết quả giả
      final SkinAnalysis fakeResult = _generateFakeAnalysis();

      // Cập nhật state của ứng dụng với kết quả
      _ref.read(appStateProvider.notifier).setAnalysis(fakeResult);
      // Giữ lại ảnh và câu trả lời, chỉ tắt loading
      state = state.copyWith(isAnalyzing: false);
    } catch (e) {
      state = state.copyWith(isAnalyzing: false, error: "Lỗi bất ngờ: $e");
    }
  }

  // [CẢI TIẾN #1] - Tách toàn bộ logic tạo dữ liệu giả ra hàm riêng
  SkinAnalysis _generateFakeAnalysis() {
    final random = math.Random();

    // [CẢI TIẾN #2] - Tạo các điểm số chi tiết trước
    final detailedScores = {
      'acne': random.nextInt(10) + 1,
      'pores': random.nextInt(10) + 1,
      'pigmentation': random.nextInt(10) + 1,
      'wrinkles': random.nextInt(10) + 1,
      'texture': random.nextInt(10) + 1,
      'redness': random.nextInt(10) + 1,
    };

    // Tính điểm trung bình thực sự từ các điểm số chi tiết
    final double averageScore =
        detailedScores.values.reduce((a, b) => a + b) / detailedScores.length;

    final List<SkinIssueDetail> fakeIssues = [
      SkinIssueDetail(
          label: ['Mụn viêm', 'Sợi bã nhờn'][random.nextInt(2)],
          severity: "Cao"),
      SkinIssueDetail(
          label: ['Lỗ chân lông to', 'Mụn ẩn'][random.nextInt(2)],
          severity: "Trung bình"),
    ];

    final String fakeSkinType =
        ["Da Dầu", "Da Khô", "Da Hỗn Hợp"][random.nextInt(3)];

    return SkinAnalysis(
      skinScore: averageScore, // <-- Sử dụng điểm trung bình đã tính toán
      skinType: "$fakeSkinType (Kết quả ngẫu nhiên)",
      analysis: AnalysisDetail(
        overallIssues: fakeIssues,
        acne: detailedScores['acne']!,
        pores: detailedScores['pores']!,
        pigmentation: detailedScores['pigmentation']!,
        wrinkles: detailedScores['wrinkles']!,
        texture: detailedScores['texture']!,
        redness: detailedScores['redness']!,
      ),
      improvements: {
        "Cải thiện chung": ["Uống đủ 2 lít nước mỗi ngày", "Ngủ sớm hơn"],
        "Vấn đề da": ["Giảm mụn ẩn", "Sử dụng BHA"],
      },
      // [CẢI TIẾN #4] - Cập nhật cấu trúc dữ liệu products
      products: [
        ProductSuggestion(
            name: "Serum B5",
            brand: "La Roche-Posay",
            reason: "Giúp phục hồi và làm dịu da.",
            image: "https://via.placeholder.com/150/C6DEF6/FFFFFF?text=Serum"),
        ProductSuggestion(
            name: "Kem chống nắng Anessa",
            brand: "Shiseido",
            reason: "Bảo vệ da tối ưu khỏi tia UV.",
            image:
                "https://via.placeholder.com/150/F7D8E4/FFFFFF?text=Sunscreen"),
        ProductSuggestion(
            name: "Sữa rửa mặt Cetaphil",
            brand: "Cetaphil",
            reason: "Dịu nhẹ, phù hợp cho da nhạy cảm.",
            image:
                "https://via.placeholder.com/150/5080BE/FFFFFF?text=Cleanser")
      ],
      date: DateTime.now(),
    );
  }
}

final analysisFlowProvider =
    StateNotifierProvider<AnalysisFlowNotifier, AnalysisFlowState>(
  (ref) => AnalysisFlowNotifier(ref),
);
