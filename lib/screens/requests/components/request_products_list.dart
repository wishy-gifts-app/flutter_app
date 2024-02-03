import 'package:Wishy/components/delivery_availability_dialog.dart';
import 'package:Wishy/components/empty_state_widget.dart';
import 'package:Wishy/components/variants/variants_modal.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/screens/checkout/checkout_screen.dart';
import 'package:Wishy/screens/details/details_screen.dart';
import 'package:Wishy/screens/home/home_screen.dart';
import 'package:Wishy/utils/analytics.dart';
import 'package:Wishy/utils/is_variants_exists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/models/Request.dart';
import 'package:Wishy/services/graphql_service.dart';
import '../../../size_config.dart';

class RequestProductsList extends StatefulWidget {
  @override
  _RequestProductsState createState() => _RequestProductsState();
}

class _RequestProductsState extends State<RequestProductsList> {
  final situation = "request_product_card";
  List<Request?> requests = [];
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();

  GraphQLPaginationService _paginationService = new GraphQLPaginationService(
      queryName: "getUserRequests", variables: {"limit": 5});

  Future<bool> saveLike(
      int productId, bool isLike, BuildContext context) async {
    try {
      graphQLQueryHandler("saveLike", {
        "product_id": productId,
        "is_like": isLike,
        "user_id": GlobalManager().userId
      });

      return true;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error to save reaction. Please try again.')),
      );

      return false;
    }
  }

  Future<bool> removeRequest(Request request, BuildContext context) async {
    setState(() {
      requests.remove(request);
    });
    AnalyticsService.trackEvent(analyticEvents["REQUEST_REMOVED"]!,
        properties: {
          "Product Id": request.product.id,
          "Request Id": request.id,
          "Requester Id": request.requesterId,
          "Recipient Id": request.recipientId,
        });

    try {
      graphQLQueryHandler("updateRequestById", {
        "show_request": false,
        "id": request.id,
      });

      return true;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error to remove the request. Please try again.')),
      );

      return false;
    }
  }

  void _onCheckoutPressed(Request request) async {
    AnalyticsService.trackEvent(analyticEvents["CHECKOUT_PRESSED"]!,
        properties: {
          "Product Id": request.product.id,
          "Situation": situation,
          "Variants Exist": isVariantsExists(request.product.variants),
          "Variant Picked": false,
          "Delivery Availability": GlobalManager().isDeliveryAvailable
        });

    if (!GlobalManager().isDeliveryAvailable!) {
      await DeliveryAvailabilityDialog.show(context);

      if (!GlobalManager().isDeliveryAvailable!) {
        return;
      }
    }

    if (isVariantsExists(request.product.variants)) {
      showVariantsModal(context, request.product, null, situation);
    } else {
      AnalyticsService.trackEvent(analyticEvents["CHECKOUT_PRESSED"]!,
          properties: {
            "Product Id": request.product.id,
            "Situation": situation,
            "Variants Exist": false,
            "Variant Picked": false,
          });

      Navigator.pushNamed(
        context,
        CheckoutScreen.routeName,
        arguments: {
          'variant': request.product.variants![0],
          'productId': request.product.id,
          'recipientId': request.requesterId
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchData();
      }
    });
  }

  _fetchData() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      final formatResponse = (dynamic result) => (result as List<dynamic>)
          .map((item) => new Request.fromJson(item))
          .toList();

      final nextPageData = await _paginationService.run();
      setState(() {
        isLoading = false;
      });

      if (nextPageData["data"] != null) {
        setState(() {
          requests.addAll(formatResponse(nextPageData["data"]));
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (requests.length == 0) {
      return isLoading
          ? Center(
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(30)),
                  child: CircularProgressIndicator()))
          : EmptyStateWidget(
              title: "Begin Your Gifting Adventure!",
              body:
                  "Add your desired items and choose a friend to receive a hint. Let's turn your gift dreams into reality!",
              CTA: "Browse More Wishes",
              routeName: HomeScreen.routeName);
    }

    return Container(
      height: SizeConfig.screenHeight,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: isLoading ? requests.length + 1 : requests.length,
        itemBuilder: (context, index) {
          if (index == requests.length) {
            return CircularProgressIndicator();
          }
          Request request = requests[index]!;
          return GestureDetector(
              onTap: () => {
                    AnalyticsService.trackEvent(
                        analyticEvents["PRODUCT_DETAILS_PRESSED"]!,
                        properties: {
                          "Product Id": request.product.id,
                          'Product Title': request.product.title,
                          "Situation": situation
                        }),
                    Navigator.pushNamed(
                      context,
                      DetailsScreen.routeName,
                      arguments: ProductDetailsArguments(
                          product: request.product,
                          variantId: request.variantId,
                          recipientId: request.requesterId,
                          buttonText:
                              request.type == RequestType.requestFromUser
                                  ? "Buy For " + request.otherUserName
                                  : "Buy Now"),
                    )
                  },
              child: Slidable(
                key: ValueKey(index),
                endActionPane: _buildActionPane(request, context),
                child: Card(
                  elevation: 4.0,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Initicon(
                              text: request.otherUserName,
                              elevation: 4,
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  request.otherUserName,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  width: 160,
                                  child: Text(
                                    request.reason,
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                            Expanded(child: Container()),
                            if (request.product.images.length > 0)
                              Image.network(
                                request.product.images[0].url,
                                width: 60,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            if (request.product.images.length == 0)
                              Container(
                                width: 80,
                                child: Text(
                                  request.product.title,
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                          ],
                        ),
                        SizedBox(height: 10),
                        Chip(
                          backgroundColor:
                              request.type == RequestType.userRequest
                                  ? Colors.blue
                                  : Colors.orange,
                          label: Text(
                            request.type == RequestType.userRequest
                                ? 'You Requested'
                                : 'Requested from You',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }

  ActionPane _buildActionPane(Request request, BuildContext context) {
    List<SlidableAction> actions = [];
    if (request.type == RequestType.requestFromUser) {
      actions.add(
        SlidableAction(
          onPressed: (context) => _onCheckoutPressed(request),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          icon: Icons.shopping_cart,
          label: 'Buy',
        ),
      );
    }
    actions.add(
      SlidableAction(
        onPressed: (context) => removeRequest(request, context),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: 'Remove',
      ),
    );
    return ActionPane(
      motion: const ScrollMotion(),
      children: actions,
    );
  }
}
