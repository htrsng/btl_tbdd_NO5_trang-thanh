// Dọn dẹp: Tất cả import được đặt ở đầu và không trùng lặp
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

import '../../models/skin_analysis_model.dart';
import '../../providers/analysis_flow_provider.dart';
import '../../widgets/results/analysis_panel_content.dart';

// Tùy chọn: Import painter nếu bạn muốn giữ lại các vùng highlight
// import '../../widgets/painters/skin_area_painter.dart';

class ResultsStep extends ConsumerWidget {
  final SkinAnalysis analysis;
  const ResultsStep({super.key, required this.analysis});

  // --- HÀM HELPER ---

  String _getScoreComment(double score) {
    String formattedScore = score.toStringAsFixed(1);
    if (score >= 9.0)
      return "Tuyệt vời! Làn da của bạn gần như hoàn hảo ($formattedScore/10)";
    if (score >= 8.0)
      return "Rất tốt! Da của bạn đang ở trạng thái khỏe mạnh ($formattedScore/10)";
    if (score >= 7.0)
      return "Khá ổn! Cần chú ý một vài điểm nhỏ ($formattedScore/10)";
    if (score >= 6.0)
      return "Bình thường. Da bạn cần được chăm sóc kỹ hơn ($formattedScore/10)";
    // Không cần 'else' ở đây vì nếu các điều kiện trên không đúng, nó sẽ tự động chạy dòng dưới.
    return "Cần cải thiện! Hãy xem kỹ các đề xuất bên dưới ($formattedScore/10)";
  }

  // --- HÀM BUILD CHÍNH ---

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final images = ref.watch(analysisFlowProvider.select((s) => s.images));
    final centerImage = images.length > 1 ? images[1] : null;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Lớp 1: Ảnh nền (dùng ảnh chính diện của người dùng)
          _buildBackgroundImage(centerImage),

          // Lớp 2: Các thành phần UI phía trên (thumbnail, nhận xét)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildThumbnailsRow(images),
                const SizedBox(height: 16),
                _buildScoreComment(),
              ],
            ),
          ),

          // Lớp 3: Tấm panel kết quả có thể kéo
          _buildDraggableSheet(),
        ],
      ),
    );
  }

  // --- CÁC WIDGET CON ĐƯỢC TÁCH RA CHO GỌN GÀNG ---

  Widget _buildBackgroundImage(XFile? imageFile) {
    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Hiển thị ảnh người dùng nếu có
          if (imageFile != null)
            FutureBuilder<Uint8List>(
              future: imageFile.readAsBytes(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Image.memory(snapshot.data!, fit: BoxFit.cover);
                }
                return Container(color: Colors.grey.shade900);
              },
            )
          else
            // Ảnh dự phòng nếu không có ảnh người dùng
            Image.network(
              'https://i.unsplash.com/photo-1596245104991-8fbe840b151d?w=800&q=80',
              fit: BoxFit.cover,
            ),

          // Lớp phủ tối để làm nổi bật text
          Container(
            color: Colors.black.withAlpha(51),
          ), // Tối ưu: Đổi từ withOpacity
          // Tùy chọn: Vẽ các vùng highlight ở đây nếu bạn vẫn muốn dùng
          // buildSkinOverlays(context),
        ],
      ),
    );
  }

  Widget _buildThumbnailsRow(List<XFile?> images) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final xfile = images.length > i ? images[i] : null;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white70, width: 1.5),
            ),
            child: xfile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: FutureBuilder<Uint8List>(
                      future: xfile.readAsBytes(),
                      builder: (ctx, snap) {
                        if (snap.hasData) {
                          return Image.memory(snap.data!, fit: BoxFit.cover);
                        }
                        return const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  )
                : const Icon(Icons.image_not_supported, color: Colors.white70),
          ),
        );
      }),
    );
  }

  Widget _buildScoreComment() {
    return Text(
      _getScoreComment(analysis.skinScore),
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        shadows: [
          Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
    );
  }

  Widget _buildDraggableSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.55, // Tăng nhẹ kích thước ban đầu
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(51), // Tối ưu: Đổi từ withOpacity
              blurRadius: 10.0,
            ),
          ],
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          // Sửa lỗi: Gọi constructor với tham số có tên 'analysis'
          child: AnalysisPanelContent(analysis: analysis),
        ),
      ),
    );
  }
}
