// lib/screens/steps/results_step.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data'; // Giữ lại để code của bạn không lỗi

import '../../models/skin_analysis_model.dart';
import '../../widgets/painters/skin_area_painter.dart';
import '../../widgets/results/analysis_panel_content.dart';
import '../../providers/analysis_flow_provider.dart';

class ResultsStep extends StatelessWidget {
  final SkinAnalysis analysis;
  const ResultsStep({super.key, required this.analysis});

  /// HÀM MỚI: Tạo nhận xét dựa trên điểm số
  String _getScoreComment(double score) {
    String formattedScore = score.toStringAsFixed(1); // Làm tròn 1 chữ số
    if (score >= 9.0) {
      return "Tuyệt vời! Làn da của bạn gần như hoàn hảo ($formattedScore/10)";
    } else if (score >= 8.0) {
      return "Rất tốt! Da của bạn đang ở trạng thái khỏe mạnh ($formattedScore/10)";
    } else if (score >= 7.0) {
      return "Khá ổn! Cần chú ý một vài điểm nhỏ ($formattedScore/10)";
    } else if (score >= 6.0) {
      return "Bình thường. Da bạn cần được chăm sóc kỹ hơn ($formattedScore/10)";
    } else {
      return "Cần cải thiện! Hãy xem kỹ các đề xuất bên dưới ($formattedScore/10)";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Lớp 1: Ảnh nền - dùng Image.network với errorBuilder để tránh
          // lỗi không mong muốn khi tải ảnh (CORS / offline trên web).
          Positioned.fill(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  'https://i.unsplash.com/photo-1596245104991-8fbe840b151d?w=800&q=80',
                  fit: BoxFit.cover,
                  // Nếu load thất bại (statusCode 0 / CORS), hiển thị màu nền thay vì
                  // ném exception.
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: Colors.grey.shade900);
                  },
                ),
                // Lớp phủ tối như trước
                Container(color: Colors.black.withOpacity(0.1)),
              ],
            ),
          ),

          // Lớp 2: Hiển thị 3 ảnh và Nhận xét
          Positioned(
            top: 50, // Đẩy xuống một chút
            left: 20,
            right: 20,
            child: Column(
              // SỬA: Dùng Column để chứa cả ảnh và text
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 100, // SỬA: Giảm chiều cao của box
                  child: Consumer(
                    builder: (context, ref, child) {
                      final flow = ref.watch(analysisFlowProvider);

                      // LƯU Ý: Nếu ảnh của bạn không hiện, có thể do
                      // analysisFlowProvider đã bị reset. Bạn cần
                      // sửa provider để không reset `images` sau khi phân tích.

                      final imgs = flow.images;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(3, (i) {
                          final xfile = imgs[i];
                          return Container(
                            width: 90, // SỬA: Nhỏ hơn
                            height: 90, // SỬA: Nhỏ hơn
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.black26,
                              border: Border.all(
                                color: Colors.white70,
                                width: 1,
                              ),
                            ),
                            child: xfile != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: FutureBuilder<Uint8List?>(
                                      // Logic tải ảnh của bạn
                                      future:
                                          flow.imageBytes.containsKey(i) &&
                                              flow.imageBytes[i] != null
                                          ? Future.value(flow.imageBytes[i])
                                          : xfile.readAsBytes(),
                                      builder: (ctx, snap) {
                                        if (snap.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          );
                                        }
                                        final bytes = snap.data;
                                        if (bytes == null || bytes.isEmpty) {
                                          return const Center(
                                            child: Icon(Icons.broken_image),
                                          );
                                        }
                                        return Image.memory(
                                          bytes,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  )
                                : const Center(
                                    child: Icon(
                                      Icons.image,
                                      color: Colors.white70,
                                      size: 34,
                                    ),
                                  ),
                          );
                        }),
                      );
                    },
                  ),
                ),

                // THÊM MỚI: Nhận xét điểm số
                const SizedBox(height: 12),
                Text(
                  _getScoreComment(analysis.skinScore),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Lớp 3: Skin Overlays (từ code cũ của bạn, bị che bởi Lớp 2)
          // Bạn có thể xóa phần này nếu không dùng
          buildSkinOverlays(context),

          // Lớp 4: Draggable sheet
          buildDraggableSheet(analysis),
        ],
      ),
    );
  }

  // --- CÁC HÀM TỪ FILE GỐC ---
  Widget buildSkinOverlays(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const Color overlayColor = Color(0xFFA6E59A);

    return Stack(
      children: [
        Positioned(
          top: size.height * 0.3,
          left: size.width * 0.35,
          child: CustomPaint(
            size: Size(size.width * 0.25, size.height * 0.15),
            painter: SkinAreaPainter(
              color: overlayColor,
              path: Path()
                ..moveTo(0, size.height * 0.05)
                ..quadraticBezierTo(
                  0,
                  size.height * 0.1,
                  size.width * 0.12,
                  size.height * 0.13,
                )
                ..quadraticBezierTo(
                  size.width * 0.25,
                  size.height * 0.1,
                  size.width * 0.25,
                  size.height * 0.05,
                )
                ..lineTo(size.width * 0.15, 0)
                ..close(),
              dotCount: 200,
            ),
          ),
        ),
        Positioned(
          top: size.height * 0.35,
          left: size.width * 0.55,
          child: CustomPaint(
            size: Size(size.width * 0.3, size.height * 0.1),
            painter: SkinAreaPainter(
              color: overlayColor,
              path: Path()
                ..moveTo(0, size.height * 0.05)
                ..quadraticBezierTo(
                  size.width * 0.1,
                  size.height * 0.15,
                  size.width * 0.25,
                  size.height * 0.08,
                )
                ..quadraticBezierTo(
                  size.width * 0.3,
                  size.height * 0.02,
                  size.width * 0.15,
                  0,
                )
                ..quadraticBezierTo(size.width * 0.05, 0, 0, size.height * 0.05)
                ..close(),
              dotCount: 300,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDraggableSheet(SkinAnalysis analysis) => DraggableScrollableSheet(
    initialChildSize: 0.5,
    minChildSize: 0.45,
    maxChildSize: 0.9,
    builder: (context, scrollController) => Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(
              51,
            ), // SỬA LỖI: withOpacity -> withAlpha
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: SingleChildScrollView(
        controller: scrollController,
        child: AnalysisPanelContent(analysis), // Sử dụng widget đã tách
      ),
    ),
  );
}
