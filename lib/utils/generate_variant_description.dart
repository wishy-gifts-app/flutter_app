import 'package:Wishy/models/Product.dart';

String generateVariantDescription(Variant? variant) {
  List<String> parts = [];

  if (variant != null) {
    if (variant.color != null && variant.color != "") {
      parts.add(variant.colorName ?? variant.color!);
    }
    if (variant.size != null && variant.size != "") {
      parts.add(variant.size!);
    }
    if (variant.material != null && variant.material != "") {
      parts.add(variant.material!);
    }
    if (variant.style != null && variant.style != "") {
      parts.add(variant.style!);
    }
  }

  String variantText =
      parts.isNotEmpty ? "Specific type: ${parts.join(', ')}" : "";

  return variantText;
}
