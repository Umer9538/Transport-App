# Product Requirements Document (PRD)
## Private Transportation Subscription App - "DriverApp"

**Version:** 1.0
**Date:** January 2026
**Status:** Draft

---

## 1. Executive Summary

### 1.1 Product Vision
DriverApp is a subscription-based private transportation platform that revolutionizes daily commuting by offering pre-scheduled rides with personalized preferences. Unlike traditional ride-hailing apps that focus on on-demand trips, DriverApp targets users who need consistent, reliable transportation on a regular basis.

### 1.2 Problem Statement
Current ride-hailing solutions have limitations for regular commuters:
- **Unpredictable costs** - Surge pricing makes budgeting difficult
- **No consistency** - Different drivers every trip
- **Safety concerns** - No driver gender preference options
- **No scheduling** - Must book each ride individually
- **No bundled services** - Car maintenance/wash handled separately

### 1.3 Solution
A subscription-based transportation service that offers:
- Fixed monthly pricing for predictable budgeting
- Pre-scheduled rides for days, weeks, or months
- Driver gender selection for comfort and safety
- Vehicle type choices to match user needs
- Optional car maintenance and wash services

### 1.4 Target Users
| User Segment | Description |
|--------------|-------------|
| Daily Commuters | Professionals traveling to/from work on fixed schedules |
| School Parents | Parents needing reliable pickup/drop for children |
| Corporate Clients | Companies providing employee transportation |
| Seniors | Elderly users needing regular medical or social visits |
| Women Travelers | Users preferring female drivers for safety/comfort |

---

## 2. Product Scope

### 2.1 In Scope (MVP)
- User registration and authentication
- Subscription plan selection and management
- Driver gender preference selection
- Vehicle type selection (Low, Mid, Luxury, Van)
- Schedule creation (pickup/drop-off times)
- Day selection (daily, weekly, monthly, weekdays-only)
- Trip management dashboard
- Real-time ride tracking
- Payment processing
- Push notifications
- Basic ratings and feedback

### 2.2 Out of Scope (MVP)
- Car maintenance service (Phase 2)
- Car wash service (Phase 2)
- Driver app (separate product)
- Admin panel (separate web application)
- Multi-language support (Phase 2)
- Loyalty/rewards program (Phase 3)

---

## 3. Functional Requirements

### 3.1 User Authentication & Profile

#### 3.1.1 Registration
| Requirement ID | Description | Priority |
|----------------|-------------|----------|
| AUTH-001 | User can register with phone number + OTP | P0 |
| AUTH-002 | User can register with email + password | P0 |
| AUTH-003 | Social login (Google, Apple) | P1 |
| AUTH-004 | Profile creation with name, photo, emergency contact | P0 |

#### 3.1.2 Profile Management
| Requirement ID | Description | Priority |
|----------------|-------------|----------|
| PROF-001 | User can update profile information | P0 |
| PROF-002 | User can add multiple saved addresses (home, work, etc.) | P0 |
| PROF-003 | User can set default preferences (driver gender, vehicle type) | P1 |
| PROF-004 | User can view ride history | P0 |

### 3.2 Subscription Management

#### 3.2.1 Plan Selection
| Requirement ID | Description | Priority |
|----------------|-------------|----------|
| SUB-001 | Display available subscription plans | P0 |
| SUB-002 | Filter plans by duration (weekly, monthly, quarterly) | P0 |
| SUB-003 | Show pricing based on vehicle type selection | P0 |
| SUB-004 | Allow plan comparison | P1 |
| SUB-005 | Apply promo/discount codes | P1 |

#### 3.2.2 Subscription Plans Structure
```
Plan Types:
├── Basic Plan
│   ├── Weekly: 5 days/week, 2 trips/day (pickup + drop)
│   ├── Monthly: 20-22 days, 2 trips/day
│   └── Quarterly: 3 months, 2 trips/day
│
├── Flexible Plan
│   ├── Weekly: Custom days selection
│   ├── Monthly: Custom days selection
│   └── Pay-per-extra-trip option
│
└── Premium Plan
    ├── Unlimited trips
    ├── Priority driver assignment
    └── 24/7 support
```

