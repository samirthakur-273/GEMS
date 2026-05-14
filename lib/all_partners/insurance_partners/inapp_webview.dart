import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({required this.url, this.userToken});
  final String url;
  final String? userToken;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _webViewController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (url) async {
            setState(() => _isLoading = false);
            await _setCookies(); 
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  Future<void> _setCookies() async {
    if (widget.userToken != null) {
      final script = '''
        document.cookie = "${GemsGLobals.userToken}=${widget.userToken}; path=/";
      ''';
      await _webViewController.runJavaScript(script);
    }
  }

  Future<bool> _onWillPop() async {
    if (await _webViewController.canGoBack()) {
      await _webViewController.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        if (!didPop && await _webViewController.canGoBack()) {
          await _webViewController.goBack();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(90.0),
          child: GradientAppBar(
            title: GemsGLobals.insuranceText,
            color: white_text_color,
            size: text_font_medium18_size,
            weight: FontWeight.w500,
            centerTitle: true,
            height: 90,
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              WebViewWidget(controller: _webViewController),
              if (_isLoading)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}
