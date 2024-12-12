import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/sidebar.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  final List<Map<String, String>> newsItems = const [
    {
      'imageUrl': 'assets/images/news1.png',
      'title': 'Perayaan Grand Opening Funks Kitchen Resmi Dibuka!',
      'date': '22 Oktober 2024',
    },
    {
      'imageUrl': 'assets/images/news2.png',
      'title': 'Memperkenalkan Menu Baru Kami Cita Rasa Funky!',
      'date': '15 Oktober 2024',
    },
    {
      'imageUrl': 'assets/images/news3.png',
      'title': 'Funks Kitchen Gathering Kini Tersedia',
      'date': '1 Oktober 2024',
    },
    {
      'imageUrl': 'assets/images/news4.png',
      'title': 'Dapatkan Penawaran Funky Setiap Minggu',
      'date': '8 Oktober 2024',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      drawer: const Sidebar(),
      body: Stack(  // Use Stack to overlay bottom navigation on top of content
        children: [
          // Main content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Center(
                        child: Text(
                          'News',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Popular',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: newsItems.length,
                        itemBuilder: (context, index) {
                          final item = newsItems[index];
                          return _buildNewsCard(
                            imageUrl: item['imageUrl']!,
                            title: item['title']!,
                            date: item['date']!,
                          );
                        },
                      ),
                      const SizedBox(height: 150),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard({
    required String imageUrl,
    required String title,
    required String date,
  }) {
    return Container(
      width: 361,
      height: 185,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imageUrl,
              width: 339,
              height: 104,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: 350,
            height: 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            width: 100,
            height: 15,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              date,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
