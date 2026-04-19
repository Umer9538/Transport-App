// Run: node scripts/seed_data.js
// Seeds subscription plans and promo codes into Firestore

const { initializeApp, applicationDefault } = require('firebase-admin/app');
const { getFirestore, Timestamp } = require('firebase-admin/firestore');

// Uses default credentials from: firebase login
process.env.GOOGLE_CLOUD_PROJECT = 'drive-app-780b3';
initializeApp({ projectId: 'drive-app-780b3' });

const db = getFirestore();

async function seed() {
  console.log('Seeding Firestore for project: drive-app-780b3\n');

  // ==================== PLANS ====================
  const plans = [
    {
      name: 'Basic',
      description: 'Perfect for occasional commuters',
      type: 'monthly',
      durationDays: 30,
      tripsPerDay: 1,
      basePrice: 299.0,
      features: ['1 trip per day', 'Economy vehicle', 'Standard support'],
      isPopular: false,
      isActive: true,
      sortOrder: 1,
      createdAt: Timestamp.now(),
    },
    {
      name: 'Standard',
      description: 'Great for daily commuters',
      type: 'monthly',
      durationDays: 30,
      tripsPerDay: 2,
      basePrice: 599.0,
      features: ['2 trips per day', 'Mid-range vehicle', 'Priority support', 'Schedule flexibility'],
      isPopular: true,
      isActive: true,
      sortOrder: 2,
      createdAt: Timestamp.now(),
    },
    {
      name: 'Premium',
      description: 'The ultimate commute experience',
      type: 'monthly',
      durationDays: 30,
      tripsPerDay: 3,
      basePrice: 999.0,
      features: ['3 trips per day', 'Luxury vehicle', '24/7 support', 'Driver preference', 'No surge pricing'],
      isPopular: false,
      isActive: true,
      sortOrder: 3,
      createdAt: Timestamp.now(),
    },
    {
      name: 'Weekly Basic',
      description: 'Try it for a week',
      type: 'weekly',
      durationDays: 7,
      tripsPerDay: 2,
      basePrice: 149.0,
      features: ['2 trips per day', 'Economy vehicle', '7-day plan'],
      isPopular: false,
      isActive: true,
      sortOrder: 4,
      createdAt: Timestamp.now(),
    },
  ];

  for (const plan of plans) {
    const existing = await db.collection('plans')
      .where('name', '==', plan.name)
      .limit(1)
      .get();

    if (existing.empty) {
      await db.collection('plans').add(plan);
      console.log(`  + Created plan: ${plan.name} (SAR ${plan.basePrice})`);
    } else {
      console.log(`  = Plan exists: ${plan.name}`);
    }
  }

  // ==================== PROMO CODES ====================
  const promos = [
    {
      code: 'WELCOME25',
      description: '25% off your first month',
      discountPercent: 25,
      maxDiscount: 100.0,
      isActive: true,
      expiresAt: Timestamp.fromDate(new Date(Date.now() + 90 * 24 * 60 * 60 * 1000)),
      createdAt: Timestamp.now(),
    },
    {
      code: 'UPGRADE20',
      description: '20% off when you upgrade your plan',
      discountPercent: 20,
      maxDiscount: 80.0,
      isActive: true,
      expiresAt: Timestamp.fromDate(new Date(Date.now() + 60 * 24 * 60 * 60 * 1000)),
      createdAt: Timestamp.now(),
    },
    {
      code: 'WEEKEND15',
      description: '15% weekend bonus discount',
      discountPercent: 15,
      maxDiscount: 60.0,
      isActive: true,
      expiresAt: Timestamp.fromDate(new Date(Date.now() + 30 * 24 * 60 * 60 * 1000)),
      createdAt: Timestamp.now(),
    },
  ];

  for (const promo of promos) {
    const existing = await db.collection('promoCodes')
      .where('code', '==', promo.code)
      .limit(1)
      .get();

    if (existing.empty) {
      await db.collection('promoCodes').add(promo);
      console.log(`  + Created promo: ${promo.code} (${promo.discountPercent}% off)`);
    } else {
      console.log(`  = Promo exists: ${promo.code}`);
    }
  }

  console.log('\n--- Seeding complete! ---');
  console.log('\nTo test the app:');
  console.log('  1. flutter run');
  console.log('  2. Register with any email');
  console.log('  3. Complete profile (name + phone)');
  console.log('  4. Browse plans, subscribe, set schedule');
  console.log('\nTo create an admin user:');
  console.log('  1. Register normally in the app');
  console.log('  2. Go to Firebase Console > Firestore > users/{uid}');
  console.log('  3. Edit the "role" field from "user" to "admin"');
  console.log('  4. Restart the app - you\'ll see the admin dashboard');
  console.log('\nTo create a driver:');
  console.log('  1. Register normally, then use driver registration in-app');
  console.log('  2. OR edit "role" to "driver" in Firebase Console');
}

seed().catch(console.error);
