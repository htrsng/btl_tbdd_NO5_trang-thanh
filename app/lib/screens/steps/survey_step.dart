// lib/screens/steps/survey_step.dart
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
  int _currentSurveyStep = 0;

  void _nextStep() {
    final questions = ref.read(surveyQuestionsProvider);
    final answers = ref.read(analysisFlowProvider).surveyAnswers;

    if (answers[questions[_currentSurveyStep]['id']]!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Chọn câu trả lời!')));
      return;
    }
    if (_currentSurveyStep < questions.length - 1) {
      setState(() => _currentSurveyStep++);
    } else {
      // Gọi provider để phân tích
      // Provider sẽ xử lý việc set loading và chuyển bước
      ref.read(analysisFlowProvider.notifier).analyze();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Đọc danh sách câu hỏi từ provider
    final questions = ref.watch(surveyQuestionsProvider);
    // Đọc danh sách câu trả lời để hiển thị
    final surveyAnswers = ref.watch(analysisFlowProvider).surveyAnswers;

    final q = questions[_currentSurveyStep];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Khảo sát nhanh (Câu ${_currentSurveyStep + 1}/${questions.length})',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              q['text'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // THAY THẾ BẰNG CODE MỚI NÀY:
            Column(
              children: (q['options'] as List).map((opt) {
                final String currentAnswer = surveyAnswers[q['id']] ?? "";
                return ListTile(
                  title: Text(opt),
                  // Dùng Radio() bên trong ListTile
                  leading: Radio<String>(
                    value: opt,
                    groupValue: currentAnswer,
                    onChanged: (val) {
                      ref
                          .read(analysisFlowProvider.notifier)
                          .setSurveyAnswer(q['id'], val ?? '');
                    },
                  ),
                  // Thêm onTap để người dùng có thể bấm vào bất cứ đâu
                  onTap: () {
                    ref
                        .read(analysisFlowProvider.notifier)
                        .setSurveyAnswer(q['id'], opt);
                  },
                );
              }).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentSurveyStep > 0)
                  TextButton(
                    onPressed: () => setState(() => _currentSurveyStep--),
                    child: const Text('Trước'),
                  ),
                const Spacer(), // Đẩy nút "Tiếp" sang phải
                ElevatedButton(
                  onPressed: _nextStep,
                  child: Text(
                    _currentSurveyStep == questions.length - 1
                        ? 'Gửi & Phân tích'
                        : 'Tiếp',
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
