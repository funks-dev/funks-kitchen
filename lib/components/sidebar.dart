import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
    );
  }
}
