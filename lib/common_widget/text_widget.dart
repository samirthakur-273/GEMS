/* Author : Ruchita Manve
 Date created : 04-July-2019
 Discription : Common Wideget for TextWidget */

import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String? text;
  final double? size;
  final Color? color;
  final FontWeight? weight;
  final bool? softwrap;
  final TextAlign? alignment;
  final TextDecoration? decoration;
  final TextDecorationStyle? decorationStyle;
  final TextAlign? textAlign;
  final textDecorationColor;
  final FontStyle? fontStyle;

  final overflow;
  final maxLines;
  final toUpperCase;
  const TextWidget(
      {Key? key,
      this.text,
      this.size,
      this.color,
      this.weight,
      this.softwrap,
      this.alignment,
      this.decoration,
      this.decorationStyle,
      this.textDecorationColor,
      this.textAlign,
      this.overflow,
      this.maxLines,
      this.fontStyle,
      this.toUpperCase})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      this.toUpperCase == true ? this.text!.toUpperCase() : this.text!,
      softWrap: this.softwrap,
      textAlign: this.alignment,
      overflow: this.overflow,
      maxLines: this.maxLines,
      style: TextStyle(
          fontSize: this.size,
          decoration: this.decoration,
          color: this.color,
          fontWeight: this.weight,
          fontFamily: "Poppins",
          decorationColor: this.textDecorationColor,
          fontStyle: this.fontStyle),
    );
  }
}
