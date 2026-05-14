import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/homepage/apiconfig/apiconfighome.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/offer_module/offer_detail/offer_detail.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../common_widget/bottombar.dart';

class OtherPartners extends StatefulWidget {
  final List? travelsubection;

  const OtherPartners({Key? key, this.travelsubection})
      : super(
          key: key,
        );

  @override
  State<OtherPartners> createState() => _OtherPartnersState();
}

class _OtherPartnersState extends State<OtherPartners> {
  List? travelSubsectionData = [];

  bool? bookingdotcomloader = false;

  @override
  void initState() {
    travelSubsectionData = widget.travelsubection;

    super.initState();
  }

  Widget _tabbar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      // color: black_color,
      child: BottomBar(
        initialIndex: 0,
      ),
    );
  }

  affilatePartnerAPi(String affilateID) {
    if (GemsGLobals.userType != "guest") {
      var body = {
        "customer_id": GemsGLobals.membershipNo,
        "partner_id": affilateID
      };

     
      HomeApiconfig.affilatePartner(http.Client(), body).then((result) async {

        if (result["status"] == true) {
            setState(() {
            bookingdotcomloader=false;
          });
          var url = result["values"]["partner_url"] ?? "";
          await launchUrl(
              Uri.parse(
                url.toString(),
              ),
              mode: LaunchMode.externalApplication);

         // LaunchUrl.openLink(url: url);
        }else{
            setState(() {
            bookingdotcomloader=false;
          });
        }
      });
    } else {
      // DialogAlert.showLoginAlert(context);
    }
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
            title: 'Other Partners',
            color: white_text_color,
            size: text_font_medium18_size,
            weight: FontWeight.w500,
            centerTitle: true,
            height: 90,
          ),
        ),
        body:bookingdotcomloader ==true? SpinKitCircle(color: blue_color,): GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 4.3 / 4.4,
            crossAxisSpacing: 1,
            primary: false,
            shrinkWrap: true,
            padding: EdgeInsets.all(10),
            physics: NeverScrollableScrollPhysics(),
            children: new List.generate(travelSubsectionData!.length, (index) {
              return GestureDetector(
                onTap: () async {
                  if (travelSubsectionData![index]["sub_sec_code"] != null &&
                      travelSubsectionData![index]["sub_sec_code"] != "") {
                    switch (travelSubsectionData![index]["sub_sec_code"]
                        .toString()
                        .toLowerCase()) {
                      case 'affiliate':
                           setState(() {
                            bookingdotcomloader =true;
                          });
                        await affilatePartnerAPi(
                            travelSubsectionData![index]['affiliate_id']);
                        break;
      
                      case 'offer':
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => OfferDetail(
                                      brandcode: travelSubsectionData![index]
                                          ["brand_code"],
                                      outletcode: travelSubsectionData![index]
                                          ["outlet_code"],
                                      partnerbrandid: travelSubsectionData![index]
                                          ["partner_brndid"],
                                      catcode: travelSubsectionData![index]
                                              ["category_code"] ??
                                          "",
                                      catname: travelSubsectionData![index]
                                              ["category_name"] ??
                                          "",
                                      subcatheading: travelSubsectionData![index]
                                              ["alt_cat_name"] ??
                                          "",
                                    )));
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
                              fit: BoxFit.cover,
                              imageUrl: travelSubsectionData![index]
                                  ['sub_sec_image']),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: TextWidget(
                          text: travelSubsectionData![index]['sub_sec_name'],
                          size: text_font_medium15_size,
                          weight: FontWeight.w500,
                          color: flight_text_black_color,
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
