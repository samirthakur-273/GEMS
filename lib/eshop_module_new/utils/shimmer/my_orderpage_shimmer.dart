import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MyOrderPageShimmer extends StatelessWidget {
  const MyOrderPageShimmer({Key ?key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _orderHistory() {
      List<Widget> _list = [];
      for (var i = 0; i < 2; i++) {
        _list.add(Container(
          height: 150,
          color: Colors.grey,
          margin: EdgeInsets.only(bottom: 10),
        ));
      }
      return _list;
    }

    return SafeArea(
        child: Column(
      children: [
        Container(
            height: 70,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            decoration: BoxDecoration(
              color: Color(0xfffefbea),
            ),
            child: Column(children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              height: 35,
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade300,
                                        blurRadius: 5.0)
                                  ],
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              height: 35,
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[300]!,
                                        blurRadius: 5.0)
                                  ],
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ])),
        SizedBox(
          height: 10,
        ),
        Shimmer.fromColors(
          child: Column(children: _orderHistory()),
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 3.5,
        ),
        Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 180,
                height: 40,
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    boxShadow: [
                      BoxShadow(color: Colors.grey[300]!, blurRadius: 5.0)
                    ],
                    borderRadius: BorderRadius.circular(20)),
              ),
            ))
      ],
    ));
  }
}
