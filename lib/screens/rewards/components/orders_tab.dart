import 'package:Wishy/components/empty_state_widget.dart';
import 'package:Wishy/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/components/history_product_card.dart';
import 'package:Wishy/components/order_state.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/models/Order.dart';
import 'package:Wishy/services/graphql_service.dart';
import 'package:Wishy/size_config.dart';

class OrdersTab extends StatefulWidget {
  @override
  _OrdersTabState createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> {
  int selectedOrderIndex = 0;
  GraphQLPaginationService _paginationActiveServices = GraphQLPaginationService(
      queryName: "getUserOrders",
      variables: {"limit": 5, "is_order_completed": false});
  GraphQLPaginationService _paginationHistoryServices =
      GraphQLPaginationService(
          queryName: "getUserOrders",
          variables: {"limit": 5, "is_order_completed": true});
  List<Order> activeOrders = [];
  List<Order> historyOrders = [];
  ScrollController _activeOrdersController = ScrollController();
  ScrollController _historyOrdersController = ScrollController();

  @override
  void initState() {
    super.initState();

    _activeOrdersController.addListener(() {
      if (_activeOrdersController.position.pixels ==
          _activeOrdersController.position.maxScrollExtent) {
        fetchActiveData();
      }
    });

    _historyOrdersController.addListener(() {
      if (_historyOrdersController.position.pixels ==
          _historyOrdersController.position.maxScrollExtent) {
        fetchHistoryData();
      }
    });

    fetchActiveData();
    fetchHistoryData();
  }

  Future<void> fetchActiveData() async {
    List<Order>? products;
    final formatResponse = (dynamic result) =>
        (result as List<dynamic>).map((item) => Order.fromJson(item)).toList();
    final result = await _paginationActiveServices.run();
    final nextPageData = result["data"];
    products = nextPageData != null ? formatResponse(nextPageData) : null;

    if (mounted) {
      if (products != null && products.isNotEmpty) {
        setState(() {
          activeOrders.addAll(products!);
        });
      }
    }
  }

  Future<void> fetchHistoryData() async {
    List<Order>? products;
    final formatResponse = (dynamic result) =>
        (result as List<dynamic>).map((item) => Order.fromJson(item)).toList();
    final result = await _paginationHistoryServices.run();
    final nextPageData = result["data"];
    products = nextPageData != null ? formatResponse(nextPageData) : null;

    if (mounted) {
      if (products != null && products.isNotEmpty) {
        setState(() {
          historyOrders.addAll(products!);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverList(
          delegate: SliverChildListDelegate(
        [
          SizedBox(height: getProportionateScreenHeight(10)),
          if (activeOrders.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Active Orders',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 260,
              child: ListView(
                scrollDirection: Axis.horizontal,
                controller: _activeOrdersController,
                children: activeOrders.map((order) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedOrderIndex = activeOrders.indexOf(order);
                      });
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 170,
                          decoration: BoxDecoration(
                            border: activeOrders.indexOf(order) ==
                                    selectedOrderIndex
                                ? Border.all(color: kPrimaryColor, width: 2.0)
                                : null,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: HistoryProductCard(
                            product: order.product,
                            variantId: order.variantId,
                            price: order.price,
                            recipientUserName: order.recipientUserName,
                          ),
                        )),
                  );
                }).toList(),
              ),
            ),
            OrderStatusStepper(
              isOrderCompleted:
                  activeOrders[selectedOrderIndex].isOrderCompleted,
              isInDelivery: activeOrders[selectedOrderIndex].isInDelivery,
              isOrderApproved: activeOrders[selectedOrderIndex].isOrderApproved,
            ),
          ],
          if (historyOrders.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('History Orders',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Padding(
                padding: const EdgeInsets.all(10),
                child: GridView.count(
                  shrinkWrap: true,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 1.5),
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  physics: NeverScrollableScrollPhysics(),
                  controller: _historyOrdersController,
                  crossAxisCount: 2,
                  padding: EdgeInsets.all(0),
                  children: historyOrders.map((order) {
                    return HistoryProductCard(
                      product: order.product,
                      variantId: order.variantId,
                      price: order.price,
                      recipientUserName: order.recipientUserName,
                    );
                  }).toList(),
                )),
          ],
          if (activeOrders.isEmpty && historyOrders.isEmpty)
            EmptyStateWidget(
                title: "Begin Your Wishy Saga",
                body:
                    "A world of wonders is just a click away. Explore your story and curate your collection of favorites.",
                CTA: "Discover & Order",
                routeName: HomeScreen.routeName)
        ],
      ))
    ]);
  }
}
