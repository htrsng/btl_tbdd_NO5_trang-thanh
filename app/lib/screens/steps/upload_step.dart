// lib/screens/steps/upload_step.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
// kIsWeb no longer needed here; image bytes are read from XFile for all platforms
import 'dart:typed_data';
import 'dart:math' as math;
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

  void _startSurvey() {
    // Đọc state từ provider
    final images = ref.read(analysisFlowProvider).images;
    if (images.any((e) => e == null)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Vui lòng chụp đủ 3 ảnh')));
      return;
    }
    ref.read(appStateProvider.notifier).setStep(2);
  }

  @override
  Widget build(BuildContext context) {
    // Lắng nghe provider để rebuild khi ảnh thay đổi
    final images = ref.watch(analysisFlowProvider).images;
    final imageBytes = ref.watch(analysisFlowProvider).imageBytes;
    final imagesUploaded = images.where((img) => img != null).length;

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Chụp 3 ảnh theo hướng dẫn (ánh sáng tốt, không makeup! 😊)',
            style: TextStyle(
              fontSize: 17,
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
                buildTopBar(),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: buildBottomBar(
                    images,
                    imageBytes,
                  ), // Truyền `images` vào
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: imagesUploaded / 3,
                backgroundColor: Colors.green[100],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                borderRadius: BorderRadius.circular(10),
                minHeight: 8,
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

  // --- CÁC HÀM TỪ FILE GỐC ---

  Widget buildCameraPreview() => Container(color: Colors.grey.shade700);

  Widget buildFaceGuide() => Center(
    child: SizedBox(
      width: 280,
      height: 400,
      child: CustomPaint(painter: FaceGuidePainter()),
    ),
  );

  Widget buildTopBar() => Positioned(
    top: 0,
    left: 0,
    right: 0,
    child: SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Nút back này bây giờ có thể hoạt động!
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
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
    ),
  );

  String _getAngleLabel(int index) => index == 0
      ? 'nghiêng trái'
      : index == 1
      ? 'chính diện'
      : 'nghiêng phải';

  Widget buildBottomBar(List<XFile?> images, Map<int, Uint8List?> imageBytes) =>
      Container(
        color: Colors.black.withOpacity(0.8),
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(context).padding.bottom + 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildFaceAngleSelector(),
            const SizedBox(height: 24),
            buildShutterControls(),
            const SizedBox(height: 8),
            _buildThumbnailRow(images, imageBytes), // Truyền `images` vào
          ],
        ),
      );

  Widget _buildThumbnailRow(
    List<XFile?> images,
    Map<int, Uint8List?> imageBytes,
  ) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _thumbnail(0, 'Trái', images[0], imageBytes[0]),
        _thumbnail(1, 'Chính', images[1], imageBytes[1]),
        _thumbnail(2, 'Phải', images[2], imageBytes[2]),
      ],
    ),
  );

  Widget buildFaceAngleSelector() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      buildAngleIcon(Icons.person_outline, _selectedAngleIndex == 0, 0),
      const SizedBox(width: 20),
      buildAngleIcon(Icons.person, _selectedAngleIndex == 1, 1),
      const SizedBox(width: 20),
      Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(math.pi),
        child: buildAngleIcon(
          Icons.person_outline,
          _selectedAngleIndex == 2,
          2,
        ),
      ),
    ],
  );

  Widget buildAngleIcon(IconData icon, bool isSelected, int index) =>
      GestureDetector(
        onTap: () => setState(() => _selectedAngleIndex = index),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white
                : Colors.grey.shade800.withOpacity(0.7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.black : Colors.white,
            size: 30,
          ),
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
        onTap: () => _showPickOptions(
          _selectedAngleIndex,
          source: ImageSource.camera,
        ), // Giả sử nút chụp là camera
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Colors.grey.withOpacity(0.5), width: 4),
          ),
        ),
      ),
      IconButton(
        icon: const Icon(
          Icons.flip_camera_ios_outlined,
          color: Colors.white,
          size: 30,
        ),
        onPressed: () {}, // Logic lật camera (nếu có)
      ),
    ],
  );

  Widget _thumbnail(int index, String label, XFile? img, Uint8List? bytes) {
    return GestureDetector(
      onTap: () {
        setState(() => _selectedAngleIndex = index);
        _showPickOptions(index);
      },
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: img != null ? Colors.white : Colors.grey[700],
                ),
                child: img != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: FutureBuilder<Uint8List?>(
                          future: (bytes != null)
                              ? Future.value(bytes)
                              : img.readAsBytes(),
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
                            final b = snap.data;
                            if (b == null || b.isEmpty) {
                              return const Center(
                                child: Icon(Icons.broken_image),
                              );
                            }
                            return Image.memory(b, fit: BoxFit.cover);
                          },
                        ),
                      )
                    : Center(
                        child: Icon(
                          _getIconForAngle(index),
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
              ),
              if (img != null)
                Positioned(
                  right: 2,
                  top: 2,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => _showPickOptions(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.edit,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => _confirmDelete(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.delete,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  IconData _getIconForAngle(int index) => index == 0
      ? Icons.arrow_left
      : index == 1
      ? Icons.face
      : Icons.arrow_right;

  Future<void> _confirmDelete(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa ảnh'),
        content: const Text('Bạn có chắc?'),
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
      // Gọi provider để xóa ảnh
      ref.read(analysisFlowProvider.notifier).removeImage(index);
    }
  }

  Future<void> _showPickOptions(int index, {ImageSource? source}) async {
    if (source != null) {
      await _pickImageForIndex(index, source);
      return;
    }

    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Thư viện'),
              onTap: () => Navigator.of(ctx).pop('gallery'),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.of(ctx).pop('camera'),
            ),
          ],
        ),
      ),
    );
    if (choice == 'gallery') {
      await _pickImageForIndex(index, ImageSource.gallery);
    } else if (choice == 'camera') {
      await _pickImageForIndex(index, ImageSource.camera);
    }
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
