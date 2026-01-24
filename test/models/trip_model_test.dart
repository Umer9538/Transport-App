import 'package:flutter_test/flutter_test.dart';
import 'package:driverapp/data/models/trip_model.dart';
import 'package:driverapp/data/models/address_model.dart';
import 'package:driverapp/core/enums/enums.dart';

void main() {
  late TripModel completedTrip;
  late TripModel scheduledTrip;
  late TripModel cancelledTrip;

  setUp(() {
    final pickup = AddressModel(
      id: 'addr-1',
      title: 'Home',
      type: AddressType.home,
      address: '123 Main St, Riyadh',
      latitude: 24.7136,
      longitude: 46.6753,
    );
    final dropoff = AddressModel(
      id: 'addr-2',
      title: 'Work',
      type: AddressType.work,
      address: '456 Office Ave, Riyadh',
      latitude: 24.7236,
      longitude: 46.6853,
    );

    completedTrip = TripModel(
      id: 'trip-001',
      subscriptionId: 'sub-001',
      userId: 'user-001',
      pickupLocation: pickup,
      dropoffLocation: dropoff,
      scheduledTime: DateTime(2026, 1, 15, 8, 30),
      status: TripStatus.completed,
      vehicleType: VehicleType.mid,
      driverId: 'driver-001',
      driverName: 'Ahmed',
      driverRating: 4.9,
      fare: 55.0,
      distanceKm: 12.5,
      estimatedMinutes: 25,
      rating: 5.0,
      createdAt: DateTime(2026, 1, 14),
      updatedAt: DateTime(2026, 1, 15),
    );

    scheduledTrip = TripModel(
      id: 'trip-002',
      subscriptionId: 'sub-001',
      userId: 'user-001',
      pickupLocation: pickup,
      dropoffLocation: dropoff,
      scheduledTime: DateTime.now().add(const Duration(hours: 2)),
      status: TripStatus.scheduled,
      vehicleType: VehicleType.luxury,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    cancelledTrip = TripModel(
      id: 'trip-003',
      subscriptionId: 'sub-001',
      userId: 'user-001',
      pickupLocation: pickup,
      dropoffLocation: dropoff,
      scheduledTime: DateTime(2026, 1, 10, 17, 0),
      status: TripStatus.cancelled,
      vehicleType: VehicleType.mid,
      createdAt: DateTime(2026, 1, 9),
      updatedAt: DateTime(2026, 1, 10),
    );
  });

  group('TripModel status helpers', () {
    test('isUpcoming returns true for scheduled trips', () {
      expect(scheduledTrip.isUpcoming, isTrue);
    });

    test('isUpcoming returns false for completed trips', () {
      expect(completedTrip.isUpcoming, isFalse);
    });

    test('isCompleted returns true for completed trips', () {
      expect(completedTrip.isCompleted, isTrue);
    });

    test('isCancelled returns true for cancelled trips', () {
      expect(cancelledTrip.isCancelled, isTrue);
    });

    test('isOngoing returns false for scheduled trips', () {
      expect(scheduledTrip.isOngoing, isFalse);
    });

    test('hasDriver returns true when driverId is set', () {
      expect(completedTrip.hasDriver, isTrue);
    });

    test('hasDriver returns false when no driver assigned', () {
      expect(scheduledTrip.hasDriver, isFalse);
    });
  });

  group('TripModel convenience getters', () {
    test('pickupAddress returns pickup location address', () {
      expect(completedTrip.pickupAddress, '123 Main St, Riyadh');
    });

    test('dropoffAddress returns dropoff location address', () {
      expect(completedTrip.dropoffAddress, '456 Office Ave, Riyadh');
    });

    test('durationMinutes returns estimatedMinutes', () {
      expect(completedTrip.durationMinutes, 25);
    });

    test('durationMinutes returns 0 when estimatedMinutes is null', () {
      expect(scheduledTrip.durationMinutes, 0);
    });

    test('formattedScheduledTime formats correctly', () {
      expect(completedTrip.formattedScheduledTime, '8:30 AM');
    });

    test('formattedScheduledDate formats correctly', () {
      expect(completedTrip.formattedScheduledDate, 'Jan 15, 2026');
    });
  });

  group('TripModel copyWith', () {
    test('copyWith preserves original values when no args', () {
      final copy = completedTrip.copyWith();
      expect(copy.id, completedTrip.id);
      expect(copy.fare, completedTrip.fare);
      expect(copy.status, completedTrip.status);
    });

    test('copyWith overrides specified values', () {
      final copy = completedTrip.copyWith(
        fare: 100.0,
        status: TripStatus.cancelled,
      );
      expect(copy.fare, 100.0);
      expect(copy.status, TripStatus.cancelled);
      expect(copy.id, completedTrip.id);
    });
  });

  group('TripModel toFirestore', () {
    test('toFirestore includes all required fields', () {
      final data = completedTrip.toFirestore();
      expect(data['userId'], 'user-001');
      expect(data['subscriptionId'], 'sub-001');
      expect(data['status'], 'completed');
      expect(data['vehicleType'], 'mid');
      expect(data['fare'], 55.0);
      expect(data['distanceKm'], 12.5);
      expect(data['driverName'], 'Ahmed');
    });

    test('toFirestore handles null optional fields', () {
      final data = scheduledTrip.toFirestore();
      expect(data['driverId'], isNull);
      expect(data['fare'], isNull);
      expect(data['rating'], isNull);
    });
  });
}
