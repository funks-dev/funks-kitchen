import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  bool _mounted = true;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _selectedIndex = 0;
  bool isLoading = true;
  List<MenuItem> popularFoods = [];
  List<MenuItem> popularDrinks = [];
  List<Map<String, dynamic>> newsItems = [];
  Timer? _autoSlideTimer;

  void _onItemTapped(int index) {
    if (!_mounted) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_mounted) {
        _startAutoSlide();
        _fetchPopularItems();
        _fetchNewsItems();
      }
    });
  }

  @override
  void dispose() {
    _mounted = false;
    _pageController.dispose();
    _autoSlideTimer?.cancel();
    super.dispose();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_mounted && _pageController.hasClients) {
        setState(() {
          _currentPage = (_currentPage + 1) % 3;
        });
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _fetchNewsItems() async {
    if (!_mounted) return;

    try {
      setState(() => isLoading = true);

      final response = await supabase
          .from('news_items')
          .select()
          .order('created_at', ascending: false)  // Get newest first
          .limit(4);  // Only get 4 items

      if (!_mounted) return;

      setState(() {
        newsItems = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });

    } catch (error) {
      if (kDebugMode) {
        print('Error fetching news items: $error');
      }
      if (_mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load news: ${error.toString()}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _fetchPopularItems() async {
    if (!_mounted) return;

    try {
      setState(() => isLoading = true);

      final foodResponse = await supabase
          .from('menu_items')
          .select()
          .eq('category', 'Food')
          .limit(5);

      if (!_mounted) return;

      final drinkResponse = await supabase
          .from('menu_items')
          .select()
          .eq('category', 'Drinks')
          .limit(5);

      if (!_mounted) return;

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
      if (_mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load popular items: ${error.toString()}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // WITH REPLACE
  // void _navigateToPage(BuildContext context, Widget page) {
  //   if (page.runtimeType.toString() == ModalRoute.of(context)?.settings.name) {
  //     return;
  //   }
  //
  //   Navigator.pushReplacement(
  //     context,
  //     PageRouteBuilder(
  //       pageBuilder: (context, animation, secondaryAnimation) => page,
  //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //         return FadeTransition(
  //           opacity: animation,
  //           child: child,
  //         );
  //       },
  //       transitionDuration: const Duration(milliseconds: 200),
  //       settings: RouteSettings(name: page.runtimeType.toString()),
  //     ),
  //   );
  // }

  // WITHOUT REPLACE
  void _navigateToPage(BuildContext context, Widget page) {
    // Check if the current page is the same as the one being navigated to
    if (page.runtimeType.toString() == ModalRoute.of(context)?.settings.name) {
      return;
    }

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Use a FadeTransition for the page change animation
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
                onTap: () => _navigateToPage(
                    context,
                    DetailPage(id: items[index].id.toString())
                ),
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
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NewsPage(),
                    ),
                  ),
                  child: const Icon(Icons.arrow_forward),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 210,
          child: isLoading
              ? ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 8 : 0,
                right: 8,
              ),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: SizedBox(
                  width: 180,
                  height: 210,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10),
                            ),
                            child: Container(
                              height: 108,
                              width: double.infinity,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            width: 152,
                            height: 10,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            width: 80,
                            height: 9,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
              : ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: newsItems.length,
            itemBuilder: (context, index) {
              final item = newsItems[index];
              final createdAt = DateTime.parse(item['created_at']);
              final formattedDate = DateFormat('dd MMMM yyyy').format(createdAt);

              return Container(
                margin: EdgeInsets.only(
                  left: index == 0 ? 8 : 0,
                  right: 8,
                ),
                child: CardItem(
                  imageUrl: item['image_url'],
                  title: item['title'],
                  date: formattedDate,
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
        onRefresh: () async {
          await Future.wait([
            _fetchPopularItems(),
            _fetchNewsItems(),
          ]);
        },
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
}