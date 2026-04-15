import 'package:flutter/material.dart';

import '../../dashboard/presentation/dashboard_page.dart';
import '../../items/presentation/items_page.dart';
import '../../profile/presentation/profile_page.dart';
import '../../transactions/presentation/transactions_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  // Menyimpan riwayat tab yang pernah dibuka
  final List<int> _tabHistory = [];

  late final List<Widget> _pages = const [
    DashboardPage(),
    ItemsPage(),
    TransactionsPage(),
    ProfilePage(),
  ];

  void _onDestinationSelected(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _tabHistory.add(_currentIndex);
      _currentIndex = index;
    });
  }

  void _handleBackPressed() {
    if (_tabHistory.isNotEmpty) {
      setState(() {
        _currentIndex = _tabHistory.removeLast();
      });
      return;
    }

    // Kalau tidak ada riwayat tapi masih bukan di tab home,
    // arahkan dulu ke home
    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Hanya boleh keluar app jika sedang di home dan tidak ada riwayat tab
      canPop: _currentIndex == 0 && _tabHistory.isEmpty,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _handleBackPressed();
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: NavigationBar(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: _onDestinationSelected,
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home_rounded),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.inventory_2_outlined),
                      selectedIcon: Icon(Icons.inventory_2_rounded),
                      label: 'Barang',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.receipt_long_outlined),
                      selectedIcon: Icon(Icons.receipt_long_rounded),
                      label: 'Transaksi',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person_outline_rounded),
                      selectedIcon: Icon(Icons.person_rounded),
                      label: 'Profil',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}