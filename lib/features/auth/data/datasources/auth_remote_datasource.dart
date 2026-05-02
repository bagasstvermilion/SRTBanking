import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:srtbanking/core/error/exceptions.dart';
import '../../../../core/utils/format_account_number.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String email,
    required String password,
    required String fullName,
  });
  Future<void> logout();
  UserModel? getCurrentUser();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDatasourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = credential.user!.uid;
      final doc = await firestore.collection('users').doc(uid).get();
      if (!doc.exists) throw ServerException('User data not found');
      return UserModel.fromFirestore(doc.data()!, uid);
    } on FirebaseAuthException catch (e) {
      throw ServerException(_mapAuthError(e.code));
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;
      final user = UserModel(uid: uid, email: email, fullName: fullName);

      // Pastikan await selesai sebelum return
      await firestore.collection('users').doc(uid).set({
        ...user.toMap(),
        'balance': 0.0,
        'accountNumber': _generateAccountNumber(uid),
      });

      // Verifikasi data sudah masuk
      final doc = await firestore.collection('users').doc(uid).get();
      if (!doc.exists) throw ServerException('Gagal menyimpan data user');

      return user;
    } on FirebaseAuthException catch (e) {
      throw ServerException(_mapAuthError(e.code));
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  UserModel? getCurrentUser() {
    final user = firebaseAuth.currentUser;
    if (user == null) return null;
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      fullName: user.displayName ?? '',
    );
  }

  String _generateAccountNumber(String uid) {
    final digits = uid.replaceAll(RegExp(r'[^0-9]'), '');

    final base = digits.length >= 8
        ? digits.substring(0, 8)
        : digits.padLeft(8, '0');

    final formatted = FormatAccountNumber.format(base);

    return '8800-$formatted';
  }

  String _mapAuthError(String code) => switch (code) {
    'user-not-found' => 'Email tidak terdaftar',
    'wrong-password' => 'Password salah',
    'email-already-in-use' => 'Email sudah digunakan',
    'weak-password' => 'Password minimal 6 karakter',
    'invalid-email' => 'Format email tidak valid',
    'too-many-requests' => 'Terlalu banyak percobaan, coba lagi nanti',
    'network-request-failed' => 'Tidak ada koneksi internet',
    _ => 'Terjadi kesalahan, coba lagi',
  };
}
