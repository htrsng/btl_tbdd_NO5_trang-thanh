// lib/screens/steps/intro_step.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_state_provider.dart';

class IntroStep extends ConsumerWidget {
  const IntroStep({super.key});

  void _goToUpload(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(appStateProvider.notifier);
    notifier.setStep(1);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Chuyển sang bước ${ref.read(appStateProvider).currentStep}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color.fromARGB(255, 161, 142, 32), Color(0xFF6dd5c0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(Icons.spa, color: Colors.white, size: 50),
        ),
        const SizedBox(height: 30),
        const Text(
          'Chào mừng đến với SkinAI',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: Color(0xFF006644),
          ),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Khám phá bí mật làn da của bạn với trí tuệ nhân tạo. '
            'Chỉ cần chụp ảnh và trả lời vài câu hỏi đơn giản!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.4),
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: const Color(0xFF00a86b),
            elevation: 6,
          ),
          onPressed: () => _goToUpload(context, ref),
          child: const Text(
            'Bắt đầu ngay',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
