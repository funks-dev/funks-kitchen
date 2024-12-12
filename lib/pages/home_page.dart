import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/card_item.dart';
import '../components/footer.dart';
import '../components/sidebar.dart';
import '../models/menu_item.dart';
import 'detail_page.dart';
import 'news_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shimmer/shimmer.dart';

final supabase = Supabase.instance.client;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _selectedIndex = 0;
  bool isLoading = true;
  List<MenuItem> popularFoods = [];
  List<MenuItem> popularDrinks = [];

  final List<Map<String, String>> newsItems = [
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
    _fetchPopularItems();
  }

  Future<void> _fetchPopularItems() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Add artificial delay to show shimmer effect
      await Future.delayed(const Duration(seconds: 1));

      // Fetch popular food items
      final foodResponse = await supabase
          .from('menu_items')
          .select()
          .eq('category', 'Food')
          .limit(5);

      if (kDebugMode) {
        print('Popular food response: $foodResponse');
      }

      // Fetch popular drink items
      final drinkResponse = await supabase
          .from('menu_items')
          .select()
          .eq('category', 'Drinks')
          .limit(5);

      if (kDebugMode) {
        print('Popular drink response: $drinkResponse');
      }

      setState(() {
        popularFoods = (foodResponse as List<dynamic>)
            .map((item) => MenuItem.fromJson(item))
            .toList();
        popularDrinks = (drinkResponse as List<dynamic>)
            .map((item) => MenuItem.fromJson(item))
            .toList();
        isLoading = false;
      });

    } catch (error) {
      if (kDebugMode) {
        print('Error fetching popular items: $error');
      }
      setState(() {
        isLoading = false;
      });

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load popular items: ${error.toString()}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 3), () {
      if (_pageController.hasClients) {
        setState(() {
          _currentPage = (_currentPage + 1) % 3;
        });
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
      _startAutoSlide();
    });
  }

  Widget _buildShimmerItem() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: 82,
          height: 117,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
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

  Widget _buildPopularSection(String title, List<MenuItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 117,
          child: isLoading
              ? ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) => _buildShimmerItem(),
          )
              : ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        id: items[index].id.toString(),
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(
                    left: index == 0 ? 8 : 0,
                    right: 8,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: 82,
                        height: 117,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            items[index].imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.error),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Center(
                child: Text(
                  'News',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NewsPage()),
                    );
                  },
                  child: const Icon(Icons.arrow_forward),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 210,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: newsItems.length,
            itemBuilder: (context, index) {
              final item = newsItems[index];
              return Container(
                margin: EdgeInsets.only(
                  left: index == 0 ? 8 : 0,
                  right: 8,
                ),
                child: CardItem(
                  imageUrl: item['imageUrl']!,
                  title: item['title']!,
                  date: item['date']!,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      drawer: const Sidebar(),
      body: RefreshIndicator(
        onRefresh: _fetchPopularItems,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      children: [
                        Image.asset('assets/images/slide1.png', fit: BoxFit.cover),
                        Image.asset('assets/images/slide2.png', fit: BoxFit.cover),
                        Image.asset('assets/images/slide3.png', fit: BoxFit.cover),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    child: _buildPageIndicator(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildNewsSection(),
              const SizedBox(height: 12),
              _buildPopularSection('Popular Foods', popularFoods),
              const SizedBox(height: 12),
              _buildPopularSection('Popular Drinks', popularDrinks),
              const SizedBox(height: 50),
            ],
          ),
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