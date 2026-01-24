import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../../core/constants/app_constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // TEST MODE: Set to true to bypass OTP verification for testing
  // Set to false for production
  static const bool testMode = true;
  static const String testOTP = '123456'; // Any OTP works in test mode

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Phone verification
  String? _verificationId;
  int? _resendToken;
  String? _testPhoneNumber; // Store phone for test mode

  // Send OTP to phone number
  Future<void> sendOTP({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
    required Function(PhoneAuthCredential credential) onAutoVerify,
  }) async {
    // TEST MODE: Skip actual OTP sending
    if (testMode) {
      _testPhoneNumber = phoneNumber;
      _verificationId = 'test-verification-id';
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      onCodeSent('test-verification-id');
      return;
    }

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: AppConstants.otpExpirySeconds),
        verificationCompleted: (PhoneAuthCredential credential) async {
          onAutoVerify(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _resendToken = resendToken;
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
        forceResendingToken: _resendToken,
      );
    } catch (e) {
      onError(e.toString());
    }
  }

  // Verify OTP and sign in
  // In test mode, returns null (bypasses Firebase entirely)
  Future<UserCredential?> verifyOTP(String otp) async {
    // TEST MODE: Accept any 6-digit OTP, skip Firebase auth
    if (testMode) {
      if (otp.length != 6) {
        throw Exception('Please enter a 6-digit OTP');
      }
      // No Firebase call needed - just return null to signal success
      await Future.delayed(const Duration(milliseconds: 300));
      return null;
    }

    if (_verificationId == null) {
      throw Exception('No verification ID found. Please request OTP again.');
    }

    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );

    return await _auth.signInWithCredential(credential);
  }

  // Check if we're in test mode
  bool get isTestMode => testMode;

  // Sign in with credential
  Future<UserCredential> signInWithCredential(
      PhoneAuthCredential credential) async {
    return await _auth.signInWithCredential(credential);
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Register with email and password
  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Check if user exists in Firestore
  Future<bool> userExists(String uid) async {
    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .get();
    return doc.exists;
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .get();

    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }
    return null;
  }

  // Create user in Firestore
  Future<void> createUser(UserModel user) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.id)
        .set(user.toFirestore());
  }

  // Update user in Firestore
  Future<void> updateUser(UserModel user) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.id)
        .update(user.toFirestore());
  }

  // Sign out
  Future<void> signOut() async {
    _verificationId = null;
    _resendToken = null;
    _testPhoneNumber = null;
    await _auth.signOut();
  }

  // Get test phone number (for test mode)
  String? get testPhoneNumber => _testPhoneNumber;

  // Delete account
  Future<void> deleteAccount() async {
    final user = currentUser;
    if (user != null) {
      // Delete user data from Firestore
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .delete();

      // Delete Firebase Auth user
      await user.delete();
    }
  }
}
