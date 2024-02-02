import 'utils.dart';

class Product extends Identifiable {
  final int id;
  final String title;
  final double price;
  final List<Variant>? variants;
  final List<ProductImage> images;
  final String? vendorName, description, followerName, likedByUserName;
  final DateTime? likeCreatedAt;
  final bool? isLike;
  final bool isAvailable;
  final int? followerId;
  final List<String> tags;
  final DateTime? deletedAt;

  Product({
    required this.id,
    required this.title,
    this.description,
    required this.images,
    required this.price,
    required this.variants,
    this.vendorName,
    this.likeCreatedAt,
    this.isLike = null,
    this.followerId = null,
    this.followerName = null,
    this.deletedAt = null,
    this.likedByUserName = null,
    required this.isAvailable,
    required this.tags,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: convertValue<int>(json, 'id', true),
      title: convertValue<String>(json, 'title', true),
      description: convertValue<String?>(json, 'description', false),
      isLike: convertValue<bool?>(json, 'is_like', false),
      isAvailable:
          convertValue<bool>(json, 'is_available', false, defaultValue: true),
      followerId: convertValue<int?>(json, 'follower_id', false),
      followerName: convertValue<String?>(json, 'follower_name', false),
      price: convertValue<double>(json, 'price', true, defaultValue: 0),
      images: json['images'] != null
          ? (json['images'] as List<dynamic>)
              .map((imageJson) => ProductImage.fromJson(imageJson))
              .toList()
          : [],
      variants: json['variants'] != null
          ? (json['variants'] as List<dynamic>)
              .map((variantJson) => Variant.fromJson(variantJson))
              .toList()
          : null,
      vendorName: convertValue<String?>(json, 'vendor_name', false),
      likedByUserName: convertValue<String?>(
        json,
        'liked_by_user_name',
        false,
      ),
      deletedAt: convertValue<DateTime?>(json, 'deleted_at', false),
      tags:
          (json['tags'] as List<dynamic>).map((tag) => tag.toString()).toList(),
    );
  }
}

class Attribute {
  final String name, value;
  final String? additionalData;

  Attribute({
    required this.name,
    required this.value,
    this.additionalData,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      name: convertValue<String>(json, 'name', true),
      value: convertValue<String>(json, 'value', true),
      additionalData: convertValue<String?>(json, 'additional_data', false),
    );
  }

  Attribute clone() {
    return Attribute(
      name: this.name,
      value: this.value,
      additionalData: this.additionalData,
    );
  }

  bool isEqual(Attribute v) {
    return this.name == v.name && this.value == v.value;
  }

  bool isExistIn(List<Attribute> list) {
    return list.any((v) {
      return isEqual(v);
    });
  }
}

class Variant {
  final int id;
  final String title;
  final List<Attribute>? attributes;
  final double price;
  final double? weight;
  final int inventoryQuantity;
  final int? imageId;

  Variant({
    required this.id,
    required this.title,
    required this.weight,
    required this.price,
    required this.inventoryQuantity,
    required this.attributes,
    this.imageId,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: convertValue<int>(json, 'id', true),
      title: convertValue<String>(json, 'title', true),
      weight: convertValue<double?>(json, 'weight', false),
      price: convertValue<double>(json, 'price', true),
      attributes: json["attributes"] != null
          ? (json["attributes"] as List<dynamic>)
              .map((item) => Attribute.fromJson(item))
              .toList()
          : null,
      imageId: convertValue<int?>(json, 'image_id', false),
      inventoryQuantity: convertValue<int>(json, 'inventory_quantity', true),
    );
  }

  Map<String, dynamic> _toMap() {
    return {
      'id': id,
      'title': title,
      'weight': weight,
      'price': price,
      'image_id': imageId,
      'color': attributes,
      'inventoryQuantity': inventoryQuantity,
      'attributes': attributes
    };
  }

  dynamic get(String propertyName) {
    var _mapRep = _toMap();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }
}

class ProductImage {
  final int id;
  final String url, alt;

  ProductImage({
    required this.id,
    required this.url,
    required this.alt,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: convertValue<int>(json, 'id', true),
      url: convertValue<String>(json, 'url', true),
      alt: convertValue<String>(json, 'alt', true),
    );
  }
}
