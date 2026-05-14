/* Author : Ruchita Manve
 Date created : 03-July-2019
 Discription : Common Wideget for Button */
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';

class ButtonWidget extends StatelessWidget {
  final AsyncCallback? onTap;
  final String? buttonText;
  final double? width;
  final textcolor;
  final color;
  final size;
  final FontWeight? weight;
  final double? height;
  const ButtonWidget(
      {Key? key,
      this.onTap,
      this.buttonText,
      this.width,
      this.height,
      this.color,
      this.textcolor,
      this.size,
      this.weight})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: this.width,
        height: this.height,
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(this.color),
            textStyle: WidgetStateProperty.all<TextStyle>(this.textcolor)
          ),
          // color: this.color,
          onPressed: this.onTap,
          child: TextWidget(
            text: this.buttonText!,
            size: this.size,
            weight: FontWeight.bold,
          ),
          // textColor: this.textcolor,
        ));
  }
}
