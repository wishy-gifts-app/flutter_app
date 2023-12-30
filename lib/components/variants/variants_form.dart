import 'package:flutter/material.dart';
import 'package:Wishy/components/variants/variant_picker.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/models/Product.dart';
import 'package:Wishy/components/variants/color_dots.dart';

Map<String, dynamic> groupVariants(List<Variant> variants) {
  List<Map<String, dynamic>> colors = [];
  List<String> styles = [];
  List<String> materials = [];
  List<String> sizes = [];

  variants.forEach((element) {
    if (element.color != null && element.color != "") {
      if (!colors.any((item) => item["color"] == element.color))
        colors.add({"color": element.color!, "color_name": element.colorName});
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
    'color': colors.length == 0 ? null : colors,
    'style': styles.length == 0 ? null : styles,
    'material': materials.length == 0 ? null : materials,
    'size': sizes.length == 0 ? null : sizes,
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

dynamic getVariantWidget = (String type, dynamic values,
    Function(String, String) onVariantChange, String? chosenVariant) {
  switch (type) {
    case "color":
      return ColorDots(
          values: values,
          onVariantChange: onVariantChange,
          chosenVariant: chosenVariant);
    case "size":
      return VariantPicker(
          type: type,
          values: values,
          onVariantChange: onVariantChange,
          chosenVariant: chosenVariant);
    case "style":
      return VariantPicker(
          type: type,
          values: values,
          onVariantChange: onVariantChange,
          chosenVariant: chosenVariant);
    case "material":
      return VariantPicker(
          type: type,
          values: values,
          onVariantChange: onVariantChange,
          chosenVariant: chosenVariant);
    default:
      return Container();
  }
};
