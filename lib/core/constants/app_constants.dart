class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'DriverApp';
  static const String appVersion = '1.0.0';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String subscriptionsCollection = 'subscriptions';
  static const String tripsCollection = 'trips';
  static const String plansCollection = 'plans';
  static const String paymentsCollection = 'payments';
  static const String notificationsCollection = 'notifications';
  static const String chatsCollection = 'chats';
  static const String promoCodesCollection = 'promoCodes';
  static const String referralsCollection = 'referrals';

  // Storage Paths
  static const String profileImagesPath = 'profile_images';
  static const String documentsPath = 'documents';

  // Shared Preferences Keys
  static const String keyIsFirstLaunch = 'is_first_launch';
  static const String keyUserId = 'user_id';
  static const String keyAuthToken = 'auth_token';

  // Time Constants
  static const int otpExpirySeconds = 60;
  static const int tripReminderMinutes = 30;
  static const int scheduleModificationCutoffHours = 2;

  // Limits
  static const int maxSavedAddresses = 5;
  static const int maxExcludedDates = 30;
}
