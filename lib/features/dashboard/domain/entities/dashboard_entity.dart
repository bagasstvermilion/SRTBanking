class DashboardEntity {
  final String userId;
  final String fullName;
  final String accountNumber;
  final double balance;
  final List<TransactionSummaryEntity> recentTransactions;

  const DashboardEntity({
    required this.userId,
    required this.fullName,
    required this.accountNumber,
    required this.balance,
    required this.recentTransactions,
  });
}

class TransactionSummaryEntity {
  final String id;
  final String title;
  final double amount;
  final bool isDebit;
  final DateTime date;

  const TransactionSummaryEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.isDebit,
    required this.date,
  });
}
