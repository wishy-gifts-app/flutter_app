import 'utils.dart';

class Product {
  final int id;
  final String title, description;
  final double price;
  final List<Variant> variants;
  final List<ProductImage> images;
  final String? vendorName;
  final DateTime? likeCreatedAt; // Optional, if it can be null
  final List<String> tags; // You can replace this with an appropriate type

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.price,
    required this.variants,
    this.vendorName,
    this.likeCreatedAt,
    required this.tags,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: convertValue<int>(json, 'id', true),
      title: convertValue<String>(json, 'title', true),
      description: convertValue<String>(json, 'description', true),
      price: 0,
      images: json['images'] != null
          ? (json['images'] as List<dynamic>)
              .map((imageJson) => ProductImage.fromJson(imageJson))
              .toList()
          : [],
      variants: (json['variants'] as List<dynamic>)
          .map((variantJson) => Variant.fromJson(variantJson))
          .toList(),
      vendorName: convertValue<String>(json, 'vendorName', false),
      tags: (json['tags'] as List<dynamic>)
          .map((tag) => tag.toString())
          .toList(), // You can adjust this based on the actual data structure
    );
  }
}

class Variant {
  final int id;
  final String title;
  final double weight, price;
  final int inventoryQuantity;

  Variant({
    required this.id,
    required this.title,
    required this.weight,
    required this.price,
    required this.inventoryQuantity,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
        id: convertValue<int>(json, 'id', true),
        title: convertValue<String>(json, 'title', true),
        weight: convertValue<double>(json, 'weight', true),
        price: convertValue<double>(json, 'price', true),
        // inventoryQuantity: convertValue<int>(json, 'inventoryQuantity', true),
        inventoryQuantity: 0);
  }
}

class ProductImage {
  final int id;
  final int? variantId;
  final String url, alt;

  ProductImage({
    required this.id,
    this.variantId,
    required this.url,
    required this.alt,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: convertValue<int>(json, 'id', true),
      variantId: convertValue<int>(json, 'variantId', false),
      url: convertValue<String>(json, 'url', true),
      alt: convertValue<String>(json, 'alt', true),
    );
  }
}
