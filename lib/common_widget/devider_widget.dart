import 'package:flutter/material.dart';

class DeviderWidget extends StatelessWidget {
  final Color color;
  final double height;
  const DeviderWidget(this.color, this.height, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Divider(
        color: this.color,
        height: this.height,
      ),
    );
  }
}
