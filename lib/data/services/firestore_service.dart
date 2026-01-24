import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/subscription_model.dart';
import '../models/trip_model.dart';
import '../models/plan_model.dart';
import '../models/user_model.dart';
import '../../core/constants/app_constants.dart';
import '../../core/enums/enums.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== USER OPERATIONS ====================

  // Get user stream
  Stream<UserModel?> getUserStream(String userId) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromFirestore(doc) : null);
  }

  // Update user
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    data['updatedAt'] = Timestamp.now();
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .update(data);
  }

  // ==================== PLAN OPERATIONS ====================

  // Get all active plans
  Future<List<PlanModel>> getActivePlans() async {
    final snapshot = await _firestore
        .collection(AppConstants.plansCollection)
        .where('isActive', isEqualTo: true)
        .orderBy('sortOrder')
        .get();

    return snapshot.docs.map((doc) => PlanModel.fromFirestore(doc)).toList();
  }

  // Get plan by ID
  Future<PlanModel?> getPlan(String planId) async {
    final doc = await _firestore
        .collection(AppConstants.plansCollection)
        .doc(planId)
        .get();

    return doc.exists ? PlanModel.fromFirestore(doc) : null;
  }

  // ==================== SUBSCRIPTION OPERATIONS ====================

  // Create subscription
  Future<String> createSubscription(SubscriptionModel subscription) async {
    final docRef = await _firestore
        .collection(AppConstants.subscriptionsCollection)
        .add(subscription.toFirestore());
    return docRef.id;
  }

  // Get user's active subscription
  Future<SubscriptionModel?> getActiveSubscription(String userId) async {
    final snapshot = await _firestore
        .collection(AppConstants.subscriptionsCollection)
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: SubscriptionStatus.active.name)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return SubscriptionModel.fromFirestore(snapshot.docs.first);
  }

  // Get user's active subscription stream
  Stream<SubscriptionModel?> getActiveSubscriptionStream(String userId) {
    return _firestore
        .collection(AppConstants.subscriptionsCollection)
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: SubscriptionStatus.active.name)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      return SubscriptionModel.fromFirestore(snapshot.docs.first);
    });
  }

  // Get all user subscriptions
  Stream<List<SubscriptionModel>> getUserSubscriptions(String userId) {
    return _firestore
        .collection(AppConstants.subscriptionsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SubscriptionModel.fromFirestore(doc))
            .toList());
  }

  // Update subscription
  Future<void> updateSubscription(
      String subscriptionId, Map<String, dynamic> data) async {
    await _firestore
        .collection(AppConstants.subscriptionsCollection)
        .doc(subscriptionId)
        .update(data);
  }

  // Pause subscription
  Future<void> pauseSubscription(String subscriptionId) async {
    await _firestore
        .collection(AppConstants.subscriptionsCollection)
        .doc(subscriptionId)
        .update({
      'status': SubscriptionStatus.paused.name,
      'pausedAt': Timestamp.now(),
    });
  }

  // Resume subscription
  Future<void> resumeSubscription(String subscriptionId) async {
    await _firestore
        .collection(AppConstants.subscriptionsCollection)
        .doc(subscriptionId)
        .update({
      'status': SubscriptionStatus.active.name,
      'pausedAt': null,
    });
  }

  // Cancel subscription
  Future<void> cancelSubscription(
      String subscriptionId, String? reason) async {
    await _firestore
        .collection(AppConstants.subscriptionsCollection)
        .doc(subscriptionId)
        .update({
      'status': SubscriptionStatus.cancelled.name,
      'cancelledAt': Timestamp.now(),
      'cancellationReason': reason,
    });
  }

  // ==================== TRIP OPERATIONS ====================

  // Create trip
  Future<String> createTrip(TripModel trip) async {
    final docRef = await _firestore
        .collection(AppConstants.tripsCollection)
        .add(trip.toFirestore());
    return docRef.id;
  }

  // Get upcoming trips
  Stream<List<TripModel>> getUpcomingTrips(String userId) {
    final now = DateTime.now();
    return _firestore
        .collection(AppConstants.tripsCollection)
        .where('userId', isEqualTo: userId)
        .where('scheduledTime', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
        .where('status', whereIn: [
          TripStatus.scheduled.name,
          TripStatus.driverAssigned.name,
          TripStatus.driverArriving.name,
          TripStatus.inProgress.name,
        ])
        .orderBy('scheduledTime')
        .limit(10)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => TripModel.fromFirestore(doc)).toList());
  }

  // Get next trip
  Future<TripModel?> getNextTrip(String userId) async {
    final now = DateTime.now();
    final snapshot = await _firestore
        .collection(AppConstants.tripsCollection)
        .where('userId', isEqualTo: userId)
        .where('scheduledTime', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
        .where('status', whereIn: [
          TripStatus.scheduled.name,
          TripStatus.driverAssigned.name,
          TripStatus.driverArriving.name,
        ])
        .orderBy('scheduledTime')
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return TripModel.fromFirestore(snapshot.docs.first);
  }

  // Get trip history
  Stream<List<TripModel>> getTripHistory(String userId, {int limit = 20}) {
    return _firestore
        .collection(AppConstants.tripsCollection)
        .where('userId', isEqualTo: userId)
        .where('status', whereIn: [
          TripStatus.completed.name,
          TripStatus.cancelled.name,
          TripStatus.noShow.name,
        ])
        .orderBy('scheduledTime', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => TripModel.fromFirestore(doc)).toList());
  }

  // Get trip by ID stream (for real-time tracking)
  Stream<TripModel?> getTripStream(String tripId) {
    return _firestore
        .collection(AppConstants.tripsCollection)
        .doc(tripId)
        .snapshots()
        .map((doc) => doc.exists ? TripModel.fromFirestore(doc) : null);
  }

  // Update trip
  Future<void> updateTrip(String tripId, Map<String, dynamic> data) async {
    data['updatedAt'] = Timestamp.now();
    await _firestore
        .collection(AppConstants.tripsCollection)
        .doc(tripId)
        .update(data);
  }

  // Cancel trip
  Future<void> cancelTrip(String tripId) async {
    await _firestore
        .collection(AppConstants.tripsCollection)
        .doc(tripId)
        .update({
      'status': TripStatus.cancelled.name,
      'updatedAt': Timestamp.now(),
    });
  }

  // Rate trip
  Future<void> rateTrip(String tripId, double rating, String? feedback) async {
    await _firestore
        .collection(AppConstants.tripsCollection)
        .doc(tripId)
        .update({
      'rating': rating,
      'feedback': feedback,
      'updatedAt': Timestamp.now(),
    });
  }

  // Get today's trips
  Future<List<TripModel>> getTodayTrips(String userId) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final snapshot = await _firestore
        .collection(AppConstants.tripsCollection)
        .where('userId', isEqualTo: userId)
        .where('scheduledTime',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('scheduledTime',
            isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .orderBy('scheduledTime')
        .get();

    return snapshot.docs.map((doc) => TripModel.fromFirestore(doc)).toList();
  }
}
