import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/footer.dart';

class DetailPage extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String description;

  const DetailPage({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      body: Column(
        children: [
          // Title Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          // Image Section
          Container(
            width: 282,
            height: 230,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Description Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              description,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),

          // Add Spacer to push the footer to the bottom
          const Spacer(),

          // Sticky Bottom Navigation with no background
          CustomBottomNavigation(
            selectedIndex: 0, // Default index
            onItemTapped: (index) {
              // Handle item tap logic if needed
            },
            isBackgroundVisible: false,  // Set background visibility to false
          ),
        ],
      ),
    );
  }
}
