import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/card_item.dart';
import '../components/footer.dart';
import '../components/sidebar.dart';
import '../models/menu_item.dart';
import 'menu_detail_page.dart';
import 'news_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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

  final List<MenuItem> popularFoods = [
    MenuItem(
      name: 'Funky Fried Rice',
      imageUrl: 'assets/images/funky_fried_rice.png',
      description: 'The menu above is a typical fried rice dish with a special touch. This fried rice uses fluffy rice, sauteed with garlic and a little soy sauce to give it a savory taste and distinctive aroma. Inside there are tender pieces of beef, giving a delicious texture and taste to every bite. Chunks of red sausage add color and rich flavor, combining perfectly with sliced vegetables such as carrots and spring onions, providing a fresh and sweet touch. \n\nOn the side are fresh cucumber slices, which add freshness to every bite. Not to forget, the chili sauce with sliced red and green chilies and small pieces of garlic, provides an appetizing spicy option, according to your taste.',
      category: 'Food',
    ),
    MenuItem(
      name: 'Funky Noodle',
      imageUrl: 'assets/images/funky_noodle.png',
      description: 'Enjoy a special fried noodle dish that is full of color and taste! Chewy noodles are combined with pieces of fresh vegetables, savory meat and a sprinkling of chili which gives a tempting spicy sensation. The rich, signature sauce coats each noodle strand perfectly, creating an alluring combination of sweet, salty and spicy. \n\nPlus fresh lime juice which gives a fresh sour touch, this Funky Noodle is the perfect choice for those of you who are looking for a unique and bold noodle dish. Suitable to enjoy at any time for an unforgettable culinary experience!',
      category: 'Food',
    ),
    MenuItem(
      name: 'Spicy Funked-Up Pasta',
      imageUrl: 'assets/images/spicy_funkedup_pasta.png',
      description: "Enjoy our Spaghetti Bolognese dish, the perfect combination of spaghetti cooked al dente with a rich bolognese sauce. Fresh tomato sauce and high-quality minced beef are slow cooked with garlic, onions and spices such as oregano and basil, creating a deep savory taste and mouth-watering aroma. Served with a sprinkling of fresh basil leaves, each bite delivers authentic Italian deliciousness that will make you feel like you're dining at a classic Italian restaurant.",
      category: 'Food',
    ),
    MenuItem(
      name: 'Funky Rice Bowl Chicken',
      imageUrl: 'assets/images/funky_rice_bowl_chicken.png',
      description: "Enjoy our delicious Funky Rice Bowl Chicken! Soft white rice combined with crispy and tasty fried chicken pieces, drizzled with sweet and delicious teriyaki sauce. Plus a sprinkling of fresh spring onions which gives a fresh and slightly spicy taste, making every bite even more delicious. Ready to whet your appetite!",
      category: 'Food',
    ),
    MenuItem(
      name: 'Funky Rice Bowl Katsu',
      imageUrl: 'assets/images/funky_rice_bowl_katsu.png',
      description: "Funky Rice Bowl Katsu is an appetizing menu. Soft white rice combined with crispy chicken pieces and a thick, savory sauce. Sweet, salty and savory flavors combine perfectly in every bite, creating an unforgettable culinary experience. \n\nEnjoy this delicious Funky Rice Bowl Katsu for your lunch or dinner. A satisfying and appetizing dish, ready to pamper your taste buds!",
      category: 'Food',
    ),
    MenuItem(
      name: 'Funky BBQ Ribs',
      imageUrl: 'assets/images/funky_bbq_ribs.png',
      description: "Feel the juicy and tender sensation of our Funky BBQ Ribs which are cooked slowly until the meat easily separates from the bone. Dressed in a special, rich BBQ sauce, these ribs offer the perfect mix of sweet, savory and a touch of smoky. Every bite presents an explosion of flavors that pamper the tongue, combined with selected herbs and spices that make this dish even more special. \n\nServed with roasted potatoes and spicy chili sauce as a side, these Funky BBQ Ribs are the perfect choice for true BBQ fans. Suitable to enjoy with family or friends, creating a memorable culinary experience.",
      category: 'Food',
    ),
  ];

  final List<MenuItem> popularDrinks = [
    MenuItem(
      name: 'Chocolatte',
      imageUrl: 'assets/images/chocolatte.png',
      description: 'a creamy and appetizing chocolate drink. Each sip delivers a delicious blend of dark chocolate with the smoothness of milk, complemented by a garnish of grated chocolate and a dollop of whipped cream on top. Served chilled with a layer of tantalizing chocolate sauce in the glass, this Chocolatte is the perfect choice for chocolate lovers who want to savor sweet moments on every occasion.',
      category: 'Drinks',
    ),
    MenuItem(
      name: 'Milk Coffee',
      imageUrl: 'assets/images/milk_coffee.png',
      description: "Enjoy the perfect refreshment of our Milk Coffee! This drink is a harmonious combination of rich coffee and smooth fresh milk, creating a creamy flavor sensation with a hint of sweetness that is a treat for the palate. Poured in just the right amount, every sip of this Milk Coffee delivers a rich coffee flavor balanced with the smoothness of milk. Perfect to accompany your day, whether you're relaxing or busy, this drink delivers passion and enjoyment in one cup.",
      category: 'Drinks',
    ),
    MenuItem(
      name: 'Watermelon Smoothies',
      imageUrl: 'assets/images/watermelon_smoothies.png',
      description: "Watermelon Smoothies are made from a simple yet refreshing blend of fresh ingredients. Juicy red watermelon chunks take center stage, providing natural sweetness and a vibrant red color, creating a drink that is both eye-catching and throat-refreshing. Watermelon is also rich in water, so these smoothies are perfect as a thirst quencher on a hot day. \n\nA little lime juice is added to give it a touch of fresh acidity that blends perfectly with the sweetness of the watermelon, resulting in a light and refreshing balance of flavors. Ice cubes are also blended in with these ingredients, creating a smooth and refreshing chilled texture. This combination of natural ingredients not only makes Watermelon Smoothies delicious, but also provides a healthy intake of vitamin A, vitamin C, and natural antioxidants.",
      category: 'Drinks',
    ),
    MenuItem(
      name: 'Kiwi Smoothies',
      imageUrl: 'assets/images/kiwi_smoothies.png',
      description: "These Kiwi Smoothies are made from fresh, quality ingredients that provide optimal flavor and health benefits. The main ingredient is fresh green kiwi, peeled and blended until smooth, giving it a distinctive tart-sweet flavor and a beautiful natural green color. For extra smoothness, the smoothies are also blended with creamy yogurt that adds a creamy texture and slightly tart flavor that is perfectly balanced with the kiwi. \n\nAs a natural sweetener, a little honey is added to give a light touch of sweetness without compromising the freshness of the kiwi flavor. Ice cubes are also blended in to give a refreshing chill sensation, making these Kiwi Smoothies the perfect choice as a thirst-quenching drink. This combination of natural ingredients creates a drink that is not only delicious but also rich in vitamin C, antioxidants, and fiber that are good for the body.",
      category: 'Drinks',
    ),
    MenuItem(
      name: 'lychee ice',
      imageUrl: 'assets/images/lychee_ice.png',
      description: "Enjoy a refreshing sensation with Lychee Ice, a drink that presents a blend of sweet and exotic flavors from fresh lychee fruit. Each sip delivers a natural coolness, coupled with the distinctive aroma of mint leaves and a hint of lime juice that provides a fresh sour touch. Ideal for hot weather, Lychee Ice is the perfect choice to quench your thirst while enjoying the sweetness of tropical flavors.",
      category: 'Drinks',
    ),
    MenuItem(
      name: 'Strawberry Squash',
      imageUrl: 'assets/images/strawberry_squash.png',
      description: "Refresh your day with Strawberry Squash, a drink that combines the freshness of strawberries with the chewy texture of nata de coco. The combination of the strawberry's beautiful red color and natural sweetness makes this drink not only a treat for the tongue but also an eye-catcher. With a generous addition of ice, Strawberry Squash is the perfect choice to quench your thirst and provide a refreshing touch of sweetness.",
      category: 'Drinks',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
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
          height: 117, // Height fixed
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MenuDetailPage(menuItem: items[index]),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(
                    left: index == 0 ? 8 : 0,
                    right: 8, // Adjusted right margin
                  ),
                  child: Stack(
                    children: [
                      // Background rectangle with rounded corners
                      Container(
                        width: 82,
                        height: 117,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      // Image inside the rectangle
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            items[index].imageUrl,
                            fit: BoxFit.cover,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Full-width PageView
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: 150,
                  width: double.infinity,  // Full width
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