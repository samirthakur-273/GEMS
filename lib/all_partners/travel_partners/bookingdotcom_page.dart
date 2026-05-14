import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/bottombar.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/homepage/apiconfig/apiconfighome.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class BookingdotcomPage extends StatefulWidget {
  final String affilateID;
  const BookingdotcomPage({Key? key, required this.affilateID})
      : super(key: key);

  @override
  State<BookingdotcomPage> createState() => _BookingComPageState();
}

class _BookingComPageState extends State<BookingdotcomPage> {
  bool? bookingdotcomloader = false;

  Future<void> _launchInWebViewWithoutJavaScript(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
      webViewConfiguration: const WebViewConfiguration(enableJavaScript: true),
    )) {
      throw Exception('${GemsGLobals.invalid} $url');
    }
  }

  void affilatePartnerAPi(String affilateID) {
    if (GemsGLobals.userType != GemsGLobals.guest) {
      var body = {
        "customer_id": GemsGLobals.membershipNo,
        "partner_id": affilateID
      };

      HomeApiconfig.affilatePartner(http.Client(), body).then((result) async {
        if (result["status"] == true) {
          var url = result["values"]["partner_url"] ?? "";
          setState(() {
            var newUri = Uri.parse(url);
            _launchInWebViewWithoutJavaScript(newUri);
            bookingdotcomloader = false;
          });
        } else {
          setState(() {
            bookingdotcomloader = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _offerText() {
      return Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            TextWidget(
              text: GemsGLobals.bookingEarnText,
              size: text_font_medium_x_size,
              color: grey_text,
              weight: FontWeight.w500,
            ),
            SizedBox(
              height: 20,
            ),
            TextWidget(
              text: GemsGLobals.bookingOfferText,
              size: text_font_medium_x_size,
              color: grey_text,
              weight: FontWeight.w500,
            ),
            TextWidget(
              text: GemsGLobals.bookingSpend,
              size: text_font_medium_x_size,
              color: grey_text,
              weight: FontWeight.w500,
            ),
          ],
        ),
      );
    }

    Widget _linkButton() {
      return GestureDetector(
          onTap: () {
            setState(() {
              bookingdotcomloader = true;
            });
            affilatePartnerAPi(widget.affilateID);
          },
          child: bookingdotcomloader == false
              ? Container(
                  height: 50,
                  width: 50,
                  margin: EdgeInsets.only(top: 45, left: 20, right: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: greenboxcolor),
                  child: Center(
                    child: TextWidget(
                      text: GemsGLobals.bookNow,
                      color: white_shade,
                      size: text_font_medium_size,
                      weight: FontWeight.w500,
                    ),
                  ))
              : Container(
                  margin: EdgeInsets.only(top: 40),
                  child: SpinKitCircle(
                    color: btn_bg_color,
                  ),
                ));
    }

    Widget _gemsLogo() {
      return Container(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20.0, right: 20, top: 20, bottom: 5),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              height: 120,
              child: Image(
                image: AssetImage(ImageConstants.bookingLogo),
              ),
            ),
          ]),
        ),
      );
    }

    Widget _termsandCondition() {
      return Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(children: [
              TextWidget(
                text: '*',
                size: text_font_medium18_size,
                color: red_color,
              ),
              TextWidget(
                text: GemsGLobals.termcondition,
                size: text_font_medium_x_size,
                color: grey_text,
                weight: FontWeight.w500,
              ),
            ]),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Html(
                data: GemsGLobals.bookingCriteria,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Html(
                data: GemsGLobals.bookingTermCondition,
              ),
            ),
          ],
        ),
      );
    }

    Widget _body() {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          color: boxgrey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(
                height: 50.0,
              ),
              _gemsLogo(),
              SizedBox(
                height: 50.0,
              ),
              _offerText(),
              _linkButton(),
              SizedBox(
                height: 20.0,
              ),
              _termsandCondition(),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      );
    }

    Widget _tabbar() {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: BottomBar(initialIndex: 0),
      );
    }

    return SafeArea(
      top: false,
      child: Scaffold(
        extendBody: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90.0),
          child: GradientAppBar(
            title: GemsGLobals.bookigAppbar,
            color: white_text_color,
            size: text_font_medium18_size,
            weight: FontWeight.w500,
            centerTitle: true,
            height: 90,
          ),
        ),
        body: PopScope(
            canPop: true,
            onPopInvoked: (canPop) async {
              Future.value(false);
            },
            child: _body()),
        bottomNavigationBar: SizedBox(
          height: 95,
          child: _tabbar(),
        ),
      ),
    );
  }
}
