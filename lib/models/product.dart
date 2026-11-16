class Product {
  final int id;
  final String name;
  final String tagline;
  final String category;
  final double price;
  final String image;
  final String description;
  final Map<String, String> specs;

  const Product({
    required this.id,
    required this.name,
    required this.tagline,
    required this.category,
    required this.price,
    required this.image,
    required this.description,
    this.specs = const {},
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawSpecs = json['specs'] as Map<String, dynamic>? ?? {};
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      tagline: json['tagline'] as String? ?? '',
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
      description: json['description'] as String? ?? '',
      specs: rawSpecs.map((key, value) => MapEntry(key, value.toString())),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'tagline': tagline,
        'category': category,
        'price': price,
        'image': image,
        'description': description,
        'specs': specs,
      };
}