#### 3.2.3 Vehicle Types & Pricing Tiers
| Vehicle Type | Description | Price Multiplier |
|--------------|-------------|------------------|
| Low (Economy) | Compact cars, basic comfort | 1.0x |
| Mid (Comfort) | Sedan, good comfort | 1.3x |
| Luxury | Premium vehicles, executive comfort | 2.0x |
| Van | 7+ seater, family/group transport | 1.5x |

### 3.3 Driver Preferences

#### 3.3.1 Gender Selection
| Requirement ID | Description | Priority |
|----------------|-------------|----------|
| DRV-001 | User can select preferred driver gender (Male/Female/No Preference) | P0 |
| DRV-002 | System matches drivers based on gender preference | P0 |
| DRV-003 | Notify user if preferred gender unavailable | P0 |
| DRV-004 | Allow temporary override for single trip | P1 |

#### 3.3.2 Driver Assignment
| Requirement ID | Description | Priority |
|----------------|-------------|----------|
| DRV-005 | Consistent driver assignment for regular schedules | P1 |
| DRV-006 | User can request specific driver (if available) | P2 |
| DRV-007 | User can block specific drivers | P1 |

### 3.4 Schedule Management

#### 3.4.1 Time Selection
| Requirement ID | Description | Priority |
|----------------|-------------|----------|
| SCH-001 | Select pickup time (with 15-min intervals) | P0 |
| SCH-002 | Select drop-off location and estimated time | P0 |
| SCH-003 | Set different times for different days | P1 |
| SCH-004 | Configure return trip timing | P0 |

#### 3.4.2 Day Selection Patterns
| Requirement ID | Description | Priority |
|----------------|-------------|----------|
| SCH-005 | Select specific days of the week | P0 |
| SCH-006 | Weekdays only (Mon-Fri) preset | P0 |
| SCH-007 | Full week (Mon-Sun) preset | P0 |
| SCH-008 | Custom pattern (e.g., Mon, Wed, Fri) | P0 |
| SCH-009 | Exclude specific dates (holidays, leave) | P1 |
| SCH-010 | Monthly calendar view for schedule overview | P0 |

#### 3.4.3 Schedule Modifications
| Requirement ID | Description | Priority |
|----------------|-------------|----------|
| SCH-011 | Cancel individual trips | P0 |
| SCH-012 | Modify pickup/drop time (before cutoff) | P0 |
| SCH-013 | Add extra one-time trips | P1 |
| SCH-014 | Pause subscription temporarily | P1 |

### 3.5 Trip Management

#### 3.5.1 Active Trip
| Requirement ID | Description | Priority |
|----------------|-------------|----------|
| TRIP-001 | View upcoming trip details | P0 |
| TRIP-002 | Real-time driver location tracking | P0 |
| TRIP-003 | Driver ETA display | P0 |
| TRIP-004 | Contact driver (call/chat) | P0 |
| TRIP-005 | Share trip status with emergency contact | P1 |
| TRIP-006 | SOS/Emergency button | P0 |

#### 3.5.2 Trip History
| Requirement ID | Description | Priority |
|----------------|-------------|----------|
| TRIP-007 | View completed trips | P0 |
| TRIP-008 | Rate driver after trip | P0 |
| TRIP-009 | Report issues with trip | P0 |
| TRIP-010 | Download trip receipts | P1 |

### 3.6 Payments

#### 3.6.1 Payment Methods
| Requirement ID | Description | Priority |
|----------------|-------------|----------|
| PAY-001 | Add/manage credit/debit cards | P0 |
| PAY-002 | Digital wallet integration (Apple Pay, Google Pay) | P1 |
| PAY-003 | Local payment gateway support | P1 |
| PAY-004 | Wallet balance (for extra trips) | P2 |

#### 3.6.2 Billing
| Requirement ID | Description | Priority |
|----------------|-------------|----------|
| PAY-005 | Auto-charge on subscription renewal | P0 |
| PAY-006 | View billing history | P0 |
| PAY-007 | Download invoices | P1 |
| PAY-008 | Payment failure handling and retry | P0 |

### 3.7 Notifications

