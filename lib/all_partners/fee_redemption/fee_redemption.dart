import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gems_revamp/all_partners/fee_redemption/fee_redmption_details_page.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import '../../common_widget/bottombar.dart';
import '../../makesense_module/makesense_apiconfig.dart';
import 'package:http/http.dart' as http;


class FeeRedemptionPage extends StatefulWidget {
  final List? data;
  final String? title;

  const FeeRedemptionPage({Key? key, this.data, this.title})
      : super(
          key: key,
        );

  @override
  State<FeeRedemptionPage> createState() => _FeeRedemptionPageState();
}

class _FeeRedemptionPageState extends State<FeeRedemptionPage> {
  List? travelSubsectionData = [];

  @override
  void initState() {
    travelSubsectionData = widget.data;

    super.initState();
    makesenseEventcall();
    GemsGLobals.lastVisitPageName = GemsGLobals.eventEducationSpendsListingPage;
  }

  makesenseEventcall() {
    String keyName = GemsGLobals.eventEducationSpendsListingPage;
    var segmentReq = {GemsGLobals.intSource: GemsGLobals.lastVisitPageName};
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }
  

  Widget _tabbar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: BottomBar(
        initialIndex: 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        extendBody: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90.0),
          child: GradientAppBar(
            title: widget.title,
            color: white_text_color,
            size: text_font_medium18_size,
            weight: FontWeight.w500,
            centerTitle: true,
            height: 90,
          ),
        ),
        body: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 5.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: Platform.isIOS ? 3 / 2.5 : 3 / 2.8,
              padding: EdgeInsets.only(top:10),
            physics: NeverScrollableScrollPhysics(),
            children: new List.generate(travelSubsectionData!.length, (index) {
              return GestureDetector(
                onTap: () async {
                  if (travelSubsectionData![index]["sub_sec_code"] != null &&
                      travelSubsectionData![index]["sub_sec_code"] != "") {
                    switch (travelSubsectionData![index]["sub_sec_code"]
                        .toString()
                        .toLowerCase()) {
                      case "sfee":
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    FeeRedemptionDetailsPage(
                                      routeFrom: "school_fee_redeemption",
                                      title: travelSubsectionData![index]
                                          ['sub_sec_name'],
                                      description: travelSubsectionData![index]
                                          ['sub_sec_desc'],
                                      urlforandroid: travelSubsectionData![index]
                                          ['android_deep_link'],

                                    )));
                        break;
      
                      case "bfee":
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    FeeRedemptionDetailsPage(
                                      routeFrom: "bus_fee_redeemption",
                                      title: travelSubsectionData![index]
                                          ['sub_sec_name'],
                                      description: travelSubsectionData![index]
                                          ['sub_sec_desc'],
                                      urlforandroid: travelSubsectionData![index]
                                          ['android_deep_link'],
                                  
                                    )));
                        break;
                      case "uni_red":
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    FeeRedemptionDetailsPage(
                                        routeFrom: "uniform_redeemption",
                                        title: travelSubsectionData![index]
                                                ['sub_sec_name'] ??
                                            "",
                                        description: travelSubsectionData![index]
                                                ['sub_sec_desc'] ??
                                            "",
                                        url: travelSubsectionData![index]
                                            ['web_deep_link'])));
                        break;
                    }
                  }
                },
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 140,
                        width: MediaQuery.of(context).size.width / 2.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                              placeholder: (context, url) => Container(
                                    child: Image.asset(
                                      ImageConstants.noimages,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                              errorWidget: (context, url, error) {
                                return Image.asset(
                                  ImageConstants.noimages,
                                  fit: BoxFit.fill,
                                );
                              },
                              fit: BoxFit.fill,
                              imageUrl: travelSubsectionData![index]
                                  ['sub_sec_image']),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                      
                        child: FittedBox(
                          child: TextWidget(
                            text: travelSubsectionData![index]['sub_sec_name'],
                            size: text_font_medium15_size,
                            weight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                            color: flight_text_black_color,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            })),
        bottomNavigationBar:  SizedBox(height: 95, child: _tabbar()),
      ),
    );
  }
}
