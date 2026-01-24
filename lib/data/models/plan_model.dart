import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/enums/enums.dart';

class PlanModel {
  final String id;
  final String name;
  final String description;
  final PlanType type;
  final int durationDays;
  final int tripsPerDay;
  final double basePrice;
  final List<String> features;
  final bool isPopular;
  final bool isActive;
  final int sortOrder;

  PlanModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.durationDays,
    required this.tripsPerDay,
    required this.basePrice,
    required this.features,
    this.isPopular = false,
    this.isActive = true,
    this.sortOrder = 0,
  });

  factory PlanModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PlanModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      type: PlanType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => PlanType.monthly,
      ),
      durationDays: data['durationDays'] ?? 30,
      tripsPerDay: data['tripsPerDay'] ?? 2,
      basePrice: (data['basePrice'] ?? 0.0).toDouble(),
      features: List<String>.from(data['features'] ?? []),
      isPopular: data['isPopular'] ?? false,
      isActive: data['isActive'] ?? true,
      sortOrder: data['sortOrder'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'type': type.name,
      'durationDays': durationDays,
      'tripsPerDay': tripsPerDay,
      'basePrice': basePrice,
      'features': features,
      'isPopular': isPopular,
      'isActive': isActive,
      'sortOrder': sortOrder,
    };
  }

  int get totalTrips => (durationDays * tripsPerDay * 5 / 7).round();

  double getPriceForVehicle(VehicleType vehicleType) {
    return basePrice * vehicleType.priceMultiplier;
  }

  String get formattedBasePrice => '\$${basePrice.toStringAsFixed(0)}';

  String get formattedDuration {
    if (durationDays == 7) return '1 Week';
    if (durationDays == 30 || durationDays == 31) return '1 Month';
    if (durationDays == 90 || durationDays == 91) return '3 Months';
    return '$durationDays Days';
  }

  PlanModel copyWith({
    String? id,
    String? name,
    String? description,
    PlanType? type,
    int? durationDays,
    int? tripsPerDay,
    double? basePrice,
    List<String>? features,
    bool? isPopular,
    bool? isActive,
    int? sortOrder,
  }) {
    return PlanModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      durationDays: durationDays ?? this.durationDays,
      tripsPerDay: tripsPerDay ?? this.tripsPerDay,
      basePrice: basePrice ?? this.basePrice,
      features: features ?? this.features,
      isPopular: isPopular ?? this.isPopular,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
