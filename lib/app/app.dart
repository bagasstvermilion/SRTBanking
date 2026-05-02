import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srtbanking/features/dashboard/presentation/pages/main_page.dart';
import '../features/auth/presentation/state/auth_provider.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import 'routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SRT Banking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      routes: AppRoutes.routes,
      home: const _AuthGate(),
    );
  }
}

class _AuthGate extends ConsumerWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return switch (authState) {
      AuthInitial() || AuthLoading() => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      AuthAuthenticated() => const MainPage(),
      _ => const LoginPage(),
    };
  }
}
