import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsAndConditon extends StatefulWidget {
  static String tag = 'routeproduct-page';
  final String? checkURL;

  TermsAndConditon({
    Key? key,
    @required this.checkURL,
  }) : super(key: key);

  @override
  _TermsAndConditonState createState() => new _TermsAndConditonState();
}

class _TermsAndConditonState extends State<TermsAndConditon> {
  bool isLoading = true;
  String? url;
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    if (widget.checkURL == "Terms and Conditions") {
      url = "https://www.gemsrewards.com/terms-and-conditions";
    } else if (widget.checkURL == "GEMS Rewards") {
      url = "https://www.gemsrewards.com/gems-rewards-plus";
    } else {
      url = "https://www.gemsrewards.com/privacy-policy";
    }

    _controller = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(url!));
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: TextWidget(text: "Demo"),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        child: Container(
          decoration: BoxDecoration(gradient: gradient_theme_color),
        ),
        preferredSize: Size.fromHeight(0.0),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(gradient: gradient_theme_color),
              width: MediaQuery.of(context).size.width,
              height: appBar.preferredSize.height + 90,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GradientAppBar(
                      title: widget.checkURL,
                      color: white_text_color,
                      size: text_font_medium18_size,
                      weight: FontWeight.w500,
                      centerTitle: true,
                    ),
                  ],
                ),
              ),
            ),
            isLoading
                ? Container(
                    child: Center(
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: SpinKitCircle(
                          color: btn_bg_color,
                        ),
                      ),
                    ),
                    height: MediaQuery.of(context).size.height -
                        (appBar.preferredSize.height +
                            90 +
                            MediaQuery.of(context).padding.top),
                  )
                : SizedBox(height: 0),
            Expanded(
              child: WebViewWidget(controller: _controller),
            ),
          ],
        ),
      ),
    );
  }
}
