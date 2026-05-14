import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final int maxLines;

  const ExpandableText({
    Key? key,
    required this.text,
    this.style = const TextStyle(color: Colors.black),
    this.maxLines = 2,
  }) : super(key: key);

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool expanded = false;
  bool isOverflowing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkTextOverflow();
    });
  }

  void checkTextOverflow() {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      maxLines: widget.maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 40);

    if (textPainter.didExceedMaxLines) {
      setState(() {
        isOverflowing = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: RichText(
        text: TextSpan(
          text: expanded || !isOverflowing
              ? widget.text
              : widget.text.length > GemsGLobals.descriptionTextLength
                  ? widget.text
                          .substring(
                              GemsGLobals.zeroCount, GemsGLobals.descriptionTextLength)
                          .trim() +
                      "..."
                  : widget.text,
          style: widget.style,
          children: isOverflowing
              ? [
                  TextSpan(
                    text:
                        expanded ? GemsGLobals.readLess : GemsGLobals.readMore,
                    style: const TextStyle(color: aqua_blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        setState(() {
                          expanded = !expanded;
                        });
                      },
                  ),
                ]
              : [],
        ),
      ),
    );
  }
}
