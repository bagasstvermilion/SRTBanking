import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard_page.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [DashboardPage(), _TransactionPlaceholder()];

  void _onQrisTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const _QrisPlaceholder()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF1565C0),
        onTap: (index) {
          if (index == 1) {
            _onQrisTap();
            return;
          }
          setState(() {
            _currentIndex = index == 2 ? 1 : index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Beranda",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: "QRIS"),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: "Transaksi",
          ),
        ],
      ),
    );
  }
}

class _TransactionPlaceholder extends StatelessWidget {
  const _TransactionPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: Center(child: Text("Halaman Transaksi")),
    );
  }
}

class _QrisPlaceholder extends StatelessWidget {
  const _QrisPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const Center(
            child: Text(
              'Kamera QRIS',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Positioned(
            top: 48,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
