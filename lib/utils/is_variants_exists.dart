import 'package:Wishy/models/Product.dart';

bool isVariantsExists(List<Variant>? variants) {
  if (variants == null || variants.length == 0)
    return false;
  else if (variants.length == 1) {
    final variant = variants[0];
    if ((variant.color == null || variant.color == "") &&
        (variant.size == null || variant.size == "") &&
        (variant.material == null || variant.material == "") &&
        (variant.style == null || variant.style == "")) {
      return false;
    }
  }

  return true;
}
