import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingPLPPage extends StatefulWidget {
  @override
  _LoadingPLPPageState createState() => _LoadingPLPPageState();
}

class _LoadingPLPPageState extends State<LoadingPLPPage> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          enabled: _enabled,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            width: MediaQuery.of(context).size.width / 1.1,
            margin: EdgeInsets.all(10),
            height: 140,
          ),
        ),
        Expanded(
          child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              enabled: _enabled,
              child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration( color: Colors.white,  borderRadius:
                                              BorderRadius.circular(10),),
                     margin: EdgeInsets.only(
                                          bottom: 20, left: 15, right: 15),
                                      padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                      height: 100.0,
                      // width: 20.0,
                     
                    );
                  })
              // GridView.builder(
              //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: 2,
              //       mainAxisSpacing: 6.0,
              //       crossAxisSpacing: 6.0,
              //       childAspectRatio: 0.70,
              //     ),
              //     itemCount: 2,
              //     itemBuilder: (context, i) {
              //       return Container(
              //         margin: EdgeInsets.fromLTRB(16, 10, 16, 10),
              //         height: 40.0,
              //         width: 20.0,
              //         color: Colors.white,
              //       );
              //     }),
              ),
        ),
      ],
    ));
  }
}
