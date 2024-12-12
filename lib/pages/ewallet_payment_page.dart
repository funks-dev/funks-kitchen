import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'menu_page.dart';
import 'order_complete_page.dart';

final supabase = Supabase.instance.client;

class EWalletPaymentPage extends StatelessWidget {
  final List<CartItem> cartItems;
  final double totalPrice;
  final String orderId;
  final String qrCodeUrl;

  const EWalletPaymentPage({
    super.key,
    required this.cartItems,
    required this.totalPrice,
    required this.orderId,
    required this.qrCodeUrl,
  });

  Future<void> _updatePaymentStatus(BuildContext context) async {
    try {
      // Update order status
      await supabase
          .from('orders')
          .update({
        'payment_status': 'paid',
        'order_status': 'processing',
        'updated_at': DateTime.now().toIso8601String(),
      })
          .eq('id', orderId);

      // Update payment record
      await supabase
          .from('payments')
          .update({
        'status': 'success',
        'updated_at': DateTime.now().toIso8601String(),
      })
          .eq('order_id', orderId);

      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OrderCompletePage(),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error updating payment status: $e');
      }
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update payment status: $e')),
      );
    }
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

            // Instruction Text
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Cepetan di Scan Lewat Bank atau yang kamu punya',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // QR Code using provided qrCodeUrl (Dummy QR Code)
            QrImageView(
              data: qrCodeUrl,  // QR code data (dummy)
              version: QrVersions.auto,
              size: 250.0,
              backgroundColor: Colors.white,
              errorStateBuilder: (cxt, err) {
                return const Center(
                  child: Text(
                    'Error generating QR code',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              },
            ),

            // Payment Steps
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '1. Download atau Screenshoot',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Inter',
                    ),
                  ),
                  Text(
                    '2. Buka Bank kamu atau Aplikasi Lainnya',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Inter',
                    ),
                  ),
                  Text(
                    '3. Success',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),

            // Spacer to push button to bottom
            const Spacer(),

            // Confirm Payment Button
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _updatePaymentStatus(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
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