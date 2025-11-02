// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get homeTab => 'Home';

  @override
  String get suggestionsTab => 'Suggestions';

  @override
  String get historyTab => 'History';

  @override
  String get profileTab => 'Profile';

  @override
  String get continueButton => 'Continue';

  @override
  String get introSlide1Title => 'Welcome to SkinAI!';

  @override
  String get introSlide1Subtitle =>
      'Your personal skin analysis assistant powered by AI.';

  @override
  String get introSlide2Title => 'Upload 3 Photos Easily';

  @override
  String get introSlide2Subtitle =>
      'Take a front, left, and right photo for the most accurate results.';

  @override
  String get introSlide3Title => 'Get In-depth Suggestions';

  @override
  String get introSlide3Subtitle =>
      'Discover your skin condition and receive personalized recommendations.';

  @override
  String get introStartButton => 'Start Exploring';

  @override
  String get photosUploaded => 'Uploaded';

  @override
  String get uploadPhoto => 'Upload Photo';

  @override
  String get leftAngle => 'Left';

  @override
  String get centerAngle => 'Center';

  @override
  String get rightAngle => 'Right';

  @override
  String get suggestionsTitle => 'Personalized Suggestions';

  @override
  String get habitsTab => 'Habits';

  @override
  String get productsTab => 'Products';

  @override
  String get lifestyleTab => 'Lifestyle';

  @override
  String get performAnalysisFirst =>
      'Please perform an analysis on the Home screen first.';

  @override
  String get noHabitSuggestions => 'No habit suggestions available.';

  @override
  String get noProductSuggestions => 'No products suggested.';

  @override
  String get findProductsButton => 'Find Products on Shopee';

  @override
  String get featureInProgress => 'Feature in development!';

  @override
  String get historyTitle => 'Analysis History';

  @override
  String get skinProgressionChartTitle => 'Skin Progression';

  @override
  String get analysisDate => 'Analysis Date';

  @override
  String get skinScore => 'Skin Score';

  @override
  String get skinType => 'Skin Type';

  @override
  String get noHistoryMessage =>
      'No history yet. Let\'s start your first analysis!';

  @override
  String get startAnalysisButton => 'Start Analysis';

  @override
  String get deleteAll => 'Delete All';

  @override
  String get profileTitle => 'Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get notifications => 'Notifications';

  @override
  String get aboutUs => 'About Us';

  @override
  String get logout => 'Logout';

  @override
  String scoreCommentExcellent(Object score) {
    return 'Excellent! Your skin is nearly perfect ($score/10)';
  }

  @override
  String scoreCommentVeryGood(Object score) {
    return 'Very Good! Your skin is in a healthy state ($score/10)';
  }

  @override
  String scoreCommentGood(Object score) {
    return 'Good! A few minor points to note ($score/10)';
  }

  @override
  String scoreCommentAverage(Object score) {
    return 'Average. Your skin needs more care ($score/10)';
  }

  @override
  String scoreCommentNeedsImprovement(Object score) {
    return 'Needs Improvement! Please review the suggestions below ($score/10)';
  }

  @override
  String get deleteHistoryTitle => 'Delete History';

  @override
  String get deleteAllHistoryConfirmation =>
      'Are you sure you want to delete all analysis history? This action cannot be undone.';

  @override
  String get deleteSingleHistoryConfirmation =>
      'Are you sure you want to delete this item?';

  @override
  String get deleteButton => 'Delete';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get historyDetailTitle => 'Analysis Details';

  @override
  String get language => 'Language';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get lifestyleTip1Title => 'Stay Hydrated';

  @override
  String get lifestyleTip1Subtitle =>
      'Hydration is key to healthy and glowing skin.';

  @override
  String get lifestyleTip2Title => 'Balanced Diet';

  @override
  String get lifestyleTip2Subtitle =>
      'Incorporate greens and fruits to provide vitamins for your skin.';

  @override
  String get lifestyleTip3Title => 'Get Enough Sleep';

  @override
  String get lifestyleTip3Subtitle =>
      'Sleep gives your skin time to recover and regenerate cells.';

  @override
  String get appName => 'SkinAI App';

  @override
  String get aboutUsBody =>
      'We aim to provide a convenient solution for people to better understand their skin and find the most suitable care routine.';

  @override
  String get aboutUsLecturer => 'Instructor: Nguyen Xuan Que';

  @override
  String get aboutUsStudent1 => 'Nguyen Thi Huyen Trang - 23010181';

  @override
  String get aboutUsStudent2 => 'Tran Xuan Thanh - 23010160';

  @override
  String get detailedAnalysis => 'Detailed Analysis';

  @override
  String get chatWithAI => 'Chat with SkinAI';

  @override
  String get chatWithAISubtitle =>
      'Chat with our AI to get quick answers about skin issues.';

  @override
  String get connectExpert => 'Connect with an Expert';

  @override
  String get connectExpertSubtitle =>
      'Book a 1-on-1 consultation with a dermatologist.';

  @override
  String get disclaimerTitle => 'Important Disclaimer';

  @override
  String get disclaimerBody =>
      'SkinAI provides suggestions for reference only. Analysis results may not be 100% accurate. Please consult a dermatologist or medical professional for professional medical advice.';

  @override
  String get viewMore => 'View More';

  @override
  String get chatWithAITitle => 'Chat with SkinAI';

  @override
  String get chatInitialMessage =>
      'Hello, I\'m SkinAI. What questions do you have about your analysis results?';

  @override
  String get chatPlaceholder => 'Type your question...';

  @override
  String get expertBookingTitle => 'Connect with Expert';

  @override
  String get expertName => 'Dr. John Doe';

  @override
  String get expertSpecialty => 'Dermatologist - 10 years experience';

  @override
  String get expertBio =>
      'Dr. Doe is a leading expert in acne treatment and skin recovery. Book your 1-on-1 consultation today.';

  @override
  String get bookAppointmentButton => 'Book Consultation';
}