| Requirement ID | Description | Priority |
|----------------|-------------|----------|
| NOT-001 | Trip reminder (30 min before) | P0 |
| NOT-002 | Driver assigned notification | P0 |
| NOT-003 | Driver arriving notification | P0 |
| NOT-004 | Trip started/completed notification | P0 |
| NOT-005 | Payment confirmation | P0 |
| NOT-006 | Subscription renewal reminder | P0 |
| NOT-007 | Schedule change alerts | P0 |

---

## 4. User Flows

### 4.1 Onboarding Flow
```
┌─────────────────┐
│   Splash Screen │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Welcome/Intro  │
│    (3 slides)   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐     ┌─────────────────┐
│  Phone/Email    │────▶│   OTP Verify    │
│    Entry        │     │                 │
└────────┬────────┘     └────────┬────────┘
         │                       │
         ▼                       ▼
┌─────────────────┐     ┌─────────────────┐
│ Social Login    │     │ Create Profile  │
│ (Google/Apple)  │────▶│ (Name, Photo)   │
└─────────────────┘     └────────┬────────┘
                                 │
                                 ▼
                        ┌─────────────────┐
                        │  Add Addresses  │
                        │ (Home, Work)    │
                        └────────┬────────┘
                                 │
                                 ▼
                        ┌─────────────────┐
                        │   Home Screen   │
                        └─────────────────┘
```

### 4.2 Subscription Purchase Flow
```
┌─────────────────┐
│   Home Screen   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Choose Plan    │
│ (Basic/Flex/    │
│   Premium)      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Select Vehicle  │
│  Type (Low/Mid/ │
│  Luxury/Van)    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Select Driver   │
│   Gender        │
│ (M/F/Any)       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Set Schedule    │
│ - Days          │
│ - Pickup Time   │
│ - Drop Location │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Review & Pay    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Confirmation   │
└─────────────────┘
```

### 4.3 Daily Trip Flow
```
┌─────────────────┐
│ Push: "Trip in  │
│    30 mins"     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Driver Assigned │
│ View Details    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Driver Arriving │
│ Track on Map    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Trip Started   │
│ Live Tracking   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Trip Completed  │
│ Rate Driver     │
└─────────────────┘
```

---

## 5. Screen Specifications

### 5.1 Screen List

| Screen ID | Screen Name | Description |
|-----------|-------------|-------------|
| S-01 | Splash | App logo and loading |
| S-02 | Onboarding | Feature introduction slides |
| S-03 | Login | Phone/email entry |
| S-04 | OTP Verification | Code verification |
| S-05 | Create Profile | Name, photo, details |
| S-06 | Add Address | Location picker |
| S-07 | Home | Dashboard with active subscription |
| S-08 | Plans | Subscription plans listing |
| S-09 | Plan Details | Single plan details |
| S-10 | Vehicle Selection | Choose car type |
| S-11 | Driver Preference | Gender selection |
| S-12 | Schedule Setup | Day and time selection |
| S-13 | Schedule Calendar | Monthly calendar view |
| S-14 | Review Order | Summary before payment |
| S-15 | Payment | Add/select payment method |
| S-16 | Confirmation | Subscription success |
| S-17 | Active Trip | Live ride tracking |
| S-18 | Trip History | Past rides list |
| S-19 | Trip Details | Single trip information |
| S-20 | Profile | User settings |
| S-21 | My Subscription | Current plan management |
| S-22 | Notifications | Alert center |
| S-23 | Support | Help and contact |
| S-24 | Rate Driver | Post-trip feedback |

### 5.2 Home Screen (S-07) Wireframe
```
┌─────────────────────────────────────┐
│ ☰        DriverApp           🔔    │
├─────────────────────────────────────┤
│                                     │
│  Good Morning, Ahmed!               │
│                                     │
│  ┌───────────────────────────────┐  │
│  │  NEXT TRIP                    │  │
│  │  ─────────────────────────    │  │
│  │  📍 Home → Office             │  │
│  │  🕐 Today, 8:30 AM            │  │
│  │  🚗 Mid Sedan                 │  │
│  │  👤 Female Driver             │  │
│  │                               │  │
│  │  [View Details]  [Modify]     │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │  MY SUBSCRIPTION              │  │
│  │  ─────────────────────────    │  │
│  │  Premium Monthly              │  │
│  │  18 of 22 trips remaining     │  │
│  │  Renews: Feb 15, 2026         │  │
│  │  ████████████░░░░ 82%         │  │
│  │                               │  │
│  │  [Manage]                     │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌──────────┐  ┌──────────┐        │
│  │ Schedule │  │  History │        │
│  │ Calendar │  │          │        │
│  └──────────┘  └──────────┘        │
│                                     │
├─────────────────────────────────────┤
│  🏠      📅      🚗      👤        │
│  Home  Schedule  Trips  Profile    │
└─────────────────────────────────────┘
```

