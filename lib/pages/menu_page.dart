import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/footer.dart';
import '../components/sidebar.dart';
import '../models/menu_item.dart';
import 'checkout_page.dart';
import 'detail_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

final supabase = Supabase.instance.client;

class MenuPage extends StatefulWidget {
  final bool initialIsFoodSelected;

  const MenuPage({super.key, required this.initialIsFoodSelected});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class CartItem {
  final MenuItem menuItem;
  int quantity;

  CartItem({
    required this.menuItem,
    this.quantity = 1,
  });
}

class _MenuPageState extends State<MenuPage> {
  late bool isFoodSelected;
  int _selectedIndex = 1;
  late String _selectedSubcategory;
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {};
  int cartItemCount = 0;  // Tambahkan ini
  double cartTotalPrice = 0;
  bool isCartExpanded = false;
  List<CartItem> cartItems = [];

  // Lists untuk menyimpan data dari Supabase
  List<MenuItem> foodItems = [];
  List<MenuItem> drinkItems = [];
  bool isLoading = true;
  bool _mounted = true;

  final List<String> foodSubcategories = ['Noodle', 'Rice', 'Snacks', 'Western'];
  final List<String> drinkSubcategories = ['Coffee', 'Non-Coffee', 'Smoothies', 'Juice'];

