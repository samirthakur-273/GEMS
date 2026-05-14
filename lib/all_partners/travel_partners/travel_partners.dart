import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gems_revamp/all_partners/travel_partners/bookingdotcom_page.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/flight_module/flighthomepage.dart';
import 'package:gems_revamp/homepage/apiconfig/apiconfighome.dart';
import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_homepage.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/offer_module/offer_webview.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../common_widget/bottombar.dart';
import '../../utils/constants_files/text_constants.dart';

class TravelPartners extends StatefulWidget {
  final List? travelsubection;

  const TravelPartners({Key? key, this.travelsubection})
      : super(
          key: key,
        );

  @override
  State<TravelPartners> createState() => _TravelPartnersState();
}

class _TravelPartnersState extends State<TravelPartners> {
  List? travelSubsectionData = [];

  bool? bookingdotcomloader = false;

  @override
  void initState() {
    travelSubsectionData = widget.travelsubection;

    super.initState();
  }

  _makesenseeventcall(action) {
    String keyName = AppTexts.travelBannerClickedText;
    var segmentReq = {
      AppTexts.actionText: action,
      AppTexts.fromScreenText: AppTexts.homeScreenText
    };

    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  makesenseEventCall(partner) {
    String keyName = GemsGLobals.eventIoLRedirection;
    var segmentReq = {'partner': partner, 'int_source': GemsGLobals.homepage};

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

  Future<void> _launchInWebViewWithoutJavaScript(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
      webViewConfiguration: const WebViewConfiguration(enableJavaScript: true),
    )) {
      throw Exception('Could not launch $url');
    }
  }

  void affilatePartnerAPi(String affilateID) {
    if (GemsGLobals.userType != "guest") {
      var body = {
        "customer_id": GemsGLobals.membershipNo,
        "partner_id": affilateID
      };

      HomeApiconfig.affilatePartner(http.Client(), body).then((result) async {
        if (result["status"] == true) {
          var url = result["values"]["partner_url"] ?? "";
          bool isExternalBrowser = result["values"]["is_external_browser"];
          if (isExternalBrowser == false) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ForYouWeb(
                          appbarname: GemsGLobals.gemsreward,
                          weburl: url,
                        )));
          } else {
            setState(() {
              var newUri = Uri.parse(url);
              _launchInWebViewWithoutJavaScript(newUri);
              bookingdotcomloader = false;
            });
          }
        } else {
          setState(() {
            bookingdotcomloader = false;
          });
        }
      });
    } else {}
  }

  void elevateGetUrlAPi() {
    if (GemsGLobals.userType != "guest") {
      var body = {
        "customer_id": GemsGLobals.membershipNo,
      };

      HomeApiconfig.elevateTripApi(http.Client(), body).then((result) async {
        if (result["status"] == true) {
          var url = result["URL"] ?? "";
          setState(() {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ForYouWeb(
                          appbarname: "GEMS REWARDS",
                          weburl: url,
                        )));
            // LaunchUrl.openLink(url: url);
            bookingdotcomloader = false;
          });
        } else {
          setState(() {
            bookingdotcomloader = false;
          });
        }
      });
    } else {}
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
            title: AppTexts.travelPartnersText,
            color: white_text_color,
            size: text_font_medium18_size,
            weight: FontWeight.w500,
            centerTitle: true,
            height: 90,
          ),
        ),
        body: bookingdotcomloader == true
            ? SpinKitCircle(
                color: blue_color,
              )
            : GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 3 / 3.2,
                crossAxisSpacing: 12.0,
                primary: false,
                shrinkWrap: true,
                padding: EdgeInsets.all(15),
                physics: NeverScrollableScrollPhysics(),
                children:
                    new List.generate(travelSubsectionData!.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      if (travelSubsectionData![index]["sub_sec_code"] !=
                              null &&
                          travelSubsectionData![index]["sub_sec_code"] != "") {
                        switch (travelSubsectionData![index]["sub_sec_code"]
                            .toString()
                            .toLowerCase()) {
                          case (AppTexts.hotelKey):
                           
                           
                            affilatePartnerAPi(
                                travelSubsectionData![index]["affiliate_id"]);

                            _makesenseeventcall(AppTexts.hotelKey);

                          case 'flight':
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (contex) => FlightHomePage(
                                          tabIndex: 0,
                                        )));
                            break;

                          case 'affiliate':
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BookingdotcomPage(
                                        affilateID: travelSubsectionData![index]
                                            ['affiliate_id'])));
                            break;
                          case 'eletrips':
                            setState(() {
                              bookingdotcomloader = true;
                            });
                            elevateGetUrlAPi();
                            break;
                          case 'affilate_partner':
                            affilatePartnerAPi(
                                travelSubsectionData![index]['affiliate_id']);
                            break;
                          default:
                        }
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      width: MediaQuery.of(context).size.width / 2.5,
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
                  );
                })),
        bottomNavigationBar: SizedBox(height: 95, child: _tabbar()),
      ),
    );
  }
}
