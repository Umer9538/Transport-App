import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/enums/enums.dart';
import 'address_model.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImageUrl;
  final String? emergencyContact;
  final String? emergencyContactName;
  final List<AddressModel> savedAddresses;
  final DriverGender preferredDriverGender;
  final VehicleType preferredVehicleType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isVerified;
  final bool isActive;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImageUrl,
    this.emergencyContact,
    this.emergencyContactName,
    this.savedAddresses = const [],
    this.preferredDriverGender = DriverGender.noPreference,
    this.preferredVehicleType = VehicleType.mid,
    required this.createdAt,
    required this.updatedAt,
    this.isVerified = false,
    this.isActive = true,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      emergencyContact: data['emergencyContact'],
      emergencyContactName: data['emergencyContactName'],
      savedAddresses: (data['savedAddresses'] as List<dynamic>?)
              ?.map((e) => AddressModel.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      preferredDriverGender: DriverGender.values.firstWhere(
        (e) => e.name == data['preferredDriverGender'],
        orElse: () => DriverGender.noPreference,
      ),
      preferredVehicleType: VehicleType.values.firstWhere(
        (e) => e.name == data['preferredVehicleType'],
        orElse: () => VehicleType.mid,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      isVerified: data['isVerified'] ?? false,
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'emergencyContact': emergencyContact,
      'emergencyContactName': emergencyContactName,
      'savedAddresses': savedAddresses.map((e) => e.toMap()).toList(),
      'preferredDriverGender': preferredDriverGender.name,
      'preferredVehicleType': preferredVehicleType.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isVerified': isVerified,
      'isActive': isActive,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImageUrl,
    String? emergencyContact,
    String? emergencyContactName,
    List<AddressModel>? savedAddresses,
    DriverGender? preferredDriverGender,
    VehicleType? preferredVehicleType,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isVerified,
    bool? isActive,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      savedAddresses: savedAddresses ?? this.savedAddresses,
      preferredDriverGender: preferredDriverGender ?? this.preferredDriverGender,
      preferredVehicleType: preferredVehicleType ?? this.preferredVehicleType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
    );
  }
}
