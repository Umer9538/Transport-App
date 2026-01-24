import 'package:flutter/material.dart';
import '../presentation/screens/splash/splash_screen.dart';
import '../presentation/screens/onboarding/onboarding_screen.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/otp_screen.dart';
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
import '../presentation/screens/settings/settings_screen.dart';
import '../presentation/screens/tracking/trip_tracking_screen.dart';
import '../presentation/screens/notifications/notifications_screen.dart';
import '../presentation/screens/support/support_screen.dart';
import '../presentation/screens/rating/rate_driver_screen.dart';
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

      case otp:
        final args = routeSettings.arguments as Map<String, dynamic>;
        return SlidePageRoute(
          page: OTPScreen(
            phoneNumber: args['phoneNumber'],
            verificationId: args['verificationId'],
          ),
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
