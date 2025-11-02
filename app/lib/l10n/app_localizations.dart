import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// No description provided for @suggestionsTab.
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get suggestionsTab;

  /// No description provided for @historyTab.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTab;

  /// No description provided for @profileTab.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTab;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @introSlide1Title.
  ///
  /// In en, this message translates to:
  /// **'Welcome to SkinAI!'**
  String get introSlide1Title;

  /// No description provided for @introSlide1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your personal skin analysis assistant powered by AI.'**
  String get introSlide1Subtitle;

  /// No description provided for @introSlide2Title.
  ///
  /// In en, this message translates to:
  /// **'Upload 3 Photos Easily'**
  String get introSlide2Title;

  /// No description provided for @introSlide2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Take a front, left, and right photo for the most accurate results.'**
  String get introSlide2Subtitle;

  /// No description provided for @introSlide3Title.
  ///
  /// In en, this message translates to:
  /// **'Get In-depth Suggestions'**
  String get introSlide3Title;

  /// No description provided for @introSlide3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover your skin condition and receive personalized recommendations.'**
  String get introSlide3Subtitle;

  /// No description provided for @introStartButton.
  ///
  /// In en, this message translates to:
  /// **'Start Exploring'**
  String get introStartButton;

  /// No description provided for @photosUploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get photosUploaded;

  /// No description provided for @uploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload Photo'**
  String get uploadPhoto;

  /// No description provided for @leftAngle.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get leftAngle;

  /// No description provided for @centerAngle.
  ///
  /// In en, this message translates to:
  /// **'Center'**
  String get centerAngle;

  /// No description provided for @rightAngle.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get rightAngle;

  /// No description provided for @suggestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Personalized Suggestions'**
  String get suggestionsTitle;

  /// No description provided for @habitsTab.
  ///
  /// In en, this message translates to:
  /// **'Habits'**
  String get habitsTab;

  /// No description provided for @productsTab.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get productsTab;

  /// No description provided for @lifestyleTab.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle'**
  String get lifestyleTab;

  /// No description provided for @performAnalysisFirst.
  ///
  /// In en, this message translates to:
  /// **'Please perform an analysis on the Home screen first.'**
  String get performAnalysisFirst;

  /// No description provided for @noHabitSuggestions.
  ///
  /// In en, this message translates to:
  /// **'No habit suggestions available.'**
  String get noHabitSuggestions;

  /// No description provided for @noProductSuggestions.
  ///
  /// In en, this message translates to:
  /// **'No products suggested.'**
  String get noProductSuggestions;

  /// No description provided for @findProductsButton.
  ///
  /// In en, this message translates to:
  /// **'Find Products on Shopee'**
  String get findProductsButton;

  /// No description provided for @featureInProgress.
  ///
  /// In en, this message translates to:
  /// **'Feature in development!'**
  String get featureInProgress;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Analysis History'**
  String get historyTitle;

  /// No description provided for @skinProgressionChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Skin Progression'**
  String get skinProgressionChartTitle;

  /// No description provided for @analysisDate.
  ///
  /// In en, this message translates to:
  /// **'Analysis Date'**
  String get analysisDate;

  /// No description provided for @skinScore.
  ///
  /// In en, this message translates to:
  /// **'Skin Score'**
  String get skinScore;

  /// No description provided for @skinType.
  ///
  /// In en, this message translates to:
  /// **'Skin Type'**
  String get skinType;

  /// No description provided for @noHistoryMessage.
  ///
  /// In en, this message translates to:
  /// **'No history yet. Let\'s start your first analysis!'**
  String get noHistoryMessage;

  /// No description provided for @startAnalysisButton.
  ///
  /// In en, this message translates to:
  /// **'Start Analysis'**
  String get startAnalysisButton;

  /// No description provided for @deleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete All'**
  String get deleteAll;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @scoreCommentExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent! Your skin is nearly perfect ({score}/10)'**
  String scoreCommentExcellent(Object score);

  /// No description provided for @scoreCommentVeryGood.
  ///
  /// In en, this message translates to:
  /// **'Very Good! Your skin is in a healthy state ({score}/10)'**
  String scoreCommentVeryGood(Object score);

  /// No description provided for @scoreCommentGood.
  ///
  /// In en, this message translates to:
  /// **'Good! A few minor points to note ({score}/10)'**
  String scoreCommentGood(Object score);

  /// No description provided for @scoreCommentAverage.
  ///
  /// In en, this message translates to:
  /// **'Average. Your skin needs more care ({score}/10)'**
  String scoreCommentAverage(Object score);

  /// No description provided for @scoreCommentNeedsImprovement.
  ///
  /// In en, this message translates to:
  /// **'Needs Improvement! Please review the suggestions below ({score}/10)'**
  String scoreCommentNeedsImprovement(Object score);

  /// No description provided for @deleteHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete History'**
  String get deleteHistoryTitle;

  /// No description provided for @deleteAllHistoryConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all analysis history? This action cannot be undone.'**
  String get deleteAllHistoryConfirmation;

  /// No description provided for @deleteSingleHistoryConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get deleteSingleHistoryConfirmation;

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @historyDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Analysis Details'**
  String get historyDetailTitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @lifestyleTip1Title.
  ///
  /// In en, this message translates to:
  /// **'Stay Hydrated'**
  String get lifestyleTip1Title;

  /// No description provided for @lifestyleTip1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Hydration is key to healthy and glowing skin.'**
  String get lifestyleTip1Subtitle;

  /// No description provided for @lifestyleTip2Title.
  ///
  /// In en, this message translates to:
  /// **'Balanced Diet'**
  String get lifestyleTip2Title;

  /// No description provided for @lifestyleTip2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Incorporate greens and fruits to provide vitamins for your skin.'**
  String get lifestyleTip2Subtitle;

  /// No description provided for @lifestyleTip3Title.
  ///
  /// In en, this message translates to:
  /// **'Get Enough Sleep'**
  String get lifestyleTip3Title;

  /// No description provided for @lifestyleTip3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Sleep gives your skin time to recover and regenerate cells.'**
  String get lifestyleTip3Subtitle;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'SkinAI App'**
  String get appName;

  /// No description provided for @aboutUsBody.
  ///
  /// In en, this message translates to:
  /// **'We aim to provide a convenient solution for people to better understand their skin and find the most suitable care routine.'**
  String get aboutUsBody;

  /// No description provided for @aboutUsLecturer.
  ///
  /// In en, this message translates to:
  /// **'Instructor: Nguyen Xuan Que'**
  String get aboutUsLecturer;

  /// No description provided for @aboutUsStudent1.
  ///
  /// In en, this message translates to:
  /// **'Nguyen Thi Huyen Trang - 23010181'**
  String get aboutUsStudent1;

  /// No description provided for @aboutUsStudent2.
  ///
  /// In en, this message translates to:
  /// **'Tran Xuan Thanh - 23010160'**
  String get aboutUsStudent2;

  /// No description provided for @detailedAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Detailed Analysis'**
  String get detailedAnalysis;

  /// No description provided for @chatWithAI.
  ///
  /// In en, this message translates to:
  /// **'Chat with SkinAI'**
  String get chatWithAI;

  /// No description provided for @chatWithAISubtitle.
  ///
  /// In en, this message translates to:
  /// **'Chat with our AI to get quick answers about skin issues.'**
  String get chatWithAISubtitle;

  /// No description provided for @connectExpert.
  ///
  /// In en, this message translates to:
  /// **'Connect with an Expert'**
  String get connectExpert;

  /// No description provided for @connectExpertSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Book a 1-on-1 consultation with a dermatologist.'**
  String get connectExpertSubtitle;

  /// No description provided for @disclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Important Disclaimer'**
  String get disclaimerTitle;

  /// No description provided for @disclaimerBody.
  ///
  /// In en, this message translates to:
  /// **'SkinAI provides suggestions for reference only. Analysis results may not be 100% accurate. Please consult a dermatologist or medical professional for professional medical advice.'**
  String get disclaimerBody;

  /// No description provided for @viewMore.
  ///
  /// In en, this message translates to:
  /// **'View More'**
  String get viewMore;

  /// No description provided for @chatWithAITitle.
  ///
  /// In en, this message translates to:
  /// **'Chat with SkinAI'**
  String get chatWithAITitle;

  /// No description provided for @chatInitialMessage.
  ///
  /// In en, this message translates to:
  /// **'Hello, I\'m SkinAI. What questions do you have about your analysis results?'**
  String get chatInitialMessage;

  /// No description provided for @chatPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Type your question...'**
  String get chatPlaceholder;

  /// No description provided for @expertBookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect with Expert'**
  String get expertBookingTitle;

  /// No description provided for @expertName.
  ///
  /// In en, this message translates to:
  /// **'Dr. John Doe'**
  String get expertName;

  /// No description provided for @expertSpecialty.
  ///
  /// In en, this message translates to:
  /// **'Dermatologist - 10 years experience'**
  String get expertSpecialty;

  /// No description provided for @expertBio.
  ///
  /// In en, this message translates to:
  /// **'Dr. Doe is a leading expert in acne treatment and skin recovery. Book your 1-on-1 consultation today.'**
  String get expertBio;

  /// No description provided for @bookAppointmentButton.
  ///
  /// In en, this message translates to:
  /// **'Book Consultation'**
  String get bookAppointmentButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
