import '../../domain/entities/dashboard_entity.dart';

class DashboardModel extends DashboardEntity {
  const DashboardModel({
    required super.userId,
    required super.fullName,
    required super.accountNumber,
    required super.balance,
    required super.recentTransactions,
  });

  factory DashboardModel.fromFirestore(
    Map<String, dynamic> data,
    List<TransactionSummaryModel> transactions,
  ) {
    return DashboardModel(
      userId: data['userId'] ?? '',
      fullName: data['fullName'] ?? '',
      accountNumber: data['accountNumber'] ?? '',
      balance: (data['balance'] ?? 0).toDouble(),
      recentTransactions: transactions,
    );
  }
}

class TransactionSummaryModel extends TransactionSummaryEntity {
  const TransactionSummaryModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.isDebit,
    required super.date,
  });

  factory TransactionSummaryModel.fromFirestore(
    Map<String, dynamic> data,
    String id,
  ) {
    return TransactionSummaryModel(
      id: id,
      title: data['title'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      isDebit: data['isDebit'] ?? true,
      date: (data['date'] as dynamic).toDate(),
    );
  }
}
