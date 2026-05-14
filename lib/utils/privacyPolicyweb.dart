import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter_webview_pro/webview_flutter.dart';

// import 'package:webview_flutter/webview_flutter.dart';

class PrivacyForYouWeb extends StatefulWidget {
  final String? appbarname;
  final String? weburl;

  var finalURL;
  PrivacyForYouWeb({
    Key? key,
    @required this.appbarname,
    @required this.weburl,
  }) : super(key: key);

  @override
  _PrivacyForYouWebState createState() => new _PrivacyForYouWebState();
}

class _PrivacyForYouWebState extends State<PrivacyForYouWeb> {
  bool isloading = true;
  String? url;
  late final WebViewController webViewController;

  @override
  void initState() {
    super.initState();

    url = this.widget.weburl;
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains("https://api.whatsapp.com/")) {
              _launchURL(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url!));
  }

  Widget appBar() {
    return Container(
        decoration: BoxDecoration(
          color: Color(0xffffffff),
        ),
        height: 55,
        child: Stack(children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: new Container(
              height: 50,
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 10, bottom: 0, left: 10),
              child: new Image.asset(
                "images/flights/back_arrow_black.png",
                width: 30,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextWidget(
                        text: "Passenger Details ",
                        textAlign: TextAlign.center,
                        color: Color(0xff333333),
                        size: text_font_medium_x_size,
                        weight: FontWeight.bold),
                  ],
                ),
              ),
            ],
          ),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        bottom: false,
        top: false,
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(90.0),
              child: GradientAppBar(
                title: widget.appbarname,
                color: white_text_color,
                size: text_font_medium18_size,
                weight: FontWeight.w500,
                centerTitle: true,
                height: 90,
              ),
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                          color: Colors.grey,
                          child: WebViewWidget(controller: webViewController)),
                      if (isloading)
                        Center(
                          child: Container(
                            height: 50,
                            width: 50,
                            child: SpinKitCircle(
                              size: 50.0,
                              color: btn_bg_color,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

_launchURL(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  } else {
    throw 'Could not launch $url';
  }
}
