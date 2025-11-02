import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

import '../../l10n/app_localizations.dart';
import '../../models/skin_analysis_model.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/analysis_flow_provider.dart';
import '../../widgets/results/analysis_panel_content.dart';

// [CẢI TIẾN] - Chuyển sang ConsumerStatefulWidget để quản lý trạng thái của PageView
class ResultsStep extends ConsumerStatefulWidget {
  final SkinAnalysis analysis;
  const ResultsStep({super.key, required this.analysis});

  @override
  ConsumerState<ResultsStep> createState() => _ResultsStepState();
}

class _ResultsStepState extends ConsumerState<ResultsStep> {
  int _currentPage = 1; // Mặc định hiển thị ảnh chính diện (index 1)
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // [CẢI TIẾN #2] - Hàm helper giờ đây sử dụng đa ngôn ngữ
  String _getScoreComment(double score, AppLocalizations l10n) {
    String formattedScore = score.toStringAsFixed(1);
    if (score >= 9.0) return l10n.scoreCommentExcellent(formattedScore);
    if (score >= 8.0) return l10n.scoreCommentVeryGood(formattedScore);
    if (score >= 7.0) return l10n.scoreCommentGood(formattedScore);
    if (score >= 6.0) return l10n.scoreCommentAverage(formattedScore);
    return l10n.scoreCommentNeedsImprovement(formattedScore);
  }

  @override
  Widget build(BuildContext context) {
    final images = ref.watch(analysisFlowProvider.select((s) => s.images));
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // [CẢI TIẾN #1] - Lớp 1: Trình xem ảnh có thể lướt (PageView)
          _buildImagePageView(images),

          // Lớp 2: Các thành phần UI phía trên
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 8,
            right: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Nút Quay lại để quay về bước trước (Survey)
                IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 30),
                  onPressed: () =>
                      ref.read(appStateProvider.notifier).setStep(2),
                ),
                // [CẢI TIẾN #3] - Chỉ báo trang
                _buildPageIndicator(images.length),
                // [CẢI TIẾN #3] - Nút Đóng
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () {
                    // Reset luồng và quay về bước đầu tiên
                    ref.read(analysisFlowProvider.notifier).resetFlow();
                    ref.read(appStateProvider.notifier).setStep(0);
                  },
                ),
              ],
            ),
          ),

          // Lớp 3: Tấm panel kết quả có thể kéo
          _buildDraggableSheet(),
        ],
      ),
    );
  }

  // --- CÁC WIDGET CON ĐƯỢC TÁCH RA ---

  Widget _buildImagePageView(List<XFile?> images) {
    return PageView.builder(
      controller: _pageController,
      itemCount: images.length,
      onPageChanged: (index) => setState(() => _currentPage = index),
      itemBuilder: (context, index) {
        final imageFile = images[index];
        return Stack(
          fit: StackFit.expand,
          children: [
            if (imageFile != null)
              FutureBuilder<Uint8List>(
                future: imageFile.readAsBytes(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Image.memory(snapshot.data!, fit: BoxFit.cover);
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              )
            else
              Container(
                  color: Colors.grey.shade900,
                  child: const Icon(Icons.image_not_supported,
                      color: Colors.white54, size: 50)),
            Container(color: Colors.black.withAlpha(51)),
          ],
        );
      },
    );
  }

  Widget _buildPageIndicator(int pageCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          height: 8.0,
          width: _currentPage == index ? 24.0 : 8.0,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? Colors.white
                : Colors.white.withAlpha(128),
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }

  Widget _buildDraggableSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.45,
      maxChildSize: 0.9,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(51), blurRadius: 10.0)
          ],
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          // Truy cập analysis qua 'widget.analysis' vì đây là StatefulWidget
          child: AnalysisPanelContent(analysis: widget.analysis),
        ),
      ),
    );
  }
}
