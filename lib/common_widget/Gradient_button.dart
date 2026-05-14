import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';

class GradientButtonWidget extends StatelessWidget {
  final EdgeInsets? padding;
  final Color? color;
  final Color? disabledColor;
  final VoidCallback onTap;
  final Widget? child;
  final ShapeBorder? shape;
  final double? height;

  final String? buttonText;
  final textColor;
  final size;
  final Gradient? gradientcolor;
  final BoxShadow? shadowColor;
  final BorderRadius? borderRadius;
  const GradientButtonWidget(
      {Key? key,
      this.padding,
      this.color,
      required this.onTap,
      this.disabledColor,
      this.buttonText,
      this.textColor,
      this.size,
      this.child,
      this.shape,
      this.gradientcolor,
      this.borderRadius,
      this.shadowColor,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 60,
      decoration: BoxDecoration(
          gradient: gradientcolor ?? gradient_theme_color,
          // boxShadow: [
          //   BoxShadow(
          //       color: Colors.blue.withOpacity(0.2),
          //       offset: Offset(2.0, 2.0),
          //       blurRadius: 2.0,
          //       spreadRadius: 2.0)
          // ],
          borderRadius: borderRadius ?? BorderRadius.circular(15)),
      child: MaterialButton(
        padding: padding ?? const EdgeInsets.all(12),
        onPressed: onTap == null
            ? null
            : () {
                onTap();
              },
        // onPressed: onTap == null
        //     ? null
        //     : () {
        //         //  onTap();
        //         Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) => TabsScreen(
        //                       initialIndex: 0,
        //                     )));
        //       },
        disabledColor: disabledColor ?? Colors.grey,
        child: child,
        textColor: this.textColor,
      ),
    );
  }
}
