// Run with: dart run scripts/seed_firestore.dart
// Seeds initial data (plans, admin user) into Firestore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../lib/firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final firestore = FirebaseFirestore.instance;

  print('Seeding Firestore...');

  // ==================== SEED SUBSCRIPTION PLANS ====================
  final plans = [
    {
      'name': 'Basic',
      'description': 'Perfect for occasional commuters',
      'type': 'monthly',
      'durationDays': 30,
      'tripsPerDay': 1,
      'basePrice': 299.0,
      'features': ['1 trip per day', 'Economy vehicle', 'Standard support'],
      'isPopular': false,
      'isActive': true,
      'sortOrder': 1,
      'createdAt': Timestamp.now(),
    },
    {
      'name': 'Standard',
      'description': 'Great for daily commuters',
      'type': 'monthly',
      'durationDays': 30,
      'tripsPerDay': 2,
      'basePrice': 599.0,
      'features': ['2 trips per day', 'Mid-range vehicle', 'Priority support', 'Schedule flexibility'],
      'isPopular': true,
      'isActive': true,
      'sortOrder': 2,
      'createdAt': Timestamp.now(),
    },
    {
      'name': 'Premium',
      'description': 'The ultimate commute experience',
      'type': 'monthly',
      'durationDays': 30,
      'tripsPerDay': 3,
      'basePrice': 999.0,
      'features': ['3 trips per day', 'Luxury vehicle', '24/7 support', 'Driver preference', 'No surge pricing'],
      'isPopular': false,
      'isActive': true,
      'sortOrder': 3,
      'createdAt': Timestamp.now(),
    },
    {
      'name': 'Weekly Basic',
      'description': 'Try it for a week',
      'type': 'weekly',
      'durationDays': 7,
      'tripsPerDay': 2,
      'basePrice': 149.0,
      'features': ['2 trips per day', 'Economy vehicle', '7-day plan'],
      'isPopular': false,
      'isActive': true,
      'sortOrder': 4,
      'createdAt': Timestamp.now(),
    },
  ];

  for (final plan in plans) {
    // Check if plan already exists
    final existing = await firestore
        .collection('plans')
        .where('name', isEqualTo: plan['name'])
        .limit(1)
        .get();

    if (existing.docs.isEmpty) {
      await firestore.collection('plans').add(plan);
      print('  Created plan: ${plan['name']}');
    } else {
      print('  Plan already exists: ${plan['name']}');
    }
  }

  // ==================== SEED PROMO CODES ====================
  final promos = [
    {
      'code': 'WELCOME25',
      'description': '25% off your first month',
      'discountPercent': 25,
      'maxDiscount': 100.0,
      'isActive': true,
      'expiresAt': Timestamp.fromDate(DateTime.now().add(const Duration(days: 90))),
      'createdAt': Timestamp.now(),
    },
    {
      'code': 'UPGRADE20',
      'description': '20% off when you upgrade your plan',
      'discountPercent': 20,
      'maxDiscount': 80.0,
      'isActive': true,
      'expiresAt': Timestamp.fromDate(DateTime.now().add(const Duration(days: 60))),
      'createdAt': Timestamp.now(),
    },
  ];

  for (final promo in promos) {
    final existing = await firestore
        .collection('promoCodes')
        .where('code', isEqualTo: promo['code'])
        .limit(1)
        .get();

    if (existing.docs.isEmpty) {
      await firestore.collection('promoCodes').add(promo);
      print('  Created promo: ${promo['code']}');
    } else {
      print('  Promo already exists: ${promo['code']}');
    }
  }

  print('\nSeeding complete!');
  print('You can now test the app with:');
  print('  - 4 subscription plans (Basic, Standard, Premium, Weekly)');
  print('  - 2 promo codes (WELCOME25, UPGRADE20)');
  print('\nTo create an admin user:');
  print('  1. Register with email in the app');
  print('  2. In Firebase Console > Firestore > users/{uid}');
  print('  3. Change "role" field from "user" to "admin"');
}
