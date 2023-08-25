import 'package:flutter/material.dart';
import 'package:shop_app/components/variant_picker.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/components/color_dots.dart';
import 'package:string_to_color/string_to_color.dart';

Map<String, dynamic> groupVariants(List<Variant> variants) {
  List<Color> colors = [];
  List<String> styles = [];
  List<String> materials = [];
  List<String> sizes = [];

  variants.forEach((element) {
    if (element.color != null && element.color != "") {
      Color color = ColorUtils.stringToColor(element.color!.toLowerCase());

      if (!colors.contains(color)) colors.add(color);
    }
    if (element.style != null &&
        element.style != "" &&
        !styles.contains(element.style!)) {
      styles.add(element.style!);
    }
    if (element.material != null &&
        element.material != "" &&
        !materials.contains(element.material!)) {
      materials.add(element.material!);
    }
    if (element.size != null &&
        element.size != "" &&
        !sizes.contains(element.size!)) {
      sizes.add(element.size!);
    }
  });

  return {
    'colors': colors.length == 0 ? null : colors,
    'styles': styles.length == 0 ? null : styles,
    'materials': materials.length == 0 ? null : materials,
    'sizes': sizes.length == 0 ? null : sizes,
  };
}

Map<String, dynamic> buildVariantWithChildren(
  Map<String, dynamic> item,
  Map<String, dynamic>? object,
) {
  if (object == null) {
    return item;
  } else {
    final result = buildVariantWithChildren(item, object["child"]);

    return {
      ...object,
      "child": result,
    };
  }
}

Map<String, dynamic>? getVariantsDataWithChildren(List<Variant> variants) {
  final groupedVariants = groupVariants(variants);
  Map<String, dynamic>? groupVariantsWithChildren;

  variantOptions.forEach((element) {
    if (groupedVariants[element] != null) {
      final newVariant = {"type": element, "values": groupedVariants[element]};

      groupVariantsWithChildren =
          buildVariantWithChildren(newVariant, groupVariantsWithChildren);
    }
  });

  return groupVariantsWithChildren;
}

dynamic getVariantWidget = (String type, dynamic values) {
  switch (type) {
    case "colors":
      return ColorDots(values: values);
    case "sizes":
      return VariantPicker(type: type, values: values);
    case "colors":
      return ColorDots(values: values);
    case "colors":
      return ColorDots(values: values);
    case "colors":
      return ColorDots(values: values);
    default:
      return Container();
  }
};
