import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/cache_service.dart';
import '../models/user_model.dart';
import '../models/subscription_model.dart';
import '../models/trip_model.dart';
import '../models/plan_model.dart';
import '../../core/enums/enums.dart';

// ==================== SERVICES ====================

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

final cacheServiceProvider = Provider<CacheService>((ref) {
  return CacheService();
});

// ==================== AUTH ====================

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).value;
});

// ==================== USER ====================

final userDataProvider = StreamProvider.family<UserModel?, String>((ref, userId) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getUserStream(userId);
});

final currentUserDataProvider = StreamProvider<UserModel?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(null);

  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getUserStream(user.uid);
});

// ==================== PLANS ====================

final plansProvider = FutureProvider<List<PlanModel>>((ref) async {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getActivePlans();
});

// ==================== SUBSCRIPTIONS ====================

final activeSubscriptionProvider = StreamProvider<SubscriptionModel?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(null);

  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getActiveSubscriptionStream(user.uid);
});

final userSubscriptionsProvider = StreamProvider<List<SubscriptionModel>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);

  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getUserSubscriptions(user.uid);
});

// ==================== TRIPS ====================

final upcomingTripsProvider = StreamProvider<List<TripModel>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);

  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getUpcomingTrips(user.uid);
});

final tripHistoryProvider = StreamProvider<List<TripModel>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);

  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getTripHistory(user.uid);
});

final tripStreamProvider = StreamProvider.family<TripModel?, String>((ref, tripId) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getTripStream(tripId);
});

final nextTripProvider = FutureProvider<TripModel?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;

  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getNextTrip(user.uid);
});

// ==================== DRIVER ====================

// Driver status state
final driverStatusProvider = StateProvider<DriverStatus>((ref) => DriverStatus.offline);

// Driver's assigned trips
final driverAssignedTripsProvider = StreamProvider<List<TripModel>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);

  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getDriverAssignedTrips(user.uid);
});

// Driver's active trip (in progress)
final driverActiveTripProvider = StreamProvider<TripModel?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(null);

  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getDriverActiveTrip(user.uid);
});

// Driver's today trips
final driverTodayTripsProvider = StreamProvider<List<TripModel>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);

  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getDriverTodayTrips(user.uid);
});

// Driver's trip history
final driverTripHistoryProvider = StreamProvider<List<TripModel>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);

  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getDriverTripHistory(user.uid);
});

// Driver earnings for current period
final driverEarningsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, period) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return {'totalEarnings': 0, 'tripCount': 0, 'totalDistance': 0, 'averagePerTrip': 0};

  final firestoreService = ref.watch(firestoreServiceProvider);

  final now = DateTime.now();
  DateTime startDate;
  DateTime endDate = now;

  switch (period) {
    case 'today':
      startDate = DateTime(now.year, now.month, now.day);
      break;
    case 'week':
      startDate = now.subtract(const Duration(days: 7));
      break;
    case 'month':
      startDate = DateTime(now.year, now.month, 1);
      break;
    default:
      startDate = now.subtract(const Duration(days: 7));
  }

  return firestoreService.getDriverEarnings(user.uid, startDate: startDate, endDate: endDate);
});

// Driver stats
final driverStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return {'totalTrips': 0, 'averageRating': 5.0, 'acceptanceRate': 100.0};

  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getDriverStats(user.uid);
});

// All drivers (for admin)
final allDriversProvider = StreamProvider<List<UserModel>>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getAllDrivers();
});

// Available drivers (online, for admin trip assignment)
final availableDriversProvider = StreamProvider<List<UserModel>>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getAvailableDrivers();
});

// ==================== NOTIFICATIONS ====================

final notificationsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);

  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getUserNotifications(user.uid);
});

// ==================== ADMIN ====================

final adminStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getAdminStats();
});

final allUsersProvider = StreamProvider<List<UserModel>>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getAllUsers();
});

final allTripsProvider = StreamProvider<List<TripModel>>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getAllTrips();
});

// ==================== PAYMENTS ====================

final userPaymentsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);

  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getUserPayments(user.uid);
});

// ==================== PROMO CODES ====================

final promoCodesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getActivePromoCodes();
});

// ==================== LIVE CHAT ====================

final chatIdProvider = FutureProvider<String>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) throw Exception('Not authenticated');

  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getOrCreateChat(user.uid);
});

final chatMessagesProvider = StreamProvider.family<List<Map<String, dynamic>>, String>((ref, chatId) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getChatMessages(chatId);
});

// ==================== APP STATE ====================

final isFirstLaunchProvider = StateProvider<bool>((ref) => true);

final selectedPlanProvider = StateProvider<PlanModel?>((ref) => null);

final onboardingCompleteProvider = StateProvider<bool>((ref) => false);
