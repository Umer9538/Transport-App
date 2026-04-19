import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'DriverApp'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get support;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOtp;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @mySubscription.
  ///
  /// In en, this message translates to:
  /// **'My Subscription'**
  String get mySubscription;

  /// No description provided for @plans.
  ///
  /// In en, this message translates to:
  /// **'Subscription Plans'**
  String get plans;

  /// No description provided for @choosePlan.
  ///
  /// In en, this message translates to:
  /// **'Choose a Plan'**
  String get choosePlan;

  /// No description provided for @subscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscribe;

  /// No description provided for @upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgrade;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @cancelSubscription.
  ///
  /// In en, this message translates to:
  /// **'Cancel Subscription'**
  String get cancelSubscription;

  /// No description provided for @tripDetails.
  ///
  /// In en, this message translates to:
  /// **'Trip Details'**
  String get tripDetails;

  /// No description provided for @tripHistory.
  ///
  /// In en, this message translates to:
  /// **'Trip History'**
  String get tripHistory;

  /// No description provided for @tripReceipt.
  ///
  /// In en, this message translates to:
  /// **'Trip Receipt'**
  String get tripReceipt;

  /// No description provided for @viewReceipt.
  ///
  /// In en, this message translates to:
  /// **'View Receipt'**
  String get viewReceipt;

  /// No description provided for @pickup.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get pickup;

  /// No description provided for @dropoff.
  ///
  /// In en, this message translates to:
  /// **'Drop-off'**
  String get dropoff;

  /// No description provided for @driver.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get driver;

  /// No description provided for @vehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicle;

  /// No description provided for @fare.
  ///
  /// In en, this message translates to:
  /// **'Fare'**
  String get fare;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @rateTrip.
  ///
  /// In en, this message translates to:
  /// **'Rate this trip'**
  String get rateTrip;

  /// No description provided for @trackTrip.
  ///
  /// In en, this message translates to:
  /// **'Track Trip'**
  String get trackTrip;

  /// No description provided for @cancelTrip.
  ///
  /// In en, this message translates to:
  /// **'Cancel Trip'**
  String get cancelTrip;

  /// No description provided for @shareTrip.
  ///
  /// In en, this message translates to:
  /// **'Share Trip'**
  String get shareTrip;

  /// No description provided for @sos.
  ///
  /// In en, this message translates to:
  /// **'SOS'**
  String get sos;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @savedAddresses.
  ///
  /// In en, this message translates to:
  /// **'Saved Addresses'**
  String get savedAddresses;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @referFriends.
  ///
  /// In en, this message translates to:
  /// **'Refer & Earn'**
  String get referFriends;

  /// No description provided for @promoOffers.
  ///
  /// In en, this message translates to:
  /// **'Promo & Offers'**
  String get promoOffers;

  /// No description provided for @liveChat.
  ///
  /// In en, this message translates to:
  /// **'Live Chat'**
  String get liveChat;

  /// No description provided for @emailSupport.
  ///
  /// In en, this message translates to:
  /// **'Email Support'**
  String get emailSupport;

  /// No description provided for @phoneSupport.
  ///
  /// In en, this message translates to:
  /// **'Phone Support'**
  String get phoneSupport;

  /// No description provided for @reportProblem.
  ///
  /// In en, this message translates to:
  /// **'Report a Problem'**
  String get reportProblem;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @biometricLogin.
  ///
  /// In en, this message translates to:
  /// **'Biometric Login'**
  String get biometricLogin;

  /// No description provided for @privacySettings.
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacySettings;

  /// No description provided for @loginHistory.
  ///
  /// In en, this message translates to:
  /// **'Login History'**
  String get loginHistory;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @todaySchedule.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Schedule'**
  String get todaySchedule;

  /// No description provided for @upcomingTrips.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Trips'**
  String get upcomingTrips;

  /// No description provided for @pastTrips.
  ///
  /// In en, this message translates to:
  /// **'Past Trips'**
  String get pastTrips;

  /// No description provided for @noTrips.
  ///
  /// In en, this message translates to:
  /// **'No trips'**
  String get noTrips;

  /// No description provided for @noUpcomingTrips.
  ///
  /// In en, this message translates to:
  /// **'No upcoming trips scheduled'**
  String get noUpcomingTrips;

  /// No description provided for @noPastTrips.
  ///
  /// In en, this message translates to:
  /// **'No past trips yet'**
  String get noPastTrips;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @fareBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Fare Breakdown'**
  String get fareBreakdown;

  /// No description provided for @baseFare.
  ///
  /// In en, this message translates to:
  /// **'Base fare'**
  String get baseFare;

  /// No description provided for @timeCharge.
  ///
  /// In en, this message translates to:
  /// **'Time charge'**
  String get timeCharge;

  /// No description provided for @serviceFee.
  ///
  /// In en, this message translates to:
  /// **'Service fee'**
  String get serviceFee;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copied;

  /// No description provided for @referralCode.
  ///
  /// In en, this message translates to:
  /// **'Your Referral Code'**
  String get referralCode;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get howItWorks;

  /// No description provided for @referralHistory.
  ///
  /// In en, this message translates to:
  /// **'Referral History'**
  String get referralHistory;

  /// No description provided for @availableOffers.
  ///
  /// In en, this message translates to:
  /// **'Available Offers'**
  String get availableOffers;

  /// No description provided for @havePromoCode.
  ///
  /// In en, this message translates to:
  /// **'Have a promo code?'**
  String get havePromoCode;

  /// No description provided for @enterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter code'**
  String get enterCode;

  /// No description provided for @applied.
  ///
  /// In en, this message translates to:
  /// **'Applied'**
  String get applied;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @scheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get scheduled;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @selectLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get selectLocation;

  /// No description provided for @confirmLocation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get confirmLocation;

  /// No description provided for @useCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use Current Location'**
  String get useCurrentLocation;

  /// No description provided for @pickOnMap.
  ///
  /// In en, this message translates to:
  /// **'Pick on Map'**
  String get pickOnMap;

  /// No description provided for @recentLocations.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recentLocations;

  /// No description provided for @popularPlaces.
  ///
  /// In en, this message translates to:
  /// **'Popular Places'**
  String get popularPlaces;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @emailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// No description provided for @tripReminders.
  ///
  /// In en, this message translates to:
  /// **'Trip Reminders'**
  String get tripReminders;

  /// No description provided for @promotionalEmails.
  ///
  /// In en, this message translates to:
  /// **'Promotional'**
  String get promotionalEmails;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @emergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get emergencyContact;

  /// No description provided for @memberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since'**
  String get memberSince;

  /// No description provided for @accountVerified.
  ///
  /// In en, this message translates to:
  /// **'Account Verified'**
  String get accountVerified;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get faq;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// No description provided for @nextTrip.
  ///
  /// In en, this message translates to:
  /// **'Next Trip'**
  String get nextTrip;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @noUpcomingTripsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to a plan to schedule your rides'**
  String get noUpcomingTripsSubtitle;

  /// No description provided for @startYourJourney.
  ///
  /// In en, this message translates to:
  /// **'Start Your Journey'**
  String get startYourJourney;

  /// No description provided for @viewPlans.
  ///
  /// In en, this message translates to:
  /// **'View Plans'**
  String get viewPlans;

  /// No description provided for @subscribeForRides.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to a plan and enjoy hassle-free daily commute'**
  String get subscribeForRides;

  /// No description provided for @keepTrip.
  ///
  /// In en, this message translates to:
  /// **'Keep Trip'**
  String get keepTrip;

  /// No description provided for @tripCancelled.
  ///
  /// In en, this message translates to:
  /// **'Trip cancelled'**
  String get tripCancelled;

  /// No description provided for @cancelTripConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this trip?'**
  String get cancelTripConfirm;

  /// No description provided for @tripsRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count} trips remaining'**
  String tripsRemaining(int count);

  /// No description provided for @renewsInDays.
  ///
  /// In en, this message translates to:
  /// **'Renews in {days} days'**
  String renewsInDays(int days);

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @updateYourDetails.
  ///
  /// In en, this message translates to:
  /// **'Update your details'**
  String get updateYourDetails;

  /// No description provided for @manageYourLocations.
  ///
  /// In en, this message translates to:
  /// **'Manage your locations'**
  String get manageYourLocations;

  /// No description provided for @manageCardsAndWallets.
  ///
  /// In en, this message translates to:
  /// **'Manage cards and wallets'**
  String get manageCardsAndWallets;

  /// No description provided for @earnWithUs.
  ///
  /// In en, this message translates to:
  /// **'Earn with Us'**
  String get earnWithUs;

  /// No description provided for @becomeADriver.
  ///
  /// In en, this message translates to:
  /// **'Become a Driver'**
  String get becomeADriver;

  /// No description provided for @earnMoneyDriving.
  ///
  /// In en, this message translates to:
  /// **'Earn money by driving with us'**
  String get earnMoneyDriving;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @driverPreference.
  ///
  /// In en, this message translates to:
  /// **'Driver Preference'**
  String get driverPreference;

  /// No description provided for @vehicleType.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type'**
  String get vehicleType;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @faqsAndGuides.
  ///
  /// In en, this message translates to:
  /// **'FAQs and guides'**
  String get faqsAndGuides;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @getHelpFromTeam.
  ///
  /// In en, this message translates to:
  /// **'Get help from our team'**
  String get getHelpFromTeam;

  /// No description provided for @reportAnIssue.
  ///
  /// In en, this message translates to:
  /// **'Report an Issue'**
  String get reportAnIssue;

  /// No description provided for @helpUsImprove.
  ///
  /// In en, this message translates to:
  /// **'Help us improve'**
  String get helpUsImprove;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @signOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get signOutConfirm;

  /// No description provided for @noActiveSubscription.
  ///
  /// In en, this message translates to:
  /// **'No Active Subscription'**
  String get noActiveSubscription;

  /// No description provided for @subscribeToEnjoy.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to enjoy hassle-free rides'**
  String get subscribeToEnjoy;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @languageThemeMore.
  ///
  /// In en, this message translates to:
  /// **'Language, theme, notifications & more'**
  String get languageThemeMore;

  /// No description provided for @selectDriverPreference.
  ///
  /// In en, this message translates to:
  /// **'Select Driver Preference'**
  String get selectDriverPreference;

  /// No description provided for @selectVehicleType.
  ///
  /// In en, this message translates to:
  /// **'Select Vehicle Type'**
  String get selectVehicleType;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @receiveUpdatesAlerts.
  ///
  /// In en, this message translates to:
  /// **'Receive trip updates and alerts'**
  String get receiveUpdatesAlerts;

  /// No description provided for @receiveEmailUpdates.
  ///
  /// In en, this message translates to:
  /// **'Receive important updates via email'**
  String get receiveEmailUpdates;

  /// No description provided for @getNotifiedBeforePickup.
  ///
  /// In en, this message translates to:
  /// **'Get notified 30 min before pickup'**
  String get getNotifiedBeforePickup;

  /// No description provided for @receiveOffersDiscounts.
  ///
  /// In en, this message translates to:
  /// **'Receive offers and discounts'**
  String get receiveOffersDiscounts;

  /// No description provided for @privacyAndSecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacyAndSecurity;

  /// No description provided for @updateYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Update your password'**
  String get updateYourPassword;

  /// No description provided for @useFingerprintFaceId.
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint or face ID'**
  String get useFingerprintFaceId;

  /// No description provided for @controlDataSharing.
  ///
  /// In en, this message translates to:
  /// **'Control your data sharing'**
  String get controlDataSharing;

  /// No description provided for @viewRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'View recent account activity'**
  String get viewRecentActivity;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @mapStyle.
  ///
  /// In en, this message translates to:
  /// **'Map Style'**
  String get mapStyle;

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSection;

  /// No description provided for @aboutDriverApp.
  ///
  /// In en, this message translates to:
  /// **'About DriverApp'**
  String get aboutDriverApp;

  /// No description provided for @readOurTerms.
  ///
  /// In en, this message translates to:
  /// **'Read our terms'**
  String get readOurTerms;

  /// No description provided for @howWeHandleData.
  ///
  /// In en, this message translates to:
  /// **'How we handle your data'**
  String get howWeHandleData;

  /// No description provided for @leaveAReview.
  ///
  /// In en, this message translates to:
  /// **'Leave a review'**
  String get leaveAReview;

  /// No description provided for @developerSection.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developerSection;

  /// No description provided for @adminPanel.
  ///
  /// In en, this message translates to:
  /// **'Admin Panel'**
  String get adminPanel;

  /// No description provided for @manageTripsUsersDrivers.
  ///
  /// In en, this message translates to:
  /// **'Manage trips, users & drivers'**
  String get manageTripsUsersDrivers;

  /// No description provided for @switchUserRole.
  ///
  /// In en, this message translates to:
  /// **'Switch User Role'**
  String get switchUserRole;

  /// No description provided for @testDifferentInterfaces.
  ///
  /// In en, this message translates to:
  /// **'Test different user interfaces'**
  String get testDifferentInterfaces;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerZone;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

  /// No description provided for @freeUpStorage.
  ///
  /// In en, this message translates to:
  /// **'Free up storage space'**
  String get freeUpStorage;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @permanentlyDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your account'**
  String get permanentlyDeleteAccount;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @selectTheme.
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectTheme;

  /// No description provided for @selectMapStyle.
  ///
  /// In en, this message translates to:
  /// **'Select Map Style'**
  String get selectMapStyle;

  /// No description provided for @cacheCleared.
  ///
  /// In en, this message translates to:
  /// **'Cache cleared successfully'**
  String get cacheCleared;

  /// No description provided for @deleteAccountConfirmMsg.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. All your data, including trip history, subscriptions, and saved addresses will be permanently deleted.'**
  String get deleteAccountConfirmMsg;

  /// No description provided for @clearCacheConfirmMsg.
  ///
  /// In en, this message translates to:
  /// **'This will clear all cached data including images and temporary files. Your account data will not be affected.'**
  String get clearCacheConfirmMsg;

  /// No description provided for @biometricEnabled.
  ///
  /// In en, this message translates to:
  /// **'Biometric login enabled'**
  String get biometricEnabled;

  /// No description provided for @biometricDisabled.
  ///
  /// In en, this message translates to:
  /// **'Biometric login disabled'**
  String get biometricDisabled;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChanged;

  /// No description provided for @enterCurrentAndNew.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password and choose a new one'**
  String get enterCurrentAndNew;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters with a number and special character'**
  String get passwordMinLength;

  /// No description provided for @passwordMustBe8Chars.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMustBe8Chars;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get fillAllFields;

  /// No description provided for @updatePasswordBtn.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePasswordBtn;

  /// No description provided for @locationSharing.
  ///
  /// In en, this message translates to:
  /// **'Location Sharing'**
  String get locationSharing;

  /// No description provided for @shareLocationDesc.
  ///
  /// In en, this message translates to:
  /// **'Share location with drivers during trips'**
  String get shareLocationDesc;

  /// No description provided for @analyticsLabel.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analyticsLabel;

  /// No description provided for @helpImproveAppData.
  ///
  /// In en, this message translates to:
  /// **'Help improve the app with usage data'**
  String get helpImproveAppData;

  /// No description provided for @personalizedAds.
  ///
  /// In en, this message translates to:
  /// **'Personalized Ads'**
  String get personalizedAds;

  /// No description provided for @seeRelevantAds.
  ///
  /// In en, this message translates to:
  /// **'See ads relevant to your interests'**
  String get seeRelevantAds;

  /// No description provided for @dataCollection.
  ///
  /// In en, this message translates to:
  /// **'Data Collection'**
  String get dataCollection;

  /// No description provided for @allowTripPatterns.
  ///
  /// In en, this message translates to:
  /// **'Allow collection of trip patterns'**
  String get allowTripPatterns;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'Your personal transportation subscription service for hassle-free daily commute.'**
  String get appDescription;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'© 2026 DriverApp. All rights reserved.'**
  String get copyright;

  /// No description provided for @standard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get standard;

  /// No description provided for @satellite.
  ///
  /// In en, this message translates to:
  /// **'Satellite'**
  String get satellite;

  /// No description provided for @terrain.
  ///
  /// In en, this message translates to:
  /// **'Terrain'**
  String get terrain;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @userRole.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get userRole;

  /// No description provided for @driverRole.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get driverRole;

  /// No description provided for @adminRole.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get adminRole;

  /// No description provided for @regularPassengerInterface.
  ///
  /// In en, this message translates to:
  /// **'Regular passenger interface'**
  String get regularPassengerInterface;

  /// No description provided for @driverInterfaceDesc.
  ///
  /// In en, this message translates to:
  /// **'Driver interface with trip management'**
  String get driverInterfaceDesc;

  /// No description provided for @adminDashboardDesc.
  ///
  /// In en, this message translates to:
  /// **'Admin dashboard for management'**
  String get adminDashboardDesc;

  /// No description provided for @rateDriverApp.
  ///
  /// In en, this message translates to:
  /// **'Rate DriverApp'**
  String get rateDriverApp;

  /// No description provided for @howWouldYouRate.
  ///
  /// In en, this message translates to:
  /// **'How would you rate your experience?'**
  String get howWouldYouRate;

  /// No description provided for @gladYouEnjoy.
  ///
  /// In en, this message translates to:
  /// **'We\'re glad you enjoy it!'**
  String get gladYouEnjoy;

  /// No description provided for @thanksFeedback.
  ///
  /// In en, this message translates to:
  /// **'Thanks for your feedback!'**
  String get thanksFeedback;

  /// No description provided for @wellImprove.
  ///
  /// In en, this message translates to:
  /// **'We\'ll work to improve!'**
  String get wellImprove;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @thankYouRating.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your rating!'**
  String get thankYouRating;

  /// No description provided for @searchTripsPlaces.
  ///
  /// In en, this message translates to:
  /// **'Search trips, places, settings...'**
  String get searchTripsPlaces;

  /// No description provided for @mySchedule.
  ///
  /// In en, this message translates to:
  /// **'My Schedule'**
  String get mySchedule;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @forTestingOnly.
  ///
  /// In en, this message translates to:
  /// **'For testing purposes only. Switch between different user interfaces.'**
  String get forTestingOnly;

  /// No description provided for @driverAssigned.
  ///
  /// In en, this message translates to:
  /// **'Driver Assigned'**
  String get driverAssigned;

  /// No description provided for @driverArriving.
  ///
  /// In en, this message translates to:
  /// **'Driver Arriving'**
  String get driverArriving;

  /// No description provided for @tripsLeft.
  ///
  /// In en, this message translates to:
  /// **'Trips Left'**
  String get tripsLeft;

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'Days Left'**
  String get daysLeft;

  /// No description provided for @noPreference.
  ///
  /// In en, this message translates to:
  /// **'No Preference'**
  String get noPreference;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome\nBack!'**
  String get welcomeBack;

  /// No description provided for @enterPhoneToContinue.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number to continue'**
  String get enterPhoneToContinue;

  /// No description provided for @pleaseEnterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterPhoneNumber;

  /// No description provided for @pleaseEnterValidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get pleaseEnterValidPhone;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get orContinueWith;

  /// No description provided for @google.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get google;

  /// No description provided for @apple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get apple;

  /// No description provided for @byContinuingAgree.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our '**
  String get byContinuingAgree;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get selectCountry;

  /// No description provided for @verification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verification;

  /// No description provided for @weSentCodeTo.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a 6-digit code to'**
  String get weSentCodeTo;

  /// No description provided for @invalidOtp.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP. Please try again.'**
  String get invalidOtp;

  /// No description provided for @otpSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'OTP sent successfully!'**
  String get otpSentSuccessfully;

  /// No description provided for @didNotReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get didNotReceiveCode;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @resendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String resendIn(int seconds);

  /// No description provided for @completeYourProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete Your Profile'**
  String get completeYourProfile;

  /// No description provided for @helpUsPersonalize.
  ///
  /// In en, this message translates to:
  /// **'Help us personalize your experience'**
  String get helpUsPersonalize;

  /// No description provided for @enterYourFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterYourFullName;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterName;

  /// No description provided for @nameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameMinLength;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @addEmergencyDesc.
  ///
  /// In en, this message translates to:
  /// **'Add someone we can contact in case of emergency'**
  String get addEmergencyDesc;

  /// No description provided for @contactName.
  ///
  /// In en, this message translates to:
  /// **'Contact Name'**
  String get contactName;

  /// No description provided for @contactPhone.
  ///
  /// In en, this message translates to:
  /// **'Contact Phone'**
  String get contactPhone;

  /// No description provided for @enterContactName.
  ///
  /// In en, this message translates to:
  /// **'Enter contact name'**
  String get enterContactName;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enterPhoneNumber;

  /// No description provided for @optionalRecommended.
  ///
  /// In en, this message translates to:
  /// **'This is optional but recommended for your safety'**
  String get optionalRecommended;

  /// No description provided for @completeSetup.
  ///
  /// In en, this message translates to:
  /// **'Complete Setup'**
  String get completeSetup;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// No description provided for @preScheduledRides.
  ///
  /// In en, this message translates to:
  /// **'Pre-Scheduled Rides'**
  String get preScheduledRides;

  /// No description provided for @preScheduledRidesDesc.
  ///
  /// In en, this message translates to:
  /// **'Plan your commute in advance. Schedule rides for days, weeks, or months with ease.'**
  String get preScheduledRidesDesc;

  /// No description provided for @chooseYourDriver.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Driver'**
  String get chooseYourDriver;

  /// No description provided for @chooseYourDriverDesc.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred driver gender for a comfortable and safe journey.'**
  String get chooseYourDriverDesc;

  /// No description provided for @pickYourRide.
  ///
  /// In en, this message translates to:
  /// **'Pick Your Ride'**
  String get pickYourRide;

  /// No description provided for @pickYourRideDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose from Economy, Comfort, Luxury, or Van based on your needs.'**
  String get pickYourRideDesc;

  /// No description provided for @subscribeAndSave.
  ///
  /// In en, this message translates to:
  /// **'Subscribe & Save'**
  String get subscribeAndSave;

  /// No description provided for @subscribeAndSaveDesc.
  ///
  /// In en, this message translates to:
  /// **'One subscription, unlimited convenience. Save time and money with monthly plans.'**
  String get subscribeAndSaveDesc;

  /// No description provided for @yourPersonalTransportation.
  ///
  /// In en, this message translates to:
  /// **'Your Personal Transportation'**
  String get yourPersonalTransportation;

  /// No description provided for @todaysSummary.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Summary'**
  String get todaysSummary;

  /// No description provided for @assignedTrips.
  ///
  /// In en, this message translates to:
  /// **'Assigned Trips'**
  String get assignedTrips;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @noTripsAssigned.
  ///
  /// In en, this message translates to:
  /// **'No trips assigned'**
  String get noTripsAssigned;

  /// No description provided for @goOnlineToReceive.
  ///
  /// In en, this message translates to:
  /// **'Go online to receive trip assignments'**
  String get goOnlineToReceive;

  /// No description provided for @youAreOnline.
  ///
  /// In en, this message translates to:
  /// **'You are Online'**
  String get youAreOnline;

  /// No description provided for @youAreOffline.
  ///
  /// In en, this message translates to:
  /// **'You are Offline'**
  String get youAreOffline;

  /// No description provided for @readyToReceiveTrips.
  ///
  /// In en, this message translates to:
  /// **'Ready to receive trips'**
  String get readyToReceiveTrips;

  /// No description provided for @trips.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get trips;

  /// No description provided for @earnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earnings;

  /// No description provided for @passenger.
  ///
  /// In en, this message translates to:
  /// **'Passenger'**
  String get passenger;

  /// No description provided for @errorLoadingTrips.
  ///
  /// In en, this message translates to:
  /// **'Error loading trips'**
  String get errorLoadingTrips;

  /// No description provided for @myTrips.
  ///
  /// In en, this message translates to:
  /// **'My Trips'**
  String get myTrips;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @noActiveTrip.
  ///
  /// In en, this message translates to:
  /// **'No active trip'**
  String get noActiveTrip;

  /// No description provided for @noCompletedTrips.
  ///
  /// In en, this message translates to:
  /// **'No completed trips'**
  String get noCompletedTrips;

  /// No description provided for @tripsWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Trips will appear here when assigned'**
  String get tripsWillAppearHere;

  /// No description provided for @tripStartedNavigate.
  ///
  /// In en, this message translates to:
  /// **'Trip started! Navigate to pickup location.'**
  String get tripStartedNavigate;

  /// No description provided for @declineTrip.
  ///
  /// In en, this message translates to:
  /// **'Decline Trip'**
  String get declineTrip;

  /// No description provided for @areYouSureDecline.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to decline this trip? This action cannot be undone.'**
  String get areYouSureDecline;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @tripDeclined.
  ///
  /// In en, this message translates to:
  /// **'Trip declined'**
  String get tripDeclined;

  /// No description provided for @completeTrip.
  ///
  /// In en, this message translates to:
  /// **'Complete Trip'**
  String get completeTrip;

  /// No description provided for @haveYouDroppedOff.
  ///
  /// In en, this message translates to:
  /// **'Have you dropped off the passenger at the destination?'**
  String get haveYouDroppedOff;

  /// No description provided for @notYet.
  ///
  /// In en, this message translates to:
  /// **'Not Yet'**
  String get notYet;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @tripCompletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Trip completed successfully!'**
  String get tripCompletedSuccessfully;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @driverProfile.
  ///
  /// In en, this message translates to:
  /// **'Driver Profile'**
  String get driverProfile;

  /// No description provided for @vehicleInformation.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Information'**
  String get vehicleInformation;

  /// No description provided for @performanceStats.
  ///
  /// In en, this message translates to:
  /// **'Performance Stats'**
  String get performanceStats;

  /// No description provided for @totalTrips.
  ///
  /// In en, this message translates to:
  /// **'Total Trips'**
  String get totalTrips;

  /// No description provided for @acceptanceRate.
  ///
  /// In en, this message translates to:
  /// **'Acceptance Rate'**
  String get acceptanceRate;

  /// No description provided for @onTimeRate.
  ///
  /// In en, this message translates to:
  /// **'On-Time Rate'**
  String get onTimeRate;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @bankAccount.
  ///
  /// In en, this message translates to:
  /// **'Bank Account'**
  String get bankAccount;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @areYouSureLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get areYouSureLogout;

  /// No description provided for @totalEarnings.
  ///
  /// In en, this message translates to:
  /// **'Total Earnings'**
  String get totalEarnings;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @earningsBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Earnings Breakdown'**
  String get earningsBreakdown;

  /// No description provided for @recentTrips.
  ///
  /// In en, this message translates to:
  /// **'Recent Trips'**
  String get recentTrips;

  /// No description provided for @withdrawEarnings.
  ///
  /// In en, this message translates to:
  /// **'Withdraw Earnings'**
  String get withdrawEarnings;

  /// No description provided for @tripEarnings.
  ///
  /// In en, this message translates to:
  /// **'Trip Earnings'**
  String get tripEarnings;

  /// No description provided for @tips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tips;

  /// No description provided for @bonuses.
  ///
  /// In en, this message translates to:
  /// **'Bonuses'**
  String get bonuses;

  /// No description provided for @platformFee.
  ///
  /// In en, this message translates to:
  /// **'Platform Fee (10%)'**
  String get platformFee;

  /// No description provided for @netEarnings.
  ///
  /// In en, this message translates to:
  /// **'Net Earnings'**
  String get netEarnings;

  /// No description provided for @noCompletedTripsYet.
  ///
  /// In en, this message translates to:
  /// **'No completed trips yet'**
  String get noCompletedTripsYet;

  /// No description provided for @avgTrip.
  ///
  /// In en, this message translates to:
  /// **'Avg/Trip'**
  String get avgTrip;

  /// No description provided for @withdrawalSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal request submitted successfully!'**
  String get withdrawalSubmitted;

  /// No description provided for @availableBalance.
  ///
  /// In en, this message translates to:
  /// **'Available balance: SAR '**
  String get availableBalance;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @tripCompleted.
  ///
  /// In en, this message translates to:
  /// **'Trip Completed'**
  String get tripCompleted;

  /// No description provided for @drivingLicenseNumber.
  ///
  /// In en, this message translates to:
  /// **'Driving License Number'**
  String get drivingLicenseNumber;

  /// No description provided for @enterLicenseNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your license number'**
  String get enterLicenseNumber;

  /// No description provided for @pleaseEnterLicenseNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your license number'**
  String get pleaseEnterLicenseNumber;

  /// No description provided for @ensureProfileUpToDate.
  ///
  /// In en, this message translates to:
  /// **'Make sure your profile information is up to date before proceeding.'**
  String get ensureProfileUpToDate;

  /// No description provided for @vehicleInfo.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Information'**
  String get vehicleInfo;

  /// No description provided for @enterVehicleDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter your vehicle details'**
  String get enterVehicleDetails;

  /// No description provided for @vehicleModel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Model'**
  String get vehicleModel;

  /// No description provided for @egToyotaCamry.
  ///
  /// In en, this message translates to:
  /// **'e.g., Toyota Camry 2024'**
  String get egToyotaCamry;

  /// No description provided for @pleaseEnterVehicleModel.
  ///
  /// In en, this message translates to:
  /// **'Please enter vehicle model'**
  String get pleaseEnterVehicleModel;

  /// No description provided for @licensePlateNumber.
  ///
  /// In en, this message translates to:
  /// **'License Plate Number'**
  String get licensePlateNumber;

  /// No description provided for @egABC1234.
  ///
  /// In en, this message translates to:
  /// **'e.g., ABC 1234'**
  String get egABC1234;

  /// No description provided for @pleaseEnterLicensePlate.
  ///
  /// In en, this message translates to:
  /// **'Please enter license plate number'**
  String get pleaseEnterLicensePlate;

  /// No description provided for @vehicleColor.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Color'**
  String get vehicleColor;

  /// No description provided for @egVehicleColor.
  ///
  /// In en, this message translates to:
  /// **'e.g., White, Black, Silver'**
  String get egVehicleColor;

  /// No description provided for @pleaseEnterVehicleColor.
  ///
  /// In en, this message translates to:
  /// **'Please enter vehicle color'**
  String get pleaseEnterVehicleColor;

  /// No description provided for @requiredDocuments.
  ///
  /// In en, this message translates to:
  /// **'Required Documents'**
  String get requiredDocuments;

  /// No description provided for @uploadDocumentsVerification.
  ///
  /// In en, this message translates to:
  /// **'Upload the following documents for verification'**
  String get uploadDocumentsVerification;

  /// No description provided for @drivingLicense.
  ///
  /// In en, this message translates to:
  /// **'Driving License'**
  String get drivingLicense;

  /// No description provided for @uploadDrivingLicense.
  ///
  /// In en, this message translates to:
  /// **'Upload a clear photo of your valid driving license'**
  String get uploadDrivingLicense;

  /// No description provided for @drivingLicenseUploaded.
  ///
  /// In en, this message translates to:
  /// **'Driving license uploaded successfully'**
  String get drivingLicenseUploaded;

  /// No description provided for @vehicleInsurance.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Insurance'**
  String get vehicleInsurance;

  /// No description provided for @uploadVehicleInsurance.
  ///
  /// In en, this message translates to:
  /// **'Upload your vehicle insurance document'**
  String get uploadVehicleInsurance;

  /// No description provided for @insuranceUploaded.
  ///
  /// In en, this message translates to:
  /// **'Insurance document uploaded successfully'**
  String get insuranceUploaded;

  /// No description provided for @vehiclePhoto.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Photo'**
  String get vehiclePhoto;

  /// No description provided for @uploadVehiclePhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload a clear photo of your vehicle'**
  String get uploadVehiclePhoto;

  /// No description provided for @vehiclePhotoUploaded.
  ///
  /// In en, this message translates to:
  /// **'Vehicle photo uploaded successfully'**
  String get vehiclePhotoUploaded;

  /// No description provided for @documentsVerificationNotice.
  ///
  /// In en, this message translates to:
  /// **'All documents will be verified within 24-48 hours. You will be notified once approved.'**
  String get documentsVerificationNotice;

  /// No description provided for @reviewAndSubmit.
  ///
  /// In en, this message translates to:
  /// **'Review & Submit'**
  String get reviewAndSubmit;

  /// No description provided for @reviewBeforeSubmit.
  ///
  /// In en, this message translates to:
  /// **'Please review your information before submitting'**
  String get reviewBeforeSubmit;

  /// No description provided for @licensePlate.
  ///
  /// In en, this message translates to:
  /// **'License Plate'**
  String get licensePlate;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @uploadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Uploaded successfully'**
  String get uploadedSuccessfully;

  /// No description provided for @iAgreeToThe.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get iAgreeToThe;

  /// No description provided for @driverTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Driver Terms of Service'**
  String get driverTermsOfService;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @submitApplication.
  ///
  /// In en, this message translates to:
  /// **'Submit Application'**
  String get submitApplication;

  /// No description provided for @pleaseUploadAllDocs.
  ///
  /// In en, this message translates to:
  /// **'Please upload all required documents'**
  String get pleaseUploadAllDocs;

  /// No description provided for @pleaseAgreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'Please agree to the terms and conditions'**
  String get pleaseAgreeToTerms;

  /// No description provided for @applicationSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Application Submitted!'**
  String get applicationSubmitted;

  /// No description provided for @applicationSubmittedDesc.
  ///
  /// In en, this message translates to:
  /// **'Your driver application has been submitted successfully. We will review your documents and notify you within 24-48 hours.'**
  String get applicationSubmittedDesc;

  /// No description provided for @goToDriverDashboard.
  ///
  /// In en, this message translates to:
  /// **'Go to Driver Dashboard'**
  String get goToDriverDashboard;

  /// No description provided for @chooseYourPlan.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Plan'**
  String get chooseYourPlan;

  /// No description provided for @selectPerfectSubscription.
  ///
  /// In en, this message translates to:
  /// **'Select the perfect subscription for your commute'**
  String get selectPerfectSubscription;

  /// No description provided for @availablePlans.
  ///
  /// In en, this message translates to:
  /// **'Available Plans'**
  String get availablePlans;

  /// No description provided for @weeklyBasic.
  ///
  /// In en, this message translates to:
  /// **'Weekly Basic'**
  String get weeklyBasic;

  /// No description provided for @perfectForTrying.
  ///
  /// In en, this message translates to:
  /// **'Perfect for trying out the service'**
  String get perfectForTrying;

  /// No description provided for @monthlyComfort.
  ///
  /// In en, this message translates to:
  /// **'Monthly Comfort'**
  String get monthlyComfort;

  /// No description provided for @mostPopularChoice.
  ///
  /// In en, this message translates to:
  /// **'Most popular choice for daily commuters'**
  String get mostPopularChoice;

  /// No description provided for @quarterlyPremium.
  ///
  /// In en, this message translates to:
  /// **'Quarterly Premium'**
  String get quarterlyPremium;

  /// No description provided for @bestValueLongTerm.
  ///
  /// In en, this message translates to:
  /// **'Best value for long-term commitment'**
  String get bestValueLongTerm;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'POPULAR'**
  String get popular;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @setupSchedule.
  ///
  /// In en, this message translates to:
  /// **'Setup Schedule'**
  String get setupSchedule;

  /// No description provided for @selectYourCommuteDays.
  ///
  /// In en, this message translates to:
  /// **'Select Your\nCommute Days'**
  String get selectYourCommuteDays;

  /// No description provided for @chooseTransportationDays.
  ///
  /// In en, this message translates to:
  /// **'Choose the days you need transportation'**
  String get chooseTransportationDays;

  /// No description provided for @weekdays.
  ///
  /// In en, this message translates to:
  /// **'Weekdays'**
  String get weekdays;

  /// No description provided for @allWeek.
  ///
  /// In en, this message translates to:
  /// **'All Week'**
  String get allWeek;

  /// No description provided for @setYourPickupTimes.
  ///
  /// In en, this message translates to:
  /// **'Set Your\nPickup Times'**
  String get setYourPickupTimes;

  /// No description provided for @whenPickupQuestion.
  ///
  /// In en, this message translates to:
  /// **'When should we pick you up?'**
  String get whenPickupQuestion;

  /// No description provided for @morningPickup.
  ///
  /// In en, this message translates to:
  /// **'Morning Pickup'**
  String get morningPickup;

  /// No description provided for @goingToWork.
  ///
  /// In en, this message translates to:
  /// **'Going to work/school'**
  String get goingToWork;

  /// No description provided for @includeReturnTrip.
  ///
  /// In en, this message translates to:
  /// **'Include return trip'**
  String get includeReturnTrip;

  /// No description provided for @eveningReturn.
  ///
  /// In en, this message translates to:
  /// **'Evening Return'**
  String get eveningReturn;

  /// No description provided for @goingBackHome.
  ///
  /// In en, this message translates to:
  /// **'Going back home'**
  String get goingBackHome;

  /// No description provided for @driverArrivalNotice.
  ///
  /// In en, this message translates to:
  /// **'Your driver will arrive 5-10 minutes before the scheduled time to ensure you\'re never late.'**
  String get driverArrivalNotice;

  /// No description provided for @setYourLocations.
  ///
  /// In en, this message translates to:
  /// **'Set Your\nLocations'**
  String get setYourLocations;

  /// No description provided for @pickupDropoffQuestion.
  ///
  /// In en, this message translates to:
  /// **'Where should we pick you up and drop you off?'**
  String get pickupDropoffQuestion;

  /// No description provided for @pickupLocation.
  ///
  /// In en, this message translates to:
  /// **'Pickup Location'**
  String get pickupLocation;

  /// No description provided for @tapToSetPickup.
  ///
  /// In en, this message translates to:
  /// **'Tap to set your pickup point'**
  String get tapToSetPickup;

  /// No description provided for @dropoffLocation.
  ///
  /// In en, this message translates to:
  /// **'Drop-off Location'**
  String get dropoffLocation;

  /// No description provided for @tapToSetDestination.
  ///
  /// In en, this message translates to:
  /// **'Tap to set your destination'**
  String get tapToSetDestination;

  /// No description provided for @scheduleSummary.
  ///
  /// In en, this message translates to:
  /// **'Schedule Summary'**
  String get scheduleSummary;

  /// No description provided for @daysLabel.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get daysLabel;

  /// No description provided for @morningLabel.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morningLabel;

  /// No description provided for @eveningLabel.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get eveningLabel;

  /// No description provided for @tripsPerWeek.
  ///
  /// In en, this message translates to:
  /// **'Trips/Week'**
  String get tripsPerWeek;

  /// No description provided for @reviewAndPay.
  ///
  /// In en, this message translates to:
  /// **'Review & Pay'**
  String get reviewAndPay;

  /// No description provided for @setPickupLocation.
  ///
  /// In en, this message translates to:
  /// **'Set Pickup Location'**
  String get setPickupLocation;

  /// No description provided for @setDropoffLocation.
  ///
  /// In en, this message translates to:
  /// **'Set Drop-off Location'**
  String get setDropoffLocation;

  /// No description provided for @searchForLocation.
  ///
  /// In en, this message translates to:
  /// **'Search for a location...'**
  String get searchForLocation;

  /// No description provided for @daysSelectedTrips.
  ///
  /// In en, this message translates to:
  /// **'{days} days selected • {trips} trips per week'**
  String daysSelectedTrips(int days, int trips);

  /// No description provided for @paymentSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful!'**
  String get paymentSuccessful;

  /// No description provided for @subscriptionActivated.
  ///
  /// In en, this message translates to:
  /// **'Your subscription has been activated'**
  String get subscriptionActivated;

  /// No description provided for @planDetail.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get planDetail;

  /// No description provided for @vehicleDetail.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicleDetail;

  /// No description provided for @amountDetail.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountDetail;

  /// No description provided for @statusDetail.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusDetail;

  /// No description provided for @startDateDetail.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDateDetail;

  /// No description provided for @setUpScheduleBtn.
  ///
  /// In en, this message translates to:
  /// **'Set Up Schedule'**
  String get setUpScheduleBtn;

  /// No description provided for @goToHome.
  ///
  /// In en, this message translates to:
  /// **'Go to Home'**
  String get goToHome;

  /// No description provided for @noCancelledTrips.
  ///
  /// In en, this message translates to:
  /// **'No cancelled trips'**
  String get noCancelledTrips;

  /// No description provided for @completedTripsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your completed trips will appear here'**
  String get completedTripsEmpty;

  /// No description provided for @cancelledTripsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Cancelled trips will appear here'**
  String get cancelledTripsEmpty;

  /// No description provided for @tripRoute.
  ///
  /// In en, this message translates to:
  /// **'Trip Route'**
  String get tripRoute;

  /// No description provided for @viewFullDetails.
  ///
  /// In en, this message translates to:
  /// **'View Full Details'**
  String get viewFullDetails;

  /// No description provided for @routeSection.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get routeSection;

  /// No description provided for @timeSection.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeSection;

  /// No description provided for @pickedUp.
  ///
  /// In en, this message translates to:
  /// **'Picked Up'**
  String get pickedUp;

  /// No description provided for @droppedOff.
  ///
  /// In en, this message translates to:
  /// **'Dropped Off'**
  String get droppedOff;

  /// No description provided for @fareSection.
  ///
  /// In en, this message translates to:
  /// **'Fare'**
  String get fareSection;

  /// No description provided for @yourRating.
  ///
  /// In en, this message translates to:
  /// **'Your Rating'**
  String get yourRating;

  /// No description provided for @tripStatus.
  ///
  /// In en, this message translates to:
  /// **'Trip Status'**
  String get tripStatus;

  /// No description provided for @scheduledStatus.
  ///
  /// In en, this message translates to:
  /// **'This trip is confirmed and scheduled'**
  String get scheduledStatus;

  /// No description provided for @driverAssignedStatus.
  ///
  /// In en, this message translates to:
  /// **'A driver has been assigned to your trip'**
  String get driverAssignedStatus;

  /// No description provided for @driverArrivingStatus.
  ///
  /// In en, this message translates to:
  /// **'Your driver is on the way'**
  String get driverArrivingStatus;

  /// No description provided for @inProgressStatus.
  ///
  /// In en, this message translates to:
  /// **'You are currently on this trip'**
  String get inProgressStatus;

  /// No description provided for @completedStatus.
  ///
  /// In en, this message translates to:
  /// **'This trip has been completed'**
  String get completedStatus;

  /// No description provided for @cancelledStatus.
  ///
  /// In en, this message translates to:
  /// **'This trip was cancelled'**
  String get cancelledStatus;

  /// No description provided for @noShowStatus.
  ///
  /// In en, this message translates to:
  /// **'Driver arrived but passenger was not present'**
  String get noShowStatus;

  /// No description provided for @receiptShared.
  ///
  /// In en, this message translates to:
  /// **'Receipt shared'**
  String get receiptShared;

  /// No description provided for @receiptDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Receipt downloaded as PDF'**
  String get receiptDownloaded;

  /// No description provided for @receiptEmailed.
  ///
  /// In en, this message translates to:
  /// **'Receipt sent to your email'**
  String get receiptEmailed;

  /// No description provided for @distanceCharge.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distanceCharge;

  /// No description provided for @subscriptionDiscount.
  ///
  /// In en, this message translates to:
  /// **'Subscription discount'**
  String get subscriptionDiscount;

  /// No description provided for @tripId.
  ///
  /// In en, this message translates to:
  /// **'Trip ID'**
  String get tripId;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentMethod;

  /// No description provided for @invoiceNumber.
  ///
  /// In en, this message translates to:
  /// **'Invoice #{number}'**
  String invoiceNumber(String number);

  /// No description provided for @generatedOn.
  ///
  /// In en, this message translates to:
  /// **'Generated on {date}'**
  String generatedOn(String date);

  /// No description provided for @noTripsScheduled.
  ///
  /// In en, this message translates to:
  /// **'No trips scheduled'**
  String get noTripsScheduled;

  /// No description provided for @youHaveNoTripsToday.
  ///
  /// In en, this message translates to:
  /// **'You have no trips on this day'**
  String get youHaveNoTripsToday;

  /// No description provided for @modifyTrip.
  ///
  /// In en, this message translates to:
  /// **'Modify Trip'**
  String get modifyTrip;

  /// No description provided for @pickupTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Pickup Time'**
  String get pickupTimeLabel;

  /// No description provided for @tapToChange.
  ///
  /// In en, this message translates to:
  /// **'Tap to change'**
  String get tapToChange;

  /// No description provided for @confirmChanges.
  ///
  /// In en, this message translates to:
  /// **'Confirm Changes'**
  String get confirmChanges;

  /// No description provided for @tripUpdated.
  ///
  /// In en, this message translates to:
  /// **'Trip updated to {time}'**
  String tripUpdated(String time);

  /// No description provided for @cancelTripAtTime.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel the trip at {time}?'**
  String cancelTripAtTime(String time);

  /// No description provided for @modify.
  ///
  /// In en, this message translates to:
  /// **'Modify'**
  String get modify;

  /// No description provided for @tripTracking.
  ///
  /// In en, this message translates to:
  /// **'Trip Tracking'**
  String get tripTracking;

  /// No description provided for @shareTripStatus.
  ///
  /// In en, this message translates to:
  /// **'Share Trip Status'**
  String get shareTripStatus;

  /// No description provided for @letSomeoneKnow.
  ///
  /// In en, this message translates to:
  /// **'Let someone know where you are'**
  String get letSomeoneKnow;

  /// No description provided for @shareViaSms.
  ///
  /// In en, this message translates to:
  /// **'Share via SMS'**
  String get shareViaSms;

  /// No description provided for @sendTripViaSms.
  ///
  /// In en, this message translates to:
  /// **'Send trip details via text'**
  String get sendTripViaSms;

  /// No description provided for @tripSharedSms.
  ///
  /// In en, this message translates to:
  /// **'Trip details shared via SMS'**
  String get tripSharedSms;

  /// No description provided for @shareViaWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Share via WhatsApp'**
  String get shareViaWhatsapp;

  /// No description provided for @sendLiveLocation.
  ///
  /// In en, this message translates to:
  /// **'Send live location link'**
  String get sendLiveLocation;

  /// No description provided for @tripSharedWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Trip details shared via WhatsApp'**
  String get tripSharedWhatsapp;

  /// No description provided for @shareWithEmergency.
  ///
  /// In en, this message translates to:
  /// **'Share with Emergency Contact'**
  String get shareWithEmergency;

  /// No description provided for @notifyEmergency.
  ///
  /// In en, this message translates to:
  /// **'Notify your saved contact'**
  String get notifyEmergency;

  /// No description provided for @emergencyContactNotified.
  ///
  /// In en, this message translates to:
  /// **'Emergency contact notified'**
  String get emergencyContactNotified;

  /// No description provided for @emergencySos.
  ///
  /// In en, this message translates to:
  /// **'Emergency SOS'**
  String get emergencySos;

  /// No description provided for @sosInEmergency.
  ///
  /// In en, this message translates to:
  /// **'Are you in an emergency? This will:'**
  String get sosInEmergency;

  /// No description provided for @callEmergencyServices.
  ///
  /// In en, this message translates to:
  /// **'Call emergency services (911)'**
  String get callEmergencyServices;

  /// No description provided for @alertEmergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Alert your emergency contact'**
  String get alertEmergencyContact;

  /// No description provided for @shareYourLocation.
  ///
  /// In en, this message translates to:
  /// **'Share your live location'**
  String get shareYourLocation;

  /// No description provided for @startRecording.
  ///
  /// In en, this message translates to:
  /// **'Start recording (if enabled)'**
  String get startRecording;

  /// No description provided for @activateSos.
  ///
  /// In en, this message translates to:
  /// **'Activate SOS'**
  String get activateSos;

  /// No description provided for @sosActivated.
  ///
  /// In en, this message translates to:
  /// **'SOS Activated - Help is on the way'**
  String get sosActivated;

  /// No description provided for @yourDriver.
  ///
  /// In en, this message translates to:
  /// **'Your Driver'**
  String get yourDriver;

  /// No description provided for @onTheWay.
  ///
  /// In en, this message translates to:
  /// **'On the way'**
  String get onTheWay;

  /// No description provided for @dataRefreshed.
  ///
  /// In en, this message translates to:
  /// **'Data refreshed'**
  String get dataRefreshed;

  /// No description provided for @activeUsers.
  ///
  /// In en, this message translates to:
  /// **'Active Users'**
  String get activeUsers;

  /// No description provided for @todaysTrips.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Trips'**
  String get todaysTrips;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @activeDrivers.
  ///
  /// In en, this message translates to:
  /// **'Active Drivers'**
  String get activeDrivers;

  /// No description provided for @monthlyRevenue.
  ///
  /// In en, this message translates to:
  /// **'Monthly Revenue'**
  String get monthlyRevenue;

  /// No description provided for @fromLastMonth.
  ///
  /// In en, this message translates to:
  /// **'+12.5% from last month'**
  String get fromLastMonth;

  /// No description provided for @management.
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get management;

  /// No description provided for @createTrip.
  ///
  /// In en, this message translates to:
  /// **'Create Trip'**
  String get createTrip;

  /// No description provided for @manuallyCreateTrips.
  ///
  /// In en, this message translates to:
  /// **'Manually create and assign trips'**
  String get manuallyCreateTrips;

  /// No description provided for @userManagement.
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get userManagement;

  /// No description provided for @viewManageUsers.
  ///
  /// In en, this message translates to:
  /// **'View and manage registered users'**
  String get viewManageUsers;

  /// No description provided for @driverManagement.
  ///
  /// In en, this message translates to:
  /// **'Driver Management'**
  String get driverManagement;

  /// No description provided for @manageDriversAssignments.
  ///
  /// In en, this message translates to:
  /// **'Manage drivers and assignments'**
  String get manageDriversAssignments;

  /// No description provided for @subscriptionsManagement.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions management'**
  String get subscriptionsManagement;

  /// No description provided for @viewActiveSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'View active subscriptions'**
  String get viewActiveSubscriptions;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @viewDetailedReports.
  ///
  /// In en, this message translates to:
  /// **'View detailed reports and charts'**
  String get viewDetailedReports;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @newUserRegistered.
  ///
  /// In en, this message translates to:
  /// **'New user registered'**
  String get newUserRegistered;

  /// No description provided for @subscriptionUpgraded.
  ///
  /// In en, this message translates to:
  /// **'Subscription upgraded'**
  String get subscriptionUpgraded;

  /// No description provided for @tripManagement.
  ///
  /// In en, this message translates to:
  /// **'Trip Management'**
  String get tripManagement;

  /// No description provided for @assignDriver.
  ///
  /// In en, this message translates to:
  /// **'Assign Driver'**
  String get assignDriver;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @selectDriverForTrip.
  ///
  /// In en, this message translates to:
  /// **'Select a driver for trip #'**
  String get selectDriverForTrip;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @createNewTrip.
  ///
  /// In en, this message translates to:
  /// **'Create New Trip'**
  String get createNewTrip;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'User Name'**
  String get userName;

  /// No description provided for @searchUsers.
  ///
  /// In en, this message translates to:
  /// **'Search users...'**
  String get searchUsers;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'users'**
  String get users;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @deactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivate;

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @plan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get plan;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @joined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get joined;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @onTrip.
  ///
  /// In en, this message translates to:
  /// **'On Trip'**
  String get onTrip;

  /// No description provided for @thisYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get thisYear;

  /// No description provided for @totalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get totalRevenue;

  /// No description provided for @fromLastPeriod.
  ///
  /// In en, this message translates to:
  /// **'+12.5% from last period'**
  String get fromLastPeriod;

  /// No description provided for @newUsers.
  ///
  /// In en, this message translates to:
  /// **'New Users'**
  String get newUsers;

  /// No description provided for @cancellations.
  ///
  /// In en, this message translates to:
  /// **'Cancellations'**
  String get cancellations;

  /// No description provided for @avgRating.
  ///
  /// In en, this message translates to:
  /// **'Avg Rating'**
  String get avgRating;

  /// No description provided for @tripVolume.
  ///
  /// In en, this message translates to:
  /// **'Trip Volume'**
  String get tripVolume;

  /// No description provided for @dailyTrips.
  ///
  /// In en, this message translates to:
  /// **'Daily Trips'**
  String get dailyTrips;

  /// No description provided for @subscriptionDistribution.
  ///
  /// In en, this message translates to:
  /// **'Subscription Distribution'**
  String get subscriptionDistribution;

  /// No description provided for @basicPlan.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get basicPlan;

  /// No description provided for @premiumPlan.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premiumPlan;

  /// No description provided for @vipPlan.
  ///
  /// In en, this message translates to:
  /// **'VIP'**
  String get vipPlan;

  /// No description provided for @popularRoutes.
  ///
  /// In en, this message translates to:
  /// **'Popular Routes'**
  String get popularRoutes;

  /// No description provided for @topDrivers.
  ///
  /// In en, this message translates to:
  /// **'Top Drivers'**
  String get topDrivers;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// No description provided for @frequentlyAskedQuestions.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get frequentlyAskedQuestions;

  /// No description provided for @faqChangePickupTime.
  ///
  /// In en, this message translates to:
  /// **'How do I change my pickup time?'**
  String get faqChangePickupTime;

  /// No description provided for @faqChangePickupTimeAnswer.
  ///
  /// In en, this message translates to:
  /// **'Go to My Schedule > Select a day > Tap \"Modify\" on the trip card. You can change the pickup time up to 2 hours before the scheduled time.'**
  String get faqChangePickupTimeAnswer;

  /// No description provided for @faqCancelSingleTrip.
  ///
  /// In en, this message translates to:
  /// **'Can I cancel a single trip?'**
  String get faqCancelSingleTrip;

  /// No description provided for @faqCancelSingleTripAnswer.
  ///
  /// In en, this message translates to:
  /// **'Yes! Open the trip from your schedule or home screen, then tap \"Cancel Trip\". Cancellations within 30 minutes of pickup may incur a fee.'**
  String get faqCancelSingleTripAnswer;

  /// No description provided for @faqUpgradePlan.
  ///
  /// In en, this message translates to:
  /// **'How do I upgrade my plan?'**
  String get faqUpgradePlan;

  /// No description provided for @faqUpgradePlanAnswer.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile > My Subscription > Upgrade Plan. Choose a new plan and the price difference will be prorated for the remaining days.'**
  String get faqUpgradePlanAnswer;

  /// No description provided for @faqDriverNoShow.
  ///
  /// In en, this message translates to:
  /// **'What if my driver doesn\'t show up?'**
  String get faqDriverNoShow;

  /// No description provided for @faqDriverNoShowAnswer.
  ///
  /// In en, this message translates to:
  /// **'If your driver hasn\'t arrived within 10 minutes of the scheduled time, you can report it through the app. We\'ll assign a new driver or provide a credit.'**
  String get faqDriverNoShowAnswer;

  /// No description provided for @faqChangePayment.
  ///
  /// In en, this message translates to:
  /// **'How do I change my payment method?'**
  String get faqChangePayment;

  /// No description provided for @faqChangePaymentAnswer.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile > Payment Methods. You can add a new card or bank account, and set it as your default payment method.'**
  String get faqChangePaymentAnswer;

  /// No description provided for @faqPauseSubscription.
  ///
  /// In en, this message translates to:
  /// **'Can I pause my subscription?'**
  String get faqPauseSubscription;

  /// No description provided for @faqPauseSubscriptionAnswer.
  ///
  /// In en, this message translates to:
  /// **'Yes, you can pause your subscription for up to 14 days per month. Go to Profile > My Subscription > Pause Subscription.'**
  String get faqPauseSubscriptionAnswer;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @chatWithSupportTeam.
  ///
  /// In en, this message translates to:
  /// **'Chat with our support team'**
  String get chatWithSupportTeam;

  /// No description provided for @letUsKnowIssues.
  ///
  /// In en, this message translates to:
  /// **'Let us know about issues'**
  String get letUsKnowIssues;

  /// No description provided for @tripIssue.
  ///
  /// In en, this message translates to:
  /// **'Trip Issue'**
  String get tripIssue;

  /// No description provided for @billing.
  ///
  /// In en, this message translates to:
  /// **'Billing'**
  String get billing;

  /// No description provided for @supportAgent.
  ///
  /// In en, this message translates to:
  /// **'Support Agent'**
  String get supportAgent;

  /// No description provided for @typing.
  ///
  /// In en, this message translates to:
  /// **'Typing...'**
  String get typing;

  /// No description provided for @clearChat.
  ///
  /// In en, this message translates to:
  /// **'Clear Chat'**
  String get clearChat;

  /// No description provided for @emailTranscript.
  ///
  /// In en, this message translates to:
  /// **'Email Transcript'**
  String get emailTranscript;

  /// No description provided for @chatTranscriptSent.
  ///
  /// In en, this message translates to:
  /// **'Chat transcript sent to your email'**
  String get chatTranscriptSent;

  /// No description provided for @rateYourTrip.
  ///
  /// In en, this message translates to:
  /// **'Rate Your Trip'**
  String get rateYourTrip;

  /// No description provided for @whatDidYouLike.
  ///
  /// In en, this message translates to:
  /// **'What did you like?'**
  String get whatDidYouLike;

  /// No description provided for @whatWentWrong.
  ///
  /// In en, this message translates to:
  /// **'What went wrong?'**
  String get whatWentWrong;

  /// No description provided for @smoothDriving.
  ///
  /// In en, this message translates to:
  /// **'Smooth Driving'**
  String get smoothDriving;

  /// No description provided for @onTime.
  ///
  /// In en, this message translates to:
  /// **'On Time'**
  String get onTime;

  /// No description provided for @friendly.
  ///
  /// In en, this message translates to:
  /// **'Friendly'**
  String get friendly;

  /// No description provided for @cleanCar.
  ///
  /// In en, this message translates to:
  /// **'Clean Car'**
  String get cleanCar;

  /// No description provided for @goodMusic.
  ///
  /// In en, this message translates to:
  /// **'Good Music'**
  String get goodMusic;

  /// No description provided for @professional.
  ///
  /// In en, this message translates to:
  /// **'Professional'**
  String get professional;

  /// No description provided for @lateArrival.
  ///
  /// In en, this message translates to:
  /// **'Late Arrival'**
  String get lateArrival;

  /// No description provided for @rude.
  ///
  /// In en, this message translates to:
  /// **'Rude'**
  String get rude;

  /// No description provided for @recklessDriving.
  ///
  /// In en, this message translates to:
  /// **'Reckless Driving'**
  String get recklessDriving;

  /// No description provided for @dirtyCar.
  ///
  /// In en, this message translates to:
  /// **'Dirty Car'**
  String get dirtyCar;

  /// No description provided for @wrongRoute.
  ///
  /// In en, this message translates to:
  /// **'Wrong Route'**
  String get wrongRoute;

  /// No description provided for @phoneUsage.
  ///
  /// In en, this message translates to:
  /// **'Phone Usage'**
  String get phoneUsage;

  /// No description provided for @additionalFeedback.
  ///
  /// In en, this message translates to:
  /// **'Additional Feedback (Optional)'**
  String get additionalFeedback;

  /// No description provided for @tellUsMoreAboutExperience.
  ///
  /// In en, this message translates to:
  /// **'Tell us more about your experience...'**
  String get tellUsMoreAboutExperience;

  /// No description provided for @submitRating.
  ///
  /// In en, this message translates to:
  /// **'Submit Rating'**
  String get submitRating;

  /// No description provided for @thankYouForFeedback.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback!'**
  String get thankYouForFeedback;

  /// No description provided for @inviteFriendsAndEarn.
  ///
  /// In en, this message translates to:
  /// **'Invite Friends & Earn'**
  String get inviteFriendsAndEarn;

  /// No description provided for @getSarCreditPerFriend.
  ///
  /// In en, this message translates to:
  /// **'Get SAR 50 credit for each friend\nwho subscribes'**
  String get getSarCreditPerFriend;

  /// No description provided for @codeCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Code copied to clipboard'**
  String get codeCopiedToClipboard;

  /// No description provided for @sms.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get sms;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @sharingVia.
  ///
  /// In en, this message translates to:
  /// **'Sharing via'**
  String get sharingVia;

  /// No description provided for @friendsReferred.
  ///
  /// In en, this message translates to:
  /// **'Friends\nReferred'**
  String get friendsReferred;

  /// No description provided for @creditsEarned.
  ///
  /// In en, this message translates to:
  /// **'Credits\nEarned'**
  String get creditsEarned;

  /// No description provided for @perReferral.
  ///
  /// In en, this message translates to:
  /// **'Per\nReferral'**
  String get perReferral;

  /// No description provided for @shareYourCode.
  ///
  /// In en, this message translates to:
  /// **'Share your code'**
  String get shareYourCode;

  /// No description provided for @sendYourReferralCode.
  ///
  /// In en, this message translates to:
  /// **'Send your referral code to friends via any channel'**
  String get sendYourReferralCode;

  /// No description provided for @friendSubscribes.
  ///
  /// In en, this message translates to:
  /// **'Friend subscribes'**
  String get friendSubscribes;

  /// No description provided for @theySignUpAndSubscribe.
  ///
  /// In en, this message translates to:
  /// **'They sign up and subscribe using your code'**
  String get theySignUpAndSubscribe;

  /// No description provided for @bothEarnCredits.
  ///
  /// In en, this message translates to:
  /// **'Both earn credits'**
  String get bothEarnCredits;

  /// No description provided for @youGetSarTheyGetDiscount.
  ///
  /// In en, this message translates to:
  /// **'You get SAR 50, they get SAR 25 off their first month'**
  String get youGetSarTheyGetDiscount;

  /// No description provided for @pendingSignup.
  ///
  /// In en, this message translates to:
  /// **'Pending signup'**
  String get pendingSignup;

  /// No description provided for @promoAndOffers.
  ///
  /// In en, this message translates to:
  /// **'Promo & Offers'**
  String get promoAndOffers;

  /// No description provided for @customCode.
  ///
  /// In en, this message translates to:
  /// **'Custom Code'**
  String get customCode;

  /// No description provided for @promoCodeApplied.
  ///
  /// In en, this message translates to:
  /// **'Promo code applied successfully!'**
  String get promoCodeApplied;

  /// No description provided for @referAndEarnSAR50.
  ///
  /// In en, this message translates to:
  /// **'Refer & Earn SAR 50'**
  String get referAndEarnSAR50;

  /// No description provided for @inviteFriendsEarnCredits.
  ///
  /// In en, this message translates to:
  /// **'Invite friends and earn credits'**
  String get inviteFriendsEarnCredits;

  /// No description provided for @use.
  ///
  /// In en, this message translates to:
  /// **'Use'**
  String get use;

  /// No description provided for @readAll.
  ///
  /// In en, this message translates to:
  /// **'Read all'**
  String get readAll;

  /// No description provided for @tripsTab.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get tripsTab;

  /// No description provided for @billingTab.
  ///
  /// In en, this message translates to:
  /// **'Billing'**
  String get billingTab;

  /// No description provided for @otherTab.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherTab;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @youreAllCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up!'**
  String get youreAllCaughtUp;

  /// No description provided for @driverArrivingIn5Min.
  ///
  /// In en, this message translates to:
  /// **'Ahmed Khan is arriving in 5 minutes. Be ready at pickup point.'**
  String get driverArrivingIn5Min;

  /// No description provided for @tripCompletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your morning trip has been completed. Rate your experience!'**
  String get tripCompletedMessage;

  /// No description provided for @subscriptionRenewed.
  ///
  /// In en, this message translates to:
  /// **'Subscription Renewed'**
  String get subscriptionRenewed;

  /// No description provided for @subscriptionRenewedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your Standard plan has been renewed for another month.'**
  String get subscriptionRenewedMessage;

  /// No description provided for @upgradeOffer.
  ///
  /// In en, this message translates to:
  /// **'20% Off Upgrade!'**
  String get upgradeOffer;

  /// No description provided for @upgradeOfferMessage.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium plan and get 20% off for the first month.'**
  String get upgradeOfferMessage;

  /// No description provided for @scheduleChanged.
  ///
  /// In en, this message translates to:
  /// **'Schedule Changed'**
  String get scheduleChanged;

  /// No description provided for @scheduleChangedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your pickup time for tomorrow has been updated to 8:30 AM.'**
  String get scheduleChangedMessage;

  /// No description provided for @paymentReceived.
  ///
  /// In en, this message translates to:
  /// **'Payment Received'**
  String get paymentReceived;

  /// No description provided for @paymentReceivedMessage.
  ///
  /// In en, this message translates to:
  /// **'Payment of SAR 599 received for Standard plan subscription.'**
  String get paymentReceivedMessage;

  /// No description provided for @appUpdateAvailable.
  ///
  /// In en, this message translates to:
  /// **'App Update Available'**
  String get appUpdateAvailable;

  /// No description provided for @appUpdateMessage.
  ///
  /// In en, this message translates to:
  /// **'A new version of DriverApp is available. Update now for new features!'**
  String get appUpdateMessage;

  /// No description provided for @weekendSpecial.
  ///
  /// In en, this message translates to:
  /// **'Weekend Special'**
  String get weekendSpecial;

  /// No description provided for @weekendSpecialMessage.
  ///
  /// In en, this message translates to:
  /// **'Book weekend rides at 15% discount. Limited time offer!'**
  String get weekendSpecialMessage;

  /// No description provided for @searchForPlaceOrAddress.
  ///
  /// In en, this message translates to:
  /// **'Search for a place or address'**
  String get searchForPlaceOrAddress;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @changeProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change Profile Photo'**
  String get changeProfilePhoto;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @useYourCamera.
  ///
  /// In en, this message translates to:
  /// **'Use your camera'**
  String get useYourCamera;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @pickAnExistingPhoto.
  ///
  /// In en, this message translates to:
  /// **'Pick an existing photo'**
  String get pickAnExistingPhoto;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove Photo'**
  String get removePhoto;

  /// No description provided for @useDefaultAvatar.
  ///
  /// In en, this message translates to:
  /// **'Use default avatar'**
  String get useDefaultAvatar;

  /// No description provided for @photoSelectedSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Photo selected. Save changes to update.'**
  String get photoSelectedSaveChanges;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @thisPersonWillBeNotified.
  ///
  /// In en, this message translates to:
  /// **'This person will be notified in case of emergency during a trip'**
  String get thisPersonWillBeNotified;

  /// No description provided for @accountInfo.
  ///
  /// In en, this message translates to:
  /// **'Account Info'**
  String get accountInfo;

  /// No description provided for @accountStatus.
  ///
  /// In en, this message translates to:
  /// **'Account Status'**
  String get accountStatus;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @nameIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameIsRequired;

  /// No description provided for @emailIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailIsRequired;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get enterValidEmail;

  /// No description provided for @notVerified.
  ///
  /// In en, this message translates to:
  /// **'Not Verified'**
  String get notVerified;

  /// No description provided for @addAddress.
  ///
  /// In en, this message translates to:
  /// **'Add Address'**
  String get addAddress;

  /// No description provided for @noSavedAddresses.
  ///
  /// In en, this message translates to:
  /// **'No Saved Addresses'**
  String get noSavedAddresses;

  /// No description provided for @addFrequentlyVisitedPlaces.
  ///
  /// In en, this message translates to:
  /// **'Add your frequently visited places\nfor quick trip setup'**
  String get addFrequentlyVisitedPlaces;

  /// No description provided for @defaultLabel.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultLabel;

  /// No description provided for @deleteAddress.
  ///
  /// In en, this message translates to:
  /// **'Delete Address'**
  String get deleteAddress;

  /// No description provided for @addressDeleted.
  ///
  /// In en, this message translates to:
  /// **'Address deleted'**
  String get addressDeleted;

  /// No description provided for @addNewAddress.
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get addNewAddress;

  /// No description provided for @editAddress.
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get editAddress;

  /// No description provided for @addressType.
  ///
  /// In en, this message translates to:
  /// **'Address Type'**
  String get addressType;

  /// No description provided for @label.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get label;

  /// No description provided for @streetAddress.
  ///
  /// In en, this message translates to:
  /// **'Street Address'**
  String get streetAddress;

  /// No description provided for @buildingName.
  ///
  /// In en, this message translates to:
  /// **'Building Name (optional)'**
  String get buildingName;

  /// No description provided for @floor.
  ///
  /// In en, this message translates to:
  /// **'Floor'**
  String get floor;

  /// No description provided for @aptUnit.
  ///
  /// In en, this message translates to:
  /// **'Apt/Unit'**
  String get aptUnit;

  /// No description provided for @landmark.
  ///
  /// In en, this message translates to:
  /// **'Landmark (optional)'**
  String get landmark;

  /// No description provided for @labelAndAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Label and address are required'**
  String get labelAndAddressRequired;

  /// No description provided for @addressAdded.
  ///
  /// In en, this message translates to:
  /// **'Address added'**
  String get addressAdded;

  /// No description provided for @addressUpdated.
  ///
  /// In en, this message translates to:
  /// **'Address updated'**
  String get addressUpdated;

  /// No description provided for @updateAddress.
  ///
  /// In en, this message translates to:
  /// **'Update Address'**
  String get updateAddress;

  /// No description provided for @saveAddress.
  ///
  /// In en, this message translates to:
  /// **'Save Address'**
  String get saveAddress;

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// No description provided for @school.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get school;

  /// No description provided for @setAsDefault.
  ///
  /// In en, this message translates to:
  /// **'Set as Default'**
  String get setAsDefault;

  /// No description provided for @addMethod.
  ///
  /// In en, this message translates to:
  /// **'Add Method'**
  String get addMethod;

  /// No description provided for @noPaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'No Payment Methods'**
  String get noPaymentMethods;

  /// No description provided for @addCardOrWallet.
  ///
  /// In en, this message translates to:
  /// **'Add a card or wallet to pay\nfor your subscriptions'**
  String get addCardOrWallet;

  /// No description provided for @digitalWallets.
  ///
  /// In en, this message translates to:
  /// **'Digital Wallets'**
  String get digitalWallets;

  /// No description provided for @paymentInfoEncrypted.
  ///
  /// In en, this message translates to:
  /// **'Your payment information is encrypted and stored securely.'**
  String get paymentInfoEncrypted;

  /// No description provided for @cardType.
  ///
  /// In en, this message translates to:
  /// **'CARD TYPE'**
  String get cardType;

  /// No description provided for @expires.
  ///
  /// In en, this message translates to:
  /// **'EXPIRES'**
  String get expires;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @removePaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Remove Payment Method'**
  String get removePaymentMethod;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @paymentMethodRemoved.
  ///
  /// In en, this message translates to:
  /// **'Payment method removed'**
  String get paymentMethodRemoved;

  /// No description provided for @paymentMethodAdded.
  ///
  /// In en, this message translates to:
  /// **'Payment method added'**
  String get paymentMethodAdded;

  /// No description provided for @addPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Add Payment Method'**
  String get addPaymentMethod;

  /// No description provided for @creditDebitCard.
  ///
  /// In en, this message translates to:
  /// **'Credit/Debit Card'**
  String get creditDebitCard;

  /// No description provided for @applePay.
  ///
  /// In en, this message translates to:
  /// **'Apple Pay'**
  String get applePay;

  /// No description provided for @addCard.
  ///
  /// In en, this message translates to:
  /// **'Add Card'**
  String get addCard;

  /// No description provided for @connectApplePay.
  ///
  /// In en, this message translates to:
  /// **'Connect Apple Pay'**
  String get connectApplePay;

  /// No description provided for @cardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get cardNumber;

  /// No description provided for @mmyy.
  ///
  /// In en, this message translates to:
  /// **'MM/YY'**
  String get mmyy;

  /// No description provided for @cvv.
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get cvv;

  /// No description provided for @cardholderName.
  ///
  /// In en, this message translates to:
  /// **'Cardholder Name'**
  String get cardholderName;

  /// No description provided for @useApplePayWallet.
  ///
  /// In en, this message translates to:
  /// **'Use your Apple Pay wallet for seamless payments'**
  String get useApplePayWallet;

  /// No description provided for @pleaseCheckCardDetails.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all card details'**
  String get pleaseCheckCardDetails;

  /// No description provided for @logOutAll.
  ///
  /// In en, this message translates to:
  /// **'Log out all'**
  String get logOutAll;

  /// No description provided for @logOutAllDevices.
  ///
  /// In en, this message translates to:
  /// **'Log Out All Devices'**
  String get logOutAllDevices;

  /// No description provided for @logOutAllConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will log you out from all other devices. You will remain logged in on this device.'**
  String get logOutAllConfirm;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @loggedOutFromAll.
  ///
  /// In en, this message translates to:
  /// **'Logged out from all other devices'**
  String get loggedOutFromAll;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: January 1, 2026'**
  String get lastUpdated;

  /// No description provided for @effectiveDate.
  ///
  /// In en, this message translates to:
  /// **'Effective: January 1, 2026'**
  String get effectiveDate;

  /// No description provided for @describeProblem.
  ///
  /// In en, this message translates to:
  /// **'Describe the issue...'**
  String get describeProblem;

  /// No description provided for @reportSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Report submitted. Thank you!'**
  String get reportSubmitted;

  /// No description provided for @issueReported.
  ///
  /// In en, this message translates to:
  /// **'Issue reported. We\'ll get back to you shortly.'**
  String get issueReported;

  /// No description provided for @selectTheIssue.
  ///
  /// In en, this message translates to:
  /// **'Select the issue you experienced'**
  String get selectTheIssue;

  /// No description provided for @driverDidNotShowUp.
  ///
  /// In en, this message translates to:
  /// **'Driver did not show up'**
  String get driverDidNotShowUp;

  /// No description provided for @driverArrivedLate.
  ///
  /// In en, this message translates to:
  /// **'Driver arrived late'**
  String get driverArrivedLate;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @monShort.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get monShort;

  /// No description provided for @tueShort.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tueShort;

  /// No description provided for @wedShort.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wedShort;

  /// No description provided for @thuShort.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thuShort;

  /// No description provided for @friShort.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get friShort;

  /// No description provided for @satShort.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get satShort;

  /// No description provided for @sunShort.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sunShort;

  /// No description provided for @changePickupTime.
  ///
  /// In en, this message translates to:
  /// **'Change pickup time for {date}'**
  String changePickupTime(String date);

  /// No description provided for @tripScheduledTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip Scheduled'**
  String get tripScheduledTitle;

  /// No description provided for @tripStartsAt.
  ///
  /// In en, this message translates to:
  /// **'Your trip will start at {time}'**
  String tripStartsAt(String time);

  /// No description provided for @driverAssignedTitle.
  ///
  /// In en, this message translates to:
  /// **'Driver Assigned'**
  String get driverAssignedTitle;

  /// No description provided for @driverPreparingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your driver is preparing for the trip'**
  String get driverPreparingSubtitle;

  /// No description provided for @driverArrivingTitle.
  ///
  /// In en, this message translates to:
  /// **'Driver Arriving'**
  String get driverArrivingTitle;

  /// No description provided for @driverArrivingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your driver will arrive in ~5 min'**
  String get driverArrivingSubtitle;

  /// No description provided for @tripInProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip in Progress'**
  String get tripInProgressTitle;

  /// No description provided for @enjoyYourRide.
  ///
  /// In en, this message translates to:
  /// **'Enjoy your ride!'**
  String get enjoyYourRide;

  /// No description provided for @tripCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip Completed'**
  String get tripCompletedTitle;

  /// No description provided for @thankYouForRiding.
  ///
  /// In en, this message translates to:
  /// **'Thank you for riding with us'**
  String get thankYouForRiding;

  /// No description provided for @tripCancelledTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip Cancelled'**
  String get tripCancelledTitle;

  /// No description provided for @tripHasBeenCancelled.
  ///
  /// In en, this message translates to:
  /// **'This trip has been cancelled'**
  String get tripHasBeenCancelled;

  /// No description provided for @economyVehicle.
  ///
  /// In en, this message translates to:
  /// **'Economy'**
  String get economyVehicle;

  /// No description provided for @comfortVehicle.
  ///
  /// In en, this message translates to:
  /// **'Comfort'**
  String get comfortVehicle;

  /// No description provided for @luxuryVehicle.
  ///
  /// In en, this message translates to:
  /// **'Luxury'**
  String get luxuryVehicle;

  /// No description provided for @vanVehicle.
  ///
  /// In en, this message translates to:
  /// **'Van'**
  String get vanVehicle;

  /// No description provided for @economyVehicleDesc.
  ///
  /// In en, this message translates to:
  /// **'Basic comfort, compact cars'**
  String get economyVehicleDesc;

  /// No description provided for @comfortVehicleDesc.
  ///
  /// In en, this message translates to:
  /// **'Sedan, good comfort'**
  String get comfortVehicleDesc;

  /// No description provided for @luxuryVehicleDesc.
  ///
  /// In en, this message translates to:
  /// **'Premium vehicles, executive comfort'**
  String get luxuryVehicleDesc;

  /// No description provided for @vanVehicleDesc.
  ///
  /// In en, this message translates to:
  /// **'7+ seater, family/group transport'**
  String get vanVehicleDesc;

  /// No description provided for @planWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get planWeekly;

  /// No description provided for @planMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get planMonthly;

  /// No description provided for @planQuarterly.
  ///
  /// In en, this message translates to:
  /// **'Quarterly'**
  String get planQuarterly;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// No description provided for @noShow.
  ///
  /// In en, this message translates to:
  /// **'No Show'**
  String get noShow;

  /// No description provided for @statusBusy.
  ///
  /// In en, this message translates to:
  /// **'Busy'**
  String get statusBusy;

  /// No description provided for @otherAddress.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherAddress;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get paymentFailed;

  /// No description provided for @paymentRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get paymentRefunded;

  /// No description provided for @roleUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get roleUser;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get roleAdmin;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
