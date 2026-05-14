import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CartDetailsPageShimmer extends StatelessWidget {
  const CartDetailsPageShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _cartList() {
      List<Widget> _list = [];
      for (var i = 0; i < 2; i++) {
        _list.add(Container(
          height: 180,
          //color: Colors.grey.shade300,
          margin: EdgeInsets.only(bottom: 10, top: 10),
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 20,
                      width: 200,
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 14, top: 5),
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 20,
                      width: 150,
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 14, top: 5),
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 20,
                      width: 100,
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 14, top: 5),
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  height: 110,
                  width: 120,
                  color: Colors.grey.shade300,
                )
              ],
            ),
          ),
        ));
      }
      return _list;
    }

    return SafeArea(
        child: Container(
            child: Column(children: [
      Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            children: [
              Column(
                children: _cartList(),
              ),
              Container(
                height: 45,
                width: 350,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20)),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 45,
                width: 350,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20)),
              ),
            ],
          ))
    ])));
  }
}
