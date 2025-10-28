// lib/widgets/results/analysis_panel_content.dart
import 'package:flutter/material.dart';
import '../../models/skin_analysis_model.dart'; // Đảm bảo import model

class AnalysisPanelContent extends StatelessWidget {
  final SkinAnalysis analysis;

  const AnalysisPanelContent(this.analysis, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFFEEEEEE),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTopInfoCard(analysis),
              const SizedBox(height: 20),
              buildGridInfoCards(analysis),
              const SizedBox(height: 20),
              buildWarningBox(),
              const SizedBox(height: 20),
              buildProUnlockBar(),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 10),
            ],
          ),
        ),
      ],
    );
  }

  // ... (Dán toàn bộ các hàm buildTopInfoCard, buildGridInfoCards,
  // buildInfoCard, buildWarningBox, và buildProUnlockBar từ file gốc vào đây)
  Widget buildTopInfoCard(SkinAnalysis analysis) => Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: const Color(0xFFF3E5F5),
      borderRadius: BorderRadius.circular(16.0),
    ),
    child: IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Điểm trung bình",
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                ),
                const SizedBox(height: 12),
                const Icon(Icons.lock_outline, color: Colors.black, size: 28),
              ],
            ),
          ),
          VerticalDivider(color: Colors.purple.shade100, thickness: 1.5),
          const SizedBox(width: 16),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Vấn đề da",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          Text(
                            "Chuyên gia xác nhận",
                            style: TextStyle(
                              color: Colors.purple,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.purple,
                            size: 12,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...analysis.analysis['overall_issues'].map<Widget>(
                  (issue) => Text(
                    "- ${issue['label']}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget buildGridInfoCards(SkinAnalysis analysis) {
    final Color redDot = const Color(0xFFF44336);
    final Color orangeDot = const Color(0xFFFF9800);
    final Color purpleDot = const Color(0xFF673AB7);
    final Color blueDot = const Color(0xFF64B5F6);

    final issues = [
      'Mụn viêm',
      'Mụn không viêm',
      'Sợi bã nhờn',
      'Sẹo',
      'Sắc tố da',
      'Lỗ chân lông',
    ];
    final scores = [
      '8/10',
      '8/10',
      '8/10',
      '8/10',
      '8/10',
      '8/10',
    ]; // Random từ analysis nếu cần
    final colors = [redDot, orangeDot, purpleDot, redDot, orangeDot, blueDot];

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12.0,
      crossAxisSpacing: 12.0,
      childAspectRatio: 0.85,
      children: List.generate(
        6,
        (i) => buildInfoCard(
          issues[i],
          scores[i],
          colors[i],
          isHighlighted: i == 5,
        ),
      ),
    );
  }

  Widget buildInfoCard(
    String title,
    String score,
    Color dotColor, {
    bool isHighlighted = false,
  }) => Container(
    padding: const EdgeInsets.all(12.0),
    decoration: BoxDecoration(
      color: isHighlighted ? const Color(0xFFF3E5F5) : Colors.white,
      borderRadius: BorderRadius.circular(16.0),
      border: Border.all(color: Colors.grey.shade200, width: 1.5),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13.5,
            color: Colors.black87,
          ),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.lock_outline, color: Colors.black54, size: 20),
            Text(
              score,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const Spacer(),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
        ),
      ],
    ),
  );

  Widget buildWarningBox() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    decoration: BoxDecoration(
      color: const Color(0xFFFFEBEE),
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Row(
      children: [
        const Icon(Icons.cancel_rounded, color: Color(0xFFD32F2F)),
        const SizedBox(width: 12),
        Text(
          "Mỹ phẩm chưa phù hợp",
          style: TextStyle(
            color: const Color(0xFFC62828),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    ),
  );

  Widget buildProUnlockBar() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2), // Lỗi deprecated sẽ ở đây
          spreadRadius: 2,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.lock_open_rounded, color: Colors.black),
        const SizedBox(width: 12),
        Text(
          "Mở khoá Skindex Pro",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}
