import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/tabbarpage.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:intl/intl.dart';

import '../common_widget/bottombar.dart';
import '../common_widget/colors_widget.dart';
import '../common_widget/font_size.dart';
import '../utils/constants_files/text_constants.dart';

class FlightPendingPage extends StatefulWidget {
  final data;
  final brno;
  const FlightPendingPage({Key? key, this.data, this.brno}) : super(key: key);

  @override
  State<FlightPendingPage> createState() => _FlightPendingPageState();
}

class _FlightPendingPageState extends State<FlightPendingPage> {
  Widget _tabbar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      // color: white_color,
      child: BottomBar(
        initialIndex: 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: gradient_theme_color),
      child: SafeArea(
        bottom: false,
        top: true,
        child: PopScope(
          canPop: false,
          onPopInvoked: (canPop) async {},
          child: Container(
            decoration: BoxDecoration(gradient: gradient_theme_color),
            child: Scaffold(
              backgroundColor: white_color,
              body: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: SingleChildScrollView(
                  child: Column(children: [
                    Container(height: 30),
                    Image.asset(ImageConstants.flight_pendingimage,
                        height: 150),
                    Container(height: 20),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 10, bottom: 10),
                        child: Column(children: [
                          Row(
                            children: [
                              TextWidget(
                                  text: AppTexts.bookingPendingText,
                                  color: red_color,
                                  weight: FontWeight.bold,
                                  size: 16),
                            ],
                          ),
                          Container(height: 5),
                          Row(
                            children: [
                              TextWidget(text: AppTexts.bookingReferenceNumberText),
                              TextWidget(
                                text: widget.brno ?? "",
                                weight: FontWeight.bold,
                              ),
                            ],
                          ),
                          Container(height: 5),
                          Row(
                            children: [
                              TextWidget(text: AppTexts.bookingDateText),
                              TextWidget(
                                  text: DateFormat(AppTexts.bookingDateFormat)
                                      .format(DateTime.now()),
                                  weight: FontWeight.bold),
                            ],
                          ),
                        ]),
                      ),
                    ),

                    SizedBox(height: 10),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10, top: 10, bottom: 15),
                        child: Column(children: [
                          Wrap(
                            children: [
                              TextWidget(text: AppTexts.dearText),
                              TextWidget(
                                  text: GemsGLobals.userFirstName.toString(),
                                  weight: FontWeight.bold),
                              TextWidget(text: ","),
                              SizedBox(
                                height: 5,
                                ),
                                RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                  color: black_color,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  ),
                                  children: [
                                  TextSpan(
                                    text:
                                      AppTexts.bookingPendingMessage,
                                  ),
                                  TextSpan(
                                    text: AppTexts.pendingConfirmationText,
                                    style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                      AppTexts.coordinatingMessage,
                                  ),
                                  ],
                                ),
                                ),
                              Wrap(
                                children: [
                                  TextWidget(
                                      text:
                                         AppTexts.questionsMessage),
                                    RichText(
                                    text: TextSpan(
                                      children: [
                                      TextSpan(
                                        text: AppTexts.supportEmailText,
                                        style: TextStyle(
                                        color: aqua_blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                        AppTexts.supportContactNumberText,
                                        style: TextStyle(
                                        color: black_color,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        ),
                                      ),
                                      ],
                                    ),
                                    ),
                                  TextWidget(
                                    text: AppTexts.supportContactNumberTextValue,
                                    weight: FontWeight.bold,
                                  ),
                                ],
                              ),
                              Wrap(
                                children: [
                                  TextWidget(
                                    text:
                                       AppTexts.shouldWeBeUnableToConfirmText,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text:
                                          AppTexts.weWillNotifyText,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: AppTexts.refundProcessingTimeText,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              TextWidget(
                                text:
                                    AppTexts.thankYouText,
                              ),
                            ],
                          ),
                        ]),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TabsScreen(
                                              initialIndex: 0,
                                            )));
                                // Navigator.of(context).pushNamed('/tabbarpage');
                              });
                            },
                            child: Container(
                              height: 45,
                              width: 180,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Color(0xff6646b2),
                                      Colors.blue,
                                    ],
                                  )),
                              child: const Center(
                                  child: TextWidget(
                                text: 'Back to Home',
                                color: white_text_color,
                                size: text_font_medium18_size,
                                weight: FontWeight.w600,
                              )),
                            ),
                          )
                        ],
                      ),
                    )

                    // ],),
                    // SizedBox(height:50),
                  ]),
                ),
              ),

              // bottomNavigationBar:_tabbar() ,
            ),
          ),
        ),
      ),
    );
  }
}
