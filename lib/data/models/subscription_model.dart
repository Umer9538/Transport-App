import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/enums/enums.dart';
import 'schedule_model.dart';

class SubscriptionModel {
  final String id;
  final String userId;
  final String planId;
  final String planName;
  final PlanType planType;
  final VehicleType vehicleType;
  final DriverGender driverGender;
  final SubscriptionStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final ScheduleModel schedule;
  final int totalTrips;
  final int usedTrips;
  final double basePrice;
  final double finalPrice;
  final String? promoCode;
  final double discount;
  final DateTime createdAt;
  final DateTime? pausedAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;

  SubscriptionModel({
    required this.id,
    required this.userId,
    required this.planId,
    required this.planName,
    required this.planType,
    required this.vehicleType,
    required this.driverGender,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.schedule,
    required this.totalTrips,
    this.usedTrips = 0,
    required this.basePrice,
    required this.finalPrice,
    this.promoCode,
    this.discount = 0,
    required this.createdAt,
    this.pausedAt,
    this.cancelledAt,
    this.cancellationReason,
  });

  factory SubscriptionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SubscriptionModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      planId: data['planId'] ?? '',
      planName: data['planName'] ?? '',
      planType: PlanType.values.firstWhere(
        (e) => e.name == data['planType'],
        orElse: () => PlanType.monthly,
      ),
      vehicleType: VehicleType.values.firstWhere(
        (e) => e.name == data['vehicleType'],
        orElse: () => VehicleType.mid,
      ),
      driverGender: DriverGender.values.firstWhere(
        (e) => e.name == data['driverGender'],
        orElse: () => DriverGender.noPreference,
      ),
      status: SubscriptionStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => SubscriptionStatus.pending,
      ),
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      schedule: ScheduleModel.fromMap(data['schedule'] as Map<String, dynamic>),
      totalTrips: data['totalTrips'] ?? 0,
      usedTrips: data['usedTrips'] ?? 0,
      basePrice: (data['basePrice'] ?? 0.0).toDouble(),
      finalPrice: (data['finalPrice'] ?? 0.0).toDouble(),
      promoCode: data['promoCode'],
      discount: (data['discount'] ?? 0.0).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      pausedAt: data['pausedAt'] != null
          ? (data['pausedAt'] as Timestamp).toDate()
          : null,
      cancelledAt: data['cancelledAt'] != null
          ? (data['cancelledAt'] as Timestamp).toDate()
          : null,
      cancellationReason: data['cancellationReason'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'planId': planId,
      'planName': planName,
      'planType': planType.name,
      'vehicleType': vehicleType.name,
      'driverGender': driverGender.name,
      'status': status.name,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'schedule': schedule.toMap(),
      'totalTrips': totalTrips,
      'usedTrips': usedTrips,
      'basePrice': basePrice,
      'finalPrice': finalPrice,
      'promoCode': promoCode,
      'discount': discount,
      'createdAt': Timestamp.fromDate(createdAt),
      'pausedAt': pausedAt != null ? Timestamp.fromDate(pausedAt!) : null,
      'cancelledAt': cancelledAt != null ? Timestamp.fromDate(cancelledAt!) : null,
      'cancellationReason': cancellationReason,
    };
  }

  int get remainingTrips => totalTrips - usedTrips;

  double get usagePercentage =>
      totalTrips > 0 ? (usedTrips / totalTrips) * 100 : 0;

  bool get isActive => status == SubscriptionStatus.active;

  int get daysRemaining => endDate.difference(DateTime.now()).inDays;

  SubscriptionModel copyWith({
    String? id,
    String? userId,
    String? planId,
    String? planName,
    PlanType? planType,
    VehicleType? vehicleType,
    DriverGender? driverGender,
    SubscriptionStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    ScheduleModel? schedule,
    int? totalTrips,
    int? usedTrips,
    double? basePrice,
    double? finalPrice,
    String? promoCode,
    double? discount,
    DateTime? createdAt,
    DateTime? pausedAt,
    DateTime? cancelledAt,
    String? cancellationReason,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      planId: planId ?? this.planId,
      planName: planName ?? this.planName,
      planType: planType ?? this.planType,
      vehicleType: vehicleType ?? this.vehicleType,
      driverGender: driverGender ?? this.driverGender,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      schedule: schedule ?? this.schedule,
      totalTrips: totalTrips ?? this.totalTrips,
      usedTrips: usedTrips ?? this.usedTrips,
      basePrice: basePrice ?? this.basePrice,
      finalPrice: finalPrice ?? this.finalPrice,
      promoCode: promoCode ?? this.promoCode,
      discount: discount ?? this.discount,
      createdAt: createdAt ?? this.createdAt,
      pausedAt: pausedAt ?? this.pausedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
    );
  }
}
