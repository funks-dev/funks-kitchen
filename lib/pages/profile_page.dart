import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/footer.dart';
import '../components/sidebar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final PageController _pageController = PageController();
  final int _currentPage = 0;
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? Colors.black : Colors.grey,
          ),
        );
      }),
    );
  }

  // Reusable Widget for Profile Options with Icons and Text
  Widget _buildProfileOption(IconData icon, String text) {
    return InkWell(
      onTap: () {
        // Handle onTap event for each option (e.g., navigate to a different page)
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFDA1E1E)),
            const SizedBox(width: 16),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      drawer: const Sidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Title
            const Text(
              'Profile',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 16),

            // Profile Picture and Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture
                CircleAvatar(
                  radius: 36,
                  backgroundImage: const AssetImage('assets/images/profile.png'), // replace with your asset path
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(width: 16),

                // User Info
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Budiono Siregar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'budiono.siregar55@gmail.com',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '+62 8561 1111 0099',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                // Settings Icon
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    // Add functionality for updating profile
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Divider line
            const Divider(),
            const SizedBox(height: 10),

            // Activity, Review, and Wishlist Section
            _buildProfileOption(Icons.history, 'Aktivitas'),
            _buildProfileOption(Icons.rate_review, 'Ulasan'),
            _buildProfileOption(Icons.favorite_border, 'Wishlist'),
            const Divider(),
            const SizedBox(height: 10),

            // Complaint Orders Section
            _buildProfileOption(Icons.report_problem, 'Pesanan Dikomplain'),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        isBackgroundVisible: true,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}