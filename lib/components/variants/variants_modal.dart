import 'package:Wishy/components/dynamic_size_draggable_sheet.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/models/Product.dart';
import 'package:Wishy/components/variants/buy_now_widget.dart';

Future<void> showVariantsModal(
    BuildContext context, Product product, int? recipientId, String situation,
    {String? cursor}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (c) => DynamicSizeDraggableSheet(
      padding: EdgeInsets.zero,
      child: BuyNowWidget(
        firstMargin: 0,
        product: product,
        recipientId: recipientId,
        situation: situation,
        cursor: cursor,
      ),
    ),
  );
}
