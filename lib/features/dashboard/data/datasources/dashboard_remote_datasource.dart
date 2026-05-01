import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/exceptions.dart';
import '../models/dashboard_model.dart';

abstract class DashboardRemoteDatasource {
  Future<DashboardModel> getDashboardData(String userId);
}

class DashboardRemoteDatasourceImpl implements DashboardRemoteDatasource {
  final FirebaseFirestore firestore;

  DashboardRemoteDatasourceImpl({required this.firestore});

  @override
  Future<DashboardModel> getDashboardData(String userId) async {
    try {
      // Ambil data user/akun
      final userDoc = await firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        throw ServerException('Data akun belum tersedia, coba lagi');
      }

      // Ambil 5 transaksi terbaru
      final txSnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .orderBy('date', descending: true)
          .limit(5)
          .get();

      final transactions = txSnapshot.docs
          .map(
            (doc) => TransactionSummaryModel.fromFirestore(doc.data(), doc.id),
          )
          .toList();

      return DashboardModel.fromFirestore(userDoc.data()!, transactions);
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Firebase error');
    }
  }
}
