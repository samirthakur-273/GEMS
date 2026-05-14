import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:shimmer/shimmer.dart';

class LoadingCatPage extends StatefulWidget {
  @override
  _LoadingCatPageState createState() => _LoadingCatPageState();
}

class _LoadingCatPageState extends State<LoadingCatPage> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            enabled: _enabled,
            child: Container(
              height: 30,
              width: 80,
              color: Colors.white,
            ),
          ),
          actions: [
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              enabled: _enabled,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: shadow_color),
                    width: 28,
                    height: 28,
                  ),
                  SizedBox(width: 5),
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: shadow_color),
                    width: 28,
                    height: 28,
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Container(
          height: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: shadow_color,
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(30))),
                width: MediaQuery.of(context).size.width / 3,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  enabled: _enabled,
                  child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, i) {
                        return Container(
                          margin: EdgeInsets.all(10),
                          height: 20.0,
                          width: 20.0,
                          color: Colors.white,
                        );
                      }),
                ),
              ),
              Expanded(
                child: Container(
                    child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  enabled: _enabled,
                  child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, i) {
                        return Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              margin: EdgeInsets.all(10),
                              height: 50.0,
                            ),
                          ],
                        );
                      }),
                )),
              )
            ],
          ),
        ));
  }
}
