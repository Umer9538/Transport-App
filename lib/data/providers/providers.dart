import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';
import '../models/subscription_model.dart';
import '../models/trip_model.dart';
import '../models/plan_model.dart';
import '../models/address_model.dart';
import '../models/schedule_model.dart';
import '../../core/enums/enums.dart';

// ==================== SERVICES ====================

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
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
  // Test mode: return mock user data
  if (AuthService.testMode) {
    return Stream.value(_mockUser);
  }

  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(null);

  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getUserStream(user.uid);
});

// ==================== PLANS ====================

final plansProvider = FutureProvider<List<PlanModel>>((ref) async {
  // Test mode: return mock plans
  if (AuthService.testMode) {
    return _mockPlans;
  }

  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getActivePlans();
});

// ==================== SUBSCRIPTIONS ====================

final activeSubscriptionProvider = StreamProvider<SubscriptionModel?>((ref) {
  // Test mode: return mock subscription
  if (AuthService.testMode) {
    return Stream.value(_mockSubscription);
  }

  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(null);

  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getActiveSubscriptionStream(user.uid);
});

final userSubscriptionsProvider = StreamProvider<List<SubscriptionModel>>((ref) {
  if (AuthService.testMode) {
    return Stream.value([_mockSubscription]);
  }

  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);

  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getUserSubscriptions(user.uid);
});

// ==================== TRIPS ====================

final upcomingTripsProvider = StreamProvider<List<TripModel>>((ref) {
  if (AuthService.testMode) {
    return Stream.value(_mockUpcomingTrips);
  }

  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);

  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getUpcomingTrips(user.uid);
});

final tripHistoryProvider = StreamProvider<List<TripModel>>((ref) {
  if (AuthService.testMode) {
    return Stream.value(_mockTripHistory);
  }

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
  if (AuthService.testMode) {
    return _mockUpcomingTrips.isNotEmpty ? _mockUpcomingTrips.first : null;
  }

  final user = ref.watch(currentUserProvider);
  if (user == null) return null;

  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getNextTrip(user.uid);
});

// ==================== APP STATE ====================

final isFirstLaunchProvider = StateProvider<bool>((ref) => true);

final selectedPlanProvider = StateProvider<PlanModel?>((ref) => null);

final onboardingCompleteProvider = StateProvider<bool>((ref) => false);

// ==================== TEST MODE MOCK DATA ====================

final _mockUser = UserModel(
  id: 'test-user-001',
  name: 'Test User',
  email: 'test@driverapp.com',
  phone: '+1 555-123-4567',
  preferredDriverGender: DriverGender.noPreference,
  preferredVehicleType: VehicleType.mid,
  createdAt: DateTime.now().subtract(const Duration(days: 30)),
  updatedAt: DateTime.now(),
  isVerified: true,
  isActive: true,
);

final _mockPickup = AddressModel(
  id: 'addr-1',
  title: 'Home',
  address: '123 Main Street, Downtown',
  latitude: 25.2048,
  longitude: 55.2708,
  type: AddressType.home,
);

final _mockDropoff = AddressModel(
  id: 'addr-2',
  title: 'Office',
  address: '456 Business Ave, Tech Park',
  latitude: 25.2148,
  longitude: 55.2808,
  type: AddressType.work,
);

final _mockPlans = [
  PlanModel(
    id: 'plan-basic',
    name: 'Basic',
    description: 'Perfect for occasional commuters',
    type: PlanType.monthly,
    durationDays: 30,
    basePrice: 299.0,
    tripsPerDay: 1,
    features: ['1 trip per day', 'Economy vehicle', 'Standard support'],
    isPopular: false,
    isActive: true,
  ),
  PlanModel(
    id: 'plan-standard',
    name: 'Standard',
    description: 'Great for daily commuters',
    type: PlanType.monthly,
    durationDays: 30,
    basePrice: 599.0,
    tripsPerDay: 2,
    features: ['2 trips per day', 'Mid-range vehicle', 'Priority support', 'Schedule flexibility'],
    isPopular: true,
    isActive: true,
  ),
  PlanModel(
    id: 'plan-premium',
    name: 'Premium',
    description: 'The ultimate commute experience',
    type: PlanType.monthly,
    durationDays: 30,
    basePrice: 999.0,
    tripsPerDay: 3,
    features: ['3 trips per day', 'Luxury vehicle', '24/7 support', 'Driver preference', 'No surge pricing'],
    isPopular: false,
    isActive: true,
  ),
];

