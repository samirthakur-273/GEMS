import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PolicyShimmer extends StatelessWidget {
  const PolicyShimmer({Key ?key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(20),
        color: Colors.grey,
      ),
    ));
  }
}
