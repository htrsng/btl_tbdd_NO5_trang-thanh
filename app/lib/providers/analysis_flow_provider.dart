// lib/providers/analysis_flow_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'dart:math' as math;

import '../models/skin_analysis_model.dart';
import 'app_state_provider.dart';

class AnalysisFlowState {
  final List<XFile?> images;
  final Map<int, Uint8List?> imageBytes;
  final Map<String, String> surveyAnswers;
  final bool isAnalyzing;
  final String? error;

  AnalysisFlowState({
    List<XFile?>? images,
    Map<int, Uint8List?>? imageBytes,
    Map<String, String>? surveyAnswers,
    this.isAnalyzing = false,
    this.error,
  }) : images = images ?? [null, null, null],
       imageBytes = imageBytes ?? {},
       surveyAnswers =
           surveyAnswers ?? {"q1": "", "q2": "", "q3": "", "q4": "", "q5": ""};

  AnalysisFlowState copyWith({
    List<XFile?>? images,
    Map<int, Uint8List?>? imageBytes,
    Map<String, String>? surveyAnswers,
    bool? isAnalyzing,
    String? error,
    bool clearError = false,
  }) {
    return AnalysisFlowState(
      images: images ?? this.images,
      imageBytes: imageBytes ?? this.imageBytes,
      surveyAnswers: surveyAnswers ?? this.surveyAnswers,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class AnalysisFlowNotifier extends StateNotifier<AnalysisFlowState> {
  final Ref _ref;
  AnalysisFlowNotifier(this._ref) : super(AnalysisFlowState());

  Future<void> setImage(int index, XFile image) async {
    final newImages = List<XFile?>.from(state.images);
    newImages[index] = image;
    if (kIsWeb) {
      try {
        final bytes = await image.readAsBytes();
        final newBytes = Map<int, Uint8List?>.from(state.imageBytes);
        newBytes[index] = bytes;
        state = state.copyWith(images: newImages, imageBytes: newBytes);
        return;
      } catch (e) {
        // fallthrough to set without bytes
      }
    }
    state = state.copyWith(images: newImages);
  }

  void removeImage(int index) {
    final newImages = List<XFile?>.from(state.images);
    newImages[index] = null;
    final newBytes = Map<int, Uint8List?>.from(state.imageBytes);
    newBytes.remove(index);
    state = state.copyWith(images: newImages, imageBytes: newBytes);
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
    state = AnalysisFlowState();
  }

  Future<void> analyze() async {
    if (state.images.any((img) => img == null)) {
      state = state.copyWith(
        error: "Vui lòng tải đủ 3 ảnh (dù chỉ là tượng trưng).",
      );
      return;
    }
    if (state.surveyAnswers.values.any((ans) => ans.isEmpty)) {
      state = state.copyWith(error: "Vui lòng trả lời đủ khảo sát.");
      return;
    }

    state = state.copyWith(isAnalyzing: true, clearError: true);
    await Future.delayed(const Duration(seconds: 2));

    try {
      final random = math.Random();
      final double fakeScore = 6.0 + (random.nextDouble() * 3.9);
      final List<String> allIssues = [
        'Mụn viêm',
        'Mụn ẩn',
        'Sợi bã nhờn',
        'Da không đều màu',
        'Lỗ chân lông to',
        'Da nhạy cảm',
      ];
      final List<Map<String, dynamic>> fakeIssues = [
        {
          "label": allIssues[random.nextInt(allIssues.length)],
          "severity": "High",
        },
        {
          "label": allIssues[random.nextInt(allIssues.length)],
          "severity": "Medium",
        },
      ];

      final List<String> skinTypes = [
        "Da Dầu",
        "Da Khô",
        "Da Hỗn Hợp",
        "Da Thường",
      ];
      final String fakeSkinType = skinTypes[random.nextInt(skinTypes.length)];

      final SkinAnalysis fakeResult = SkinAnalysis(
        skinScore: fakeScore,
        skinType: "$fakeSkinType (Random)",
        analysis: {
          'overall_issues': fakeIssues,
          'acne': random.nextInt(10) + 1,
          'pores': random.nextInt(10) + 1,
          'pigmentation': random.nextInt(10) + 1,
          'wrinkles': random.nextInt(10) + 1,
          'texture': random.nextInt(10) + 1,
          'redness': random.nextInt(10) + 1,
        },
        improvements: {
          "Cải thiện chung (Random)": [
            "Uống đủ 2 lít nước mỗi ngày",
            "Ngủ sớm hơn",
          ],
          "Vấn đề da (Random)": ["Giảm mụn ẩn"],
        },
        products: {
          "Làm sạch (Random)": ["Sữa rửa mặt dịu nhẹ"],
          "Dưỡng ẩm (Random)": ["Kem dưỡng B5", "Serum HA"],
          "Bảo vệ (Random)": ["Kem chống nắng SPF 50+"],
        },
      );

      _ref.read(appStateProvider.notifier).setAnalysis(fakeResult);
      _ref.read(appStateProvider.notifier).setStep(3);
      state = AnalysisFlowState();
    } catch (e) {
      state = state.copyWith(isAnalyzing: false, error: "Lỗi bất ngờ: $e");
    }
  }
}

final analysisFlowProvider =
    StateNotifierProvider<AnalysisFlowNotifier, AnalysisFlowState>(
      (ref) => AnalysisFlowNotifier(ref),
    );