final _mockSchedule = ScheduleModel(
  activeDays: [DayOfWeek.monday, DayOfWeek.tuesday, DayOfWeek.wednesday, DayOfWeek.thursday, DayOfWeek.friday],
  pickupTime: const TimeOfDay(hour: 8, minute: 0),
  returnPickupTime: const TimeOfDay(hour: 17, minute: 30),
  pickupLocation: _mockPickup,
  dropoffLocation: _mockDropoff,
);

final _mockSubscription = SubscriptionModel(
  id: 'sub-001',
  userId: 'test-user-001',
  planId: 'plan-standard',
  planName: 'Standard',
  planType: PlanType.monthly,
  status: SubscriptionStatus.active,
  startDate: DateTime.now().subtract(const Duration(days: 10)),
  endDate: DateTime.now().add(const Duration(days: 20)),
  vehicleType: VehicleType.mid,
  driverGender: DriverGender.noPreference,
  schedule: _mockSchedule,
  totalTrips: 40,
  usedTrips: 14,
  basePrice: 599.0,
  finalPrice: 599.0,
  createdAt: DateTime.now().subtract(const Duration(days: 10)),
);

final _mockUpcomingTrips = [
  TripModel(
    id: 'trip-001',
    userId: 'test-user-001',
    subscriptionId: 'sub-001',
    scheduledTime: DateTime.now().add(const Duration(hours: 2)),
    pickupLocation: _mockPickup,
    dropoffLocation: _mockDropoff,
    status: TripStatus.driverAssigned,
    vehicleType: VehicleType.mid,
    driverId: 'driver-001',
    driverName: 'Ahmed Khan',
    vehicleNumber: 'ABC-1234',
    vehicleModel: 'Toyota Camry',
    driverRating: 4.9,
    createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    updatedAt: DateTime.now(),
  ),
  TripModel(
    id: 'trip-002',
    userId: 'test-user-001',
    subscriptionId: 'sub-001',
    scheduledTime: DateTime.now().add(const Duration(days: 1, hours: 8)),
    pickupLocation: _mockPickup,
    dropoffLocation: _mockDropoff,
    status: TripStatus.scheduled,
    vehicleType: VehicleType.mid,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  TripModel(
    id: 'trip-003',
    userId: 'test-user-001',
    subscriptionId: 'sub-001',
    scheduledTime: DateTime.now().add(const Duration(days: 1, hours: 17)),
    pickupLocation: _mockDropoff,
    dropoffLocation: _mockPickup,
    status: TripStatus.scheduled,
    vehicleType: VehicleType.mid,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
];

final _mockTripHistory = [
  TripModel(
    id: 'trip-h1',
    userId: 'test-user-001',
    subscriptionId: 'sub-001',
    scheduledTime: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
    pickupLocation: _mockPickup,
    dropoffLocation: _mockDropoff,
    status: TripStatus.completed,
    vehicleType: VehicleType.mid,
    driverId: 'driver-002',
    driverName: 'Mohammed Ali',
    vehicleNumber: 'XYZ-5678',
    driverRating: 4.8,
    actualPickupTime: DateTime.now().subtract(const Duration(days: 1, hours: 7, minutes: 45)),
    actualDropoffTime: DateTime.now().subtract(const Duration(days: 1, hours: 7, minutes: 15)),
    rating: 5.0,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    updatedAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  TripModel(
    id: 'trip-h2',
    userId: 'test-user-001',
    subscriptionId: 'sub-001',
    scheduledTime: DateTime.now().subtract(const Duration(days: 2, hours: 8)),
    pickupLocation: _mockPickup,
    dropoffLocation: _mockDropoff,
    status: TripStatus.completed,
    vehicleType: VehicleType.mid,
    driverId: 'driver-001',
    driverName: 'Ahmed Khan',
    vehicleNumber: 'ABC-1234',
    driverRating: 4.9,
    actualPickupTime: DateTime.now().subtract(const Duration(days: 2, hours: 7, minutes: 50)),
    actualDropoffTime: DateTime.now().subtract(const Duration(days: 2, hours: 7, minutes: 20)),
    rating: 4.5,
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    updatedAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  TripModel(
    id: 'trip-h3',
    userId: 'test-user-001',
    subscriptionId: 'sub-001',
    scheduledTime: DateTime.now().subtract(const Duration(days: 3, hours: 17)),
    pickupLocation: _mockDropoff,
    dropoffLocation: _mockPickup,
    status: TripStatus.cancelled,
    vehicleType: VehicleType.mid,
    createdAt: DateTime.now().subtract(const Duration(days: 4)),
    updatedAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
];
