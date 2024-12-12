class MenuItem {
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final String category;
  final String subcategory;
  final double price;

  MenuItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.category,
    required this.subcategory,
    required this.price,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      subcategory: json['subcategory'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }
}