import 'package:Wishy/components/animated_hint_text_field.dart';
import 'package:Wishy/components/default_button.dart';
import 'package:Wishy/components/wishy_ai.dart';
import 'package:Wishy/size_config.dart';
import 'package:flutter/material.dart';
import 'package:rounded_background_text/rounded_background_text.dart';

class QuestionCard extends StatefulWidget {
  final List<String> hintOptions;
  final String CTA;
  final String question;
  final bool withBudget;
  final List<Map<String, String>> priceRanges;
  final Function(Map<String, dynamic>, String) onSelect;

  QuestionCard({
    Key? key,
    required this.hintOptions,
    required this.onSelect,
    required this.CTA,
    required this.question,
    required this.priceRanges,
    this.withBudget = true,
  }) : super(key: key);

  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  int currentStage = 0;
  late String? selectedPriceRange;
  final TextEditingController _controller = TextEditingController();

  _onSubmit() {
    widget.onSelect(
        {"message": _controller.text, "price_range": selectedPriceRange},
        "Generating suggestions for you...");
  }

  @override
  void initState() {
    selectedPriceRange = widget.priceRanges[0]["text"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WishyAIWithBackground(),
        SizedBox(height: getProportionateScreenHeight(5)),
        RoundedBackgroundText(
          widget.question,
          backgroundColor: Colors.black.withOpacity(0.5),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Muli",
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            wordSpacing: 1,
            height: 1.2,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5),
                offset: Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
        SizedBox(
            height: getProportionateScreenHeight(widget.withBudget ? 22 : 95)),
        if (widget.withBudget)
          Align(
              alignment: Alignment.bottomLeft,
              child: Column(children: [
                RoundedBackgroundText(
                  "Your budget",
                  backgroundColor: Colors.black.withOpacity(0.5),
                  style: TextStyle(
                    fontFamily: "Muli",
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(6),
                ),
                Container(
                  width: 90,
                  child: DropdownButtonFormField<String>(
                    selectedItemBuilder: (context) {
                      return widget.priceRanges
                          .map((Map<String, String> value) {
                        return Center(
                          child: Text(value["preview"]!),
                        );
                      }).toList();
                    },
                    isExpanded: true,
                    alignment: Alignment.center,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        filled: true,
                        fillColor: Colors.white),
                    value: this.selectedPriceRange,
                    items: widget.priceRanges.map((Map<String, String> value) {
                      return DropdownMenuItem<String>(
                        alignment: Alignment.center,
                        value: value["text"],
                        child: Text(
                          value["text"]!,
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedPriceRange = newValue;
                      });
                    },
                    hint: Text('Select price range'),
                  ),
                )
              ])),
        SizedBox(height: getProportionateScreenHeight(7)),
        AnimatedHintTextField(
            hintOptions: widget.hintOptions,
            textField: TextField(
              controller: _controller,
              maxLines: 4,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            )),
        SizedBox(height: getProportionateScreenHeight(25)),
        DefaultButton(
          text: widget.CTA,
          press: _onSubmit,
        ),
      ],
    );
  }
}
