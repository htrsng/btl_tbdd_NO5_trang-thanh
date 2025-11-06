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
  String scoreCommentExcellent(String score) {
    return 'Tuyệt vời! Làn da của bạn gần như hoàn hảo ($score/10)';
  }

  @override
  String scoreCommentVeryGood(String score) {
    return 'Rất tốt! Da của bạn đang ở trạng thái khỏe mạnh ($score/10)';
  }

  @override
  String scoreCommentGood(String score) {
    return 'Khá ổn! Cần chú ý một vài điểm nhỏ ($score/10)';
  }

  @override
  String scoreCommentAverage(String score) {
    return 'Bình thường. Da bạn cần được chăm sóc kỹ hơn ($score/10)';
  }

  @override
  String scoreCommentNeedsImprovement(String score) {
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

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get darkMode => 'Chế độ tối';

  @override
  String get selectLanguage => 'Chọn ngôn ngữ';

  @override
  String get lifestyleTip1Title => 'Uống Đủ Nước';

  @override
  String get lifestyleTip1Subtitle =>
      'Hydrat hóa là chìa khóa cho làn da khỏe mạnh và căng bóng.';

  @override
  String get lifestyleTip2Title => 'Chế độ Ăn Cân bằng';

  @override
  String get lifestyleTip2Subtitle =>
      'Bổ sung rau xanh và trái cây để cung cấp vitamin cho da.';

  @override
  String get lifestyleTip3Title => 'Ngủ Đủ Giấc';

  @override
  String get lifestyleTip3Subtitle =>
      'Giấc ngủ giúp da có thời gian phục hồi và tái tạo tế bào.';

  @override
  String get appName => 'Ứng dụng SkinAI';

  @override
  String get aboutUsBody =>
      'Chúng tôi mong muốn mang lại một giải pháp tiện lợi để mọi người có thể hiểu rõ hơn về làn da của mình và tìm ra chu trình chăm sóc phù hợp nhất.';

  @override
  String get aboutUsLecturer => 'Giảng viên hướng dẫn: Nguyễn Xuân Quế';

  @override
  String get aboutUsStudent1 => 'Nguyễn Thị Huyền Trang - 23010181';

  @override
  String get aboutUsStudent2 => 'Trần Xuân Thành - 23010160';

  @override
  String get detailedAnalysis => 'Phân tích chi tiết';

  @override
  String get chatWithAI => 'Chat với SkinAI';

  @override
  String get chatWithAISubtitle =>
      'Trò chuyện với AI để hiểu nhanh về các vấn đề da.';

  @override
  String get connectExpert => 'Kết nối chuyên gia';

  @override
  String get connectExpertSubtitle => 'Đặt lịch tư vấn 1:1 với bác sĩ da liễu.';

  @override
  String get disclaimerTitle => 'Lưu ý quan trọng';

  @override
  String get disclaimerBody =>
      'SkinAI chỉ cung cấp các gợi ý mang tính tham khảo. Kết quả phân tích có thể không chính xác 100%. Vui lòng đến gặp bác sĩ hoặc chuyên gia da liễu để được tư vấn y tế chuyên nghiệp.';

  @override
  String get viewMore => 'Xem thêm';

  @override
  String get chatWithAITitle => 'Trò chuyện với SkinAI';

  @override
  String get chatInitialMessage =>
      'Chào bạn, tôi là SkinAI. Bạn có câu hỏi gì về kết quả phân tích của mình không?';

  @override
  String get chatPlaceholder => 'Nhập câu hỏi của bạn...';

  @override
  String get expertBookingTitle => 'Kết nối Chuyên gia';

  @override
  String get expertName => 'BS. Nguyễn Văn A';

  @override
  String get expertSpecialty => 'Chuyên khoa Da liễu - 10 năm kinh nghiệm';

  @override
  String get expertBio =>
      'Bác sĩ A là chuyên gia hàng đầu về điều trị mụn và phục hồi da. Đặt lịch tư vấn 1:1 ngay hôm nay.';

  @override
  String get bookAppointmentButton => 'Đặt lịch tư vấn';

  @override
  String get uploadTitle => 'Tải ảnh lên';

  @override
  String get surveyTitle => 'Khảo sát da';

  @override
  String get resultsTitle => 'Kết quả của bạn';

  @override
  String get welcomeBack => 'Chào mừng trở lại!';

  @override
  String lastSkinScore(String score, String date) {
    return 'Điểm số da gần nhất của bạn là $score (vào ngày $date)';
  }

  @override
  String get startNewAnalysis => 'Bắt đầu phân tích mới';

  @override
  String get suggestionsReady => 'Gợi ý của bạn đã sẵn sàng';

  @override
  String get suggestionsTeaser =>
      'Xem các sản phẩm, thói quen và mẹo lối sống được AI thiết kế riêng cho bạn.';

  @override
  String get viewSuggestions => 'Xem Gợi ý';

  @override
  String get trackProgress => 'Theo dõi tiến trình';

  @override
  String get trackProgressTeaser =>
      'Xem điểm số của bạn đã cải thiện như thế nào theo thời gian.';

  @override
  String get viewHistory => 'Xem Lịch sử';

  @override
  String get customizeExperience => 'Tùy chỉnh trải nghiệm';

  @override
  String get customizeExperienceTeaser =>
      'Thay đổi ngôn ngữ (Anh/Việt) hoặc chuyển sang Chế độ tối.';

  @override
  String get openSettings => 'Mở Cài đặt';
}
