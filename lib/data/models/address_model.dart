import '../../core/enums/enums.dart';

class AddressModel {
  final String id;
  final String title;
  final AddressType type;
  final String address;
  final String? buildingName;
  final String? floor;
  final String? apartment;
  final String? landmark;
  final double latitude;
  final double longitude;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.title,
    required this.type,
    required this.address,
    this.buildingName,
    this.floor,
    this.apartment,
    this.landmark,
    required this.latitude,
    required this.longitude,
    this.isDefault = false,
  });

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      type: AddressType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => AddressType.other,
      ),
      address: map['address'] ?? '',
      buildingName: map['buildingName'],
      floor: map['floor'],
      apartment: map['apartment'],
      landmark: map['landmark'],
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      isDefault: map['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type.name,
      'address': address,
      'buildingName': buildingName,
      'floor': floor,
      'apartment': apartment,
      'landmark': landmark,
      'latitude': latitude,
      'longitude': longitude,
      'isDefault': isDefault,
    };
  }

  AddressModel copyWith({
    String? id,
    String? title,
    AddressType? type,
    String? address,
    String? buildingName,
    String? floor,
    String? apartment,
    String? landmark,
    double? latitude,
    double? longitude,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      address: address ?? this.address,
      buildingName: buildingName ?? this.buildingName,
      floor: floor ?? this.floor,
      apartment: apartment ?? this.apartment,
      landmark: landmark ?? this.landmark,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  String get fullAddress {
    final parts = <String>[];
    if (buildingName != null && buildingName!.isNotEmpty) {
      parts.add(buildingName!);
    }
    if (floor != null && floor!.isNotEmpty) {
      parts.add('Floor $floor');
    }
    if (apartment != null && apartment!.isNotEmpty) {
      parts.add('Apt $apartment');
    }
    parts.add(address);
    if (landmark != null && landmark!.isNotEmpty) {
      parts.add('Near $landmark');
    }
    return parts.join(', ');
  }
}
