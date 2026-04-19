# Driver App - Complete Application Documentation

## Table of Contents
1. [Introduction](#introduction)
2. [What is This App?](#what-is-this-app)
3. [Tech Stack & Technologies](#tech-stack--technologies)
4. [User Types](#user-types)
5. [Passenger Side - Complete Flow](#passenger-side---complete-flow)
6. [Driver Side - Complete Flow](#driver-side---complete-flow)
7. [How Passenger and Driver Connect](#how-passenger-and-driver-connect)
8. [Subscription Plans Explained](#subscription-plans-explained)
9. [Trip Lifecycle](#trip-lifecycle)
10. [Earnings and Payments](#earnings-and-payments)
11. [App Screens Overview](#app-screens-overview)
12. [Technical Architecture (Simplified)](#technical-architecture-simplified)
13. [Data Flow Diagrams](#data-flow-diagrams)
14. [Project Structure](#project-structure)
15. [Database Schema](#database-schema)

---

## Introduction

This document explains the complete functionality of the Driver App - a subscription-based ride service application designed for Saudi Arabia. Unlike traditional ride-hailing apps where you book rides on-demand, this app works on a **subscription model** where passengers subscribe to monthly plans for their daily commute.

---

## What is This App?

### The Problem It Solves
Many people have the same daily commute - home to office in the morning, office to home in the evening. Instead of booking individual rides every day, this app lets you:
- Subscribe to a monthly plan
- Set your regular pickup and drop-off locations
- Set your preferred pickup times
- Get a driver assigned automatically for your daily trips

### Key Difference from Uber/Careem
| Feature | Uber/Careem | This App |
|---------|-------------|----------|
| Booking Type | On-demand (book when needed) | Subscription (pre-scheduled) |
| Payment | Pay per ride | Monthly subscription |
| Driver | Different driver each time | Can have consistent driver |
| Best For | Occasional rides | Daily commuters |

---

## Tech Stack & Technologies

### Overview Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           DRIVER APP TECH STACK                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │                         FRONTEND (Mobile App)                        │   │
│   │                                                                      │   │
│   │   ┌───────────────┐  ┌───────────────┐  ┌───────────────┐          │   │
│   │   │    FLUTTER    │  │     DART      │  │   RIVERPOD    │          │   │
│   │   │   Framework   │  │   Language    │  │    State      │          │   │
│   │   │   v3.24+      │  │   v3.5+       │  │  Management   │          │   │
│   │   └───────────────┘  └───────────────┘  └───────────────┘          │   │
│   │                                                                      │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                    │                                         │
│                                    ▼                                         │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │                         BACKEND (Firebase)                           │   │
│   │                                                                      │   │
│   │   ┌───────────────┐  ┌───────────────┐  ┌───────────────┐          │   │
│   │   │   FIRESTORE   │  │  FIREBASE     │  │   FIREBASE    │          │   │
│   │   │   Database    │  │    AUTH       │  │   STORAGE     │          │   │
│   │   └───────────────┘  └───────────────┘  └───────────────┘          │   │
│   │                                                                      │   │
│   │   ┌───────────────┐  ┌───────────────┐                              │   │
│   │   │   FIREBASE    │  │    CLOUD      │                              │   │
│   │   │   MESSAGING   │  │  FUNCTIONS    │                              │   │
│   │   │    (FCM)      │  │  (Optional)   │                              │   │
│   │   └───────────────┘  └───────────────┘                              │   │
│   │                                                                      │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                    │                                         │
│                                    ▼                                         │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │                      THIRD-PARTY SERVICES                            │   │
│   │                                                                      │   │
│   │   ┌───────────────┐  ┌───────────────┐  ┌───────────────┐          │   │
│   │   │  GOOGLE MAPS  │  │    STRIPE     │  │   TWILIO      │          │   │
│   │   │   Location    │  │   Payments    │  │  SMS/OTP      │          │   │
│   │   └───────────────┘  └───────────────┘  └───────────────┘          │   │
│   │                                                                      │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Detailed Tech Stack

#### 1. Frontend Framework

| Technology | Version | Purpose |
|------------|---------|---------|
| **Flutter** | 3.24+ | Cross-platform mobile framework |
| **Dart** | 3.5+ | Programming language |

**Why Flutter?**
- Single codebase for iOS and Android
- Fast development with hot reload
- Beautiful, native-like UI
- Large community and packages
- Excellent performance

#### 2. State Management

| Package | Version | Purpose |
|---------|---------|---------|
| **flutter_riverpod** | 2.6.1 | Main state management solution |
| **riverpod_annotation** | 2.6.1 | Code generation for Riverpod |
| **riverpod_generator** | 2.6.3 | Auto-generates Riverpod code |

**What is Riverpod?**
```
┌─────────────────────────────────────────────────────────────┐
│                    RIVERPOD EXPLAINED                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Riverpod manages app data (state) across screens.          │
│                                                              │
│  Example: User logs in                                       │
│                                                              │
│  ┌──────────┐     ┌──────────────┐     ┌──────────────┐    │
│  │  Login   │ ──→ │   Provider   │ ──→ │  Home Screen │    │
│  │  Screen  │     │ (stores user)│     │ (reads user) │    │
│  └──────────┘     └──────────────┘     └──────────────┘    │
│                          │                                   │
│                          ▼                                   │
│                   ┌──────────────┐                          │
│                   │   Profile    │                          │
│                   │   Screen     │                          │
│                   │ (reads user) │                          │
│                   └──────────────┘                          │
│                                                              │
│  All screens automatically update when data changes!        │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

#### 3. Backend Services (Firebase)

| Service | Package Version | Purpose |
|---------|-----------------|---------|
| **Firebase Core** | 3.8.1 | Firebase initialization |
| **Firebase Auth** | 5.3.4 | User authentication (Phone + OTP) |
| **Cloud Firestore** | 5.6.0 | NoSQL database for all data |
| **Firebase Storage** | 12.3.7 | File storage (images, documents) |
| **Firebase Messaging** | 15.1.6 | Push notifications (FCM) |

**Firebase Services Explained:**

```
┌─────────────────────────────────────────────────────────────┐
│                    FIREBASE SERVICES                         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. FIREBASE AUTH (Authentication)                          │
│     ├── Phone number login                                  │
│     ├── OTP verification                                    │
│     └── Session management                                  │
│                                                              │
│  2. CLOUD FIRESTORE (Database)                              │
│     ├── Users collection                                    │
│     ├── Subscriptions collection                            │
│     ├── Trips collection                                    │
│     ├── Plans collection                                    │
│     └── Real-time data sync                                 │
│                                                              │
│  3. FIREBASE STORAGE (Files)                                │
│     ├── Profile photos                                      │
│     ├── Driver documents (license, insurance)               │
│     └── Vehicle photos                                      │
│                                                              │
│  4. FIREBASE CLOUD MESSAGING (Notifications)                │
│     ├── Trip status updates                                 │
│     ├── Driver assignment alerts                            │
│     ├── Payment reminders                                   │
│     └── Promotional messages                                │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

#### 4. Maps & Location Services

| Package | Version | Purpose |
|---------|---------|---------|
| **google_maps_flutter** | 2.10.0 | Display maps in app |
| **geolocator** | 13.0.2 | Get device GPS location |
| **geocoding** | 3.0.0 | Convert addresses ↔ coordinates |

**Location Features:**
- Real-time driver tracking on map
- Pickup/dropoff location selection
- Route display between points
- Distance and ETA calculation
- Current location detection

#### 5. UI/UX Packages

| Package | Version | Purpose |
|---------|---------|---------|
| **google_fonts** | 6.2.1 | Custom typography |
| **flutter_svg** | 2.0.16 | SVG image support |
| **cached_network_image** | 3.4.1 | Image caching |
| **shimmer** | 3.0.0 | Loading placeholders |
| **flutter_spinkit** | 5.2.1 | Loading spinners |
| **pinput** | 5.0.1 | OTP input field |
| **cupertino_icons** | 1.0.8 | iOS-style icons |

**UI Components Explained:**
```
┌─────────────────────────────────────────────────────────────┐
│                    UI PACKAGES USAGE                         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  SHIMMER - Loading Skeleton                                 │
│  ┌──────────────────────────────────────┐                   │
│  │ ████████████████░░░░░░░░░░░░░░░░░░░  │ ← Animated        │
│  │ ██████████░░░░░░░░░░░░░░░░░░░░░░░░░  │   placeholder     │
│  │ ████████████████████░░░░░░░░░░░░░░░  │   while loading   │
│  └──────────────────────────────────────┘                   │
│                                                              │
│  PINPUT - OTP Input                                         │
│  ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐                      │
│  │ 1 │ │ 2 │ │ 3 │ │ 4 │ │ 5 │ │ 6 │  ← 6-digit OTP       │
│  └───┘ └───┘ └───┘ └───┘ └───┘ └───┘                      │
│                                                              │
│  CACHED_NETWORK_IMAGE                                       │
│  ┌──────────────────────────────────────┐                   │
│  │  Image loads from internet            │                   │
│  │  → Saved to device cache             │                   │
│  │  → Next time loads instantly         │                   │
│  └──────────────────────────────────────┘                   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

#### 6. Payment Processing

| Package | Version | Purpose |
|---------|---------|---------|
| **flutter_stripe** | 11.3.0 | Credit card payments |

**Payment Flow:**
```
┌─────────────────────────────────────────────────────────────┐
│                    STRIPE PAYMENT FLOW                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. User selects plan (SAR 599/month)                       │
│                    ↓                                         │
│  2. User enters card details                                │
│     ┌─────────────────────────────────┐                     │
│     │ Card: 4242 4242 4242 4242       │                     │
│     │ Exp: 12/25    CVV: 123          │                     │
│     └─────────────────────────────────┘                     │
│                    ↓                                         │
│  3. Stripe validates card (secure, not stored in app)       │
│                    ↓                                         │
│  4. Payment processed                                        │
│                    ↓                                         │
│  5. Subscription activated                                   │
│                                                              │
│  Supported Methods:                                          │
│  • Credit/Debit Cards (Visa, MasterCard)                    │
│  • Apple Pay                                                 │
│  • Mada (Saudi debit cards)                                 │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

#### 7. Local Storage & Security

| Package | Version | Purpose |
|---------|---------|---------|
| **shared_preferences** | 2.3.4 | Simple key-value storage |
| **flutter_secure_storage** | 9.2.3 | Encrypted sensitive data |

**Storage Usage:**
```
SHARED PREFERENCES (Non-sensitive)
├── isFirstLaunch: true/false
├── selectedLanguage: "en" / "ar"
├── notificationsEnabled: true/false
└── lastSyncTime: timestamp

FLUTTER SECURE STORAGE (Sensitive)
├── authToken: "xxxxx..."
├── refreshToken: "xxxxx..."
└── userCredentials: encrypted
```

#### 8. Utilities

| Package | Version | Purpose |
|---------|---------|---------|
| **intl** | 0.20.1 | Date/time formatting, localization |
| **uuid** | 4.5.1 | Generate unique IDs |
| **image_picker** | 1.1.2 | Select photos from gallery/camera |
| **url_launcher** | 6.3.1 | Open URLs, make calls, send SMS |

#### 9. Development Tools

| Package | Version | Purpose |
|---------|---------|---------|
| **flutter_lints** | 5.0.0 | Code quality rules |
| **build_runner** | 2.4.14 | Code generation |
| **flutter_launcher_icons** | 0.14.3 | Generate app icons |
| **flutter_native_splash** | 2.4.4 | Generate splash screen |

### Complete Package List

```yaml
# pubspec.yaml - All Dependencies

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # ═══════════════════════════════════════════════════
  # FIREBASE (Backend Services)
  # ═══════════════════════════════════════════════════
  firebase_core: ^3.8.1          # Firebase initialization
  firebase_auth: ^5.3.4          # Phone authentication
  cloud_firestore: ^5.6.0        # Database
  firebase_storage: ^12.3.7      # File storage
  firebase_messaging: ^15.1.6    # Push notifications

  # ═══════════════════════════════════════════════════
  # STATE MANAGEMENT
  # ═══════════════════════════════════════════════════
  flutter_riverpod: ^2.6.1       # State management
  riverpod_annotation: ^2.6.1    # Annotations

  # ═══════════════════════════════════════════════════
  # NAVIGATION
  # ═══════════════════════════════════════════════════
  go_router: ^14.6.2             # Declarative routing

  # ═══════════════════════════════════════════════════
  # UI COMPONENTS
  # ═══════════════════════════════════════════════════
  cupertino_icons: ^1.0.8        # iOS icons
  google_fonts: ^6.2.1           # Custom fonts
  flutter_svg: ^2.0.16           # SVG support
  cached_network_image: ^3.4.1   # Image caching
  shimmer: ^3.0.0                # Loading effects
  flutter_spinkit: ^5.2.1        # Spinners
  pinput: ^5.0.1                 # OTP input

  # ═══════════════════════════════════════════════════
  # MAPS & LOCATION
  # ═══════════════════════════════════════════════════
  google_maps_flutter: ^2.10.0   # Maps widget
  geolocator: ^13.0.2            # GPS location
  geocoding: ^3.0.0              # Address lookup

  # ═══════════════════════════════════════════════════
  # UTILITIES
  # ═══════════════════════════════════════════════════
  intl: ^0.20.1                  # Internationalization
  uuid: ^4.5.1                   # Unique IDs
  shared_preferences: ^2.3.4     # Local storage
  flutter_secure_storage: ^9.2.3 # Secure storage
  image_picker: ^1.1.2           # Photo picker
  url_launcher: ^6.3.1           # Open links/calls

  # ═══════════════════════════════════════════════════
  # PAYMENTS
  # ═══════════════════════════════════════════════════
  flutter_stripe: ^11.3.0        # Stripe payments

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0          # Linting rules
  riverpod_generator: ^2.6.3     # Code generation
  build_runner: ^2.4.14          # Build tool
  custom_lint: ^0.7.0            # Custom lint rules
  flutter_launcher_icons: ^0.14.3 # App icon generator
  flutter_native_splash: ^2.4.4  # Splash generator
```

### Architecture Pattern

The app follows **Clean Architecture** with **Feature-First** organization:

```
┌─────────────────────────────────────────────────────────────┐
│                    CLEAN ARCHITECTURE                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                 PRESENTATION LAYER                   │   │
│  │         (UI - Screens, Widgets, Controllers)        │   │
│  │                                                      │   │
│  │  • Screens (home, profile, trips, etc.)             │   │
│  │  • Widgets (buttons, cards, dialogs)                │   │
│  │  • Animations                                        │   │
│  └──────────────────────┬───────────────────────────────┘   │
│                         │                                    │
│                         ▼                                    │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                   DATA LAYER                         │   │
│  │           (Business Logic & Data Access)            │   │
│  │                                                      │   │
│  │  • Providers (Riverpod state)                       │   │
│  │  • Services (Firebase, API calls)                   │   │
│  │  • Models (User, Trip, Subscription)                │   │
│  └──────────────────────┬───────────────────────────────┘   │
│                         │                                    │
│                         ▼                                    │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                   CORE LAYER                         │   │
│  │            (Shared Utilities & Constants)           │   │
│  │                                                      │   │
│  │  • Theme (colors, fonts, styles)                    │   │
│  │  • Constants (API URLs, app strings)                │   │
│  │  • Enums (TripStatus, UserRole)                     │   │
│  │  • Utilities (formatters, validators)               │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Supported Platforms

| Platform | Minimum Version | Status |
|----------|-----------------|--------|
| **Android** | API 21 (Android 5.0) | ✅ Supported |
| **iOS** | iOS 12.0 | ✅ Supported |

### Language & Localization

| Language | Code | Status |
|----------|------|--------|
| **English** | en | ✅ Default |
| **Arabic** | ar | ✅ Supported |

**RTL Support:** Full right-to-left support for Arabic language.

---

## User Types

The app has two types of users:

### 1. Passenger (Customer)
- Subscribes to a plan
- Schedules regular trips
- Gets picked up and dropped off by drivers
- Pays monthly subscription fee

### 2. Driver
- Receives trip assignments
- Picks up and drops off passengers
- Earns money from completed trips
- Can go online/offline as needed

**Important:** A user can switch between being a passenger and a driver. If a passenger wants to become a driver, they can apply through the app.

---

## Passenger Side - Complete Flow

### Step 1: Getting Started (Onboarding)

```
┌─────────────────────────────────────────────────────────────┐
│                    APP LAUNCH                                │
│                         ↓                                    │
│              Is this first time?                            │
│                    ↙     ↘                                  │
│                 YES        NO                                │
│                  ↓          ↓                                │
│           Show Welcome    Go to Login                        │
│             Screens       Screen                             │
└─────────────────────────────────────────────────────────────┘
```

**Welcome Screens (First Time Users):**
1. **Screen 1:** "Your Daily Commute, Simplified" - Introduces the concept
2. **Screen 2:** "Flexible Subscription Plans" - Shows pricing benefits
3. **Screen 3:** "Safe & Reliable Drivers" - Trust and safety features

### Step 2: Registration & Login

**New User Registration:**
1. User opens the app
2. Clicks "Create Account"
3. Enters phone number (Saudi Arabia: +966)
4. Receives OTP (One-Time Password) via SMS
5. Enters OTP to verify
6. Fills in profile details:
   - Full Name
   - Email Address
   - Profile Photo (optional)
7. Account created successfully!

**Existing User Login:**
1. User opens the app
2. Clicks "Sign In"
3. Enters phone number
4. Receives and enters OTP
5. Logged in successfully!

### Step 3: Choosing a Subscription Plan

After logging in, users without an active subscription see the **Plans Screen**:

```
┌─────────────────────────────────────────────────────────────┐
│                  SUBSCRIPTION PLANS                          │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │   BASIC     │  │  STANDARD   │  │   PREMIUM   │         │
│  │             │  │  (Popular)  │  │             │         │
│  │  SAR 299    │  │  SAR 599    │  │  SAR 999    │         │
│  │  /month     │  │  /month     │  │  /month     │         │
│  │             │  │             │  │             │         │
│  │ • 1 trip/day│  │ • 2 trips/  │  │ • 3 trips/  │         │
│  │ • Economy   │  │   day       │  │   day       │         │
│  │   vehicle   │  │ • Mid-range │  │ • Luxury    │         │
│  │ • Standard  │  │   vehicle   │  │   vehicle   │         │
│  │   support   │  │ • Priority  │  │ • 24/7      │         │
│  │             │  │   support   │  │   support   │         │
│  │             │  │ • Schedule  │  │ • Driver    │         │
│  │             │  │   flex      │  │   preference│         │
│  │             │  │             │  │ • No surge  │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
└─────────────────────────────────────────────────────────────┘
```

**Plan Features Explained:**

| Plan | Trips/Day | Vehicle Type | Monthly Price |
|------|-----------|--------------|---------------|
| Basic | 1 | Economy (Sedan) | SAR 299 |
| Standard | 2 | Mid-range (Camry, Accord) | SAR 599 |
| Premium | 3 | Luxury (Mercedes, BMW) | SAR 999 |

### Step 4: Setting Up Your Schedule

After selecting a plan, user sets up their commute schedule:

**A. Set Pickup Location (Home)**
1. Search for address OR
2. Select on map OR
3. Use current location
4. Save as "Home"

**B. Set Drop-off Location (Office)**
1. Search for work address
2. Confirm on map
3. Save as "Work"

**C. Set Schedule**
```
┌─────────────────────────────────────────────────────────────┐
│                    SET YOUR SCHEDULE                         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Active Days:                                                │
│  ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐                │
│  │Mon│ │Tue│ │Wed│ │Thu│ │Fri│ │Sat│ │Sun│                │
│  │ ✓ │ │ ✓ │ │ ✓ │ │ ✓ │ │ ✓ │ │   │ │   │                │
│  └───┘ └───┘ └───┘ └───┘ └───┘ └───┘ └───┘                │
│                                                              │
│  Morning Pickup Time:    08:00 AM                           │
│  Evening Pickup Time:    05:30 PM                           │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Step 5: Making Payment

1. User sees order summary
2. Selects payment method:
   - Credit/Debit Card
   - Apple Pay
   - Wallet Balance
3. Confirms payment
4. Subscription activated!

### Step 6: Daily Usage (Home Screen)

Once subscribed, the passenger's home screen shows:

```
┌─────────────────────────────────────────────────────────────┐
│  Good Morning, Ahmed!                          🔔  ⚙️       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              YOUR NEXT TRIP                          │   │
│  │                                                      │   │
│  │   📍 Home → Office                                  │   │
│  │   🕐 Today, 08:00 AM                               │   │
│  │                                                      │   │
│  │   Driver: Ahmed Khan ⭐ 4.9                         │   │
│  │   Vehicle: Toyota Camry (White)                     │   │
│  │   Plate: ABC 1234                                   │   │
│  │                                                      │   │
│  │   [Track Driver] [Contact Driver] [Cancel]          │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │ 26 Trips     │  │ 20 Days      │  │ Standard     │     │
│  │ Remaining    │  │ Left         │  │ Plan         │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│                                                              │
│  Upcoming Trips                           [View All →]      │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ Today 5:30 PM  •  Office → Home  •  Scheduled       │   │
│  │ Tomorrow 8:00 AM  •  Home → Office  •  Scheduled    │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Step 7: During a Trip

**Trip Status Flow:**
```
Scheduled → Driver Assigned → Driver Arriving → In Progress → Completed
```

1. **Scheduled:** Trip is in the system, waiting for driver assignment
2. **Driver Assigned:** A driver has been assigned to your trip
3. **Driver Arriving:** Driver is on the way to pick you up
4. **In Progress:** You are in the car, traveling to destination
5. **Completed:** Trip finished successfully

**What Passenger Can Do During Trip:**
- Track driver location on map
- Call or message driver
- Share trip status with family
- Report an issue

### Step 8: After Trip Completion

1. Trip ends automatically when reaching destination
2. Passenger can rate the driver (1-5 stars)
3. Optionally leave feedback
4. Trip added to history

---

## Driver Side - Complete Flow

### Step 1: Becoming a Driver

**Who Can Become a Driver?**
- Any user of the app can apply to become a driver
- Must have valid Saudi driving license
- Must have a vehicle that meets requirements
- Must pass document verification

**Application Process:**

```
┌─────────────────────────────────────────────────────────────┐
│              BECOME A DRIVER - 4 STEPS                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   Step 1          Step 2         Step 3         Step 4      │
│  ┌──────┐       ┌──────┐       ┌──────┐       ┌──────┐     │
│  │  1   │ ───→  │  2   │ ───→  │  3   │ ───→  │  4   │     │
│  └──────┘       └──────┘       └──────┘       └──────┘     │
│  Personal       Vehicle        Documents       Review &     │
│  Info           Info           Upload          Submit       │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**Step 1: Personal Information**
- Verify name, phone, email
- Enter driving license number

**Step 2: Vehicle Information**
- Vehicle type (Economy/Mid/Luxury)
- Vehicle model (e.g., Toyota Camry 2024)
- License plate number
- Vehicle color

**Step 3: Document Upload**
- Driving license photo
- Vehicle insurance document
- Vehicle photo

**Step 4: Review & Submit**
- Review all information
- Agree to terms and conditions
- Submit application

**After Submission:**
- Application reviewed within 24-48 hours
- Notification sent when approved
- Can start receiving trips once approved

### Step 2: Driver Home Screen

Once approved, driver sees their dashboard:

```
┌─────────────────────────────────────────────────────────────┐
│  Welcome back, Ahmed!                          🔔  ⚙️       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  🟢 You are Online                        [Toggle]   │   │
│  │     Ready to receive trips                           │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                              │
│  Today's Summary                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │   5          │  │  SAR 350     │  │   4.8 ⭐     │     │
│  │   Trips      │  │  Earnings    │  │   Rating     │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│                                                              │
│  Assigned Trips                           [View All →]      │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ 🕐 08:30 AM                                         │   │
│  │ 📍 Al Olaya District → King Fahd University        │   │
│  │ 👤 Passenger                    SAR 45             │   │
│  │ [Start Trip]                    [Decline]          │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                              │
│  Quick Actions                                               │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                 │
│  │ Earnings │  │ My Trips │  │ Support  │                 │
│  └──────────┘  └──────────┘  └──────────┘                 │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Step 3: Going Online/Offline

**Online Status:**
- Toggle switch to go online/offline
- When **Online**: Can receive trip assignments
- When **Offline**: Won't receive new trips
- When **Busy**: Currently on a trip

```
Driver Status Flow:
Offline ←→ Online → Busy (during trip) → Online
```

### Step 4: Receiving Trip Assignments

When admin assigns a trip to driver:

1. Driver receives notification
2. Trip appears in "Assigned Trips" list
3. Driver can see:
   - Pickup time
   - Pickup location
   - Drop-off location
   - Estimated fare
   - Passenger name

**Driver Options:**
- **Accept:** Keep the assignment (default)
- **Decline:** Reject the trip (affects acceptance rate)

### Step 5: Completing a Trip

**Trip Workflow for Driver:**

```
┌─────────────────────────────────────────────────────────────┐
│                     TRIP WORKFLOW                            │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. ASSIGNED                                                 │
│     │  Trip assigned by admin                               │
│     │  Driver sees trip details                             │
│     ↓                                                        │
│  2. START TRIP                                               │
│     │  Driver clicks "Start Trip"                           │
│     │  Status changes to "Driver Arriving"                  │
│     │  Passenger gets notification                          │
│     ↓                                                        │
│  3. PICK UP PASSENGER                                        │
│     │  Driver arrives at pickup point                       │
│     │  Clicks "Picked Up" / "Start Ride"                    │
│     │  Status changes to "In Progress"                      │
│     ↓                                                        │
│  4. DROP OFF PASSENGER                                       │
│     │  Driver arrives at destination                        │
│     │  Clicks "Complete Trip"                               │
│     │  Status changes to "Completed"                        │
│     ↓                                                        │
│  5. TRIP COMPLETED                                           │
│     │  Earnings added to driver's account                   │
│     │  Passenger can rate driver                            │
│     │  Driver ready for next trip                           │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Step 6: Managing Trips

**Driver Trips Screen - 3 Tabs:**

```
┌─────────────────────────────────────────────────────────────┐
│  My Trips                                                    │
├───────────────┬───────────────┬─────────────────────────────┤
│   Upcoming    │    Active     │        Completed            │
├───────────────┴───────────────┴─────────────────────────────┤
│                                                              │
│  UPCOMING: Trips assigned for future                        │
│  - Shows time, locations, passenger info                    │
│  - Can decline if needed                                    │
│  - Can start when it's time                                 │
│                                                              │
│  ACTIVE: Trip currently in progress                         │
│  - Shows navigation to destination                          │
│  - Can contact passenger                                    │
│  - Can complete trip                                        │
│                                                              │
│  COMPLETED: Past trips history                              │
│  - Shows trip details                                       │
│  - Shows rating received                                    │
│  - Shows earnings                                           │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Step 7: Tracking Earnings

**Earnings Screen Shows:**

```
┌─────────────────────────────────────────────────────────────┐
│  Earnings                                                    │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│                    Total Earnings                            │
│                     SAR 2,450                                │
│                    This Week                                 │
│                                                              │
│  ┌─────────────┬─────────────┬─────────────┐               │
│  │   Today     │  This Week  │ This Month  │               │
│  └─────────────┴─────────────┴─────────────┘               │
│                                                              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                  │
│  │ 45 Trips │  │ 32.5 Hrs │  │ SAR 54   │                  │
│  │          │  │ Online   │  │ Avg/Trip │                  │
│  └──────────┘  └──────────┘  └──────────┘                  │
│                                                              │
│  Earnings Breakdown                                          │
│  ├── Trip Earnings    SAR 2,200  ████████████░░  85%       │
│  ├── Tips             SAR 250    ██░░░░░░░░░░░░  10%       │
│  └── Bonuses          SAR 100    █░░░░░░░░░░░░░   5%       │
│                                                              │
│  Platform Fee (10%)            - SAR 100                    │
│  ─────────────────────────────────────────                  │
│  Net Earnings                    SAR 2,450                  │
│                                                              │
│  [Withdraw Earnings]                                         │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**Earnings Calculation:**
```
Trip Fare: SAR 50
Platform Fee (10%): - SAR 5
Driver Earnings: SAR 45

Total Weekly = Sum of all trip earnings - Platform fees + Tips + Bonuses
```

---

## How Passenger and Driver Connect

### The Matching Process

```
┌─────────────────────────────────────────────────────────────┐
│                  TRIP ASSIGNMENT FLOW                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  PASSENGER                    SYSTEM                DRIVER   │
│      │                          │                      │     │
│      │  Subscribes to plan      │                      │     │
│      │  Sets schedule           │                      │     │
│      │ ──────────────────────→  │                      │     │
│      │                          │                      │     │
│      │                    Creates daily                │     │
│      │                    trip records                 │     │
│      │                          │                      │     │
│      │                    Admin assigns   ───────────→ │     │
│      │                    driver to trip               │     │
│      │                          │                      │     │
│      │  ←─────────────────      │      ─────────────→  │     │
│      │  Gets notification       │      Gets assignment │     │
│      │  "Driver assigned"       │                      │     │
│      │                          │                      │     │
│      │                          │      Starts trip     │     │
│      │  ←─────────────────      │  ←─────────────────  │     │
│      │  "Driver arriving"       │                      │     │
│      │                          │                      │     │
│      │     PASSENGER IN CAR     │                      │     │
│      │  ←─────────────────────────────────────────────→│     │
│      │                          │                      │     │
│      │                          │      Completes trip  │     │
│      │  ←─────────────────      │  ←─────────────────  │     │
│      │  "Trip completed"        │      Earnings added  │     │
│      │  Rate your driver        │                      │     │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Real-Time Communication

**Passenger Can:**
- See driver location on map
- Call driver directly
- Send message to driver
- Share trip status

**Driver Can:**
- See pickup/dropoff locations on map
- Call passenger for directions
- Navigate using in-app maps
- Mark arrival at locations

---

## Subscription Plans Explained

### Plan Comparison

| Feature | Basic | Standard | Premium |
|---------|-------|----------|---------|
| **Price/Month** | SAR 299 | SAR 599 | SAR 999 |
| **Trips Per Day** | 1 | 2 | 3 |
| **Total Monthly Trips** | 20 | 40 | 60 |
| **Vehicle Type** | Economy | Mid-range | Luxury |
| **Support** | Standard | Priority | 24/7 VIP |
| **Schedule Flexibility** | Fixed | Flexible | Very Flexible |
| **Driver Preference** | No | No | Yes |
| **Surge Protection** | No | No | Yes |

### How Trips Work

**Example: Standard Plan (2 trips/day)**
```
Morning Trip: Home → Office (8:00 AM)
Evening Trip: Office → Home (5:30 PM)

Monthly Allocation: 40 trips (20 days × 2 trips)
Used: 14 trips
Remaining: 26 trips
```

### Vehicle Types

| Type | Examples | Comfort Level | Price Multiplier |
|------|----------|---------------|------------------|
| Economy | Hyundai Accent, Nissan Sunny | Basic | 1.0x |
| Mid-range | Toyota Camry, Honda Accord | Comfortable | 1.3x |
| Luxury | Mercedes E-Class, BMW 5 Series | Premium | 1.8x |

---

## Trip Lifecycle

### Complete Trip Status Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    TRIP STATUS FLOW                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────┐                                               │
│  │SCHEDULED │  Trip created from subscription schedule      │
│  └────┬─────┘                                               │
│       │                                                      │
│       ↓                                                      │
│  ┌──────────────┐                                           │
│  │DRIVER        │  Admin assigns a driver to the trip       │
│  │ASSIGNED      │                                           │
│  └────┬─────────┘                                           │
│       │                                                      │
│       ↓                                                      │
│  ┌──────────────┐                                           │
│  │DRIVER        │  Driver starts heading to pickup          │
│  │ARRIVING      │                                           │
│  └────┬─────────┘                                           │
│       │                                                      │
│       ↓                                                      │
│  ┌──────────────┐                                           │
│  │IN PROGRESS   │  Passenger picked up, en route            │
│  │              │                                           │
│  └────┬─────────┘                                           │
│       │                                                      │
│       ├────────────────────→  ┌───────────┐                 │
│       │  Normal completion    │ COMPLETED │                 │
│       │                       └───────────┘                 │
│       │                                                      │
│       ├────────────────────→  ┌───────────┐                 │
│       │  Passenger cancels    │ CANCELLED │                 │
│       │                       └───────────┘                 │
│       │                                                      │
│       └────────────────────→  ┌───────────┐                 │
│          Passenger not found  │ NO SHOW   │                 │
│                               └───────────┘                 │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Status Descriptions

| Status | Description | Who Can See |
|--------|-------------|-------------|
| Scheduled | Trip is planned, no driver yet | Passenger |
| Driver Assigned | Driver allocated to this trip | Both |
| Driver Arriving | Driver en route to pickup | Both |
| In Progress | Passenger in car, traveling | Both |
| Completed | Trip finished successfully | Both |
| Cancelled | Trip was cancelled | Both |
| No Show | Passenger didn't appear | Both |

---

## Earnings and Payments

### For Passengers

**Payment Flow:**
```
Select Plan → Add Payment Method → Pay Monthly → Subscription Active
```

**Payment Methods Accepted:**
- Credit Card (Visa, MasterCard)
- Debit Card (Mada)
- Apple Pay
- Wallet Balance

**Subscription Renewal:**
- Auto-renews monthly
- Can cancel anytime
- Unused trips don't carry over

### For Drivers

**Earnings Flow:**
```
Complete Trip → Fare Calculated → Platform Fee Deducted → Added to Wallet
```

**Earnings Breakdown:**
```
Gross Trip Fare:     SAR 50.00
Platform Fee (10%): -SAR  5.00
──────────────────────────────
Net Earnings:        SAR 45.00
```

**Additional Earnings:**
- **Tips:** Passengers can tip after trip
- **Bonuses:** Weekly completion bonuses
- **Incentives:** Peak hour multipliers

**Withdrawal:**
- Minimum withdrawal: SAR 100
- Withdrawal to bank account
- Processing time: 1-3 business days

---

## App Screens Overview

### Passenger Screens

| Screen | Purpose |
|--------|---------|
| **Splash** | App loading, authentication check |
| **Onboarding** | Welcome screens for new users |
| **Login** | Phone number + OTP authentication |
| **Home** | Dashboard with next trip, stats |
| **Plans** | Browse and select subscription plans |
| **Checkout** | Payment and plan confirmation |
| **My Trips** | View upcoming and past trips |
| **Trip Details** | Single trip information |
| **Trip Tracking** | Live map during trip |
| **Profile** | User information, preferences |
| **Settings** | App settings, notifications |
| **Support** | Help center, contact |
| **Notifications** | Trip updates, alerts |

### Driver Screens

| Screen | Purpose |
|--------|---------|
| **Driver Home** | Dashboard with status, trips, earnings |
| **Driver Trips** | Upcoming, active, completed trips |
| **Driver Earnings** | Earnings breakdown, withdrawal |
| **Driver Profile** | Driver info, vehicle details |
| **Driver Registration** | Apply to become a driver |

---

## Technical Architecture (Simplified)

### How Data is Stored

```
┌─────────────────────────────────────────────────────────────┐
│                    FIREBASE (Cloud Database)                 │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  USERS Collection                                            │
│  ├── user_001                                               │
│  │   ├── name: "Ahmed"                                      │
│  │   ├── email: "ahmed@email.com"                           │
│  │   ├── phone: "+966501234567"                             │
│  │   ├── role: "passenger" or "driver"                      │
│  │   └── ...                                                │
│  └── user_002                                               │
│      └── ...                                                │
│                                                              │
│  SUBSCRIPTIONS Collection                                    │
│  ├── sub_001                                                │
│  │   ├── userId: "user_001"                                 │
│  │   ├── planId: "standard"                                 │
│  │   ├── startDate: "2024-01-01"                           │
│  │   ├── endDate: "2024-01-31"                             │
│  │   ├── status: "active"                                   │
│  │   └── ...                                                │
│  └── ...                                                    │
│                                                              │
│  TRIPS Collection                                            │
│  ├── trip_001                                               │
│  │   ├── passengerId: "user_001"                            │
│  │   ├── driverId: "driver_001"                             │
│  │   ├── pickupLocation: {...}                              │
│  │   ├── dropoffLocation: {...}                             │
│  │   ├── scheduledTime: "2024-01-15 08:00"                 │
│  │   ├── status: "completed"                                │
│  │   └── ...                                                │
│  └── ...                                                    │
│                                                              │
│  PLANS Collection                                            │
│  ├── basic                                                  │
│  ├── standard                                               │
│  └── premium                                                │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### How App Communicates

```
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│              │         │              │         │              │
│  PASSENGER   │ ←─────→ │   FIREBASE   │ ←─────→ │    DRIVER    │
│     APP      │         │    SERVER    │         │     APP      │
│              │         │              │         │              │
└──────────────┘         └──────────────┘         └──────────────┘
        │                       │                        │
        │   1. User signs up    │                        │
        │ ──────────────────→   │                        │
        │                       │                        │
        │   2. Subscribes       │                        │
        │ ──────────────────→   │                        │
        │                       │                        │
        │   3. Creates trips    │                        │
        │ ──────────────────→   │                        │
        │                       │                        │
        │                       │  4. Assigns driver     │
        │                       │ ──────────────────→    │
        │                       │                        │
        │   5. Real-time        │   5. Real-time        │
        │      updates          │      updates          │
        │ ←────────────────→    │ ←────────────────→    │
        │                       │                        │
```

### Real-Time Features

The app uses **Firebase Realtime** features for:
- Trip status updates
- Driver location tracking
- Notifications
- Chat messages

This means when something changes (like trip status), both passenger and driver see the update **instantly** without refreshing.

---

## Data Flow Diagrams

### New User Registration Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    REGISTRATION FLOW                         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  USER                        APP                   SERVER    │
│    │                          │                       │      │
│    │  Opens app               │                       │      │
│    │ ──────────────────────→  │                       │      │
│    │                          │                       │      │
│    │  Enters phone number     │                       │      │
│    │ ──────────────────────→  │                       │      │
│    │                          │  Request OTP          │      │
│    │                          │ ────────────────────→ │      │
│    │                          │                       │      │
│    │                          │  OTP sent via SMS     │      │
│    │  ←─────────────────────────────────────────────  │      │
│    │                          │                       │      │
│    │  Enters OTP              │                       │      │
│    │ ──────────────────────→  │                       │      │
│    │                          │  Verify OTP           │      │
│    │                          │ ────────────────────→ │      │
│    │                          │                       │      │
│    │                          │  OTP Valid            │      │
│    │                          │ ←──────────────────── │      │
│    │                          │                       │      │
│    │  Fills profile           │                       │      │
│    │ ──────────────────────→  │                       │      │
│    │                          │  Create user account  │      │
│    │                          │ ────────────────────→ │      │
│    │                          │                       │      │
│    │  Registration complete!  │                       │      │
│    │ ←──────────────────────  │                       │      │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Subscription Purchase Flow

```
┌─────────────────────────────────────────────────────────────┐
│                   SUBSCRIPTION FLOW                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. USER SELECTS PLAN                                        │
│     │                                                        │
│     ↓                                                        │
│  2. SETS LOCATIONS                                           │
│     ├── Pickup location (Home)                              │
│     └── Dropoff location (Office)                           │
│     │                                                        │
│     ↓                                                        │
│  3. SETS SCHEDULE                                            │
│     ├── Active days (Mon-Fri)                               │
│     ├── Morning time (8:00 AM)                              │
│     └── Evening time (5:30 PM)                              │
│     │                                                        │
│     ↓                                                        │
│  4. PAYMENT                                                  │
│     ├── Enter card details                                  │
│     ├── Confirm payment                                     │
│     └── Payment processed                                   │
│     │                                                        │
│     ↓                                                        │
│  5. SUBSCRIPTION ACTIVATED                                   │
│     ├── Create subscription record                          │
│     ├── Generate trip schedule                              │
│     └── User can see upcoming trips                         │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Daily Trip Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    DAILY TRIP FLOW                           │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  MORNING (e.g., 7:30 AM - 30 mins before pickup)            │
│  ├── System checks scheduled trips                          │
│  ├── Admin assigns available driver                         │
│  └── Both passenger & driver notified                       │
│                                                              │
│  PICKUP TIME (e.g., 8:00 AM)                                │
│  ├── Driver goes online                                     │
│  ├── Starts trip (status: Driver Arriving)                  │
│  ├── Navigates to pickup location                           │
│  └── Passenger sees driver location on map                  │
│                                                              │
│  DRIVER ARRIVES                                              │
│  ├── Driver reaches pickup point                            │
│  ├── Passenger gets "Driver arrived" notification           │
│  └── Passenger boards vehicle                               │
│                                                              │
│  DURING TRIP                                                 │
│  ├── Status changes to "In Progress"                        │
│  ├── Passenger can track on map                             │
│  └── Driver navigates to destination                        │
│                                                              │
│  ARRIVAL AT DESTINATION                                      │
│  ├── Driver marks trip complete                             │
│  ├── Passenger exits vehicle                                │
│  ├── Status changes to "Completed"                          │
│  └── Passenger can rate & tip driver                        │
│                                                              │
│  EVENING (Repeat process for return trip)                   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Glossary

| Term | Definition |
|------|------------|
| **OTP** | One-Time Password - a code sent to verify your phone |
| **Subscription** | Monthly plan that gives you a set number of trips |
| **Trip** | A single ride from pickup to dropoff |
| **Driver Status** | Whether a driver is online, offline, or busy |
| **Trip Status** | Current state of a trip (scheduled, in progress, etc.) |
| **Fare** | The cost of a single trip |
| **Platform Fee** | Percentage taken by the app from driver earnings |
| **Wallet** | In-app balance for payments or earnings |
| **Rating** | 1-5 star score given after trip completion |

---

## Frequently Asked Questions

### For Passengers

**Q: Can I cancel a trip?**
A: Yes, you can cancel a scheduled trip. However, frequent cancellations may affect your account.

**Q: What if my driver doesn't show up?**
A: Contact support immediately. The trip will be marked as driver no-show and you won't lose a trip from your allocation.

**Q: Can I change my pickup/dropoff locations?**
A: Yes, you can update your saved locations in the app settings.

**Q: What happens to unused trips?**
A: Unused trips do not carry over to the next month. Try to use all your allocated trips.

### For Drivers

**Q: How do I get paid?**
A: Earnings are added to your in-app wallet after each completed trip. You can withdraw to your bank account anytime.

**Q: Can I reject a trip?**
A: Yes, but rejecting too many trips will affect your acceptance rate, which impacts future assignments.

**Q: What if the passenger doesn't show up?**
A: Wait for 5 minutes, then mark as "No Show". You'll receive a partial payment.

**Q: How is my rating calculated?**
A: Your rating is the average of all ratings received from passengers in the last 100 trips.

---

## Contact & Support

- **In-App Support:** Profile → Help Center
- **Email:** support@driverapp.com
- **Phone:** +966 XX XXX XXXX
- **Working Hours:** 24/7

---

## Project Structure

### Folder Organization

```
driverapp/
│
├── lib/                              # Main source code
│   │
│   ├── main.dart                     # App entry point
│   │
│   ├── config/                       # Configuration files
│   │   └── routes.dart               # All app routes defined here
│   │
│   ├── core/                         # Core/shared utilities
│   │   ├── animations/               # Reusable animations
│   │   │   ├── fade_animation.dart
│   │   │   ├── slide_animation.dart
│   │   │   └── staggered_animation.dart
│   │   │
│   │   ├── constants/                # App constants
│   │   │   └── app_constants.dart    # API URLs, collection names
│   │   │
│   │   ├── enums/                    # Enumerations
│   │   │   └── enums.dart            # UserRole, TripStatus, etc.
│   │   │
│   │   └── theme/                    # App theming
│   │       └── app_colors.dart       # Color palette
│   │
│   ├── data/                         # Data layer
│   │   ├── models/                   # Data models
│   │   │   ├── user_model.dart       # User data structure
│   │   │   ├── trip_model.dart       # Trip data structure
│   │   │   ├── subscription_model.dart
│   │   │   ├── plan_model.dart
│   │   │   ├── address_model.dart
│   │   │   └── schedule_model.dart
│   │   │
│   │   ├── providers/                # Riverpod providers
│   │   │   └── providers.dart        # All state providers
│   │   │
│   │   └── services/                 # Backend services
│   │       ├── auth_service.dart     # Authentication logic
│   │       ├── firestore_service.dart # Database operations
│   │       └── cache_service.dart    # Local caching
│   │
│   └── presentation/                 # UI layer
│       ├── screens/                  # All screens
│       │   │
│       │   ├── splash/               # Splash screen
│       │   │   └── splash_screen.dart
│       │   │
│       │   ├── onboarding/           # Welcome screens
│       │   │   └── onboarding_screen.dart
│       │   │
│       │   ├── auth/                 # Authentication
│       │   │   ├── login_screen.dart
│       │   │   └── otp_screen.dart
│       │   │
│       │   ├── home/                 # Main passenger screen
│       │   │   └── home_screen.dart
│       │   │
│       │   ├── plans/                # Subscription plans
│       │   │   ├── plans_screen.dart
│       │   │   └── checkout_screen.dart
│       │   │
│       │   ├── trips/                # Trip management
│       │   │   ├── trips_screen.dart
│       │   │   ├── trip_details_screen.dart
│       │   │   └── trip_tracking_screen.dart
│       │   │
│       │   ├── profile/              # User profile
│       │   │   └── profile_screen.dart
│       │   │
│       │   ├── settings/             # App settings
│       │   │   └── settings_screen.dart
│       │   │
│       │   └── driver/               # Driver-specific screens
│       │       ├── driver_home_screen.dart
│       │       ├── driver_trips_screen.dart
│       │       ├── driver_earnings_screen.dart
│       │       ├── driver_profile_screen.dart
│       │       └── driver_registration_screen.dart
│       │
│       └── widgets/                  # Reusable widgets
│           └── common/
│               └── shimmer_loading.dart
│
├── assets/                           # Static assets
│   ├── icon/                         # App icons
│   └── splash/                       # Splash images
│
├── android/                          # Android-specific code
├── ios/                              # iOS-specific code
│
├── docs/                             # Documentation
│   └── COMPLETE_APP_FLOW.md          # This file
│
├── pubspec.yaml                      # Dependencies & config
└── README.md                         # Project readme
```

### Key Files Explained

| File | Purpose |
|------|---------|
| `main.dart` | App starts here, initializes Firebase, sets up providers |
| `routes.dart` | Defines all navigation routes and transitions |
| `enums.dart` | All status types (UserRole, TripStatus, DriverStatus, etc.) |
| `app_colors.dart` | Color palette used throughout the app |
| `providers.dart` | All Riverpod providers for state management |
| `firestore_service.dart` | All Firebase database operations |
| `auth_service.dart` | Login, logout, OTP verification |

---

## Database Schema

### Firestore Collections

```
┌─────────────────────────────────────────────────────────────┐
│                    FIRESTORE DATABASE                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  📁 users                     (User accounts)               │
│  📁 plans                     (Subscription plans)          │
│  📁 subscriptions             (User subscriptions)          │
│  📁 trips                     (All trip records)            │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Collection: `users`

Stores all user information (both passengers and drivers).

```javascript
// Document ID: Firebase Auth UID
{
  // Basic Info
  "id": "user_abc123",
  "name": "Ahmed Mohammed",
  "email": "ahmed@email.com",
  "phone": "+966501234567",
  "profileImageUrl": "https://...",

  // Role & Status
  "role": "passenger",           // "passenger" | "driver" | "admin"
  "isVerified": true,
  "isActive": true,

  // Preferences (for passengers)
  "preferredDriverGender": "noPreference",  // "male" | "female" | "noPreference"
  "preferredVehicleType": "mid",            // "economy" | "mid" | "luxury"

  // Driver-specific fields (only for drivers)
  "vehicleModel": "Toyota Camry 2024",
  "vehiclePlate": "ABC 1234",
  "vehicleColor": "White",
  "vehicleType": "mid",
  "driverStatus": "online",      // "online" | "offline" | "busy"
  "driverRating": 4.8,
  "totalTrips": 156,
  "licenseNumber": "DL123456",

  // Location (for drivers when online)
  "currentLatitude": 24.7136,
  "currentLongitude": 46.6753,
  "locationUpdatedAt": Timestamp,

  // Timestamps
  "createdAt": Timestamp,
  "updatedAt": Timestamp
}
```

### Collection: `plans`

Stores available subscription plans.

```javascript
// Document ID: plan_basic, plan_standard, plan_premium
{
  "id": "plan_standard",
  "name": "Standard",
  "description": "Great for daily commuters",
  "type": "monthly",
  "durationDays": 30,
  "basePrice": 599.0,
  "tripsPerDay": 2,
  "features": [
    "2 trips per day",
    "Mid-range vehicle",
    "Priority support",
    "Schedule flexibility"
  ],
  "isPopular": true,
  "isActive": true,
  "sortOrder": 2
}
```

### Collection: `subscriptions`

Stores user subscription records.

```javascript
// Document ID: Auto-generated
{
  "id": "sub_xyz789",
  "userId": "user_abc123",
  "planId": "plan_standard",
  "planName": "Standard",
  "planType": "monthly",

  // Status
  "status": "active",           // "pending" | "active" | "paused" | "cancelled" | "expired"

  // Dates
  "startDate": Timestamp,
  "endDate": Timestamp,
  "pausedAt": null,
  "cancelledAt": null,
  "cancellationReason": null,

  // Preferences
  "vehicleType": "mid",
  "driverGender": "noPreference",

  // Schedule
  "schedule": {
    "activeDays": ["monday", "tuesday", "wednesday", "thursday", "friday"],
    "pickupTime": "08:00",
    "returnPickupTime": "17:30",
    "pickupLocation": {
      "id": "addr_1",
      "title": "Home",
      "address": "123 Main St, Riyadh",
      "latitude": 24.7136,
      "longitude": 46.6753,
      "type": "home"
    },
    "dropoffLocation": {
      "id": "addr_2",
      "title": "Office",
      "address": "456 Business Ave, Riyadh",
      "latitude": 24.7236,
      "longitude": 46.6853,
      "type": "work"
    }
  },

  // Trip Tracking
  "totalTrips": 40,             // Total allocated
  "usedTrips": 14,              // Used so far

  // Pricing
  "basePrice": 599.0,
  "discount": 0.0,
  "finalPrice": 599.0,

  // Timestamps
  "createdAt": Timestamp,
  "updatedAt": Timestamp
}
```

### Collection: `trips`

Stores all trip records.

```javascript
// Document ID: Auto-generated
{
  "id": "trip_def456",
  "userId": "user_abc123",          // Passenger ID
  "subscriptionId": "sub_xyz789",

  // Schedule
  "scheduledTime": Timestamp,

  // Locations
  "pickupLocation": {
    "id": "addr_1",
    "title": "Home",
    "address": "123 Main St, Riyadh",
    "latitude": 24.7136,
    "longitude": 46.6753,
    "type": "home"
  },
  "dropoffLocation": {
    "id": "addr_2",
    "title": "Office",
    "address": "456 Business Ave, Riyadh",
    "latitude": 24.7236,
    "longitude": 46.6853,
    "type": "work"
  },check

  // Status
  "status": "completed",
  // Possible values:
  // "scheduled"      - Trip created, no driver yet
  // "driverAssigned" - Driver assigned
  // "driverArriving" - Driver on the way
  // "inProgress"     - Passenger in car
  // "completed"      - Trip finished
  // "cancelled"      - Trip cancelled
  // "noShow"         - Passenger didn't show up

  // Vehicle
  "vehicleType": "mid",

  // Driver Info (when assigned)
  "driverId": "driver_001",
  "driverName": "Mohammed Ali",
  "vehicleNumber": "ABC 1234",
  "vehicleModel": "Toyota Camry",
  "vehicleColor": "White",
  "driverRating": 4.9,

  // Actual Times
  "actualPickupTime": Timestamp,
  "actualDropoffTime": Timestamp,

  // Trip Details
  "fare": 45.0,
  "distanceKm": 12.5,
  "estimatedMinutes": 25,

  // Rating & Feedback
  "rating": 5.0,
  "feedback": "Great driver, very punctual!",

  // Timestamps
  "createdAt": Timestamp,
  "updatedAt": Timestamp
}
```

### Database Relationships

```
┌─────────────────────────────────────────────────────────────┐
│                  DATABASE RELATIONSHIPS                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│                     ┌──────────────┐                        │
│                     │    USERS     │                        │
│                     │   (id: PK)   │                        │
│                     └──────┬───────┘                        │
│                            │                                 │
│           ┌────────────────┼────────────────┐               │
│           │                │                │               │
│           ▼                ▼                ▼               │
│  ┌────────────────┐ ┌────────────┐  ┌────────────┐        │
│  │ SUBSCRIPTIONS  │ │   TRIPS    │  │   TRIPS    │        │
│  │  (userId: FK)  │ │(userId: FK)│  │(driverId:FK│        │
│  └───────┬────────┘ └────────────┘  └────────────┘        │
│          │                                                   │
│          │ references                                        │
│          ▼                                                   │
│  ┌────────────────┐                                         │
│  │     PLANS      │                                         │
│  │   (id: PK)     │                                         │
│  └────────────────┘                                         │
│                                                              │
│  Legend:                                                     │
│  PK = Primary Key (Document ID)                             │
│  FK = Foreign Key (Reference to another document)           │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Firestore Indexes Required

For efficient queries, these composite indexes are needed:

```
Collection: trips
├── Index 1: userId + scheduledTime + status
├── Index 2: driverId + scheduledTime
├── Index 3: driverId + status + scheduledTime
└── Index 4: status + scheduledTime

Collection: subscriptions
├── Index 1: userId + status
└── Index 2: userId + createdAt

Collection: users
└── Index 1: role + driverStatus + isActive
```

---

## Security Rules

### Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Users collection
    match /users/{userId} {
      // Users can read/write their own data
      allow read, write: if request.auth != null && request.auth.uid == userId;
      // Anyone authenticated can read driver profiles
      allow read: if request.auth != null && resource.data.role == 'driver';
    }

    // Plans collection (read-only for users)
    match /plans/{planId} {
      allow read: if request.auth != null;
      allow write: if false; // Only admin via console
    }

    // Subscriptions collection
    match /subscriptions/{subId} {
      allow read, write: if request.auth != null
        && resource.data.userId == request.auth.uid;
    }

    // Trips collection
    match /trips/{tripId} {
      // Passengers can read their trips
      allow read: if request.auth != null
        && (resource.data.userId == request.auth.uid
            || resource.data.driverId == request.auth.uid);
      // Drivers can update trip status
      allow update: if request.auth != null
        && resource.data.driverId == request.auth.uid;
    }
  }
}
```

---

## API Endpoints (Firebase Functions - Optional)

If using Cloud Functions for backend logic:

| Function | Trigger | Purpose |
|----------|---------|---------|
| `onUserCreate` | Auth trigger | Initialize user document |
| `createSubscription` | HTTP | Process new subscription |
| `assignDriver` | HTTP | Assign driver to trip |
| `sendNotification` | Firestore trigger | Send push notification |
| `calculateEarnings` | Scheduled | Daily earnings calculation |

---

## Environment Setup

### Required API Keys

```
┌─────────────────────────────────────────────────────────────┐
│                    REQUIRED API KEYS                         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. FIREBASE                                                 │
│     └── google-services.json (Android)                      │
│     └── GoogleService-Info.plist (iOS)                      │
│                                                              │
│  2. GOOGLE MAPS                                              │
│     └── Maps SDK for Android                                │
│     └── Maps SDK for iOS                                    │
│     └── Places API                                          │
│     └── Directions API                                      │
│                                                              │
│  3. STRIPE                                                   │
│     └── Publishable Key (client)                            │
│     └── Secret Key (server)                                 │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Configuration Files

| File | Platform | Purpose |
|------|----------|---------|
| `google-services.json` | Android | Firebase config |
| `GoogleService-Info.plist` | iOS | Firebase config |
| `android/app/src/main/AndroidManifest.xml` | Android | Permissions, API keys |
| `ios/Runner/Info.plist` | iOS | Permissions, API keys |

---

*Document Version: 1.0*
*Last Updated: February 2026*
*© Driver App - All Rights Reserved*
