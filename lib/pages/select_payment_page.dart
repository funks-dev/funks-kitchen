import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'ewallet_payment_page.dart';
import 'menu_page.dart';

final supabase = Supabase.instance.client;

class SelectPaymentPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final double totalPrice;

  const SelectPaymentPage({
    super.key,
    required this.cartItems,
    required this.totalPrice
  });

  @override
  _SelectPaymentPageState createState() => _SelectPaymentPageState();
}

class _SelectPaymentPageState extends State<SelectPaymentPage> {
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;

  Future<String> _createOrder(String paymentMethod) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Konversi total price ke integer
      final totalAmount = widget.totalPrice.round();

      // 1. Insert order
      final orderResponse = await supabase
          .from('orders')
          .insert({
        'user_id': user.id,
        'total_amount': totalAmount,
        'payment_method': paymentMethod,
        'payment_status': 'pending',
        'order_status': 'pending',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      })
          .select()
          .single();

      final orderId = orderResponse['id'];

      // 2. Insert order items - PENTING! Ini yang mengisi tabel order_items
      for (var item in widget.cartItems) {
        await supabase.from('order_items').insert({
          'order_id': orderId,
          'menu_item_id': item.menuItem.id,
          'quantity': item.quantity,
          'price_at_time': item.menuItem.price,
          'created_at': DateTime.now().toIso8601String(),
        });
      }

      return orderId;
    } catch (e) {
      if (kDebugMode) {
        print('Error creating order: $e');
      }
      rethrow;
    }
  }

  Future<void> _createPayment(String orderId, String paymentMethod) async {
    try {
      final totalAmount = widget.totalPrice.round();

      // Insert payment record
      await supabase.from('payments').insert({
        'order_id': orderId,
        'payment_method': paymentMethod,
        'amount': totalAmount,
        'status': 'pending',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error creating payment: $e');
      }
      rethrow;
    }
  }

  // Add clearCart function
  Future<void> _clearCart() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      await supabase
          .from('cart_items')
          .delete()
          .eq('user_id', user.id);
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing cart: $e');
      }
    }
  }

  void _confirmPayment() async {
    try {
      String orderId = '';

      switch (_selectedPaymentMethod) {
        case PaymentMethod.cash:
          orderId = await _createOrder('cash');
          await _createPayment(orderId, 'cash');
          if (!context.mounted) return;
          Navigator.of(context).popUntil((route) => route.isFirst);
          break;

        case PaymentMethod.card:
          orderId = await _createOrder('card');
          await _createPayment(orderId, 'card');
          if (!context.mounted) return;
          Navigator.of(context).popUntil((route) => route.isFirst);
          break;

        // Modifikasi method _confirmPayment untuk e-Wallet
        case PaymentMethod.eWallet:
          try {
            // Konversi total amount dengan round() dan pastikan tipe integer
            final totalAmount = widget.totalPrice.round();
            final user = supabase.auth.currentUser;

            if (user == null) throw Exception('User not authenticated');

            // 1. Insert order
            final orderResponse = await supabase
                .from('orders')
                .insert({
              'user_id': user.id,
              'total_amount': totalAmount, // Gunakan round()
              'payment_method': 'ewallet',
              'payment_status': 'pending',
              'order_status': 'pending',
              'qr_code_url': 'https://example.com/payment/${DateTime.now().millisecondsSinceEpoch}',
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            })
                .select()
                .single();

            final orderId = orderResponse['id'];

            // 2. Batch insert order items dengan konversi tipe yang aman
            final orderItems = widget.cartItems.map((item) => {
              'order_id': orderId,
              'menu_item_id': item.menuItem.id,
              'quantity': item.quantity,
              'price_at_time': item.menuItem.price.round(), // Konversi harga ke integer
              'created_at': DateTime.now().toIso8601String(),
            }).toList();

            // Insert order items
            await supabase
                .from('order_items')
                .insert(orderItems);

            // 3. Insert payment dengan konversi yang sama
            await supabase.from('payments').insert({
              'order_id': orderId,
              'payment_method': 'ewallet',
              'amount': totalAmount, // Gunakan round()
              'status': 'pending',
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            });

            // 4. Navigasi ke halaman e-wallet
            if (!context.mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EWalletPaymentPage(
                  cartItems: widget.cartItems,
                  totalPrice: widget.totalPrice,
                  orderId: orderId,
                  qrCodeUrl: 'https://example.com/payment/$orderId',
                ),
              ),
            );

          } catch (e) {
            if (kDebugMode) {
              print('Detailed error in e-wallet process: $e');
            }

            // Tampilkan pesan error
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Payment process failed: $e')),
            );
          }
          break;
      }

      // Hapus cart
      await _clearCart();

    } catch (e) {
      if (kDebugMode) {
        print('Error in payment confirmation: $e');
      }
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to process payment: $e')),
      );
    }
  }

  Widget _buildPaymentMethodTile({
    required IconData icon,
    required String title,
    required PaymentMethod method,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
        ),
      ),
      trailing: Radio<PaymentMethod>(
        value: method,
        groupValue: _selectedPaymentMethod,
        onChanged: (PaymentMethod? value) {
          setState(() {
            _selectedPaymentMethod = value!;
          });
        },
        activeColor: Colors.red,
      ),
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Back Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Payment Methods Text
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Payment',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Total Price
            Text(
              'Rp ${NumberFormat('#,###').format(widget.totalPrice)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
                color: Colors.red,
              ),
            ),

            // Payment Method Options
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Payment Method Header
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                        child: Text(
                          'Payment Method',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                            color: Colors.grey[800],
                          ),
                        ),
                      ),

                      // Payment Method Options
                      Column(
                        children: [
                          _buildPaymentMethodTile(
                            icon: Icons.monetization_on,
                            title: 'Cash',
                            method: PaymentMethod.cash,
                          ),
                          _buildPaymentMethodTile(
                            icon: Icons.credit_card,
                            title: 'Credit/Debit Card',
                            method: PaymentMethod.card,
                          ),
                          _buildPaymentMethodTile(
                            icon: Icons.account_balance_wallet,
                            title: 'E-Wallet',
                            method: PaymentMethod.eWallet,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Confirm Payment Button
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _confirmPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Confirm Payment',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Enum for payment methods
enum PaymentMethod {
  cash,
  card,
  eWallet
}