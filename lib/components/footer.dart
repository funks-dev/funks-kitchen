import 'package:Funks_Kitchen/pages/order_page.dart';
import 'package:Funks_Kitchen/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../pages/home_page.dart';
import '../pages/menu_page.dart';

class CustomBottomNavigation extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final bool isBackgroundVisible;

  const CustomBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.isBackgroundVisible,
  });

  @override
  _CustomBottomNavigationState createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  DateTime? _lastNavigationTime;
  static const _cooldownDuration = Duration(milliseconds: 300); // Cooldown yang masuk akal
  bool _isProcessingNavigation = false;

  Future<void> _navigateToPage(int index, Widget page) async {
    // Cek apakah masih dalam cooldown
    final now = DateTime.now();
    if (_lastNavigationTime != null &&
        now.difference(_lastNavigationTime!) < _cooldownDuration) {
      return; // Masih dalam cooldown, abaikan tap
    }

    // Cek apakah sedang memproses navigasi
    if (_isProcessingNavigation) return;

    setState(() => _isProcessingNavigation = true);
    _lastNavigationTime = now;

    try {
      widget.onItemTapped(index);
      await Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 150), // Transisi lebih cepat
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessingNavigation = false);
      }
    }

    // Tunggu cooldown selesai
    await Future.delayed(_cooldownDuration);
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required String text,
    required Widget page,
  }) {
    bool isSelected = widget.selectedIndex == index;
    return GestureDetector(
      onTap: () => _navigateToPage(index, page),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 100),
        scale: _isProcessingNavigation ? 0.95 : 1.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.white70,
                size: 20,
              ),
            ),
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      margin: const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        color: widget.isBackgroundVisible ? const Color(0xFFDA1E1E) : Colors.transparent,
        boxShadow: widget.isBackgroundVisible
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ]
            : [],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            icon: Icons.home,
            index: 0,
            text: 'Home',
            page: const HomePage(),
          ),
          _buildNavItem(
            icon: Icons.restaurant,
            index: 1,
            text: 'Menu',
            page: const MenuPage(initialIsFoodSelected: true),
          ),
          _buildNavItem(
            icon: Icons.receipt_rounded,
            index: 2,
            text: 'Order',
            page: const OrderPage(),
          ),
          _buildNavItem(
            icon: Icons.person,
            index: 3,
            text: 'Profile',
            page: const ProfilePage(),
          ),
        ],
      ),
    );
  }
}