import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailPageShimmer extends StatelessWidget {
  const ProductDetailPageShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _productImage() {
      return Container(
        decoration: BoxDecoration(
            color: white_color,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade300, blurRadius: 2, spreadRadius: 2)
            ]),
        margin: EdgeInsets.all(25),
        height: 300,
        alignment: Alignment.center,
      );
    }

    return SafeArea(
      bottom: false,
        child: Container(
            child: Column(children: [
      Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(children: [
        _productImage(),
        SizedBox(
          height: 40,
        ),
        Divider(
          color: Colors.grey[300],
          thickness: 5,
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: 50,
          width: MediaQuery.of(context).size.width / 1.1,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          width: MediaQuery.of(context).size.width / 1.1,
          child: Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          height: 100,
          width: MediaQuery.of(context).size.width / 1.1,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
          ),
        ),
        Container(
          height: 50,
          width: 300,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20)),
        ),
      ]))
    ])));
  }
}
