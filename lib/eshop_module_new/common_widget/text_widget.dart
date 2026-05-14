/* Author : Milan makwana
 Date created : 05-January -2021
 Description : Common Widget for Text */

import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final double? size;
  final Color? color;
  final FontWeight? weight;
  final bool? softwrap;
  final TextAlign? alignment;
  final TextDecoration? decoration;
  final TextAlign? textAlign;
  final fontfamily;

  final overflow;
  final maxLines;
  final toUpperCase;
  const TextWidget(
      {Key? key,
      required this.text,
      this.size,
      this.color,
      this.weight,
      this.softwrap,
      this.alignment,
      this.decoration,
      this.textAlign,
      this.overflow,
      this.maxLines,
      this.toUpperCase,
      this.fontfamily})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      this.toUpperCase == true ? this.text.toUpperCase() : this.text,
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
          // fontFamily: "Sans_Pro"
          ),
    );
  }
}
