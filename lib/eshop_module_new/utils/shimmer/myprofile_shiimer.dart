import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MyProfileShimmer extends StatelessWidget {
  const MyProfileShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            padding: EdgeInsets.all(10),
            child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 20,
                        width: 100,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 20,
                        width: 200,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 40,
                            ),
                            CircleAvatar(
                              radius: 40,
                            ),
                            CircleAvatar(
                              radius: 40,
                            )
                          ],
                        ),
                      )
                    ]))));
  }
}
