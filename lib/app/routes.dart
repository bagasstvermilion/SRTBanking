import 'package:flutter/material.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';

class AppRoutes {
  // Route names
  static const String dashboard = '/';

  // Tambah route lain nanti di sini:
  // static const String login = '/login';
  // static const String transaction = '/transaction';
  // static const String transfer = '/transfer';

  // Route map
  static final Map<String, WidgetBuilder> routes = {
    dashboard: (_) => const DashboardPage(),

    // Nanti tinggal tambah:
    // login: (_) => const LoginPage(),
    // transaction: (_) => const TransactionPage(),
    // transfer: (_) => const TransferPage(),
  };
}
