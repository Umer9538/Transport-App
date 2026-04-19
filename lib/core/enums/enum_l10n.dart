import '../../l10n/generated/app_localizations.dart';
import 'enums.dart';

/// Localized display names for enums.
/// Usage: `tripStatus.localizedName(l)` instead of `tripStatus.displayName`

extension TripStatusL10n on TripStatus {
  String localizedName(AppLocalizations l) {
    switch (this) {
      case TripStatus.scheduled:
        return l.scheduled;
      case TripStatus.driverAssigned:
        return l.driverAssigned;
      case TripStatus.driverArriving:
        return l.driverArriving;
      case TripStatus.inProgress:
        return l.inProgress;
      case TripStatus.completed:
        return l.completed;
      case TripStatus.cancelled:
        return l.cancelled;
      case TripStatus.noShow:
        return l.noShow;
    }
  }
}

extension VehicleTypeL10n on VehicleType {
  String localizedName(AppLocalizations l) {
    switch (this) {
      case VehicleType.low:
        return l.economyVehicle;
      case VehicleType.mid:
        return l.comfortVehicle;
      case VehicleType.luxury:
        return l.luxuryVehicle;
      case VehicleType.van:
        return l.vanVehicle;
    }
  }

  String localizedDescription(AppLocalizations l) {
    switch (this) {
      case VehicleType.low:
        return l.economyVehicleDesc;
      case VehicleType.mid:
        return l.comfortVehicleDesc;
      case VehicleType.luxury:
        return l.luxuryVehicleDesc;
      case VehicleType.van:
        return l.vanVehicleDesc;
    }
  }
}

extension DriverGenderL10n on DriverGender {
  String localizedName(AppLocalizations l) {
    switch (this) {
      case DriverGender.male:
        return l.male;
      case DriverGender.female:
        return l.female;
      case DriverGender.noPreference:
        return l.noPreference;
    }
  }
}

extension PlanTypeL10n on PlanType {
  String localizedName(AppLocalizations l) {
    switch (this) {
      case PlanType.weekly:
        return l.planWeekly;
      case PlanType.monthly:
        return l.planMonthly;
      case PlanType.quarterly:
        return l.planQuarterly;
    }
  }
}

extension SubscriptionStatusL10n on SubscriptionStatus {
  String localizedName(AppLocalizations l) {
    switch (this) {
      case SubscriptionStatus.active:
        return l.active;
      case SubscriptionStatus.paused:
        return l.paused;
      case SubscriptionStatus.expired:
        return l.expired;
      case SubscriptionStatus.cancelled:
        return l.cancelled;
      case SubscriptionStatus.pending:
        return l.pending;
    }
  }
}

extension DriverStatusL10n on DriverStatus {
  String localizedName(AppLocalizations l) {
    switch (this) {
      case DriverStatus.offline:
        return l.offline;
      case DriverStatus.online:
        return l.online;
      case DriverStatus.onTrip:
        return l.onTrip;
      case DriverStatus.busy:
        return l.statusBusy;
    }
  }
}

extension AddressTypeL10n on AddressType {
  String localizedName(AppLocalizations l) {
    switch (this) {
      case AddressType.home:
        return l.home;
      case AddressType.work:
        return l.work;
      case AddressType.school:
        return l.school;
      case AddressType.other:
        return l.otherAddress;
    }
  }
}

extension PaymentStatusL10n on PaymentStatus {
  String localizedName(AppLocalizations l) {
    switch (this) {
      case PaymentStatus.pending:
        return l.pending;
      case PaymentStatus.completed:
        return l.completed;
      case PaymentStatus.failed:
        return l.paymentFailed;
      case PaymentStatus.refunded:
        return l.paymentRefunded;
    }
  }
}

extension UserRoleL10n on UserRole {
  String localizedName(AppLocalizations l) {
    switch (this) {
      case UserRole.user:
        return l.roleUser;
      case UserRole.driver:
        return l.driver;
      case UserRole.admin:
        return l.roleAdmin;
    }
  }
}

extension DayOfWeekL10n on DayOfWeek {
  String localizedShortName(AppLocalizations l) {
    switch (this) {
      case DayOfWeek.monday:
        return l.monShort;
      case DayOfWeek.tuesday:
        return l.tueShort;
      case DayOfWeek.wednesday:
        return l.wedShort;
      case DayOfWeek.thursday:
        return l.thuShort;
      case DayOfWeek.friday:
        return l.friShort;
      case DayOfWeek.saturday:
        return l.satShort;
      case DayOfWeek.sunday:
        return l.sunShort;
    }
  }

  String localizedFullName(AppLocalizations l) {
    switch (this) {
      case DayOfWeek.monday:
        return l.monday;
      case DayOfWeek.tuesday:
        return l.tuesday;
      case DayOfWeek.wednesday:
        return l.wednesday;
      case DayOfWeek.thursday:
        return l.thursday;
      case DayOfWeek.friday:
        return l.friday;
      case DayOfWeek.saturday:
        return l.saturday;
      case DayOfWeek.sunday:
        return l.sunday;
    }
  }
}
