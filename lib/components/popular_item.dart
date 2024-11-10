import 'package:flutter/material.dart';

class PopularItem extends StatelessWidget {
  final String imageUrl;

  const PopularItem({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82,
      height: 117,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          imageUrl,
          height: 108,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
