// lib/providers/survey_questions_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/survey_questions.dart'; // Import file dữ liệu vừa tạo

// Provider này chỉ đơn giản là "cung cấp" danh sách câu hỏi
// Sau này bạn có thể thay 'return surveyQuestions;'
// bằng một lệnh gọi API để lấy câu hỏi từ server
final surveyQuestionsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return surveyQuestions;
});
