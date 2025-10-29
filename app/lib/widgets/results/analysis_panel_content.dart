import 'package:flutter/material.dart';
import '../../models/skin_analysis_model.dart';

class AnalysisPanelContent extends StatelessWidget {
  final SkinAnalysis analysis;

  // [SỬA LỖI #1] - Đảm bảo constructor sử dụng tham số có tên
  const AnalysisPanelContent({required this.analysis, super.key});

  // Hàm helper để lấy điểm số dạng số (int) một cách an toàn
  int _getScoreValue(String key) {
    // Sử dụng .toJson() để truy cập map gốc nếu cần,
    // nhưng tốt hơn là truy cập trực tiếp nếu model cho phép.
    // Dưới đây là cách truy cập trực tiếp, an toàn hơn.
    switch (key) {
      case 'acne':
        return analysis.analysis.acne;
      case 'pores':
        return analysis.analysis.pores;
      case 'pigmentation':
        return analysis.analysis.pigmentation;
      case 'wrinkles':
        return analysis.analysis.wrinkles;
      case 'texture':
        return analysis.analysis.texture;
      case 'redness':
        return analysis.analysis.redness;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    // [CẢI TIẾN #4] - Truy cập dữ liệu trực tiếp từ model đã type-safe
    final overallIssues = analysis.analysis.overallIssues;
    final scoreText = analysis.skinScore.toStringAsFixed(1);
    final skinType =
        analysis.skinType.isNotEmpty ? analysis.skinType : 'Chưa xác định';

    return Column(
      children: [
        // Tay nắm kéo
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTopInfoCard(context, scoreText, skinType, overallIssues),
              const SizedBox(height: 18),
              buildGridInfoCards(context),
              // Các phần còn lại như buildIssuesList, buildWarningBox có thể được thêm vào đây
            ],
          ),
        ),
      ],
    );
  }

  // --- CÁC WIDGET CON ĐÃ ĐƯỢC CẬP NHẬT ---

  Widget buildTopInfoCard(BuildContext context, String scoreText,
      String skinType, List<SkinIssueDetail> overallIssues) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withAlpha(20),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
            color: Theme.of(context).colorScheme.primary.withAlpha(40)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Điểm trung bình",
                    style:
                        TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                const SizedBox(height: 8),
                Text(scoreText,
                    style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
              ],
            ),
          ),
          Container(height: 64, width: 1, color: Colors.purple.shade100),
          const SizedBox(width: 12),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Vấn đề chính",
                    style:
                        TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                const SizedBox(height: 8),
                if (overallIssues.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: overallIssues.take(2).map((issue) {
                      return Chip(
                        label: Text(issue.label,
                            style: const TextStyle(fontSize: 12)),
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withAlpha(30),
                        side: BorderSide.none,
                        visualDensity: VisualDensity.compact,
                      );
                    }).toList(),
                  )
                else
                  Text("Tuyệt vời, không có vấn đề lớn!",
                      style: TextStyle(color: Colors.grey.shade700)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // [CẢI TIẾN #2] - Hiển thị điểm số động từ model
  Widget buildGridInfoCards(BuildContext context) {
    // Ánh xạ giữa tên hiển thị và key trong model AnalysisDetail
    final List<Map<String, dynamic>> issueDetails = [
      {'label': 'Mụn', 'key': 'acne', 'color': const Color(0xFFF44336)},
      {
        'label': 'Lỗ chân lông',
        'key': 'pores',
        'color': const Color(0xFF64B5F6)
      },
      {
        'label': 'Sắc tố',
        'key': 'pigmentation',
        'color': const Color(0xFFFF9800)
      },
      {
        'label': 'Nếp nhăn',
        'key': 'wrinkles',
        'color': const Color(0xFF673AB7)
      },
      {'label': 'Kết cấu da', 'key': 'texture', 'color': Colors.teal},
      {'label': 'Mẩn đỏ', 'key': 'redness', 'color': Colors.redAccent},
    ];

    return GridView.builder(
      itemCount: issueDetails.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 12.0,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, i) {
        final detail = issueDetails[i];
        // Dùng hàm helper để lấy điểm số động từ `analysis`
        final score = _getScoreValue(detail['key']);

        return buildInfoCard(
          detail['label'],
          score,
          detail['color'],
        );
      },
    );
  }

  // [CẢI TIẾN #3] - Giao diện thẻ mới, hiển thị điểm số thay vì ổ khóa
  Widget buildInfoCard(String title, int score, Color dotColor) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey.shade200, width: 1.2),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.5,
                  color: Colors.black87)),
          const Spacer(),
          Center(
            child: Text(
              score.toString(), // Hiển thị điểm số ở giữa
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28, // Font lớn hơn
                color: Colors.black87,
              ),
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              '/10',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
