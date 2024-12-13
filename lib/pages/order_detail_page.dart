import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import '../components/sidebar.dart';

final supabase = Supabase.instance.client;

class OrderDetailPage extends StatefulWidget {
  final String orderId;

  const OrderDetailPage({
    super.key,
    required this.orderId,
  });

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  bool isLoading = true;
  Map<String, dynamic>? orderData;
  List<Map<String, dynamic>> orderItems = [];

  @override
  void initState() {
    super.initState();
    fetchOrderDetail();
  }

  Future<void> fetchOrderDetail() async {
    setState(() => isLoading = true);

    // Menambahkan delay untuk efek shimmer
    await Future.delayed(const Duration(seconds: 2));

    try {
      final response = await supabase
          .from('orders')
          .select('''
            *,
            order_items:order_items (
              *,
              menu_item:menu_items (*)
            )
          ''')
          .eq('id', widget.orderId)
          .single();

      setState(() {
        orderData = response;
        orderItems = List<Map<String, dynamic>>.from(response['order_items']);
        isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching order detail: $e');
      }
      setState(() => isLoading = false);
    }
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              height: 92,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              height: 200,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              height: 150,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildLoadingShimmer(),
        ),
      );
    }

    final createdAt = DateTime.parse(orderData!['created_at']);
    final subtotal = orderItems.fold<int>(0, (sum, item) => sum + (item['quantity'] * item['menu_item']['price'] as int));
    final deliveryFee = 5000;
    final packagingFee = 5000;
    final total = subtotal + deliveryFee + packagingFee;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      drawer: const Sidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ${orderData!['order_status']}',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
                color: orderData!['order_status'].toLowerCase() == 'cancelled' ? Colors.red : Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Items List
                    ...orderItems.map((item) => Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item['menu_item']['image_url'],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 60,
                                    height: 60,
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
                                    item['menu_item']['name'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Rp ${NumberFormat('#,###').format(item['menu_item']['price'])}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Text(
                              'x${item['quantity']}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                    )).toList(),
                    const SizedBox(height: 16),

                    // Pricing Details Card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Subtotal', style: TextStyle(fontFamily: 'Inter')),
                                Text('Rp ${NumberFormat('#,###').format(subtotal)}',
                                    style: const TextStyle(fontFamily: 'Inter')),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Delivery Fee', style: TextStyle(fontFamily: 'Inter')),
                                Text('Rp ${NumberFormat('#,###').format(deliveryFee)}',
                                    style: const TextStyle(fontFamily: 'Inter')),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Packaging Fee', style: TextStyle(fontFamily: 'Inter')),
                                Text('Rp ${NumberFormat('#,###').format(packagingFee)}',
                                    style: const TextStyle(fontFamily: 'Inter')),
                              ],
                            ),
                            const Divider(),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Promo', style: TextStyle(fontFamily: 'Inter')),
                                Text('-', style: TextStyle(fontFamily: 'Inter')),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total',
                                    style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold)),
                                Text('Rp ${NumberFormat('#,###').format(total)}',
                                    style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Order Info Card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Order Number', style: TextStyle(fontFamily: 'Inter')),
                                Text(widget.orderId.substring(0, 8),
                                    style: const TextStyle(fontFamily: 'Inter')),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Order Time', style: TextStyle(fontFamily: 'Inter')),
                                Text(DateFormat('dd/MM/yyyy HH:mm').format(createdAt),
                                    style: const TextStyle(fontFamily: 'Inter')),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Payment Method', style: TextStyle(fontFamily: 'Inter')),
                                Text(orderData!['payment_method'],
                                    style: const TextStyle(fontFamily: 'Inter')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}