// import 'dart:async';

// import 'package:flutter/material.dart';
// // import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:gems_revamp/common_widget/colors_widget.dart';
// import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
// import 'package:gems_revamp/eshop_module_new/common_widget/loader_widget.dart';
// import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';

// class AppWebView extends StatefulWidget {
//   final title, urlKey;
//   AppWebView({this.title, this.urlKey});

//   @override
//   _AppWebViewState createState() => _AppWebViewState();
// }

// class _AppWebViewState extends State<AppWebView> {
//   // final flutterWebviewPlugin = new FlutterWebviewPlugin();
//   // StreamSubscription<WebViewStateChanged>? _onStateChanged;

//   @override
//   void initState() {
//     _onStateChanged =
//         flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
//       if (state.type == WebViewState.finishLoad) {
//         flutterWebviewPlugin.evalJavascript(
//             "document.getElementsByClassName('footer-container')[0].style.display='none';");
//       }
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _onStateChanged!.cancel();
//     flutterWebviewPlugin.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(
//           color: Colors.black,
//         ),
//         backgroundColor: Colors.white,
//         title: TextWidget(
//           text: this.widget.title,
//           size: text_size_18,
//           weight: FontWeight.w800,
//           color: black_color,
//         ),
//         centerTitle: true,
//       ),
//       body: Column(children: [
//         Stack(
//           children: [
//             WebView(
//               initialUrl: widget.urlKey,
//               javascriptMode: JavascriptMode.unrestricted,
              
//             )
//           ],
//         )
//       ]),
//     );
//     // return WebviewScaffold(
//     //   url: widget.urlKey,
//     //   appBar: AppBar(
//     //     iconTheme: IconThemeData(
//     //       color: Colors.black,
//     //     ),
//     //     backgroundColor: Colors.white,
//     //     title: TextWidget(
//     //       text: this.widget.title,
//     //       size: text_size_18,
//     //       weight: FontWeight.w800,
//     //       color: black_color,
//     //     ),
//     //     centerTitle: true,
//     //   ),
//     //   withZoom: true,
//     //   withLocalStorage: true,
//     //   hidden: true,
//     //   initialChild: Container(
//     //     child: const Center(child: CircularProgressIndicator()),
//     //   ),
//     // );
//   }
// }
