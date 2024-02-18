import 'package:Wishy/components/address.dart';
import 'package:Wishy/models/Order.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/constants.dart';
import 'package:rounded_background_text/rounded_background_text.dart';

class HistoryProductCard extends StatelessWidget {
  final Order order;

  const HistoryProductCard({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final variant = order.product.variants?.firstWhere(
      (element) => element.id == order.variantId,
    );

    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // if (order.recipientUserName != null &&
              //     order.recipientUserName!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  // "Gift for: ${order.recipientUserName}",
                  order.address.name,
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              if (variant?.title != null) ...[
                RoundedBackgroundText(
                  variant!.title,
                  backgroundColor: Colors.white.withOpacity(0.8),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, fontFamily: 'Muli'),
                ),
                SizedBox(
                  height: 4,
                )
              ],
              if (order.product.images.isNotEmpty)
                Image.network(
                  variant?.image?.url ?? order.product.images[0].url,
                  fit: BoxFit.contain,
                  height: 90,
                )
              else
                Text("Image not available"),
              Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    order.product.title,
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                    maxLines: 4,
                  )),
              Text(
                "${marketDetails["symbol"]}${order.price}",
                style: TextStyle(fontSize: 10),
              ),
              Divider(
                height: 12,
                color: kPrimaryLightColor,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: AddressSubtitle(
                    address: order.address,
                    fontSize: 9.5,
                    textAlign: TextAlign.center,
                  )),
            ],
          ),
        ]));
  }
}
