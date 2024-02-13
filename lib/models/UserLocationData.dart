import 'utils.dart';

class UserLocationData {
  final String? country;
  final String? shippingCountry;
  final String? isoCode;
  final bool isProductsAvailable;

  UserLocationData(
      {this.country,
      this.isoCode,
      this.isProductsAvailable = true,
      this.shippingCountry});

  factory UserLocationData.fromJson(Map<String, dynamic> json) {
    return UserLocationData(
      country: convertValue<String?>(json, 'country', false),
      isoCode: convertValue<String?>(json, 'iso_code', false),
      isProductsAvailable:
          convertValue<bool>(json, 'is_products_available', true),
    );
  }
}
