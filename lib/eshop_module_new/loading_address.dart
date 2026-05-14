import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingAddressPage extends StatefulWidget {
  @override
  _LoadingAddressPageState createState() => _LoadingAddressPageState();
}

class _LoadingAddressPageState extends State<LoadingAddressPage> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('test'),
        actions: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            enabled: _enabled,
            child: Row(
              children: [
                Container(width: 150, height: 15, color: Colors.white),
                SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  width: 28,
                  height: 28,
                ),
                SizedBox(width: 10),
              ],
            ),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                enabled: _enabled,
                child: ListView.builder(
                  itemBuilder: (_, __) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: theme_color, width: 1)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 10.0,
                                      width: 150.0,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      height: 10.0,
                                      width: 50.0,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      height: 10.0,
                                      width: 50.0,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      height: 10.0,
                                      width: 50.0,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  width: 28,
                                  height: 28,
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  width: 28,
                                  height: 28,
                                ),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  height: 10.0,
                                  width: 100.0,
                                  color: Colors.white,
                                ),
                                Spacer(),
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  width: 28,
                                  height: 28,
                                ),
                              ],
                            ),
                          ],
                        )),
                  ),
                  itemCount: 9,
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 8.0),
            //   child: FlatButton(
            //       onPressed: () {
            //         setState(() {
            //           _enabled = !_enabled;
            //         });
            //       },
            //       child: Text(
            //         _enabled ? 'Stop' : 'Play',
            //         style: Theme.of(context).textTheme.button.copyWith(
            //             fontSize: 18.0,
            //             color: _enabled ? Colors.redAccent : Colors.green),
            //       )),
            // )
          ],
        ),
      ),
    );
  }
}
