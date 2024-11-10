import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/footer.dart';
import '../components/sidebar.dart';
import '../models/menu_item.dart';
import 'menu_detail_page.dart';

class MenuPage extends StatefulWidget {
  final bool initialIsFoodSelected; // New parameter to determine initial menu selection

  const MenuPage({super.key, required this.initialIsFoodSelected});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late bool isFoodSelected;

  @override
  void initState() {
    super.initState();
    isFoodSelected = widget.initialIsFoodSelected; // Initialize based on passed argument
  }

  // Daftar makanan sebagai contoh MenuItem
  final List<MenuItem> foodItems = [
    MenuItem(
      name: 'Spicy Funked-Up Pasta',
      imageUrl: 'assets/images/spicy_funkedup_pasta.png',
      description: "Enjoy our Spaghetti Bolognese dish, the perfect combination of spaghetti cooked al dente with a rich bolognese sauce. Fresh tomato sauce and high-quality minced beef are slow cooked with garlic, onions and spices such as oregano and basil, creating a deep savory taste and mouth-watering aroma. Served with a sprinkling of fresh basil leaves, each bite delivers authentic Italian deliciousness that will make you feel like you're dining at a classic Italian restaurant.",
      category: 'Food',
    ),
    MenuItem(
      name: 'Funky Noodle',
      imageUrl: 'assets/images/funky_noodle.png',
      description: 'Enjoy a special fried noodle dish that is full of color and taste! Chewy noodles are combined with pieces of fresh vegetables, savory meat and a sprinkling of chili which gives a tempting spicy sensation. The rich, signature sauce coats each noodle strand perfectly, creating an alluring combination of sweet, salty and spicy. \n\nPlus fresh lime juice which gives a fresh sour touch, this Funky Noodle is the perfect choice for those of you who are looking for a unique and bold noodle dish. Suitable to enjoy at any time for an unforgettable culinary experience!',
      category: 'Food',
    ),
    MenuItem(
      name: 'Funky Fried Rice',
      imageUrl: 'assets/images/funky_fried_rice.png',
      description: 'The menu above is a typical fried rice dish with a special touch. This fried rice uses fluffy rice, sauteed with garlic and a little soy sauce to give it a savory taste and distinctive aroma. Inside there are tender pieces of beef, giving a delicious texture and taste to every bite. Chunks of red sausage add color and rich flavor, combining perfectly with sliced vegetables such as carrots and spring onions, providing a fresh and sweet touch. \n\nOn the side are fresh cucumber slices, which add freshness to every bite. Not to forget, the chili sauce with sliced red and green chilies and small pieces of garlic, provides an appetizing spicy option, according to your taste.',
      category: 'Food',
    ),
    MenuItem(
      name: 'Funky BBQ Ribs',
      imageUrl: 'assets/images/funky_bbq_ribs.png',
      description: "Feel the juicy and tender sensation of our Funky BBQ Ribs which are cooked slowly until the meat easily separates from the bone. Dressed in a special, rich BBQ sauce, these ribs offer the perfect mix of sweet, savory and a touch of smoky. Every bite presents an explosion of flavors that pamper the tongue, combined with selected herbs and spices that make this dish even more special. \n\nServed with roasted potatoes and spicy chili sauce as a side, these Funky BBQ Ribs are the perfect choice for true BBQ fans. Suitable to enjoy with family or friends, creating a memorable culinary experience.",
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
      name: 'Funky Chicken Sandwich',
      imageUrl: 'assets/images/funky_chicken_sandwitch.png',
      description: "Our Funky Chicken Sandwich is a true tastebud tantalizer! Featuring a juicy chicken patty, crisp lettuce, and a refreshing tomato slice, all nestled between two toasted buns, this sandwich is a delightful combination of textures and flavors. The savory chicken patty is perfectly complemented by the tangy tomato and the fresh crunch of the lettuce. It's a sandwich that's sure to satisfy your cravings! A delicious and filling option for any meal of the day!",
      category: 'Food',
    ),
    MenuItem(
      name: 'Funky Rice Bowl Teriyaki',
      imageUrl: 'assets/images/funky_rice_bowl_teriyaki.png',
      description: "Our Funky Chicken Sandwich is a delicious and satisfying meal that will leave you feeling full and satisfied. The sandwich features a juicy and flavorful chicken patty, topped with a variety of fresh and flavorful ingredients. The chicken patty is cooked to perfection and is seasoned with a unique blend of spices that will tantalize your taste buds. The sandwich is served on a soft and fluffy bun, and it's perfect for a quick and easy meal. \n\nIf you're looking for a hearty and flavorful sandwich that will satisfy your cravings, then you need to try our Funky Chicken Sandwich. It's the perfect combination of savory and sweet, and it's sure to become a favorite.",
      category: 'Food',
    ),
    MenuItem(
      name: 'Steak & Eggs',
      imageUrl: 'assets/images/steak_eggs.png',
      description: "This is a flavorful and hearty dish that is perfect for any time of day. Our Funky Steak & Eggs features a perfectly seared steak that is tender and juicy, served alongside a fluffy fried egg with a runny yolk. The steak is seasoned with our secret blend of spices, and the egg is cooked to perfection. The dish is served with a side of crispy bacon and a dollop of sour cream, making it a truly decadent treat.",
      category: 'Food',
    ),
    MenuItem(
      name: 'Szechuan Chicken',
      imageUrl: 'assets/images/szechuan_chicken.png',
      description: "This is a flavorful and hearty dish that is perfect for any time of day. Our Funky Steak & Eggs features a perfectly seared steak that is tender and juicy, served alongside a fluffy fried egg with a runny yolk. The steak is seasoned with our secret blend of spices, and the egg is cooked to perfection. The dish is served with a side of crispy bacon and a dollop of sour cream, making it a truly decadent treat.",
      category: 'Food',
    ),
    MenuItem(
      name: 'Funky Korean BBQ Beef Bowl',
      imageUrl: 'assets/images/funky_korean_bbq_beef_bowl.png',
      description: "This bowl is a delicious and flavorful combination of savory, sweet, and spicy flavors. It's a hearty and satisfying meal that's perfect for any occasion. The dish features tender, marinated beef that's been cooked to perfection. It's topped with a bed of fluffy white rice and an assortment of fresh vegetables, including cucumber and carrots. The bowl is then drizzled with a savory, sweet, and slightly spicy Korean BBQ sauce. This delicious dish will leave you feeling full and satisfied.",
      category: 'Food',
    ),
    MenuItem(
      name: 'Butter Chicken',
      imageUrl: 'assets/images/butter_chicken.png',
      description: "This is a delicious and flavorful dish of butter chicken that is perfect for a satisfying meal. The chicken is marinated in a creamy, spiced sauce and cooked to perfection. The dish is then served with a side of fluffy white rice that absorbs all the flavors of the sauce. The dish is garnished with fresh cilantro and a touch of green onions. \n\nThis is a dish that is sure to please everyone. It is a great option for a family dinner, a special occasion, or just a quick and easy meal. The chicken is tender and juicy, and the sauce is rich and flavorful. The rice is cooked perfectly, and the garnishes add a touch of freshness. This is a dish that is sure to become a favorite.",
      category: 'Food',
    ),
    MenuItem(
      name: 'Beef Chow Mein',
      imageUrl: 'assets/images/beef_chow_mein.png',
      description: "This beef chow mein is a delicious and flavorful dish. It's packed with tender beef, crisp vegetables, and chewy noodles, all tossed in a savory sauce. The beef is cooked to perfection, and the vegetables are fresh and vibrant. The noodles are cooked just right, and they hold up well to the sauce. The whole dish is a perfect balance of flavors and textures. \n\nThis beef chow mein is a flavorful and hearty dish that's perfect for a quick and easy meal. It's also a great option for a dinner party or potluck. It's sure to please everyone at the table.",
      category: 'Food',
    ),
    MenuItem(
      name: 'Black Pepper Beef',
      imageUrl: 'assets/images/black_pepper_beef.png',
      description: "The Black Pepper Beef is a hearty and flavorful dish that is sure to satisfy your taste buds. It features tender beef strips cooked with black peppercorns and onions, and it is served on a bed of rice. The dish is garnished with fresh cilantro and a drizzle of sesame oil. This is a dish that is sure to please everyone at the table, and it is perfect for a casual dinner or a special occasion.",
      category: 'Food',
    ),
    MenuItem(
      name: 'Chicken and Mushroom Claypot',
      imageUrl: 'assets/images/chicken_mushroom_claypot.png',
      description: "The dish is cooked in a black cast iron skillet and is sitting on a red and white checkered tablecloth. The ingredients include chicken, mushrooms, red bell peppers, and green onions. There are also some white onions on the side of the dish. The image is taken from a close-up perspective, so the viewer can see all the details of the dish. The image is well-lit and has a warm color palette. \n\nThe dish looks very appealing and would be perfect for a meal with friends or family. It is clear that this is a high-quality meal that has been prepared with care. The ingredients look fresh and flavorful, and the presentation is beautiful. This is a dish that would be sure to please any palate.",
      category: 'Food',
    ),
    MenuItem(
      name: 'Fuyunghai',
      imageUrl: 'assets/images/fuyunghai.png',
      description: "This classic Chinese dish is a must-try for any fan of savory, comforting meals. Our version features a fluffy omelet filled with a blend of ground pork, shrimp, and vegetables, all cooked to perfection. The omelet is then topped with a savory gravy, adding a touch of richness and umami. The dish is served alongside a side of steamed rice, making for a complete and satisfying meal.",
      category: 'Food',
    ),
    MenuItem(
      name: 'Funky Capcay',
      imageUrl: 'assets/images/funky_capcay.png',
      description: "The dish is presented in a bright red bowl, showcasing the vibrant hues of broccoli florets, juicy shrimp, crisp baby corn, tender bok choy, and soft, white fish balls. The vegetables are tossed in a savory sauce, likely infused with soy sauce, garlic, and ginger, giving the dish its unique, 'funky' flavor. The combination of textures and flavors is a tantalizing mix that promises a satisfying and flavorful meal. \n\nThis 'Funky Capcay' dish offers a healthy and delicious option for anyone seeking a flavorful and nutritious meal. The combination of protein, vegetables, and complex carbohydrates makes it a well-balanced and satisfying choice. Its vibrant presentation and enticing aroma make it a visually appealing dish that is sure to impress and delight diners.",
      category: 'Food',
    ),
    MenuItem(
      name: 'Noodle Chili Oil',
      imageUrl: 'assets/images/noodle_chili_oil.png',
      description: "Savor the bold flavors of our signature Noodle Chili Oil. Tender noodles are tossed in a fiery chili oil sauce that is both savory and slightly sweet. Each bite is a perfect balance of spice, heat, and aromatic notes. Garnished with fresh herbs and a sprinkle of sesame seeds, this dish is a tantalizing treat that will satisfy your cravings for something flavorful and unique.",
      category: 'Food',
    ),
    MenuItem(
      name: 'Egg Rice',
      imageUrl: 'assets/images/egg_rice.png',
      description: "A simple yet satisfying dish, our Egg Rice is a comforting blend of fluffy rice topped with a perfectly fried egg. The egg is cooked to your preference, creating a delightful contrast in textures and flavors. We season the rice with a touch of soy sauce and sesame oil, enhancing its natural sweetness. It's a perfect choice for a light meal or as a side dish to complement your main course.",
      category: 'Food',
    ),
    MenuItem(
      name: 'Pangsit Chili Oil',
      imageUrl: 'assets/images/pangsit_chili_oil.png',
      description: "Our Chili Oil Dumplings are a must-try for any spice lover. The dumplings are filled with a savory pork filling and steamed to perfection. Then, they're tossed in our signature chili oil, a blend of chili peppers, garlic, ginger, and other spices. The chili oil adds a kick of heat and flavor that will have you coming back for more. Be sure to dip the dumplings in our special vinegar sauce to balance out the heat. This dish is perfect for sharing or enjoying on its own.",
      category: 'Food',
    ),
  ];

