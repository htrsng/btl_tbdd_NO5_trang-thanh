// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get homeTab => 'Trang chủ';

  @override
  String get suggestionsTab => 'Gợi ý';

  @override
  String get historyTab => 'Lịch sử';

  @override
  String get profileTab => 'Tài khoản';

  @override
  String get continueButton => 'Tiếp tục';

  @override
  String get introSlide1Title => 'Chào mừng bạn đến với SkinAI!';

  @override
  String get introSlide1Subtitle =>
      'Trợ lý phân tích da cá nhân bằng trí tuệ nhân tạo.';

  @override
  String get introSlide2Title => 'Tải lên 3 ảnh dễ dàng';

  @override
  String get introSlide2Subtitle =>
      'Chụp ảnh chính diện, nghiêng trái và nghiêng phải để có kết quả chính xác nhất.';

  @override
  String get introSlide3Title => 'Nhận gợi ý chuyên sâu';

  @override
  String get introSlide3Subtitle =>
      'Khám phá tình trạng da và nhận các đề xuất được cá nhân hóa.';

  @override
  String get introStartButton => 'Bắt đầu khám phá';

  @override
  String get photosUploaded => 'Đã tải lên';

  @override
  String get uploadPhoto => 'Tải ảnh';

  @override
  String get leftAngle => 'Trái';

  @override
  String get centerAngle => 'Chính diện';

  @override
  String get rightAngle => 'Phải';

  @override
  String get suggestionsTitle => 'Gợi Ý Cá Nhân Hóa';

  @override
  String get habitsTab => 'Thói quen';

  @override
  String get productsTab => 'Sản phẩm';

  @override
  String get lifestyleTab => 'Lối sống';

  @override
  String get performAnalysisFirst =>
      'Hãy thực hiện phân tích ở Trang chủ trước.';

  @override
  String get noHabitSuggestions => 'Không có gợi ý về thói quen.';

  @override
  String get noProductSuggestions => 'Không có sản phẩm nào được gợi ý.';

  @override
  String get findProductsButton => 'Tìm sản phẩm trên Shopee';

  @override
  String get featureInProgress => 'Tính năng đang được phát triển!';

  @override
  String get historyTitle => 'Lịch sử phân tích';

  @override
  String get skinProgressionChartTitle => 'Tiến trình của làn da';

  @override
  String get analysisDate => 'Ngày phân tích';

  @override
  String get skinScore => 'Điểm số da';

  @override
  String get skinType => 'Loại da';

  @override
  String get noHistoryMessage =>
      'Chưa có lịch sử nào. Hãy bắt đầu lần phân tích đầu tiên của bạn!';

  @override
  String get startAnalysisButton => 'Bắt đầu phân tích';

  @override
  String get deleteAll => 'Xóa tất cả';

  @override
  String get profileTitle => 'Hồ sơ';

  @override
  String get editProfile => 'Chỉnh sửa hồ sơ';

  @override
  String get notifications => 'Cài đặt thông báo';

  @override
  String get aboutUs => 'Về chúng tôi';

  @override
  String get logout => 'Đăng xuất';

  @override
  String scoreCommentExcellent(Object score) {
    return 'Tuyệt vời! Làn da của bạn gần như hoàn hảo ($score/10)';
  }

  @override
  String scoreCommentVeryGood(Object score) {
    return 'Rất tốt! Da của bạn đang ở trạng thái khỏe mạnh ($score/10)';
  }

  @override
  String scoreCommentGood(Object score) {
    return 'Khá ổn! Cần chú ý một vài điểm nhỏ ($score/10)';
  }

  @override
  String scoreCommentAverage(Object score) {
    return 'Bình thường. Da bạn cần được chăm sóc kỹ hơn ($score/10)';
  }

  @override
  String scoreCommentNeedsImprovement(Object score) {
    return 'Cần cải thiện! Hãy xem kỹ các đề xuất bên dưới ($score/10)';
  }

  @override
  String get deleteHistoryTitle => 'Xóa Lịch sử';

  @override
  String get deleteAllHistoryConfirmation =>
      'Bạn có chắc chắn muốn xóa toàn bộ lịch sử phân tích không? Hành động này không thể hoàn tác.';

  @override
  String get deleteSingleHistoryConfirmation =>
      'Bạn có chắc chắn muốn xóa mục này không?';

  @override
  String get deleteButton => 'Xóa';

  @override
  String get cancelButton => 'Hủy';

  @override
  String get historyDetailTitle => 'Chi tiết Phân tích';
}
