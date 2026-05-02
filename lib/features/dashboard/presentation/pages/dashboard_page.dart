import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:srtbanking/features/auth/presentation/state/auth_provider.dart';
import '../../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../state/dashboard_provider.dart';
import 'profile_menu_page.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Ganti dengan userId dari auth provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authProvider);
      if (authState is AuthAuthenticated) {
        ref.read(dashboardProvider.notifier).loadDashboard(authState.user.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.fromARGB(255, 231, 243, 255), Colors.white],
            ),
          ),
          child: switch (state) {
            DashboardLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            DashboardError(:final message) => _ErrorView(message: message),
            DashboardLoaded(:final data) => _DashboardContent(data: data),
            _ => const SizedBox.shrink(),
          },
        ),
      ),
    );
  }
}

// ─── Content ─────────────────────────────────────────────────────────────────

class _DashboardContent extends StatelessWidget {
  final DashboardEntity data;
  const _DashboardContent({required this.data});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(name: data.fullName),
            const SizedBox(height: 24),
            _BalanceCard(
              balance: data.balance,
              accountNumber: data.accountNumber,
            ),
            const SizedBox(height: 28),
            _QuickActions(),
            const SizedBox(height: 28),
            const Text(
              'Transaksi Terakhir',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...data.recentTransactions.map(
              (tx) => _TransactionTile(transaction: tx),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final String name;
  const _Header({required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selamat datang 👋',
              style: TextStyle(color: Colors.grey),
            ),
            Text(
              name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProfileMenuPage(name: name)),
          ),
          child: CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: Text(name.isNotEmpty ? name[0].toUpperCase() : 'U'),
          ),
        ),
      ],
    );
  }
}

// ─── Balance Card ─────────────────────────────────────────────────────────────

class _BalanceCard extends StatelessWidget {
  final double balance;
  final String accountNumber;
  const _BalanceCard({required this.balance, required this.accountNumber});

  @override
  Widget build(BuildContext context) {
    final formatted = CurrencyFormatter.formatCompact(balance);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Saldo Rekening',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Text(
            formatted,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            accountNumber,
            style: const TextStyle(color: Colors.white70, letterSpacing: 2),
          ),
        ],
      ),
    );
  }
}

// ─── Quick Actions ────────────────────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  final actions = const [
    {'icon': Icons.send, 'label': 'Transfer'},
    {'icon': Icons.receipt_long, 'label': 'Bayar'},
    {'icon': Icons.phone_android, 'label': 'Top Up'},
    {'icon': Icons.more_horiz, 'label': 'Lainnya'},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: actions.map((a) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: Icon(
                a['icon'] as IconData,
                color: const Color(0xFF1565C0),
              ),
            ),
            const SizedBox(height: 8),
            Text(a['label'] as String, style: const TextStyle(fontSize: 12)),
          ],
        );
      }).toList(),
    );
  }
}

// ─── Transaction Tile ─────────────────────────────────────────────────────────

class _TransactionTile extends StatelessWidget {
  final TransactionSummaryEntity transaction;
  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final color = transaction.isDebit ? Colors.red : Colors.green;
    final sign = transaction.isDebit ? '-' : '+';
    final formatted = CurrencyFormatter.formatCompact(transaction.amount);
    final date = DateFormat('dd MMM yyyy').format(transaction.date);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              transaction.isDebit ? Icons.arrow_upward : Icons.arrow_downward,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  date,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            '$sign $formatted',
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// ─── Error View ───────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
