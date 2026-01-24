import 'package:flutter/material.dart';
import '../../core/enums/enums.dart';
import 'address_model.dart';

class ScheduleModel {
  final List<DayOfWeek> activeDays;
  final TimeOfDay pickupTime;
  final TimeOfDay? returnPickupTime;
  final AddressModel pickupLocation;
  final AddressModel dropoffLocation;
  final List<DateTime> excludedDates;

  ScheduleModel({
    required this.activeDays,
    required this.pickupTime,
    this.returnPickupTime,
    required this.pickupLocation,
    required this.dropoffLocation,
    this.excludedDates = const [],
  });

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
      activeDays: (map['activeDays'] as List<dynamic>?)
              ?.map((e) => DayOfWeek.values.firstWhere(
                    (d) => d.name == e,
                    orElse: () => DayOfWeek.monday,
                  ))
              .toList() ??
          [],
      pickupTime: TimeOfDay(
        hour: map['pickupTimeHour'] ?? 8,
        minute: map['pickupTimeMinute'] ?? 0,
      ),
      returnPickupTime: map['returnPickupTimeHour'] != null
          ? TimeOfDay(
              hour: map['returnPickupTimeHour'],
              minute: map['returnPickupTimeMinute'] ?? 0,
            )
          : null,
      pickupLocation:
          AddressModel.fromMap(map['pickupLocation'] as Map<String, dynamic>),
      dropoffLocation:
          AddressModel.fromMap(map['dropoffLocation'] as Map<String, dynamic>),
      excludedDates: (map['excludedDates'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'activeDays': activeDays.map((e) => e.name).toList(),
      'pickupTimeHour': pickupTime.hour,
      'pickupTimeMinute': pickupTime.minute,
      'returnPickupTimeHour': returnPickupTime?.hour,
      'returnPickupTimeMinute': returnPickupTime?.minute,
      'pickupLocation': pickupLocation.toMap(),
      'dropoffLocation': dropoffLocation.toMap(),
      'excludedDates': excludedDates.map((e) => e.toIso8601String()).toList(),
    };
  }

  String get formattedPickupTime {
    final hour = pickupTime.hour;
    final minute = pickupTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  String get formattedReturnTime {
    if (returnPickupTime == null) return 'Not set';
    final hour = returnPickupTime!.hour;
    final minute = returnPickupTime!.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  String get formattedActiveDays {
    if (activeDays.length == 7) return 'Every day';
    if (activeDays.length == 5 &&
        !activeDays.contains(DayOfWeek.saturday) &&
        !activeDays.contains(DayOfWeek.sunday)) {
      return 'Weekdays';
    }
    if (activeDays.length == 2 &&
        activeDays.contains(DayOfWeek.saturday) &&
        activeDays.contains(DayOfWeek.sunday)) {
      return 'Weekends';
    }
    return activeDays.map((e) => e.shortName).join(', ');
  }

  bool isActiveOnDate(DateTime date) {
    // Check if date is excluded
    for (final excluded in excludedDates) {
      if (excluded.year == date.year &&
          excluded.month == date.month &&
          excluded.day == date.day) {
        return false;
      }
    }

    // Check if day of week is active
    final dayOfWeek = DayOfWeek.values.firstWhere(
      (d) => d.dayNumber == date.weekday,
    );
    return activeDays.contains(dayOfWeek);
  }

  ScheduleModel copyWith({
    List<DayOfWeek>? activeDays,
    TimeOfDay? pickupTime,
    TimeOfDay? returnPickupTime,
    AddressModel? pickupLocation,
    AddressModel? dropoffLocation,
    List<DateTime>? excludedDates,
  }) {
    return ScheduleModel(
      activeDays: activeDays ?? this.activeDays,
      pickupTime: pickupTime ?? this.pickupTime,
      returnPickupTime: returnPickupTime ?? this.returnPickupTime,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropoffLocation: dropoffLocation ?? this.dropoffLocation,
      excludedDates: excludedDates ?? this.excludedDates,
    );
  }
}
