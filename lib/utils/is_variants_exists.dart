import 'package:Wishy/models/Product.dart';

bool isVariantsExists(List<Variant>? variants) {
  if (variants == null || variants.length == 0)
    return false;
  else if (variants.length == 1) {
    final variant = variants[0];
    return variant.attributes != null;
  }

  return true;
}