  // Daftar minuman sebagai contoh MenuItem
  final List<MenuItem> drinkItems = [
    MenuItem(
      name: 'Strawberry Smoothies',
      imageUrl: 'assets/images/strawberry_smoothies.png',
      description: "This fresh strawberry smoothie is the perfect blend of fresh fruit delights and creamy, mouthwatering texture. Made with handpicked strawberries that give it a natural pink color, every sip delivers a sweet and fresh taste sensation that is a treat for the palate. Topped with strawberry pieces, this drink is not only delicious but also beautiful to enjoy. \n\nIdeal as a morning pick-me-up or afternoon refreshment, this smoothie has a balance of sweetness and light sourness. Served in a tall glass with a fresh strawberry garnish on the rim, this drink is sure to charm anyone who sees it. Experience this delicious strawberry smoothie for yourself and let your day be filled with joy and positive energy.",
      category: 'Drinks',
    ),
    MenuItem(
      name: 'Kiwi Smoothies',
      imageUrl: 'assets/images/kiwi_smoothies.png',
      description: "These Kiwi Smoothies are made from fresh, quality ingredients that provide optimal flavor and health benefits. The main ingredient is fresh green kiwi, peeled and blended until smooth, giving it a distinctive tart-sweet flavor and a beautiful natural green color. For extra smoothness, the smoothies are also blended with creamy yogurt that adds a creamy texture and slightly tart flavor that is perfectly balanced with the kiwi. \n\nAs a natural sweetener, a little honey is added to give a light touch of sweetness without compromising the freshness of the kiwi flavor. Ice cubes are also blended in to give a refreshing chill sensation, making these Kiwi Smoothies the perfect choice as a thirst-quenching drink. This combination of natural ingredients creates a drink that is not only delicious but also rich in vitamin C, antioxidants, and fiber that are good for the body.",
      category: 'Drinks',
    ),
    MenuItem(
      name: 'Watermelon Smoothies',
      imageUrl: 'assets/images/watermelon_smoothies.png',
      description: "Watermelon Smoothies are made from a simple yet refreshing blend of fresh ingredients. Juicy red watermelon chunks take center stage, providing natural sweetness and a vibrant red color, creating a drink that is both eye-catching and throat-refreshing. Watermelon is also rich in water, so these smoothies are perfect as a thirst quencher on a hot day. \n\nA little lime juice is added to give it a touch of fresh acidity that blends perfectly with the sweetness of the watermelon, resulting in a light and refreshing balance of flavors. Ice cubes are also blended in with these ingredients, creating a smooth and refreshing chilled texture. This combination of natural ingredients not only makes Watermelon Smoothies delicious, but also provides a healthy intake of vitamin A, vitamin C, and natural antioxidants.",
      category: 'Drinks',
    ),
    MenuItem(
      name: 'Pineapple Smoothies',
      imageUrl: 'assets/images/pineapple_smoothies.png',
      description: "Pineapple Smoothie are Made with sweet and juicy chunks of fresh pineapple, this smoothie offers a refreshing taste and is rich in vitamin C. Blended with creamy bananas that give it a natural creamy texture, and Greek yogurt that adds a hint of acidity and is rich in protein, this drink is perfect for fueling you throughout the day. \n\nTopped off with a touch of fresh coconut water or creamy coconut milk, this Pineapple Smoothie transports you to a tropical beach. It tastes even better with the addition of natural honey as a sweetener, and fresh mint leaves as a garnish that adds a fresh aroma and a charming visual impression. Perfect to enjoy anytime as the perfect companion on a sunny day.",
      category: 'Drinks',
    ),
    MenuItem(
      name: 'Milk Coffee',
      imageUrl: 'assets/images/milk_coffee.png',
      description: "Enjoy the perfect refreshment of our Milk Coffee! This drink is a harmonious combination of rich coffee and smooth fresh milk, creating a creamy flavor sensation with a hint of sweetness that is a treat for the palate. Poured in just the right amount, every sip of this Milk Coffee delivers a rich coffee flavor balanced with the smoothness of milk. Perfect to accompany your day, whether you're relaxing or busy, this drink delivers passion and enjoyment in one cup.",
      category: 'Drinks',
    ),
    MenuItem(
      name: 'Chocolatte',
      imageUrl: 'assets/images/chocolatte.png',
      description: 'a creamy and appetizing chocolate drink. Each sip delivers a delicious blend of dark chocolate with the smoothness of milk, complemented by a garnish of grated chocolate and a dollop of whipped cream on top. Served chilled with a layer of tantalizing chocolate sauce in the glass, this Chocolatte is the perfect choice for chocolate lovers who want to savor sweet moments on every occasion.',
      category: 'Drinks',
    ),
    MenuItem(
      name: 'Matcha Latte',
      imageUrl: 'assets/images/matchalatte.png',
      description: 'Enjoy the smooth and refreshing sensation of Matcha Latte, a pastel green drink rich in the aroma of Japanese green tea. Each sip delivers a balanced flavor combination of the sweetness of fresh milk and the slight bitterness of matcha, creating a relaxing and indulgent drinking experience. Served with a topping of whipped cream and a garnish of mint leaves, this drink is not only pleasing to the eye but also gives a unique touch of flavor with every sip.',
      category: 'Drinks',
    ),
    MenuItem(
      name: 'Lemon Tea',
      imageUrl: 'assets/images/lemontea.png',
      description: 'Experience the optimal freshness of Lemon Tea, the perfect cold drink to refresh your day. The blend of rich tea and freshly squeezed lemon creates a balanced combination of sweet and sour. Served with a generous amount of ice cubes, this drink delivers a refreshing chill sensation and a fragrant lemon scent with every sip. Perfect to enjoy during hot weather or as a relaxing companion.',
      category: 'Drinks',
    ),
    MenuItem(
      name: 'Lime Squash',
      imageUrl: 'assets/images/limesquash.png',
      description: 'Experience a refreshing crispness with our Lime Squash! This drink provides the perfect combination of the fresh sourness of lime and the bubbly sensation of soda. Served chilled with a generous amount of ice cubes, Lime Squash is perfect for quenching your thirst and giving you a boost of energy on a hot day. The lime wedge garnish on top adds uniqueness and beautifies the look, making it a drink that is not only refreshing, but also pleasing to the eye.',
      category: 'Drinks',
    ),
    MenuItem(
      name: 'Lime Ice',
      imageUrl: 'assets/images/limeice.png',
      description: 'Lime Ice is the ultimate refreshment, perfect for hot days or whenever you need a cooling, zesty treat. Made with freshly squeezed lime juice, this drink is an invigorating blend of tartness and subtle sweetness, creating a vibrant flavor that instantly revitalizes. The citrusy zing of lime, combined with ice-cold refreshment, makes each sip crisp and exhilarating, delivering a burst of freshness that quenches thirst like no other. \n\nServed in a chilled glass filled with crushed ice, Lime Ice is topped with a slice of lime on the rim and a sprinkle of lime zest to enhance its aroma. The drink’s crystal-clear appearance with a hint of green is both elegant and refreshing to look at. Ideal for an afternoon cooldown or a pre-meal palate cleanser, Lime Ice is a simple yet sensational drink that adds a touch of brightness to any moment.',
      category: 'Drinks',
    ),
    MenuItem(
      name: 'lychee ice',
      imageUrl: 'assets/images/lychee_ice.png',
      description: 'njoy a refreshing sensation with Lychee Ice, a drink that presents a blend of sweet and exotic flavors from fresh lychee fruit. Each sip delivers a natural coolness, coupled with the distinctive aroma of mint leaves and a hint of lime juice that provides a fresh sour touch. Ideal for hot weather, Lychee Ice is the perfect choice to quench your thirst while enjoying the sweetness of tropical flavors.',
      category: 'Drinks',
    ),
    MenuItem(
      name: 'Strawberry Squash',
      imageUrl: 'assets/images/strawberry_squash.png',
      description: "Refresh your day with Strawberry Squash, a drink that combines the freshness of strawberries with the chewy texture of nata de coco. The combination of the strawberry's beautiful red color and natural sweetness makes this drink not only a treat for the tongue but also an eye-catcher. With a generous addition of ice, Strawberry Squash is the perfect choice to quench your thirst and provide a refreshing touch of sweetness.",
      category: 'Drinks',
    ),
    MenuItem(
      name: 'Strawberry Lime Mocktail',
      imageUrl: 'assets/images/strawberry_lime_moctail.png',
      description: "Enjoy the freshness of Strawberry Lime Mocktail, a drink that combines the sweetness of strawberries with the sour touch of lime. This mocktail delivers a refreshing sensation in every sip, perfect for refreshing your day. Its beautiful appearance with vibrant red and green colors makes it even more tempting. Perfect to enjoy at leisure or on a special occasion.",
      category: 'Drinks',
    ),
    MenuItem(
      name: 'Blueberry Mojito Squash',
      imageUrl: 'assets/images/blueberry_mojito_squash.png',
      description: "Blueberry Mojito Squash, a drink with a seductive bright blue color, combining the sweet taste of blueberries with fresh mint. This drink is perfect for those who want to experience the unique taste of fruit with the added touch of sparkling soda. This drink is not only a treat for the palate but also a refreshing sight for the eyes.",
      category: 'Drinks',
    ),
    MenuItem(
      name: 'Lemon ice with Lime',
      imageUrl: 'assets/images/lemon_ice_with_lime.png',
      description: "Refresh your day with Lemon Ice with Lime, a perfect blend of fresh and sour lemon and fragrant lime slices. This drink brings a natural coolness with the addition of abundant ice cubes, ideal to enjoy on a hot day. This drink is the perfect choice for those who love refreshing sour flavors.",
      category: 'Drinks',
    ),
    MenuItem(
      name: 'Dalgona Coffee',
      imageUrl: 'assets/images/dalgona_coffee.png',
      description: "Enjoy the smooth and creamy sensation of Dalgona Coffee, a viral coffee drink that is loved by many! Dalgona Coffee has a thick and sweet layer of coffee foam on top of cold milk, creating a refreshing blend of flavors with a touch of bold coffee flavor. This drink is perfect for anytime enjoyment, providing an experience that is not only a treat for the palate, but also a feast for the eyes with its beautiful and tempting appearance.",
      category: 'Drinks',
    ),
    MenuItem(
      name: 'Ice Cream Latte Milk',
      imageUrl: 'assets/images/ice_cream_latte_milk.png',
      description: "This Ice Cream Latte Milk is the ultimate indulgence, combining the smoothness of milk with the rich, creamy flavor of ice cream and a bold coffee essence. Each sip offers a delightful blend of sweet creaminess and the invigorating aroma of freshly brewed espresso, creating a treat that’s as satisfying as it is refreshing. With a touch of frothed milk on top and a hint of vanilla, this drink has an irresistible aroma and flavor. \n\nPerfect for a mid-day energy boost or an evening treat, this Ice Cream Latte Milk is served in a tall glass with a sprinkle of cocoa powder and a dollop of whipped cream. Finished with a coffee bean garnish on top, this drink is as visually appealing as it is delicious. Take a sip and let yourself be swept away by the rich flavors and creamy texture—it's a drink that promises pure delight in every taste!",
      category: 'Drinks',
    ),
    MenuItem(
      name: 'D’ Cold brew Latte',
      imageUrl: 'assets/images/dcold_brew_latte.png',
      description: "D' Cold Brew Latte is a refreshing twist on classic coffee, crafted for those who appreciate a smoother, bolder flavor. This drink combines the deep, rich notes of cold-brewed coffee with the velvety smoothness of milk, creating a perfect balance of robust coffee essence and creamy satisfaction. With its naturally low acidity, every sip is refreshing, energizing, and easy on the palate, making it an ideal choice for both coffee enthusiasts and casual drinkers alike. \n\nServed over ice in a tall glass, D' Cold Brew Latte has a light froth on top and a touch of caramel drizzle, enhancing both its appearance and flavor. The drink is completed with a garnish of coffee beans, adding an elegant touch to the presentation. Perfect as an energizing pick-me-up on a warm day or a smooth, indulgent treat in the afternoon, D' Cold Brew Latte is crafted to delight and refresh with every sip.",
      category: 'Drinks',
    ),
    MenuItem(
      name: 'Milkshake Chocolate with Whipped Cream',
      imageUrl: 'assets/images/milkshake_chocolate_with_whipped_cream.png',
      description: "Milkshake Chocolate with Whipped Cream is a timeless classic that combines rich, velvety chocolate with creamy milk for an indulgent treat. This milkshake is crafted with premium chocolate and blended to perfection, delivering a thick, luscious texture that’s smooth and satisfying. Each sip is filled with intense chocolatey flavor, balanced by the cool creaminess of milk, making it a must-have for any chocolate lover. \n\nServed in a frosty glass and topped with a generous swirl of whipped cream, this milkshake is as delightful to look at as it is to taste. A sprinkle of chocolate shavings and a drizzle of chocolate syrup add a finishing touch, enhancing both the flavor and presentation. Ideal for any time of day, this Milkshake Chocolate with Whipped Cream is a treat that promises to satisfy cravings and bring a little extra joy to your day!",
      category: 'Drinks',
    ),
    MenuItem(
      name: 'Iced Americano with Orange and Lemon Juice',
      imageUrl: 'assets/images/iced_americano_with_orange_and_lemon_juice.png',
      description: "Iced Americano with Orange and Lemon Juice is a refreshing and invigorating twist on the classic Americano, combining the boldness of espresso with a citrusy kick. This drink brings together the deep, robust flavor of coffee with the bright, tangy notes of fresh orange and lemon juices, creating a perfectly balanced blend that's both bold and refreshing. The acidity of the citrus enhances the coffee's natural flavors, while adding a layer of zesty sweetness that makes each sip a unique experience. \n\nServed over ice in a clear glass to showcase its vibrant color layers, the Iced Americano with Orange and Lemon Juice is finished with a slice of orange and lemon on the rim, making it as visually appealing as it is delicious. This drink is perfect for a refreshing morning boost or a cool afternoon treat, offering a revitalizing taste that’s bound to awaken the senses and bring a burst of energy to your day.",
      category: 'Drinks',
    ),
  ];

  void _openMenuDetail(MenuItem menuItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MenuDetailPage(menuItem: menuItem),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = isFoodSelected ? foodItems : drinkItems;

    return Scaffold(
      appBar: const Header(),
      drawer: const Sidebar(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 114,
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color(0xFFABABAB),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildMenuIcon(
                          icon: Icons.fastfood,
                          isSelected: isFoodSelected,
                          onTap: () {
                            setState(() {
                              isFoodSelected = true;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: _buildMenuIcon(
                          icon: Icons.local_drink,
                          isSelected: !isFoodSelected,
                          onTap: () {
                            setState(() {
                              isFoodSelected = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      isFoodSelected ? 'FOODS' : 'DRINKS',
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: isFoodSelected ? 82 / 130 : 74 / 142,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final menuItem = items[index];
                  return GestureDetector(
                    onTap: () => _openMenuDetail(menuItem),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage(menuItem.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                          height: isFoodSelected ? 100 : 110,
                          width: double.infinity,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          menuItem.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 7,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: items.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Footer(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuIcon({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isSelected)
              Container(
                width: 37,
                height: 37,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            Icon(
              icon,
              size: 24,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
