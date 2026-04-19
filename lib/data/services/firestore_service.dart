import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/subscription_model.dart';
import '../models/trip_model.dart';
import '../models/plan_model.dart';
import '../models/user_model.dart';
import '../models/address_model.dart';
import '../../core/constants/app_constants.dart';
import '../../core/enums/enums.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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

  // Upload profile image to Firebase Storage
  Future<String> uploadProfileImage(String userId, File imageFile) async {
    final ref = _storage
        .ref()
        .child(AppConstants.profileImagesPath)
        .child('$userId.jpg');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  // Update saved addresses
  Future<void> updateSavedAddresses(String userId, List<AddressModel> addresses) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .update({
      'savedAddresses': addresses.map((a) => a.toMap()).toList(),
      'updatedAt': Timestamp.now(),
    });
  }

  // ==================== NOTIFICATION OPERATIONS ====================

  // Create notification
  Future<void> createNotification({
    required String userId,
    required String title,
    required String message,
    required String type,
  }) async {
    await _firestore.collection(AppConstants.notificationsCollection).add({
      'userId': userId,
      'title': title,
      'message': message,
      'type': type,
      'isRead': false,
      'createdAt': Timestamp.now(),
    });
  }

  // Get user notifications
  Stream<List<Map<String, dynamic>>> getUserNotifications(String userId) {
    return _firestore
        .collection(AppConstants.notificationsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return data;
            }).toList());
  }

  // Mark notification as read
  Future<void> markNotificationRead(String notificationId) async {
    await _firestore
        .collection(AppConstants.notificationsCollection)
        .doc(notificationId)
        .update({'isRead': true});
  }

  // Mark all notifications as read
  Future<void> markAllNotificationsRead(String userId) async {
    final batch = _firestore.batch();
    final snapshot = await _firestore
        .collection(AppConstants.notificationsCollection)
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();
    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    await _firestore.collection(AppConstants.notificationsCollection).doc(notificationId).delete();
  }

  // ==================== ADMIN OPERATIONS ====================

  // Get all users (admin)
  Stream<List<UserModel>> getAllUsers() {
    return _firestore
        .collection(AppConstants.usersCollection)
        .where('role', isEqualTo: UserRole.user.name)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList());
  }

  // Get all trips (admin)
  Stream<List<TripModel>> getAllTrips({int limit = 50}) {
    return _firestore
        .collection(AppConstants.tripsCollection)
        .orderBy('scheduledTime', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => TripModel.fromFirestore(doc)).toList());
  }

  // Get admin stats
  Future<Map<String, dynamic>> getAdminStats() async {
    final usersCount = await _firestore
        .collection(AppConstants.usersCollection)
        .where('role', isEqualTo: UserRole.user.name)
        .where('isActive', isEqualTo: true)
        .count()
        .get();

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final todayTripsCount = await _firestore
        .collection(AppConstants.tripsCollection)
        .where('scheduledTime',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('scheduledTime',
            isLessThanOrEqualTo: Timestamp.fromDate(now.add(const Duration(days: 1))))
        .count()
        .get();

    final subsCount = await _firestore
        .collection(AppConstants.subscriptionsCollection)
        .where('status', isEqualTo: SubscriptionStatus.active.name)
        .count()
        .get();

    final driversCount = await _firestore
        .collection(AppConstants.usersCollection)
        .where('role', isEqualTo: UserRole.driver.name)
        .where('driverStatus', isEqualTo: DriverStatus.online.name)
        .count()
        .get();

    // Revenue calculation (sum of completed trips this month)
    final startOfMonth = DateTime(now.year, now.month, 1);
    final revenueSnapshot = await _firestore
        .collection(AppConstants.tripsCollection)
        .where('status', isEqualTo: TripStatus.completed.name)
        .where('actualDropoffTime',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
        .get();

    double monthlyRevenue = 0;
    for (final doc in revenueSnapshot.docs) {
      monthlyRevenue += (doc.data()['fare'] as num?)?.toDouble() ?? 0;
    }

    return {
      'activeUsers': usersCount.count ?? 0,
      'todayTrips': todayTripsCount.count ?? 0,
      'activeSubscriptions': subsCount.count ?? 0,
      'activeDrivers': driversCount.count ?? 0,
      'monthlyRevenue': monthlyRevenue,
    };
  }

  // Toggle user active status (admin)
  Future<void> toggleUserActive(String userId, bool isActive) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .update({
      'isActive': isActive,
      'updatedAt': Timestamp.now(),
    });
  }

  // ==================== PROMO CODE OPERATIONS ====================

  // Validate promo code
  Future<Map<String, dynamic>?> validatePromoCode(String code) async {
    final snapshot = await _firestore
        .collection(AppConstants.promoCodesCollection)
        .where('code', isEqualTo: code.toUpperCase())
        .where('isActive', isEqualTo: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    final data = snapshot.docs.first.data();
    data['id'] = snapshot.docs.first.id;

    // Check expiry
    final expiresAt = (data['expiresAt'] as Timestamp?)?.toDate();
    if (expiresAt != null && expiresAt.isBefore(DateTime.now())) return null;

    return data;
  }

  // Get active promo codes
  Future<List<Map<String, dynamic>>> getActivePromoCodes() async {
    final snapshot = await _firestore
        .collection(AppConstants.promoCodesCollection)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  // ==================== PAYMENT OPERATIONS ====================

  // Create payment record
  Future<String> createPayment(Map<String, dynamic> paymentData) async {
    paymentData['createdAt'] = Timestamp.now();
    final docRef = await _firestore
        .collection(AppConstants.paymentsCollection)
        .add(paymentData);
    return docRef.id;
  }

  // Get user payments
  Stream<List<Map<String, dynamic>>> getUserPayments(String userId) {
    return _firestore
        .collection(AppConstants.paymentsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(20)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return data;
            }).toList());
  }

  // ==================== LIVE CHAT OPERATIONS ====================

  // Send chat message
  Future<void> sendChatMessage({
    required String chatId,
    required String senderId,
    required String message,
    required bool isUser,
  }) async {
    await _firestore
        .collection(AppConstants.chatsCollection)
        .doc(chatId)
        .collection('messages')
        .add({
      'senderId': senderId,
      'message': message,
      'isUser': isUser,
      'createdAt': Timestamp.now(),
    });

    // Update chat metadata
    await _firestore.collection(AppConstants.chatsCollection).doc(chatId).set({
      'userId': isUser ? senderId : null,
      'lastMessage': message,
      'lastMessageAt': Timestamp.now(),
      'status': 'active',
    }, SetOptions(merge: true));
  }

  // Get chat messages stream
  Stream<List<Map<String, dynamic>>> getChatMessages(String chatId) {
    return _firestore
        .collection(AppConstants.chatsCollection)
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return data;
            }).toList());
  }

  // ==================== REFERRAL OPERATIONS ====================

  // Get or generate referral code for user
  Future<String> getUserReferralCode(String userId) async {
    final userDoc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .get();

    final data = userDoc.data();
    if (data != null && data['referralCode'] != null) {
      return data['referralCode'] as String;
    }

    // Generate a referral code
    final code = 'DRIVE${userId.substring(0, 6).toUpperCase()}';
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .update({'referralCode': code});
    return code;
  }

  // Get referral stats
  Future<Map<String, dynamic>> getReferralStats(String userId) async {
    final snapshot = await _firestore
        .collection(AppConstants.referralsCollection)
        .where('referrerId', isEqualTo: userId)
        .get();

    int totalReferrals = snapshot.docs.length;
    int completedReferrals = snapshot.docs
        .where((d) => d.data()['status'] == 'completed')
        .length;
    double earnedCredits = completedReferrals * 50.0; // SAR 50 per referral

    return {
      'totalReferrals': totalReferrals,
      'completedReferrals': completedReferrals,
      'earnedCredits': earnedCredits,
      'referrals': snapshot.docs.map((d) {
        final data = d.data();
        data['id'] = d.id;
        return data;
      }).toList(),
    };
  }

  // ==================== PAYMENT METHODS ====================

  // Get saved payment methods
  Future<List<Map<String, dynamic>>> getPaymentMethods(String userId) async {
    final snapshot = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection('paymentMethods')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  // Add payment method
  Future<String> addPaymentMethod(String userId, Map<String, dynamic> method) async {
    method['createdAt'] = Timestamp.now();
    final docRef = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection('paymentMethods')
        .add(method);
    return docRef.id;
  }

  // Delete payment method
  Future<void> deletePaymentMethod(String userId, String methodId) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection('paymentMethods')
        .doc(methodId)
        .delete();
  }

  // Set default payment method
  Future<void> setDefaultPaymentMethod(String userId, String methodId) async {
    final batch = _firestore.batch();

    // Unset all defaults
    final existing = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection('paymentMethods')
        .where('isDefault', isEqualTo: true)
        .get();

    for (final doc in existing.docs) {
      batch.update(doc.reference, {'isDefault': false});
    }

    // Set new default
    batch.update(
      _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection('paymentMethods')
          .doc(methodId),
      {'isDefault': true},
    );

    await batch.commit();
  }

  // Create or get chat for user
  Future<String> getOrCreateChat(String userId) async {
    final existing = await _firestore
        .collection(AppConstants.chatsCollection)
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'active')
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) return existing.docs.first.id;

    final docRef = await _firestore.collection(AppConstants.chatsCollection).add({
      'userId': userId,
      'status': 'active',
      'createdAt': Timestamp.now(),
      'lastMessageAt': Timestamp.now(),
    });
    return docRef.id;
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

  // ==================== DRIVER OPERATIONS ====================

  // Register as driver
  Future<void> registerAsDriver(String userId, Map<String, dynamic> driverData) async {
    driverData['role'] = UserRole.driver.name;
    driverData['driverStatus'] = DriverStatus.offline.name;
    driverData['driverRating'] = 5.0;
    driverData['totalTrips'] = 0;
    driverData['updatedAt'] = Timestamp.now();

    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .update(driverData);
  }

  // Update driver status (online/offline/busy)
  Future<void> updateDriverStatus(String driverId, DriverStatus status) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(driverId)
        .update({
      'driverStatus': status.name,
      'updatedAt': Timestamp.now(),
    });
  }

  // Get driver's assigned trips
  Stream<List<TripModel>> getDriverAssignedTrips(String driverId) {
    return _firestore
        .collection(AppConstants.tripsCollection)
        .where('driverId', isEqualTo: driverId)
        .where('status', whereIn: [
          TripStatus.driverAssigned.name,
          TripStatus.driverArriving.name,
          TripStatus.scheduled.name,
        ])
        .orderBy('scheduledTime')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => TripModel.fromFirestore(doc)).toList());
  }

  // Get driver's in-progress trip
  Stream<TripModel?> getDriverActiveTrip(String driverId) {
    return _firestore
        .collection(AppConstants.tripsCollection)
        .where('driverId', isEqualTo: driverId)
        .where('status', isEqualTo: TripStatus.inProgress.name)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      return TripModel.fromFirestore(snapshot.docs.first);
    });
  }

  // Get driver's today trips
  Stream<List<TripModel>> getDriverTodayTrips(String driverId) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return _firestore
        .collection(AppConstants.tripsCollection)
        .where('driverId', isEqualTo: driverId)
        .where('scheduledTime',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('scheduledTime',
            isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .orderBy('scheduledTime')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => TripModel.fromFirestore(doc)).toList());
  }

  // Get driver's completed trips (history)
  Stream<List<TripModel>> getDriverTripHistory(String driverId, {int limit = 50}) {
    return _firestore
        .collection(AppConstants.tripsCollection)
        .where('driverId', isEqualTo: driverId)
        .where('status', isEqualTo: TripStatus.completed.name)
        .orderBy('scheduledTime', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => TripModel.fromFirestore(doc)).toList());
  }

  // Accept trip as driver
  Future<void> acceptTrip(String tripId, String driverId) async {
    await _firestore
        .collection(AppConstants.tripsCollection)
        .doc(tripId)
        .update({
      'driverId': driverId,
      'status': TripStatus.driverAssigned.name,
      'updatedAt': Timestamp.now(),
    });
  }

  // Decline trip as driver
  Future<void> declineTrip(String tripId) async {
    await _firestore
        .collection(AppConstants.tripsCollection)
        .doc(tripId)
        .update({
      'driverId': null,
      'status': TripStatus.scheduled.name,
      'updatedAt': Timestamp.now(),
    });
  }

  // Start trip (driver arriving)
  Future<void> startDriverArriving(String tripId) async {
    await _firestore
        .collection(AppConstants.tripsCollection)
        .doc(tripId)
        .update({
      'status': TripStatus.driverArriving.name,
      'updatedAt': Timestamp.now(),
    });
  }

  // Start trip (picked up passenger)
  Future<void> startTrip(String tripId) async {
    await _firestore
        .collection(AppConstants.tripsCollection)
        .doc(tripId)
        .update({
      'status': TripStatus.inProgress.name,
      'actualPickupTime': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    });
  }

  // Complete trip
  Future<void> completeTrip(String tripId, {double? fare, double? distanceKm}) async {
    final updates = <String, dynamic>{
      'status': TripStatus.completed.name,
      'actualDropoffTime': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    };

    if (fare != null) updates['fare'] = fare;
    if (distanceKm != null) updates['distanceKm'] = distanceKm;

    await _firestore
        .collection(AppConstants.tripsCollection)
        .doc(tripId)
        .update(updates);
  }

  // Update driver location
  Future<void> updateDriverLocation(String driverId, double latitude, double longitude) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(driverId)
        .update({
      'currentLatitude': latitude,
      'currentLongitude': longitude,
      'locationUpdatedAt': Timestamp.now(),
    });
  }

  // Get driver earnings for a period
  Future<Map<String, dynamic>> getDriverEarnings(
    String driverId, {
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final snapshot = await _firestore
        .collection(AppConstants.tripsCollection)
        .where('driverId', isEqualTo: driverId)
        .where('status', isEqualTo: TripStatus.completed.name)
        .where('actualDropoffTime',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('actualDropoffTime',
            isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();

    double totalEarnings = 0;
    int tripCount = 0;
    double totalDistance = 0;

    for (final doc in snapshot.docs) {
      final data = doc.data();
      totalEarnings += (data['fare'] as num?)?.toDouble() ?? 0;
      totalDistance += (data['distanceKm'] as num?)?.toDouble() ?? 0;
      tripCount++;
    }

    return {
      'totalEarnings': totalEarnings,
      'tripCount': tripCount,
      'totalDistance': totalDistance,
      'averagePerTrip': tripCount > 0 ? totalEarnings / tripCount : 0,
    };
  }

  // Get driver stats
  Future<Map<String, dynamic>> getDriverStats(String driverId) async {
    // Get total completed trips
    final completedSnapshot = await _firestore
        .collection(AppConstants.tripsCollection)
        .where('driverId', isEqualTo: driverId)
        .where('status', isEqualTo: TripStatus.completed.name)
        .count()
        .get();

    // Get total assigned trips (to calculate acceptance rate)
    final assignedSnapshot = await _firestore
        .collection(AppConstants.tripsCollection)
        .where('driverId', isEqualTo: driverId)
        .count()
        .get();

    // Get average rating from completed trips
    final ratingSnapshot = await _firestore
        .collection(AppConstants.tripsCollection)
        .where('driverId', isEqualTo: driverId)
        .where('status', isEqualTo: TripStatus.completed.name)
        .where('rating', isGreaterThan: 0)
        .get();

    double totalRating = 0;
    int ratingCount = 0;
    for (final doc in ratingSnapshot.docs) {
      final rating = (doc.data()['rating'] as num?)?.toDouble();
      if (rating != null && rating > 0) {
        totalRating += rating;
        ratingCount++;
      }
    }

    final completedCount = completedSnapshot.count ?? 0;
    final totalAssigned = assignedSnapshot.count ?? 0;

    return {
      'totalTrips': completedCount,
      'averageRating': ratingCount > 0 ? totalRating / ratingCount : 5.0,
      'acceptanceRate': totalAssigned > 0 ? (completedCount / totalAssigned) * 100 : 100.0,
    };
  }

  // Get all available drivers (for admin/trip assignment)
  Stream<List<UserModel>> getAvailableDrivers() {
    return _firestore
        .collection(AppConstants.usersCollection)
        .where('role', isEqualTo: UserRole.driver.name)
        .where('driverStatus', isEqualTo: DriverStatus.online.name)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList());
  }

  // Get all drivers (for admin)
  Stream<List<UserModel>> getAllDrivers() {
    return _firestore
        .collection(AppConstants.usersCollection)
        .where('role', isEqualTo: UserRole.driver.name)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList());
  }

  // Assign driver to trip (admin function)
  Future<void> assignDriverToTrip(String tripId, String driverId, String driverName,
      String vehicleNumber, String vehicleModel, String? vehicleColor) async {
    await _firestore
        .collection(AppConstants.tripsCollection)
        .doc(tripId)
        .update({
      'driverId': driverId,
      'driverName': driverName,
      'vehicleNumber': vehicleNumber,
      'vehicleModel': vehicleModel,
      'vehicleColor': vehicleColor,
      'status': TripStatus.driverAssigned.name,
      'updatedAt': Timestamp.now(),
    });
  }
}
