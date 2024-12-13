import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../pages/about_us_page.dart';
import '../pages/home_page.dart';
import '../pages/menu_page.dart';
import '../pages/signin_page.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  void _navigateToPage(BuildContext context, Widget page) {
    if (page.runtimeType.toString() == ModalRoute.of(context)?.settings.name) {
      return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        settings: RouteSettings(name: page.runtimeType.toString()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Supabase.instance.client.auth.currentUser;

    return Drawer(
      child: Column(
        children: [
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
                    Navigator.pop(context);
                    _navigateToPage(context, const HomePage());
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
                        Navigator.pop(context);
                        _navigateToPage(context, const MenuPage(initialIsFoodSelected: true));
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.local_drink, color: Color(0xFFDA1E1E)),
                      title: const Text('Drinks'),
                      onTap: () {
                        Navigator.pop(context);
                        _navigateToPage(context, const MenuPage(initialIsFoodSelected: false));
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
                    Navigator.pop(context);
                    _navigateToPage(context, const AboutUsPage());
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () async {
                if (user == null) {
                  Navigator.pop(context);
                  _navigateToPage(context, const SignInPage());
                } else {
                  await Supabase.instance.client.auth.signOut();
                  if (context.mounted) {
                    Navigator.pop(context);
                    _navigateToPage(context, const HomePage());
                  }
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    user == null ? Icons.login : Icons.logout,
                    color: const Color(0xFFDA1E1E),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    user == null ? 'Sign In' : 'Log Out',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
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