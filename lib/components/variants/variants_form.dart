import 'package:Wishy/components/variants/variant_picker.dart';
import 'package:Wishy/models/Product.dart';
import 'package:Wishy/components/variants/color_dots.dart';

Map<String, dynamic> groupVariants(List<Variant> variants) {
  Map<String, List<Attribute>> groupedAttributes = {};

  variants.forEach((variant) {
    if (variant.attributes == null) return;

    variant.attributes?.forEach((attribute) {
      if (groupedAttributes[attribute.name] == null) {
        groupedAttributes[attribute.name] = [attribute];
      } else if (!groupedAttributes[attribute.name]!
          .any((attr) => attr.value == attribute.value))
        groupedAttributes[attribute.name]!.add(attribute);
    });
  });

  return groupedAttributes;
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

  groupedVariants.forEach((key, value) {
    final newVariant = {"type": key, "values": value};

    groupVariantsWithChildren =
        buildVariantWithChildren(newVariant, groupVariantsWithChildren);
  });

  return groupVariantsWithChildren;
}

dynamic getVariantWidget = (String type,
    List<Attribute> attributes,
    Function(Attribute) onVariantChange,
    String? chosenVariant,
    List<Attribute> availableValues) {
  switch (type) {
    case "Color":
      return ColorDots(
          availableValues: availableValues,
          attributes: attributes,
          onVariantChange: onVariantChange,
          chosenVariant: chosenVariant);
    default:
      return VariantPicker(
          type: type,
          availableValues: availableValues,
          attributes: attributes,
          onVariantChange: onVariantChange,
          chosenVariant: chosenVariant);
  }
};
