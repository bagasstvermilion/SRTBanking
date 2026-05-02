import 'package:flutter/material.dart';
import 'package:srtbanking/features/auth/presentation/pages/login_page.dart';
import 'package:srtbanking/features/auth/presentation/pages/register_page.dart';
import 'package:srtbanking/features/dashboard/presentation/pages/main_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';

class AppRoutes {
  // Route names
  static const String dashboard = '/dashboard';
  static const String login = '/login';
  static const String register = '/register';

  // Route map
  static final Map<String, WidgetBuilder> routes = {
    dashboard: (_) => const MainPage(),
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
  };
}
