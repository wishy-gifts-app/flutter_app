import 'package:Wishy/size_config.dart';
import 'package:flutter/material.dart';

class CustomDialog {
  Future<dynamic> show(
      BuildContext context, String title, Widget content) async {
    return showDialog<int>(
        context: context,
        builder: (context) => Dialog(
              insetPadding: EdgeInsets.all(5),
              elevation: 12,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              child: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.only(
                    right: 18, left: 18, bottom: 18, top: 18),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(10),
                      ),
                      content
                    ]),
              )),
            ));
  }
}
