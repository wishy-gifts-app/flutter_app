import 'dart:async';
import 'package:Wishy/components/interactive_dialog/chat_message.dart';
import 'package:Wishy/components/interactive_dialog/typing_indicator.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/size_config.dart';

class InteractiveDialog<T> extends StatefulWidget {
  final BuildContext context;
  final String title;
  final Future<List<T>?> Function() nextPage;
  final Future<T?> Function(String message) saveMessage;

  InteractiveDialog(
      {Key? key,
      required this.context,
      required this.nextPage,
      required this.saveMessage,
      required this.title})
      : super(key: key);

  @override
  _InteractiveDialogState createState() => _InteractiveDialogState();
}

class _InteractiveDialogState extends State<InteractiveDialog> {
  TextEditingController messageController = TextEditingController();
  bool isAwaitingResponse = true;
  bool isMessageAvailable = true;
  List<Widget> messages = [];
  ScrollController _scrollController = ScrollController();

  void _onSubmit<T>(T value) {}

  void sendMessage(String message) {
    widget.saveMessage(message);
    setState(() {
      messages.add(ChatMessage(
        message: message,
        isConsultant: false,
        actionType: CustomActionType.none,
        onSubmit: _onSubmit,
      ));
    });
    messageController.clear();
    Timer(
        Duration(milliseconds: 100),
        () => _scrollController
            .jumpTo(_scrollController.position.maxScrollExtent));
  }

  Future<void> _fetchItems() async {
    final results = await widget.nextPage();

    if (mounted) {
      if (results != null && results.length > 0) {
        setState(() {
          isAwaitingResponse = false;
          messages.insertAll(
              0,
              results
                  .map((v) => ChatMessage(
                        message: v.message,
                        isConsultant: v.isConsultant,
                        isEndChat: v.isEndChat,
                      ))
                  .toList()
                  .reversed
                  .toList());
        });
      }
    }
  }

  @override
  void initState() {
    _fetchItems().then((value) => Timer(
        Duration(milliseconds: 100),
        () => _scrollController
            .jumpTo(_scrollController.position.maxScrollExtent)));

    _scrollController.addListener(() {
      if (_scrollController.position.pixels <=
          _scrollController.position.minScrollExtent) {
        _fetchItems();
      }
    });

    super.initState();
  }

  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          leading: IconButton(
            icon: Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 1,
        ),
        body: Padding(
          padding: EdgeInsets.all(getProportionateScreenHeight(16)),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  children: [
                    ...messages,
                    if (isAwaitingResponse)
                      TypingIndicator(
                        profilePicture: 'assets/images/consultant_profile.png',
                      ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: "Type your message...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: isMessageAvailable
                          ? () => sendMessage(messageController.text)
                          : null,
                      child: CircleAvatar(
                        backgroundColor: kPrimaryColor,
                        child: Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
