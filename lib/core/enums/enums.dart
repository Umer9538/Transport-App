// Driver Gender Enum
enum DriverGender {
  male('Male'),
  female('Female'),
  noPreference('No Preference');

  final String displayName;
  const DriverGender(this.displayName);
}

// Vehicle Type Enum
enum VehicleType {
  low('Economy', 1.0, 'Basic comfort, compact cars'),
  mid('Comfort', 1.3, 'Sedan, good comfort'),
  luxury('Luxury', 2.0, 'Premium vehicles, executive comfort'),
  van('Van', 1.5, '7+ seater, family/group transport');

  final String displayName;
  final double priceMultiplier;
  final String description;
  const VehicleType(this.displayName, this.priceMultiplier, this.description);
}

// Subscription Plan Type
enum PlanType {
  weekly('Weekly'),
  monthly('Monthly'),
  quarterly('Quarterly');

  final String displayName;
  const PlanType(this.displayName);
}

// Subscription Status
enum SubscriptionStatus {
  active('Active'),
  paused('Paused'),
  expired('Expired'),
  cancelled('Cancelled'),
  pending('Pending');

  final String displayName;
  const SubscriptionStatus(this.displayName);
}

// Trip Status
enum TripStatus {
  scheduled('Scheduled'),
  driverAssigned('Driver Assigned'),
  driverArriving('Driver Arriving'),
  inProgress('In Progress'),
  completed('Completed'),
  cancelled('Cancelled'),
  noShow('No Show');

  final String displayName;
  const TripStatus(this.displayName);
}

// Day of Week
enum DayOfWeek {
  monday('Mon', 'Monday', 1),
  tuesday('Tue', 'Tuesday', 2),
  wednesday('Wed', 'Wednesday', 3),
  thursday('Thu', 'Thursday', 4),
  friday('Fri', 'Friday', 5),
  saturday('Sat', 'Saturday', 6),
  sunday('Sun', 'Sunday', 7);

  final String shortName;
  final String fullName;
  final int dayNumber;
  const DayOfWeek(this.shortName, this.fullName, this.dayNumber);
}

// Address Type
enum AddressType {
  home('Home'),
  work('Work'),
  school('School'),
  other('Other');

  final String displayName;
  const AddressType(this.displayName);
}

// Payment Status
enum PaymentStatus {
  pending('Pending'),
  completed('Completed'),
  failed('Failed'),
  refunded('Refunded');

  final String displayName;
  const PaymentStatus(this.displayName);
}
