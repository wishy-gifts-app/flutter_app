import 'package:Wishy/components/history_product_card.dart';
import 'package:Wishy/components/order_state.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/models/Order.dart';
import 'package:flutter/material.dart';

class ActiveOrdersWidget extends StatefulWidget {
  final List<Order> orders;
  final void Function() nextPage;

  ActiveOrdersWidget({required this.orders, required this.nextPage});

  @override
  _ActiveOrdersWidgetState createState() => _ActiveOrdersWidgetState();
}

class _ActiveOrdersWidgetState extends State<ActiveOrdersWidget> {
  ScrollController _activeOrdersController = ScrollController();
  int _selectedOrderIndex = 0;

  void initState() {
    _activeOrdersController.addListener(() {
      if (_activeOrdersController.position.pixels ==
          _activeOrdersController.position.maxScrollExtent) {
        widget.nextPage();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Active Orders',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      Container(
        height: 280,
        child: ListView(
          scrollDirection: Axis.horizontal,
          controller: _activeOrdersController,
          children: widget.orders.map((order) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedOrderIndex = widget.orders.indexOf(order);
                });
              },
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 170,
                    decoration: BoxDecoration(
                      border:
                          widget.orders.indexOf(order) == _selectedOrderIndex
                              ? Border.all(color: kPrimaryColor, width: 2.0)
                              : null,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: HistoryProductCard(
                      order: order,
                    ),
                  )),
            );
          }).toList(),
        ),
      ),
      OrderStatusStepper(
        order: widget.orders[_selectedOrderIndex],
      ),
    ]);
  }
}
