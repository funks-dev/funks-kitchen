import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/footer.dart';
import '../models/menu_item.dart';

class MenuDetailPage extends StatelessWidget {
  final MenuItem menuItem;

  const MenuDetailPage({super.key, required this.menuItem});

  @override
  Widget build(BuildContext context) {
    // Check if the category is "Drinks" and set dimensions accordingly
    final double imageWidth = menuItem.category == 'Drinks' ? 200 : 350;
    final double imageHeight = menuItem.category == 'Drinks' ? 300 : 200;

    return Scaffold(
      appBar: const Header(isBackButton: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                menuItem.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                menuItem.imageUrl,
                width: imageWidth,
                height: imageHeight,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ingredients',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                menuItem.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 150),
          ],
        ),
      ),
    );
  }
}