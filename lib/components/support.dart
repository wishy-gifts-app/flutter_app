import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Wishy/components/interactive_dialog/dialog.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/models/SupportMessage.dart';
import 'package:Wishy/services/graphql_service.dart';
import 'package:Wishy/utils/analytics.dart';

class SupportWidget extends StatefulWidget {
  @override
  _SupportWidgetState createState() => _SupportWidgetState();
}

class _SupportWidgetState extends State<SupportWidget> {
  bool hasNewMessage = false;
  Timer? _timer;

  void _checkUserHaveNewMessages() async {
    final result = await graphQLQueryHandler("userHasNewMessages", {});

    if (mounted) {
      setState(() {
        hasNewMessage = result["user_has_new_messages"];
      });
    }
  }

  @override
  void initState() {
    _checkUserHaveNewMessages();

    _timer = Timer.periodic(
        Duration(minutes: 5), (Timer t) => _checkUserHaveNewMessages());

    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.support_agent),
          onPressed: () {
            setState(() {
              hasNewMessage = false;
            });
            _showSupportDialog(context);
          },
        ),
        if (hasNewMessage)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  Future<SupportMessage?> _sendMessage(String message) async {
    final result = await graphQLQueryHandler("saveSupportMessage", {
      "message": message,
      "is_consultant": false,
      "is_end_chat": false,
      "user_id": GlobalManager().userId,
      "displayed_at": DateTime.now()
    });
    final formattedResult = result["data"] != null
        ? new SupportMessage.fromJson(result["data"])
        : null;

    return formattedResult;
  }

  Future<void> _showSupportDialog(BuildContext context) async {
    AnalyticsService.trackEvent(
      analyticEvents["SUPPORT_PRESSED"]!,
    );
    final GraphQLPaginationService _paginationService =
        new GraphQLPaginationService(
      queryName: "startSupport",
      variables: {"limit": 15},
    );

    Future<List<SupportMessage>?> _fetchData() async {
      final formatResponse = (dynamic result) => (result as List<dynamic>)
          .map((item) => new SupportMessage.fromJson(item))
          .toList();

      final result = await _paginationService.run();
      final formattedResult =
          result["data"] != null ? formatResponse(result["data"]) : null;

      if (formattedResult != null) {
        final newConsultantMessages = formattedResult.where((message) =>
            message.isConsultant == true && message.displayedAt == null);

        for (var message in newConsultantMessages) {
          graphQLQueryHandler(
            "updateSupportMessageById",
            {
              "id": message.id,
              "displayed_at": DateTime.now(),
            },
          );
        }
      }

      return formattedResult;
    }

    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return InteractiveDialog<SupportMessage>(
          context: context,
          title: "Customer Support",
          nextPage: _fetchData,
          saveMessage: _sendMessage,
        );
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, -1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }
}
