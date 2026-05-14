/* Author : Ruchita Manve
 Date created : 17-sep-2019
 Discription : Common Wideget for TextWidget */

import 'package:flutter/material.dart';
import 'dart:ui' as ui;


class TextShadowWidget extends StatelessWidget {
  final Color? color;
  final String? text;
  final bool? softwrap;
  final TextAlign? alignment;
  final TextDecoration? decoration;
  final TextAlign? textAlign;
  final overflow;
  final maxLines;
  final TextStyle? style;
  final TextDirection? textDirection;
  final bool? softWrap;
  final double? textScaleFactor;
  final size;
  final FontWeight? weight;
  final bool? isHeader;

  const TextShadowWidget({
    Key? key,
    this.text,
    this.color,
    this.softwrap,
    this.alignment,
    this.decoration,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.textDirection,
    this.style,
    this.softWrap,
    this.textScaleFactor,
    this.size,
    this.weight,
    this.isHeader,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new ClipRect(
      child: new Stack(
        children: [
          new Positioned(
            top: 2.0,
            left: 2.0,
            child: new Text(
              text!,
              style: TextStyle(
                fontSize: this.size,
                fontWeight: this.weight,
                color: this.color,
              ).copyWith(color: const Color(0xffC7C7C7).withOpacity(0.5)),
            ),
          ),
          new BackdropFilter(
            filter: new ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: new Text(text!,
                style: TextStyle(
                  fontSize: this.size,
                  fontWeight: this.weight,
                  color: this.color,
                )),
          ),
        ],
      ),
    );
  }
}
