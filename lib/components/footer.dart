import 'package:Funks_Kitchen/pages/profile_page.dart';
import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/menu_page.dart';

class CustomBottomNavigation extends StatefulWidget {
  final int selectedIndex; // To pass the selected index to this widget
  final ValueChanged<int> onItemTapped; // Callback to update the selected index
  final bool isBackgroundVisible; // Flag to toggle footer background visibility

  const CustomBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.isBackgroundVisible, // Accept the background visibility flag
  });

  @override
  _CustomBottomNavigationState createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60, // Reduced height
      margin: const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        color: widget.isBackgroundVisible ? const Color(0xFFDA1E1E) : Colors.transparent, // Red background visibility
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
            onTap: () {
              widget.onItemTapped(0);
              _navigateToPage(const HomePage());
            },
          ),
          _buildNavItem(
            icon: Icons.restaurant,
            index: 1,
            text: 'Menu',
            onTap: () {
              widget.onItemTapped(1);
              _navigateToPage(
                const MenuPage(initialIsFoodSelected: true),
              );
            },
          ),
          _buildNavItem(
            icon: Icons.receipt_rounded,
            index: 2,
            text: 'Order',
            onTap: () {
              // Logic for shopping cart page can be added here
            },
          ),
          _buildNavItem(
            icon: Icons.person,
            index: 3,
            text: 'Profile',
            onTap: () {
              widget.onItemTapped(3);
              _navigateToPage(
                const ProfilePage(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required String text,
    required VoidCallback onTap,
  }) {
    bool isSelected = widget.selectedIndex == index;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Container
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
          // Text Below Icon
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
    );
  }

  // Function to navigate to a page directly, replacing the current one
  void _navigateToPage(Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),  // Navigating directly
    );
  }
}
