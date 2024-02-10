import 'package:Wishy/components/active_orders_widget.dart';
import 'package:Wishy/components/empty_state_widget.dart';
import 'package:Wishy/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/components/history_product_card.dart';
import 'package:Wishy/models/Order.dart';
import 'package:Wishy/services/graphql_service.dart';
import 'package:Wishy/size_config.dart';

class OrdersTab extends StatefulWidget {
  @override
  _OrdersTabState createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> {
  int selectedOrderIndex = 0;
  bool _isEmpty = false;
  GraphQLPaginationService _paginationActiveServices = GraphQLPaginationService(
      queryName: "getUserOrders",
      variables: {"limit": 5, "active_orders": true});
  GraphQLPaginationService _paginationHistoryServices =
      GraphQLPaginationService(
          queryName: "getUserOrders",
          variables: {"limit": 5, "active_orders": false});
  List<Order> activeOrders = [];
  List<Order> historyOrders = [];
  ScrollController _historyOrdersController = ScrollController();

  @override
  void initState() {
    super.initState();

    _historyOrdersController.addListener(() {
      if (_historyOrdersController.position.pixels ==
          _historyOrdersController.position.maxScrollExtent) {
        fetchHistoryData();
      }
    });

    _initOrders();
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

  void _initOrders() async {
    await Future.wait([
      fetchActiveData(),
      fetchHistoryData(),
    ]);

    if (mounted) {
      setState(() {
        _isEmpty = activeOrders.isEmpty && historyOrders.isEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isEmpty && activeOrders.isEmpty && historyOrders.isEmpty)
      return Center(child: CircularProgressIndicator());

    return CustomScrollView(slivers: [
      SliverList(
          delegate: SliverChildListDelegate(
        [
          SizedBox(height: getProportionateScreenHeight(10)),
          if (activeOrders.isNotEmpty)
            ActiveOrdersWidget(orders: activeOrders, nextPage: fetchActiveData),
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
                      order: order,
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
