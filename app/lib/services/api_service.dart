import 'dart:io';
import 'dart:math';
import '../models/skin_analysis_model.dart';

class ApiService {
  static Future<SkinAnalysis?> analyze({
    required File leftImage,
    required File rightImage,
    required File frontImage,
    required Map<String, String> surveyAnswers,
  }) async {
    // Mock delay 1-3s như API thật
    await Future.delayed(Duration(seconds: Random().nextInt(3) + 1));

    final random = Random(
      DateTime.now().millisecondsSinceEpoch,
    ); // Random khác mỗi lần
    String skinType;
    if (surveyAnswers.values.any((ans) => ans.contains('dầu'))) {
      skinType = random.nextBool() ? 'da dầu' : 'da hỗn hợp thiên dầu';
    } else {
      skinType = ['da khô', 'da thường', 'da nhạy cảm'][random.nextInt(3)];
    }

    // Random score 5-9.5
    final skinScore = (random.nextDouble() * 4.5) + 5;

    // Random issues (1-3 issues, conf 0.2-0.8)
    final issues = <Map<String, dynamic>>[];
    final possibleIssues = ['acne', 'pores', 'pigment', 'wrinkle'];
    final numIssues = random.nextInt(3) + 1;
    for (int i = 0; i < numIssues; i++) {
      final label = possibleIssues[random.nextInt(possibleIssues.length)];
      issues.add({
        'label': label,
        'confidence': random.nextDouble() * 0.6 + 0.2,
        'side': 'front',
      });
    }

    // Random improvements & products
    final improvements = <String, List<String>>{};
    final products = <String, List<String>>{};
    for (var issue in issues) {
      final label = issue['label'] as String;
      final key = label == 'acne'
          ? 'mụn'
          : label == 'pores'
          ? 'lỗ chân lông to'
          : 'thâm/nám';
      improvements[key] = [
        'Tip ${random.nextInt(10)}: Rửa mặt nhẹ nhàng ${random.nextInt(3) + 1}x/ngày.',
        'Tip ${random.nextInt(10)}: Uống đủ ${random.nextInt(3) + 2} lít nước.',
        'Tip ${random.nextInt(10)}: Tránh nắng ${random.nextInt(3) + 1}h.',
      ];
      products[label] = [
        'Sản phẩm ${label} A ${random.nextInt(100)}',
        'Sản phẩm ${label} B ${random.nextInt(100)}',
      ];
    }
    products['general'] = [
      'Cetaphil cho $skinType',
      'Serum dưỡng ẩm random',
      'Kem chống nắng ${random.nextInt(50) + 30}SPF',
    ];

    final dummyJson = {
      "skin_score": skinScore.round(),
      "skin_type": skinType,
      "analysis": {"overall_issues": issues},
      "image_urls": {
        "left": "https://picsum.photos/512/512?random=${random.nextInt(1000)}",
        "right": "https://picsum.photos/512/512?random=${random.nextInt(1000)}",
        "front": "https://picsum.photos/512/512?random=${random.nextInt(1000)}",
      },
      "improvements": improvements,
      "products": products,
    };

    // Fix: fromJson chỉ nhận 1 arg (Map)
    return SkinAnalysis.fromJson(dummyJson);
  }
}
