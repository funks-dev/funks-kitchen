import 'package:flutter/material.dart';
import '../pages/home_page.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final bool isBackButton;

  const Header({super.key, this.isBackButton = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          isBackButton ? Icons.arrow_back : Icons.menu,
          color: Colors.white,
        ),
        onPressed: () {
          if (isBackButton) {
            Navigator.of(context).pop();
          } else {
            Scaffold.of(context).openDrawer();
          }
        },
      ),
      title: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        },
        child: Image.asset(
          'assets/images/funks_logo_header.png',
          height: 52,
          width: 76,
        ),
      ),
      centerTitle: true,
      backgroundColor: const Color(0xFFDA1E1E),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}