// Giao diện khảo sát theo từng câu hỏi.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/analysis_flow_provider.dart';
import '../../providers/survey_questions_provider.dart';

class SurveyStep extends ConsumerStatefulWidget {
  const SurveyStep({super.key});

  @override
  ConsumerState<SurveyStep> createState() => _SurveyStepState();
}

class _SurveyStepState extends ConsumerState<SurveyStep> {
  int _currentQuestionIndex = 0;

  void _nextQuestion() {
    final questions = ref.read(surveyQuestionsProvider);
    final answers = ref.read(analysisFlowProvider).surveyAnswers;

    if (answers[questions[_currentQuestionIndex]['id']]!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn một câu trả lời!')),
      );
      return;
    }

    if (_currentQuestionIndex < questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      ref.read(analysisFlowProvider.notifier).analyze();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Đọc danh sách câu hỏi và câu trả lời từ provider
    final questions = ref.watch(surveyQuestionsProvider);
    final surveyAnswers = ref.watch(analysisFlowProvider).surveyAnswers;

    // Lấy câu hỏi hiện tại để hiển thị
    final currentQuestion = questions[_currentQuestionIndex];
    final questionId = currentQuestion['id'] as String;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Phần tiêu đề và tiến trình ---
            Text(
              'Khảo sát nhanh (Câu ${_currentQuestionIndex + 1}/${questions.length})',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            // Thanh tiến trình
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / questions.length,
              backgroundColor: Colors.grey.shade200,
              minHeight: 6,
            ),
            const SizedBox(height: 24),

            // --- Phần câu hỏi và lựa chọn ---
            Text(
              currentQuestion['text'] as String,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // [SỬA LỖI] - Dùng Column và RadioListTile thay cho code cũ
            Column(
              children: (currentQuestion['options'] as List<String>).map((
                option,
              ) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: RadioListTile<String>(
                    title: Text(option),
                    value: option,
                    groupValue: surveyAnswers[questionId] ?? "",
                    onChanged: (value) {
                      // Khi chọn, gọi notifier để cập nhật state
                      if (value != null) {
                        ref
                            .read(analysisFlowProvider.notifier)
                            .setSurveyAnswer(questionId, value);
                      }
                    },
                    activeColor: Theme.of(context).primaryColor,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // --- Phần nút điều hướng ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Nút "Trước" chỉ hiện khi không phải câu đầu tiên
                if (_currentQuestionIndex > 0)
                  TextButton(
                    onPressed: _previousQuestion,
                    child: const Text('<< Quay lại'),
                  ),
                // Dùng Spacer để đẩy nút "Tiếp" sang phải nếu nút "Trước" bị ẩn
                if (_currentQuestionIndex == 0) const Spacer(),

                ElevatedButton(
                  onPressed: _nextQuestion,
                  child: Text(
                    // Thay đổi text của nút ở câu hỏi cuối cùng
                    _currentQuestionIndex == questions.length - 1
                        ? 'Hoàn thành & Phân tích'
                        : 'Tiếp theo',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