---

## 6. Technical Architecture

### 6.1 Technology Stack

| Layer | Technology | Purpose |
|-------|------------|---------|
| Mobile App | Flutter (Dart) | Cross-platform iOS & Android |
| State Management | Riverpod / BLoC | App state handling |
| Backend | Firebase | Serverless infrastructure |
| Authentication | Firebase Auth | User sign-in/sign-up |
| Database | Cloud Firestore | NoSQL real-time database |
| Storage | Firebase Storage | Profile images, documents |
| Functions | Cloud Functions | Business logic, triggers |
| Push Notifications | FCM | Alerts and reminders |
| Maps | Google Maps API | Location, routing, tracking |
| Payments | Stripe / PayPal | Subscription billing |

### 6.2 Data Models

#### 6.2.1 User Model
```dart
class User {
  String id;
  String name;
  String email;
  String phone;
  String? profileImageUrl;
  String? emergencyContact;
  List<Address> savedAddresses;
  DriverGender preferredDriverGender;
  VehicleType preferredVehicleType;
  DateTime createdAt;
  DateTime updatedAt;
}
```

#### 6.2.2 Subscription Model
```dart
class Subscription {
  String id;
  String userId;
  SubscriptionPlan plan;
  VehicleType vehicleType;
  DriverGender driverGender;
  SubscriptionStatus status;
  DateTime startDate;
  DateTime endDate;
  Schedule schedule;
  int totalTrips;
  int usedTrips;
  double price;
  DateTime createdAt;
}
```

#### 6.2.3 Trip Model
```dart
class Trip {
  String id;
  String subscriptionId;
  String userId;
  String? driverId;
  Address pickupLocation;
  Address dropoffLocation;
  DateTime scheduledTime;
  DateTime? actualPickupTime;
  DateTime? actualDropoffTime;
  TripStatus status;
  double? rating;
  String? feedback;
}
```

#### 6.2.4 Schedule Model
```dart
class Schedule {
  List<DayOfWeek> activeDays;
  TimeOfDay pickupTime;
  TimeOfDay? returnPickupTime;
  Address pickupLocation;
  Address dropoffLocation;
  List<DateTime> excludedDates;
}
```

### 6.3 App Architecture
```
┌─────────────────────────────────────────────────────┐
│                    PRESENTATION                      │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐            │
│  │ Screens │  │ Widgets │  │  State  │            │
│  │         │  │         │  │ (BLoC)  │            │
│  └────┬────┘  └────┬────┘  └────┬────┘            │
└───────┼────────────┼────────────┼───────────────────┘
        │            │            │
┌───────┼────────────┼────────────┼───────────────────┐
│       ▼            ▼            ▼                   │
│                   DOMAIN                             │
│  ┌─────────────────────────────────────────────┐   │
│  │              Use Cases                       │   │
│  │  - CreateSubscription                        │   │
│  │  - ManageSchedule                            │   │
│  │  - TrackTrip                                 │   │
│  │  - ProcessPayment                            │   │
│  └─────────────────────────────────────────────┘   │
└─────────────────────────┬───────────────────────────┘
                          │
┌─────────────────────────┼───────────────────────────┐
│                         ▼                           │
│                       DATA                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────┐  │
│  │ Repositories │  │   Services   │  │  Models  │  │
│  │              │  │              │  │          │  │
│  └──────┬───────┘  └──────┬───────┘  └──────────┘  │
└─────────┼─────────────────┼─────────────────────────┘
          │                 │
          ▼                 ▼
┌─────────────────────────────────────────────────────┐
│                    EXTERNAL                          │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌───────┐  │
│  │Firebase │  │ Google  │  │ Stripe  │  │ FCM   │  │
│  │         │  │  Maps   │  │         │  │       │  │
│  └─────────┘  └─────────┘  └─────────┘  └───────┘  │
└─────────────────────────────────────────────────────┘
```

