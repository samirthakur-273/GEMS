import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BounzHomepageShimmer extends StatelessWidget {
  const BounzHomepageShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _recommendedProducts() {
      List<Widget> _list = [];
      for (var i = 0; i < 10; i++) {
        _list.add(Container(
            width: 155,
            height: 220,
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
            )));
      }
      return _list;
    }

    Widget _recommmendProduct() {
      return Container(
        alignment: Alignment.centerLeft,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 30,
                width: 100,
                color: Colors.grey,
              ),
              SizedBox(
                height: 5,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _recommendedProducts(),
                ),
              ),
            ]),
      );
    }

    Widget _gridCategories() {
      return GridView.builder(
        shrinkWrap: true,
        itemCount: 8,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 0.0,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (context, index) {
          return Container(
            child: Column(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff1e2432),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 20,
                  width: 80,
                  color: Color(0xff1e2432),
                )
              ],
            ),
          );
        },
      );
    }

    Widget _banner() {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.shade100,
        ),
        margin: EdgeInsets.fromLTRB(0, 0, 2, 20),
        alignment: Alignment.topCenter,
      );
    }

    return SafeArea(
        child: Container(
            child: Column(children: [
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: AbsorbPointer(
                          child: Container(
                            height: 25,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade200,
                                      blurRadius: 2,
                                      spreadRadius: 2)
                                ],
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container()
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 15),
                    alignment: Alignment.center,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image.asset(
                        //   "assets/shop_assets/Group 12530@3x.png",
                        //   height: 35,
                        // ),
                        Container(
                          height: 40,
                          width: 200,
                          color: Colors.grey.shade100,
                          padding: EdgeInsets.only(top: 10),
                          alignment: Alignment.bottomCenter,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  _banner(),
                  SizedBox(
                    height: 10,
                  ),
                  _gridCategories(),
                  SizedBox(
                    height: 10,
                  ),
                  _recommmendProduct(),
                  SizedBox(
                    height: 20,
                  ),
                ],
              )))
    ])));
  }
}
