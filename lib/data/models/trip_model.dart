import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/enums/enums.dart';
import 'address_model.dart';

class TripModel {
  final String id;
  final String subscriptionId;
  final String userId;
  final String? driverId;
  final String? driverName;
  final String? driverPhone;
  final String? driverPhotoUrl;
  final double? driverRating;
  final String? vehicleNumber;
  final String? vehicleModel;
  final String? vehicleColor;
  final VehicleType vehicleType;
  final AddressModel pickupLocation;
  final AddressModel dropoffLocation;
  final DateTime scheduledTime;
  final DateTime? actualPickupTime;
  final DateTime? actualDropoffTime;
  final TripStatus status;
  final double? rating;
  final String? feedback;
  final double? driverLatitude;
  final double? driverLongitude;
  final int? estimatedMinutes;
  final double? distanceKm;
  final double? fare;
  final DateTime createdAt;
  final DateTime updatedAt;

  TripModel({
    required this.id,
    required this.subscriptionId,
    required this.userId,
    this.driverId,
    this.driverName,
    this.driverPhone,
    this.driverPhotoUrl,
    this.driverRating,
    this.vehicleNumber,
    this.vehicleModel,
    this.vehicleColor,
    required this.vehicleType,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.scheduledTime,
    this.actualPickupTime,
    this.actualDropoffTime,
    required this.status,
    this.rating,
    this.feedback,
    this.driverLatitude,
    this.driverLongitude,
    this.estimatedMinutes,
    this.distanceKm,
    this.fare,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TripModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TripModel(
      id: doc.id,
      subscriptionId: data['subscriptionId'] ?? '',
      userId: data['userId'] ?? '',
      driverId: data['driverId'],
      driverName: data['driverName'],
      driverPhone: data['driverPhone'],
      driverPhotoUrl: data['driverPhotoUrl'],
      driverRating: (data['driverRating'] as num?)?.toDouble(),
      vehicleNumber: data['vehicleNumber'],
      vehicleModel: data['vehicleModel'],
      vehicleColor: data['vehicleColor'],
      vehicleType: VehicleType.values.firstWhere(
        (e) => e.name == data['vehicleType'],
        orElse: () => VehicleType.mid,
      ),
      pickupLocation:
          AddressModel.fromMap(data['pickupLocation'] as Map<String, dynamic>),
      dropoffLocation:
          AddressModel.fromMap(data['dropoffLocation'] as Map<String, dynamic>),
      scheduledTime: (data['scheduledTime'] as Timestamp).toDate(),
      actualPickupTime: data['actualPickupTime'] != null
          ? (data['actualPickupTime'] as Timestamp).toDate()
          : null,
      actualDropoffTime: data['actualDropoffTime'] != null
          ? (data['actualDropoffTime'] as Timestamp).toDate()
          : null,
      status: TripStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => TripStatus.scheduled,
      ),
      rating: (data['rating'] as num?)?.toDouble(),
      feedback: data['feedback'],
      driverLatitude: (data['driverLatitude'] as num?)?.toDouble(),
      driverLongitude: (data['driverLongitude'] as num?)?.toDouble(),
      estimatedMinutes: data['estimatedMinutes'],
      distanceKm: (data['distanceKm'] as num?)?.toDouble(),
      fare: (data['fare'] as num?)?.toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'subscriptionId': subscriptionId,
      'userId': userId,
      'driverId': driverId,
      'driverName': driverName,
      'driverPhone': driverPhone,
      'driverPhotoUrl': driverPhotoUrl,
      'driverRating': driverRating,
      'vehicleNumber': vehicleNumber,
      'vehicleModel': vehicleModel,
      'vehicleColor': vehicleColor,
      'vehicleType': vehicleType.name,
      'pickupLocation': pickupLocation.toMap(),
      'dropoffLocation': dropoffLocation.toMap(),
      'scheduledTime': Timestamp.fromDate(scheduledTime),
      'actualPickupTime': actualPickupTime != null
          ? Timestamp.fromDate(actualPickupTime!)
          : null,
      'actualDropoffTime': actualDropoffTime != null
          ? Timestamp.fromDate(actualDropoffTime!)
          : null,
      'status': status.name,
      'rating': rating,
      'feedback': feedback,
      'driverLatitude': driverLatitude,
      'driverLongitude': driverLongitude,
      'estimatedMinutes': estimatedMinutes,
      'distanceKm': distanceKm,
      'fare': fare,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  bool get isUpcoming =>
      status == TripStatus.scheduled || status == TripStatus.driverAssigned;

  bool get isOngoing =>
      status == TripStatus.driverArriving || status == TripStatus.inProgress;

  bool get isCompleted => status == TripStatus.completed;

  bool get isCancelled =>
      status == TripStatus.cancelled || status == TripStatus.noShow;

  bool get hasDriver => driverId != null && driverId!.isNotEmpty;

  String get pickupAddress => pickupLocation.address;

  String get dropoffAddress => dropoffLocation.address;

  int get durationMinutes => estimatedMinutes ?? 0;

  String get formattedScheduledTime {
    final hour = scheduledTime.hour;
    final minute = scheduledTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  String get formattedScheduledDate {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[scheduledTime.month - 1]} ${scheduledTime.day}, ${scheduledTime.year}';
  }

  TripModel copyWith({
    String? id,
    String? subscriptionId,
    String? userId,
    String? driverId,
    String? driverName,
    String? driverPhone,
    String? driverPhotoUrl,
    double? driverRating,
    String? vehicleNumber,
    String? vehicleModel,
    String? vehicleColor,
    VehicleType? vehicleType,
    AddressModel? pickupLocation,
    AddressModel? dropoffLocation,
    DateTime? scheduledTime,
    DateTime? actualPickupTime,
    DateTime? actualDropoffTime,
    TripStatus? status,
    double? rating,
    String? feedback,
    double? driverLatitude,
    double? driverLongitude,
    int? estimatedMinutes,
    double? distanceKm,
    double? fare,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TripModel(
      id: id ?? this.id,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      userId: userId ?? this.userId,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      driverPhotoUrl: driverPhotoUrl ?? this.driverPhotoUrl,
      driverRating: driverRating ?? this.driverRating,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehicleColor: vehicleColor ?? this.vehicleColor,
      vehicleType: vehicleType ?? this.vehicleType,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropoffLocation: dropoffLocation ?? this.dropoffLocation,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      actualPickupTime: actualPickupTime ?? this.actualPickupTime,
      actualDropoffTime: actualDropoffTime ?? this.actualDropoffTime,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      feedback: feedback ?? this.feedback,
      driverLatitude: driverLatitude ?? this.driverLatitude,
      driverLongitude: driverLongitude ?? this.driverLongitude,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      distanceKm: distanceKm ?? this.distanceKm,
      fare: fare ?? this.fare,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
