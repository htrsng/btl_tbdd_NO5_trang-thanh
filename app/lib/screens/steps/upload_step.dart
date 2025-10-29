// lib/screens/steps/upload_step.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../../providers/app_state_provider.dart';
import '../../providers/analysis_flow_provider.dart';
import '../../widgets/painters/face_guide_painter.dart';

class UploadStep extends ConsumerStatefulWidget {
  const UploadStep({super.key});

  @override
  ConsumerState<UploadStep> createState() => _UploadStepState();
}

class _UploadStepState extends ConsumerState<UploadStep> {
  final ImagePicker _picker = ImagePicker();
  int _selectedAngleIndex = 1; // 0: Trái, 1: Chính diện (mặc định), 2: Phải
  int? _largePreviewIndex; // Thêm biến trạng thái cho chỉ số ảnh xem lớn

  void _startSurvey() {
    final images = ref.read(analysisFlowProvider).images;
    if (images.any((e) => e == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng tải lên đủ 3 ảnh')),
      );
      return;
    }
    ref.read(appStateProvider.notifier).setStep(2);
  }

  @override
  Widget build(BuildContext context) {
    // Lấy state một cách an toàn — watch chỉ phần images (imageBytes đã bị loại)
    final images = ref.watch(analysisFlowProvider.select((s) => s.images));
    final imagesUploaded = images.where((img) => img != null).length;

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            'Tải lên 3 ảnh (trái / chính / phải)',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              fit: StackFit.expand,
              children: [
                buildCameraPreview(),
                buildFaceGuide(),
                // Simplified top bar with only back and title
                Positioned(top: 8, left: 8, right: 8, child: buildTopBar()),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: buildBottomBar(images),
                ),
                // Vị trí cho ảnh xem lớn
                if (_largePreviewIndex != null)
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () => setState(() => _largePreviewIndex = null),
                      child: Container(
                        color: Colors.black87,
                        child: Center(
                          child: FutureBuilder<Uint8List?>(
                            future: images[_largePreviewIndex!]!.readAsBytes(),
                            builder: (ctx, snap) {
                              if (snap.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator(
                                    color: Colors.white);
                              }
                              final bytes = snap.data;
                              if (bytes == null || bytes.isEmpty) {
                                return const Icon(Icons.broken_image,
                                    color: Colors.white70, size: 64);
                              }
                              return InteractiveViewer(
                                child: Image.memory(bytes, fit: BoxFit.contain),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$imagesUploaded / 3',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      imagesUploaded == 3 ? Colors.green : Colors.grey,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: imagesUploaded == 3 ? _startSurvey : null,
                child: const Text(
                  'Tiếp',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        // Replace LinearProgressIndicator usage (remove borderRadius param)
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: imagesUploaded / 3,
                  backgroundColor: Colors.green[100],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                  minHeight: 8,
                ),
              ),
              if (imagesUploaded == 3)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    onPressed: _startSurvey,
                    child: const Text(
                      'Tiếp theo: Khảo sát loại da',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // --- CÁC HÀM BUILD GIAO DIỆN ---

  Widget buildCameraPreview() => Container(color: Colors.grey.shade700);

  Widget buildFaceGuide() => Center(
        child: SizedBox(
          width: 280,
          height: 400,
          child: CustomPaint(painter: FaceGuidePainter()),
        ),
      );

  Widget buildTopBar() => SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon:
                    const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                onPressed: () => ref.read(appStateProvider.notifier).setStep(0),
              ),
              Text(
                "Chụp ${_getAngleLabel(_selectedAngleIndex)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => ref.read(appStateProvider.notifier).setStep(0),
              ),
            ],
          ),
        ),
      );

  String _getAngleLabel(int index) => index == 0
      ? 'nghiêng trái'
      : index == 1
          ? 'chính diện'
          : 'nghiêng phải';

  // [ĐÃ CẬP NHẬT] - Bỏ `buildFaceAngleSelector`
  Widget buildBottomBar(List<XFile?> images) => Container(
        // withOpacity deprecated -> dùng withAlpha(0.8*255 = 204)
        color: Colors.black.withAlpha(204),
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(context).padding.bottom + 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Cụm icon chọn góc đã bị loại bỏ
            buildShutterControls(), // Nút chụp ảnh được đưa lên trên
            const SizedBox(height: 16),
            _buildThumbnailRow(images), // Hàng thumbnail giờ là bộ chọn chính
          ],
        ),
      );

  Widget _buildThumbnailRow(List<XFile?> images) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _thumbnail(0, 'Trái', images[0]),
            _thumbnail(1, 'Chính', images[1]),
            _thumbnail(2, 'Phải', images[2]),
          ],
        ),
      );

  Widget buildShutterControls() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(
              Icons.photo_library_outlined,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () => _showPickOptions(_selectedAngleIndex),
          ),
          GestureDetector(
            onTap: () => _showPickOptions(_selectedAngleIndex,
                source: ImageSource.camera),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border:
                    Border.all(color: Colors.grey.withOpacity(0.5), width: 4),
              ),
            ),
          ),
          // Dùng SizedBox để căn giữa nút chụp
          const SizedBox(width: 48), // Kích thước của IconButton (48x48)
        ],
      );

  // [ĐÃ NÂNG CẤP] - Thêm hiệu ứng visual khi được chọn
  Widget _thumbnail(int index, String label, XFile? img) {
    final bool isSelected = _selectedAngleIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedAngleIndex = index);
        // Tự động mở tùy chọn chọn ảnh khi nhấn vào thumbnail trống
        if (img == null) {
          _showPickOptions(index);
        }
      },
      onLongPress: img != null ? () => _confirmDelete(index) : null,
      child: Column(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              // Colors.grey.shade700.withOpacity(0.7) -> withAlpha(179)
              color: img != null
                  ? Colors.white
                  : Colors.grey.shade700.withAlpha(179),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: img != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(
                      10,
                    ), // Bo tròn nhẹ bên trong viền
                    child: FutureBuilder<Uint8List?>(
                      future: img.readAsBytes(),
                      builder: (ctx, snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          );
                        }
                        final b = snap.data;
                        if (b == null || b.isEmpty) {
                          return const Center(
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.white,
                            ),
                          );
                        }
                        return Image.memory(
                          b,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        );
                      },
                    ),
                  )
                : Center(
                    child: Icon(
                      _getIconForAngle(index),
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _thumbnailLower(int index, String label, XFile? img) {
    return GestureDetector(
      onTap: () {
        // set selected angle
        setState(() => _selectedAngleIndex = index);
        // if has image -> open large preview, else pick
        if (img != null) {
          setState(() => _largePreviewIndex = index);
        } else {
          _showPickOptions(index);
        }
      },
      onLongPress: img != null ? () => _confirmDelete(index) : null,
      child: Column(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: img != null
                  ? Colors.white
                  : Colors.grey.shade700.withAlpha(179),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: img != null
                  ? FutureBuilder<Uint8List?>(
                      future: img.readAsBytes(),
                      builder: (ctx, snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          );
                        }
                        final b = snap.data;
                        if (b == null || b.isEmpty) {
                          return const Center(child: Icon(Icons.broken_image));
                        }
                        return Image.memory(b, fit: BoxFit.cover);
                      },
                    )
                  : Center(
                      child: Icon(
                        _getIconForAngle(index),
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  IconData _getIconForAngle(int index) {
    switch (index) {
      case 0:
        return Icons.arrow_back_ios_new;
      case 2:
        return Icons.arrow_forward_ios;
      case 1:
      default:
        return Icons.face_retouching_natural_outlined;
    }
  }

  // --- CÁC HÀM LOGIC (Không thay đổi) ---

  Future<void> _confirmDelete(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa ảnh'),
        content: const Text('Bạn có chắc chắn muốn xóa ảnh này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      ref.read(analysisFlowProvider.notifier).removeImage(index);
    }
  }

  Future<void> _showPickOptions(int index, {ImageSource? source}) async {
    if (source != null) {
      await _pickImageForIndex(index, source);
      return;
    }

    await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Chọn từ thư viện'),
              onTap: () => Navigator.of(ctx).pop('gallery'),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Chụp ảnh mới'),
              onTap: () => Navigator.of(ctx).pop('camera'),
            ),
          ],
        ),
      ),
    ).then((choice) async {
      if (choice == 'gallery') {
        await _pickImageForIndex(index, ImageSource.gallery);
      } else if (choice == 'camera') {
        await _pickImageForIndex(index, ImageSource.camera);
      }
    });
  }

  Future<void> _pickImageForIndex(int index, ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (picked == null) return;

      // Use XFile.readAsBytes for both web and native so we don't need dart:io
      await ref.read(analysisFlowProvider.notifier).setImage(index, picked);
      if (!mounted) return;
      setState(() {
        _selectedAngleIndex = index;
        _largePreviewIndex = null;
      });
    } catch (e) {
      debugPrint('Pick error: $e');
      // fallback: try gallery if camera failed
      if (source == ImageSource.camera) {
        try {
          final XFile? fallback = await _picker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 85,
          );
          if (fallback == null) return;
          await ref
              .read(analysisFlowProvider.notifier)
              .setImage(index, fallback);
          if (!mounted) return;
          setState(() => _selectedAngleIndex = index);
          return;
        } catch (e2) {
          debugPrint('Fallback pick error: $e2');
        }
      }
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Lỗi khi chọn ảnh')));
      }
    }
  }
}
