import 'package:Wishy/components/animated_hint_text_field.dart';
import 'package:Wishy/size_config.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/components/default_button.dart';
import 'package:Wishy/constants.dart';
import 'package:rounded_background_text/rounded_background_text.dart';

class InteractiveCard extends StatefulWidget {
  final String type;
  final Map<String, dynamic> data;
  final String backgroundImagePath;
  final String question;

  InteractiveCard({
    Key? key,
    required this.type,
    required this.data,
    required this.backgroundImagePath,
    required this.question,
  }) : super(key: key);

  @override
  _InteractiveCardState createState() => _InteractiveCardState();
}

class _InteractiveCardState extends State<InteractiveCard> {
  int currentStage = 0;
  late String? selectedPriceRange;
  String message = '';
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> priceRanges = [
    {
      "preview": "\$50",
      "fullText": 'Under \$50',
    },
    {"preview": "\$100", "fullText": '\$50 to \$100'},
    {
      "fullText": 'Over \$100',
      "preview": "\$150",
    },
    {
      "fullText": 'Over \$600',
      "preview": "\$550",
    }
  ];

  @override
  void initState() {
    selectedPriceRange = priceRanges[0]["fullText"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: AssetImage(widget.backgroundImagePath),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
            child: SingleChildScrollView(
                child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundedBackgroundText(
                widget.question,
                backgroundColor: Colors.black.withOpacity(0.5),
                style: TextStyle(
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
                  height: getProportionateScreenHeight(
                      widget.data["withBudgetInput"] == true ? 25 : 100)),
              if (widget.data["withBudgetInput"] ?? false)
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(children: [
                      RoundedBackgroundText(
                        "Your budget",
                        backgroundColor: Colors.black.withOpacity(0.5),
                        style: TextStyle(
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
                        height: getProportionateScreenHeight(10),
                      ),
                      Container(
                        width: 90,
                        child: DropdownButtonFormField<String>(
                          selectedItemBuilder: (context) {
                            return priceRanges.map((Map<String, String> value) {
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
                          items: priceRanges.map((Map<String, String> value) {
                            return DropdownMenuItem<String>(
                              alignment: Alignment.center,
                              value: value["fullText"],
                              child: Text(
                                value["fullText"]!,
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
              SizedBox(height: getProportionateScreenHeight(25)),
              AnimatedHintTextField(
                  hintOptions: widget.data["hintOptions"]!,
                  textField: TextField(
                    controller: _controller,
                    maxLines: 4,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 15),
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
                text: widget.data["CTA"],
                press: () {},
              ),
            ],
          ),
        ))));
  }
}
