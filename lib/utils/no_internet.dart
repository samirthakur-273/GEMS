import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/utils/connectivity.dart';

import 'constants_files/imageconstants.dart';

class NoInternet extends StatefulWidget {
  final String? noConnection;
  final String? type;

  const NoInternet({Key? key, this.noConnection, this.type}) : super(key: key);

  @override
  _NoInternetState createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
          bottom: false,
          top: false,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(110.0),
              // child: GradientAppBar(
              //   title: "No Internet!",
              //   color: white_text_color,
              //   size: 18,
              //   weight: FontWeight.w500,
              //   centerTitle: true,
              //   height: 110,
              // ),
              child:Container(
          decoration: BoxDecoration(gradient: gradient_theme_color),
          alignment: Alignment.bottomLeft,
          padding: EdgeInsets.only(
            top: 25,
          ),
          height:  90,
          child: Container(
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    // Navigator.of(context).maybePop();
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue[400],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Container(
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 27,
                          color: white_text_color,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: 30),
                    child: 
                  
                    TextWidget(
                      text:"No Internet!",
                       color: white_text_color,
                         size: text_font_medium18_size,
                weight: FontWeight.w500,
             
                    )
                  ),
                )
              ],
            ),
          ))
            ),
            body: retrydata(),
          )),
    );
  }

  Widget retrydata() {
    return Container(
      child: Column(
        children: <Widget>[
          // Container(
          //   child: AppBarWidget(
          //     title: "No Internet!",
          //     color: Colors.grey,
          //     size: appbar_text_size,
          //   ),
          // ),
          Expanded(
            child: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 80,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 3,
                    child: Image.asset(
                      ImageConstants.no_connection,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextWidget(
                    text: "Can't Connect",
                    weight: FontWeight.bold,
                    size: 22,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextWidget(
                    text: "Check your network and try again",
                    weight: FontWeight.normal,
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            bluishgradient,
                            blue_color,
                          ],
                        )),
                    width: MediaQuery.of(context).size.width / 1.3,
                    height: 50,
                    child: TextButton(
                      child: TextWidget(
                        text: "RETRY",
                        color: white_text_color,
                        size: 20,
                      ),
                      onPressed: () async {
                        Internetconnectivity().isConnected().then((result) {
                          if (result) {
                            Navigator.pop(context, "1");
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
