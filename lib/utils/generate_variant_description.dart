import 'package:Wishy/models/Product.dart';

String generateVariantDescription(Variant? variant) {
  List<String> parts = [];

  if (variant != null) {
    if (variant.color != null && variant.color != "") {
      parts.add("Color: " + (variant.colorName ?? variant.color!));
    }
    if (variant.size != null && variant.size != "") {
      parts.add("Size: " + variant.size!);
    }
    if (variant.material != null && variant.material != "") {
      parts.add("Material: " + variant.material!);
    }
    if (variant.style != null && variant.style != "") {
      parts.add("Style: " + variant.style!);
    }
  }

  String variantText = parts.isNotEmpty ? "${parts.join(', ')}" : "";

  return variantText;
}
