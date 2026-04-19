import 'package:flutter/material.dart';
import '../presentation/screens/splash/splash_screen.dart';
import '../presentation/screens/onboarding/onboarding_screen.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/profile_setup_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/subscription/plans_screen.dart';
import '../presentation/screens/subscription/schedule_setup_screen.dart';
import '../presentation/screens/subscription/payment_confirmation_screen.dart';
import '../presentation/screens/subscription/my_subscription_screen.dart';
import '../presentation/screens/schedule/schedule_screen.dart';
import '../presentation/screens/history/trip_history_screen.dart';
import '../presentation/screens/history/trip_details_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/screens/profile/personal_info_screen.dart';
import '../presentation/screens/profile/saved_addresses_screen.dart';
import '../presentation/screens/profile/payment_methods_screen.dart';
import '../presentation/screens/settings/settings_screen.dart';
import '../presentation/screens/settings/login_history_screen.dart';
import '../presentation/screens/settings/terms_screen.dart';
import '../presentation/screens/settings/privacy_policy_screen.dart';
import '../presentation/screens/support/live_chat_screen.dart';
import '../presentation/screens/common/location_picker_screen.dart';
import '../presentation/screens/history/trip_receipt_screen.dart';
import '../presentation/screens/referral/referral_screen.dart';
import '../presentation/screens/offers/promo_offers_screen.dart';
import '../presentation/screens/tracking/trip_tracking_screen.dart';
import '../presentation/screens/notifications/notifications_screen.dart';
import '../presentation/screens/support/support_screen.dart';
import '../presentation/screens/rating/rate_driver_screen.dart';
import '../presentation/screens/admin/admin_dashboard_screen.dart';
import '../presentation/screens/admin/trip_management_screen.dart';
import '../presentation/screens/admin/user_management_screen.dart';
import '../presentation/screens/admin/driver_management_screen.dart';
import '../presentation/screens/admin/analytics_screen.dart';
import '../presentation/screens/driver/driver_home_screen.dart';
import '../presentation/screens/driver/driver_trips_screen.dart';
import '../presentation/screens/driver/driver_earnings_screen.dart';
import '../presentation/screens/driver/driver_profile_screen.dart';
import '../presentation/screens/driver/driver_registration_screen.dart';
import '../data/models/trip_model.dart';
import '../core/animations/page_transitions.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String profileSetup = '/profile-setup';
  static const String home = '/home';
  static const String plans = '/plans';
  static const String scheduleSetup = '/schedule-setup';
  static const String schedule = '/schedule';
  static const String history = '/history';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String support = '/support';
  static const String notifications = '/notifications';
  static const String tripDetails = '/trip-details';
  static const String tripTracking = '/trip-tracking';
  static const String paymentConfirmation = '/payment-confirmation';
  static const String mySubscription = '/my-subscription';
  static const String rateDriver = '/rate-driver';
  static const String personalInfo = '/personal-info';
  static const String savedAddresses = '/saved-addresses';
  static const String paymentMethods = '/payment-methods';
  static const String loginHistory = '/login-history';
  static const String terms = '/terms';
  static const String privacyPolicy = '/privacy-policy';
  static const String liveChat = '/live-chat';
  static const String locationPicker = '/location-picker';
  static const String tripReceipt = '/trip-receipt';
  static const String referral = '/referral';
  static const String promoOffers = '/promo-offers';
  static const String adminDashboard = '/admin';
  static const String adminTrips = '/admin/trips';
  static const String adminUsers = '/admin/users';
  static const String adminDrivers = '/admin/drivers';
  static const String adminAnalytics = '/admin/analytics';

  // Driver routes
  static const String driverHome = '/driver-home';
  static const String driverTrips = '/driver-trips';
  static const String driverEarnings = '/driver-earnings';
  static const String driverProfile = '/driver-profile';
  static const String driverRegistration = '/driver-registration';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return FadePageRoute(page: const SplashScreen());

      case onboarding:
        return SlidePageRoute(
          page: const OnboardingScreen(),
          direction: SlideTransitionDirection.rightToLeft,
        );

      case login:
        return SlidePageRoute(
          page: const LoginScreen(),
          direction: SlideTransitionDirection.rightToLeft,
        );

      case profileSetup:
        return SlidePageRoute(
          page: const ProfileSetupScreen(),
          direction: SlideTransitionDirection.bottomToTop,
        );

      case home:
        return FadePageRoute(page: const HomeScreen());

      case plans:
        return SlidePageRoute(
          page: const PlansScreen(),
          direction: SlideTransitionDirection.bottomToTop,
        );

      case scheduleSetup:
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return SlidePageRoute(
          page: ScheduleSetupScreen(arguments: args),
          direction: SlideTransitionDirection.rightToLeft,
        );

      case schedule:
        return SlidePageRoute(
          page: const ScheduleScreen(),
          direction: SlideTransitionDirection.rightToLeft,
        );

      case history:
        return SlidePageRoute(
          page: const TripHistoryScreen(),
          direction: SlideTransitionDirection.rightToLeft,
        );

      case profile:
        return SlidePageRoute(
          page: const ProfileScreen(),
          direction: SlideTransitionDirection.rightToLeft,
        );

      case AppRoutes.settings:
        return SlidePageRoute(
          page: const SettingsScreen(),
          direction: SlideTransitionDirection.rightToLeft,
        );

      case AppRoutes.support:
        return SlidePageRoute(
          page: const SupportScreen(),
          direction: SlideTransitionDirection.rightToLeft,
        );

      case notifications:
        return SlidePageRoute(
          page: const NotificationsScreen(),
          direction: SlideTransitionDirection.rightToLeft,
        );

      case tripDetails:
        final trip = routeSettings.arguments as TripModel;
        return SlidePageRoute(
          page: TripDetailsScreen(trip: trip),
          direction: SlideTransitionDirection.rightToLeft,
        );

      case tripTracking:
        final trip = routeSettings.arguments as TripModel;
        return SlidePageRoute(
          page: TripTrackingScreen(trip: trip),
          direction: SlideTransitionDirection.bottomToTop,
        );

      case paymentConfirmation:
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return ScalePageRoute(
          page: PaymentConfirmationScreen(arguments: args),
        );

      case mySubscription:
        return SlidePageRoute(
          page: const MySubscriptionScreen(),
          direction: SlideTransitionDirection.rightToLeft,
        );

      case rateDriver:
        final trip = routeSettings.arguments as TripModel;
        return SlidePageRoute(
          page: RateDriverScreen(trip: trip),
          direction: SlideTransitionDirection.bottomToTop,
        );

      case personalInfo:
        return SlidePageRoute(
          page: const PersonalInfoScreen(),
          direction: SlideTransitionDirection.rightToLeft,
        );

      case savedAddresses:
        return SlidePageRoute(
          page: const SavedAddressesScreen(),
          direction: SlideTransitionDirection.rightToLeft,
        );

      case paymentMethods:
        return SlidePageRoute(
          page: const PaymentMethodsScreen(),
          direction: SlideTransitionDirection.rightToLeft,
        );

      case loginHistory:
        return SlidePageRoute(
          page: const LoginHistoryScreen(),
          direction: SlideTransitionDirection.rightToLeft,
        );

      case terms:
        return SlidePageRoute(
          page: const TermsScreen(),
          direction: SlideTransitionDirection.rightToLeft,
        );

      case privacyPolicy:
        return SlidePageRoute(
          page: const PrivacyPolicyScreen(),
          direction: SlideTransitionDirection.rightToLeft,
        );

      case liveChat:
        return SlidePageRoute(
          page: const LiveChatScreen(),
          direction: SlideTransitionDirection.bottomToTop,
        );

      case locationPicker:
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return SlidePageRoute(
          page: LocationPickerScreen(
            title: args?['title'],
            initialLocation: args?['initialLocation'],
          ),
          direction: SlideTransitionDirection.bottomToTop,
        );

      case tripReceipt:
        final trip = routeSettings.arguments as TripModel;
        return SlidePageRoute(
          page: TripReceiptScreen(trip: trip),
          direction: SlideTransitionDirection.rightToLeft,
        );

      case referral:
        return SlidePageRoute(
          page: const ReferralScreen(),
          direction: SlideTransitionDirection.rightToLeft,
        );

      case promoOffers:
        return SlidePageRoute(
          page: const PromoOffersScreen(),
          direction: SlideTransitionDirection.rightToLeft,
        );

      case adminDashboard:
        return SlidePageRoute(
          page: const AdminDashboardScreen(),
          direction: SlideTransitionDirection.bottomToTop,
        );

      case adminTrips:
        return SlidePageRoute(
          page: const TripManagementScreen(),
          direction: SlideTransitionDirection.rightToLeft,
        );

      case adminUsers:
        return SlidePageRoute(
          page: const UserManagementScreen(),
          direction: SlideTransitionDirection.rightToLeft,
        );

      case adminDrivers:
        return SlidePageRoute(
          page: const DriverManagementScreen(),
          direction: SlideTransitionDirection.rightToLeft,
        );

      case adminAnalytics:
        return SlidePageRoute(
          page: const AnalyticsScreen(),
          direction: SlideTransitionDirection.rightToLeft,
        );

      // Driver routes
      case driverHome:
        return FadePageRoute(page: const DriverHomeScreen());

      case driverTrips:
        return SlidePageRoute(
          page: const DriverTripsScreen(),
          direction: SlideTransitionDirection.rightToLeft,
        );

      case driverEarnings:
        return SlidePageRoute(
          page: const DriverEarningsScreen(),
          direction: SlideTransitionDirection.rightToLeft,
        );

      case driverProfile:
        return SlidePageRoute(
          page: const DriverProfileScreen(),
          direction: SlideTransitionDirection.rightToLeft,
        );

      case driverRegistration:
        return SlidePageRoute(
          page: const DriverRegistrationScreen(),
          direction: SlideTransitionDirection.bottomToTop,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${routeSettings.name}'),
            ),
          ),
        );
    }
  }
}