  @override
  void initState() {
    super.initState();
    isFoodSelected = widget.initialIsFoodSelected;
    _selectedSubcategory = isFoodSelected
        ? foodSubcategories.first
        : drinkSubcategories.first;

    for (var category in foodSubcategories) {
      _sectionKeys[category] = GlobalKey();
    }
    for (var category in drinkSubcategories) {
      _sectionKeys[category] = GlobalKey();
    }

    _scrollController.addListener(_updateSelectedCategoryFromScroll);

    // Gunakan addPostFrameCallback untuk memulai fetch data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_mounted) {
        _fetchMenuItems();
        _loadCartItems();
      }
    });
  }

  @override
  void dispose() {
    _mounted = false;
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchMenuItems() async {
    if (!_mounted) return;

    try {
      setState(() => isLoading = true);

      if (kDebugMode) {
        print('Fetching data from Supabase...');
      }

      final foodResponse = await supabase
          .from('menu_items')
          .select()
          .eq('category', 'Food');

      if (!_mounted) return;

      if (kDebugMode) {
        print('Food response: $foodResponse');
      }

      final drinkResponse = await supabase
          .from('menu_items')
          .select()
          .eq('category', 'Drinks');

      if (!_mounted) return;

      if (kDebugMode) {
        print('Drink response: $drinkResponse');
      }

      if (foodResponse == null || drinkResponse == null) {
        throw Exception('Null response from Supabase');
      }

      if (_mounted) {
        setState(() {
          foodItems = (foodResponse as List<dynamic>)
              .map((item) => MenuItem.fromJson(item))
              .toList();
          drinkItems = (drinkResponse as List<dynamic>)
              .map((item) => MenuItem.fromJson(item))
              .toList();
          isLoading = false;
        });
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error detail: $error');
      }

      if (_mounted) {
        setState(() => isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load menu items: ${error.toString()}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _updateSelectedCategoryFromScroll() {
    if (!_scrollController.hasClients) return;

    final subcategories = isFoodSelected ? foodSubcategories : drinkSubcategories;
    final double scrollOffset = _scrollController.offset;
    const double headerTriggerOffset = 120.0;

    String? visibleCategory;

    for (var category in subcategories) {
      final key = _sectionKeys[category];
      if (key?.currentContext != null) {
        final RenderBox box = key!.currentContext!.findRenderObject() as RenderBox;
        final Offset position = box.localToGlobal(Offset.zero);

        if (position.dy >= headerTriggerOffset && position.dy <= headerTriggerOffset + 50) {
          visibleCategory = category;
          break;
        }
      }
    }

    if (visibleCategory != null && visibleCategory != _selectedSubcategory) {
      setState(() {
        _selectedSubcategory = visibleCategory!;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openMenuDetail(MenuItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(id: item.id),
      ),
    );
  }

  void scrollToCategory(String category) {
    final key = _sectionKeys[category];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void updateTabController() {
    final subcategories = isFoodSelected ? foodSubcategories : drinkSubcategories;
    setState(() {
      _selectedSubcategory = subcategories.first;
    });
    _scrollController.jumpTo(0);
  }

  Future<void> _addToCart(MenuItem item) async {
    try {
      // Get the current authenticated user
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        // If no user is logged in, show a message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please log in to add items to cart'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      // Check if the item is already in the cart
      final existingCartItemResponse = await supabase
          .from('cart_items')
          .select()
          .eq('user_id', userId)
          .eq('menu_item_id', item.id)
          .maybeSingle(); // Use maybeSingle instead of single()

      if (existingCartItemResponse != null) {
        // If item exists, update the quantity
        await supabase
            .from('cart_items')
            .update({
          'quantity': existingCartItemResponse['quantity'] + 1,
          'updated_at': DateTime.now().toIso8601String(),
        })
            .eq('user_id', userId)
            .eq('menu_item_id', item.id);
      } else {
        // If item doesn't exist, insert new cart item
        await supabase.from('cart_items').insert({
          'user_id': userId,
          'menu_item_id': item.id,
          'quantity': 1,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
      }

      // Update local state
      setState(() {
        // Check if item already exists in local cart
        int existingIndex = cartItems.indexWhere((cartItem) => cartItem.menuItem.id == item.id);

        if (existingIndex != -1) {
          // If item exists, increment quantity
          cartItems[existingIndex].quantity++;
        } else {
          // If item doesn't exist, add new cart item
          cartItems.add(CartItem(menuItem: item));
        }

        // Update cart summary
        cartItemCount = cartItems.fold(0, (sum, item) => sum + item.quantity);
        cartTotalPrice = cartItems.fold(0, (sum, item) => sum + (item.menuItem.price * item.quantity));
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.name} added to cart'),
          duration: const Duration(seconds: 1),
        ),
      );

    } catch (error) {
      // Handle any errors
      if (kDebugMode) {
        print('Error adding to cart: $error');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add item to cart: $error'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _updateCartItemQuantity(int index, bool increase) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      final cartItem = cartItems[index];

      if (increase) {
        cartItem.quantity++;
      } else if (cartItem.quantity > 1) {
        cartItem.quantity--;
      } else {
        // If quantity is 1 and decreasing, remove the item
        await supabase
            .from('cart_items')
            .delete()
            .eq('user_id', userId)
            .eq('menu_item_id', cartItem.menuItem.id);

        cartItems.removeAt(index);
      }

      // Update quantity in Supabase
      if (cartItem.quantity > 0) {
        await supabase
            .from('cart_items')
            .update({
          'quantity': cartItem.quantity,
          'updated_at': DateTime.now().toIso8601String(),
        })
            .eq('user_id', userId)
            .eq('menu_item_id', cartItem.menuItem.id);
      }

      // Update local state
      setState(() {
        cartItemCount = cartItems.fold(0, (sum, item) => sum + item.quantity);
        cartTotalPrice = cartItems.fold(0, (sum, item) => sum + (item.menuItem.price * item.quantity));
      });

    } catch (error) {
      if (kDebugMode) {
        print('Error updating cart item: $error');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update cart: $error'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _clearCart() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      // Delete all cart items for the current user
      await supabase
          .from('cart_items')
          .delete()
          .eq('user_id', userId);

      // Clear local state
      setState(() {
        cartItems.clear();
        cartItemCount = 0;
        cartTotalPrice = 0;
      });

    } catch (error) {
      if (kDebugMode) {
        print('Error clearing cart: $error');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to clear cart: $error'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _loadCartItems() async {
    if (!_mounted) return;

    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      final cartResponse = await supabase
          .from('cart_items')
          .select('*, menu_items(*)')
          .eq('user_id', userId);

      if (!_mounted) return;

      final loadedCartItems = (cartResponse as List<dynamic>).map((cartItemData) {
        return CartItem(
          menuItem: MenuItem.fromJson(cartItemData['menu_items']),
          quantity: cartItemData['quantity'],
        );
      }).toList();

      if (_mounted) {
        setState(() {
          cartItems = loadedCartItems;
          cartItemCount = cartItems.fold(0, (sum, item) => sum + item.quantity);
          cartTotalPrice = cartItems.fold(0, (sum, item) => sum + (item.menuItem.price * item.quantity));
          isCartExpanded = false;
        });
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error loading cart items: $error');
      }
      if (_mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load cart items: $error'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _toggleCartExpansion() {
    setState(() {
      isCartExpanded = !isCartExpanded;
    });
  }

  Widget _buildShimmerMenuItem() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          // Image shimmer
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Content shimmer
          Expanded(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Button shimmer
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              width: 36,
              height: 36,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(String subcategory, List<MenuItem> items) {
    final filteredItems = items.where((item) => item.subcategory == subcategory).toList();

    if (filteredItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      key: _sectionKeys[subcategory],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              subcategory,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              final item = filteredItems[index];
              return GestureDetector(
                onTap: () => _openMenuDetail(item),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Item image with NetworkImage
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.imageUrl,
                          width: item.category == 'food' ? 80 : 80,
                          height: item.category == 'food' ? 80 : 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: item.category == 'food' ? 80 : 80,
                              height: item.category == 'food' ? 80 : 100,
                              color: Colors.grey[300],
                              child: const Icon(Icons.error),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Rp ${NumberFormat('#,###').format(item.price)}',  // Format harga dengan pemisah ribuan
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Inter',
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Modifikasi onPressed di IconButton add to cart
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        onPressed: () {
                          _addToCart(item);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = isFoodSelected ? foodItems : drinkItems;
    final subcategories = isFoodSelected ? foodSubcategories : drinkSubcategories;

    return Scaffold(
      appBar: const Header(),
      drawer: const Sidebar(),
      body: RefreshIndicator(
        onRefresh: _fetchMenuItems,
        color: Colors.red,
        child: Row(
          children: [
            Container(
              width: 110,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: ListView.builder(
                itemCount: subcategories.length,
                itemBuilder: (context, index) {
                  final subcategory = subcategories[index];
                  return ListTile(
                    selected: _selectedSubcategory == subcategory,
                    selectedTileColor: Colors.red[50],
                    onTap: () {
                      setState(() {
                        _selectedSubcategory = subcategory;
                      });
                      scrollToCategory(subcategory);
                    },
                    title: Text(
                      subcategory,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: _selectedSubcategory == subcategory
                            ? Colors.red
                            : Colors.black,
                        fontWeight: _selectedSubcategory == subcategory
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  _buildMenuHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: isLoading
                          ? Column(
                        children: List.generate(
                          8,
                              (index) => _buildShimmerMenuItem(),
                        ),
                      )
                          : Column(
                        children: [
                          for (var subcategory in subcategories)
                            _buildMenuItems(subcategory, items),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        isBackgroundVisible: true,
      ),
      bottomSheet: cartItemCount > 0
          ? GestureDetector(
        onTap: _toggleCartExpansion,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          color: Colors.red,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isCartExpanded)
                SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    color: Colors.red,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Section: "Total Items" and "Clear All"
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$cartItemCount Items:',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            // Mengubah bagian ini untuk icon dan text Clear All
                            TextButton.icon(
                              onPressed: () {
                                // Implement the "Clear All" logic here
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 18,
                              ),
                              label: TextButton(
                                onPressed: _clearCart,
                                child: const Text(
                                  'Clear All',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 0), // Mengurangi padding
                              ),
                            ),
                          ],
                        ),

                        // Divider
                        const Divider(
                          color: Colors.white,
                          thickness: 1,
                        ),

                        // Cart Items List
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final cartItem = cartItems[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  // Left: Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      cartItem.menuItem.imageUrl,
                                      width: 50,
                                      height: 70,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 50,
                                          height: 70,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.error),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Right: Item Name and Price
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cartItem.menuItem.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Rp ${NumberFormat('#,###').format(cartItem.menuItem.price * cartItem.quantity)}',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Quantity Control
                                  Row(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        width: 26,
                                        height: 26,
                                        child: IconButton(
                                          onPressed: () => _updateCartItemQuantity(index, false),
                                          icon: const Icon(
                                            Icons.remove,
                                            color: Colors.red,
                                            size: 10,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        cartItem.quantity.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        width: 26,
                                        height: 26,
                                        child: IconButton(
                                          onPressed: () => _updateCartItemQuantity(index, true),
                                          icon: const Icon(
                                            Icons.add,
                                            color: Colors.red,
                                            size: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 2),
                      ],
                    ),
                  ),
                ),
              // Bottom Section: Cart Summary and Checkout
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.red,
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Image.asset('assets/images/funks_logo_header.png', height: 50, width: 50),
                        if (cartItemCount > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                cartItemCount.toString(),
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 10,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Rp ${NumberFormat('#,###').format(cartTotalPrice)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutPage(
                                  cartItems: cartItems,
                                  totalPrice: cartTotalPrice,
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 10,
                            ),
                            child: const Text(
                              'Check Out',
                              style: TextStyle(
                                color: Colors.red,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
          : null,
    );
  }

  Widget _buildMenuHeader() {
    return Column(
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
                    updateTabController();
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
                    updateTabController();
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
      ],
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