### 6.4 Folder Structure
```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   ├── theme/
│   ├── utils/
│   └── errors/
├── config/
│   ├── routes.dart
│   └── firebase_options.dart
├── data/
│   ├── models/
│   ├── repositories/
│   └── services/
├── domain/
│   ├── entities/
│   └── usecases/
├── presentation/
│   ├── screens/
│   │   ├── auth/
│   │   ├── home/
│   │   ├── subscription/
│   │   ├── schedule/
│   │   ├── trip/
│   │   └── profile/
│   ├── widgets/
│   └── blocs/
└── l10n/
```

---

## 7. Non-Functional Requirements

### 7.1 Performance
| Metric | Target |
|--------|--------|
| App launch time | < 3 seconds |
| Screen transition | < 300ms |
| API response time | < 2 seconds |
| Map load time | < 2 seconds |
| Offline capability | Basic viewing |

### 7.2 Security
- End-to-end encryption for sensitive data
- Secure storage for payment information (PCI compliant)
- OAuth 2.0 for authentication
- SSL/TLS for all API communications
- Regular security audits

### 7.3 Scalability
- Support 100,000+ active users
- Handle 10,000+ concurrent trips
- Auto-scaling infrastructure
- CDN for static assets

### 7.4 Reliability
- 99.9% uptime SLA
- Automatic failover
- Data backup every 6 hours
- Disaster recovery plan

### 7.5 Accessibility
- WCAG 2.1 AA compliance
- Screen reader support
- High contrast mode
- Font scaling support

---

## 8. Release Plan

### 8.1 MVP (Phase 1)
**Target: 3 months**

Core Features:
- User authentication (phone + social)
- Basic subscription plans (weekly/monthly)
- Vehicle type selection
- Driver gender preference
- Schedule creation (single route)
- Trip tracking
- Basic payment integration
- Push notifications

### 8.2 Phase 2
**Target: +2 months**

Enhanced Features:
- Multiple routes per subscription
- Car maintenance service
- Car wash service
- Favorite drivers
- Advanced scheduling
- Referral program
- Multi-language support

### 8.3 Phase 3
**Target: +2 months**

Premium Features:
- Corporate accounts
- Family plans
- Loyalty rewards
- In-app chat with driver
- Trip sharing
- Advanced analytics

---

## 9. Success Metrics

### 9.1 Key Performance Indicators (KPIs)

| Metric | Target (Month 3) | Target (Month 6) |
|--------|------------------|------------------|
| App Downloads | 10,000 | 50,000 |
| Active Subscriptions | 1,000 | 5,000 |
| Monthly Revenue | $50,000 | $250,000 |
| User Retention (30-day) | 60% | 70% |
| App Rating | 4.0+ | 4.5+ |
| Trip Completion Rate | 95% | 98% |
| Average Response Time | 10 min | 7 min |

### 9.2 User Satisfaction Metrics
- Net Promoter Score (NPS) > 50
- Customer Satisfaction (CSAT) > 4.5/5
- Driver Rating Average > 4.7/5

---

## 10. Risks and Mitigations

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Driver shortage | High | Medium | Partner with driver agencies, incentive programs |
| Payment failures | High | Low | Multiple payment options, retry logic |
| GPS accuracy issues | Medium | Medium | Multiple location sources, manual override |
| Competition | Medium | High | Unique features, quality service, pricing |
| Regulatory issues | High | Low | Legal compliance, local partnerships |

---

## 11. Appendix

### 11.1 Glossary
| Term | Definition |
|------|------------|
| Subscription | Recurring payment plan for transportation services |
| Trip | Single journey from pickup to dropoff |
| Schedule | Pre-defined pattern of trips |
| Driver Gender Preference | User's choice of male/female driver |
| Vehicle Type | Category of car (Low, Mid, Luxury, Van) |

### 11.2 References
- Firebase Documentation
- Flutter Documentation
- Google Maps Platform
- Stripe API Documentation

---

## 12. Approval

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Product Owner | | | |
| Tech Lead | | | |
| Design Lead | | | |
| QA Lead | | | |

---

*Document maintained by: Product Team*
*Last Updated: January 2026*
