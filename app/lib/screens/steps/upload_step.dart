import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../../providers/app_state_provider.dart';
import '../../providers/analysis_flow_provider.dart';
import '../../widgets/painters/face_guide_painter.dart';
import '../../l10n/app_localizations.dart';

class UploadStep extends ConsumerStatefulWidget {
  const UploadStep({super.key});

  @override
  ConsumerState<UploadStep> createState() => _UploadStepState();
}

class _UploadStepState extends ConsumerState<UploadStep> {
  final ImagePicker _picker = ImagePicker();
  int _selectedAngleIndex = 1; // Mặc định là ảnh Chính diện
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Khởi tạo PageController để bắt đầu ở trang giữa (ảnh chính diện)
    _pageController = PageController(initialPage: _selectedAngleIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToSurvey() {
    ref.read(appStateProvider.notifier).setStep(2);
  }

  @override
  Widget build(BuildContext context) {
    final images = ref.watch(analysisFlowProvider).images;
    final imagesUploaded = images.where((img) => img != null).length;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Expanded(
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              fit: StackFit.expand,
              children: [
                // [CẢI TIẾN] - Lớp 1: Trình xem ảnh có thể lướt
                _buildImagePageView(images),

                // Lớp 3: Thanh tiêu đề
                Positioned(top: 0, left: 0, right: 0, child: buildTopBar()),

                // Lớp 4: Thanh điều khiển dưới cùng
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: buildBottomBar(images)),
              ],
            ),
          ),
        ),
        // [CẢI TIẾN] - Chỉ giữ lại một khu vực điều khiển duy nhất ở dưới
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${l10n.photosUploaded}: $imagesUploaded / 3',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              ElevatedButton(
                onPressed: imagesUploaded == 3 ? _goToSurvey : null,
                child: Text(l10n.continueButton),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- CÁC HÀM BUILD GIAO DIỆN ĐÃ ĐƯỢC CẬP NHẬT ---

  Widget _buildImagePageView(List<XFile?> images) {
    return PageView.builder(
      controller: _pageController,
      itemCount: 3,
      onPageChanged: (index) {
        setState(() => _selectedAngleIndex = index);
      },
      itemBuilder: (context, index) {
        final imageFile = images[index];
        if (imageFile == null) {
          return Container(color: Colors.black);
        }
        return FutureBuilder<Uint8List>(
          future: imageFile.readAsBytes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Image.memory(snapshot.data!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity);
            }
            return const Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }

  Widget buildFaceGuide() => Center(
      child:
          CustomPaint(painter: FaceGuidePainter(), size: const Size(280, 400)));

  Widget buildTopBar() {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () => ref.read(appStateProvider.notifier).setStep(0),
            ),
            Text(
              "${l10n.uploadPhoto} (${_getAngleLabel(_selectedAngleIndex, l10n)})",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            // Placeholder để căn giữa tiêu đề
            const Opacity(
                opacity: 0,
                child: IconButton(icon: Icon(Icons.close), onPressed: null)),
          ],
        ),
      ),
    );
  }

  String _getAngleLabel(int index, AppLocalizations l10n) => index == 0
      ? l10n.leftAngle
      : (index == 1 ? l10n.centerAngle : l10n.rightAngle);

  Widget buildBottomBar(List<XFile?> images) => Container(
        color: Colors.black.withAlpha(204),
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, MediaQuery.of(context).padding.bottom + 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThumbnailRow(images),
            const SizedBox(height: 24),
            buildShutterControls(),
          ],
        ),
      );

  Widget buildShutterControls() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.photo_library_outlined,
                color: Colors.white, size: 30),
            onPressed: () =>
                _pickImageForIndex(_selectedAngleIndex, ImageSource.gallery),
          ),
          GestureDetector(
            onTap: () =>
                _pickImageForIndex(_selectedAngleIndex, ImageSource.camera),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.grey.withAlpha(128), width: 4),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios_outlined,
                color: Colors.white, size: 30),
            onPressed: null, // TODO: Thêm logic chuyển camera
          ),
        ],
      );

  Widget _buildThumbnailRow(List<XFile?> images) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _thumbnail(0, l10n.leftAngle, images[0]),
        _thumbnail(1, l10n.centerAngle, images[1]),
        _thumbnail(2, l10n.rightAngle, images[2]),
      ],
    );
  }

  Widget _thumbnail(int index, String label, XFile? img) {
    final bool isSelected = _selectedAngleIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedAngleIndex = index);
        _pageController.animateToPage(index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
        if (img == null) {
          _pickImageForIndex(index, ImageSource.gallery);
        }
      },
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isSelected ? Colors.grey[700] : Colors.grey[850],
              border: isSelected
                  ? Border.all(color: Colors.white, width: 2.0)
                  : null,
            ),
            child: img != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FutureBuilder<Uint8List>(
                      future: img.readAsBytes(),
                      builder: (ctx, snap) {
                        if (snap.hasData) {
                          return Image.memory(snap.data!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity);
                        }
                        return const Center(
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white));
                      },
                    ),
                  )
                : Icon(_getIconForAngle(index), color: Colors.white, size: 30),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade400,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  IconData _getIconForAngle(int index) => index == 0
      ? Icons.arrow_back_ios_new
      : (index == 1
          ? Icons.face_retouching_natural_outlined
          : Icons.arrow_forward_ios);

  // --- CÁC HÀM LOGIC (Giữ nguyên, chỉ bỏ debugPrint) ---
  Future<void> _pickImageForIndex(int index, ImageSource source) async {
    try {
      final XFile? picked =
          await _picker.pickImage(source: source, imageQuality: 85);
      if (picked == null || !mounted) return;

      await ref.read(analysisFlowProvider.notifier).setImage(index, picked);
      setState(() {
        _selectedAngleIndex = index;
        // Ra lệnh cho PageView lướt đến ảnh vừa chọn
        _pageController.animateToPage(index,
            duration: const Duration(milliseconds: 10), curve: Curves.easeIn);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã xảy ra lỗi khi chọn ảnh')));
      }
    }
  }
}
