import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../common_widget/appbar_widget.dart';
import '../common_widget/font_size.dart';
import '../common_widget/tabbarpage.dart';
import '../common_widget/text_widget.dart';
import '../eshop_module_new/utils/customloader/custome_circle_loader.dart';
import '../utils/gemsGlobals.dart';

class HomeWebview extends StatefulWidget {
  final String? appbarname;
  final String? weburl;

  HomeWebview({
    Key? key,
    @required this.appbarname,
    @required this.weburl,
  }) : super(key: key);

  @override
  State<HomeWebview> createState() => _HomeWebviewState();
}

class _HomeWebviewState extends State<HomeWebview> {
  bool isloading = true;
  String? url;

  WebViewController? webView;
  late final WebViewController webViewController;

  @override
  void initState() {
    super.initState();

    url = this.widget.weburl;
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isloading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isloading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains(GemsGLobals.salesForceUrl)) {
              salesForcePopup();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url!));
  }

  Future<bool> _onWillPop(BuildContext context) async {
    var value = await webView?.canGoBack();

    if (value!) {
      webView?.goBack();

      return false;
    } else {
      return true;
    }
  }

  salesForcePopup() async {
    await Future.delayed(Duration(milliseconds: 10));
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return PopScope(
            canPop: false,
            onPopInvoked: (canPop) async {
              Future.value(false);
            },
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child: Container(
                margin: EdgeInsets.only(top: 25, left: 20, right: 20),
                height: 100,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: TextWidget(
                        text: GemsGLobals.formSubmitSuccessText,
                        size: text_font_medium15_size,
                        weight: FontWeight.bold,
                        color: Colors.grey[700],
                        alignment: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 22, bottom: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 35,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.0,
                                  color: blue_color,
                                ),
                                borderRadius: BorderRadius.circular(3)),
                            child: new TextButton(
                              child: TextWidget(
                                text: GemsGLobals.ok.toUpperCase(),
                                color: blue_color,
                                textAlign: TextAlign.center,
                                size: text_font_size_small,
                                weight: FontWeight.bold,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        TabsScreen(
                                      initialIndex: 0,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
          canPop: true,
          onPopInvoked: (canPop) async {
            _onWillPop(context);        
          },
      child: Container(
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
                            child:
                                WebViewWidget(controller: webViewController)),
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
      ),
    );
  }
}
