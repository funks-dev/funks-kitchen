class Order {
  final String id;
  final String userId;
  final int totalAmount;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final String? qrCodeUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.userId,
    required this.totalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    this.qrCodeUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      totalAmount: json['total_amount'],
      paymentMethod: json['payment_method'],
      paymentStatus: json['payment_status'],
      orderStatus: json['order_status'],
      qrCodeUrl: json['qr_code_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}