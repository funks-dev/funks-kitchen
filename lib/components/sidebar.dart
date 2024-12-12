import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = Supabase.instance.client.auth.currentUser;  // Check current user

    return Drawer(
      child: Column(
        children: [
          // Main content of the Sidebar (Menu, etc.)
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color(0xFF202020),
                  ),
                  child: Image.asset('assets/images/funks_logo_header.png', height: 52, width: 60),
                ),
                ListTile(
                  leading: const Icon(Icons.home, color: Color(0xFFDA1E1E), size: 30),
                  title: const Text(
                    'Home',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.pushNamed(context, '/home_page'); // Navigate to the Home page
                  },
                ),
                ExpansionTile(
                  leading: const Icon(Icons.restaurant_menu, color: Color(0xFFDA1E1E), size: 30),
                  title: const Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  childrenPadding: const EdgeInsets.only(left: 40.0),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.local_dining, color: Color(0xFFDA1E1E)),
                      title: const Text('Foods'),
                      onTap: () {
                        Navigator.pop(context); // Close the drawer
                        Navigator.pushNamed(
                          context,
                          '/menu_page',
                          arguments: true, // Show food items
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.local_drink, color: Color(0xFFDA1E1E)),
                      title: const Text('Drinks'),
                      onTap: () {
                        Navigator.pop(context); // Close the drawer
                        Navigator.pushNamed(
                          context,
                          '/menu_page',
                          arguments: false, // Show drink items
                        );
                      },
                    ),
                  ],
                ),
                ListTile(
                  leading: const Icon(Icons.info, color: Color(0xFFDA1E1E), size: 30),
                  title: const Text(
                    'About Us',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.pushNamed(context, '/about_us_page'); // Navigate to About Us page
                  },
                ),
              ],
            ),
          ),
          // Divider before the Sign In section
          const Divider(),
          // Dynamic Sign In / Log Out section at the very bottom
          Padding(
            padding: const EdgeInsets.all(16.0),  // Add padding around the text
            child: GestureDetector(
              onTap: () async {
                if (user == null) {
                  Navigator.pop(context); // Close the drawer
                  Navigator.pushNamed(context, '/signin_page'); // Navigate to Sign In page
                } else {
                  await Supabase.instance.client.auth.signOut(); // Log out the user
                  Navigator.pop(context); // Close the drawer
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home_page',
                        (route) => false, // Remove all previous routes
                  );
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,  // Align the row to the start (left)
                children: [
                  Icon(
                    user == null ? Icons.login : Icons.logout,  // Change icon based on login status
                    color: const Color(0xFFDA1E1E),  // Red icon
                  ),
                  const SizedBox(width: 10),  // Add space between the icon and the text
                  Text(
                    user == null ? 'Sign In' : 'Log Out',  // Display either Sign In or Log Out based on user status
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,  // Black text
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}