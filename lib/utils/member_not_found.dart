import 'package:flutter/material.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common_widget/colors_widget.dart';
import '../common_widget/font_size.dart';
import '../common_widget/text_widget.dart';
import 'constants_files/imageconstants.dart';

class MemberNotFound extends StatefulWidget {
  final String text;

  const MemberNotFound({key, required this.text});

  @override
  State<MemberNotFound> createState() => _MemberNotFoundState();
}

class _MemberNotFoundState extends State<MemberNotFound> {
  List _message = [];
  List email = [];

  @override
  void initState() {
    _message = widget.text.split('contact');
    email = _message[1].toString().split('for');
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
            bottom: false,
            top: false,
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(110.0),
                  child: Container(
                      decoration: BoxDecoration(gradient: gradient_theme_color),
                      alignment: Alignment.bottomLeft,
                      padding: EdgeInsets.only(
                        top: 25,
                      ),
                      height: 90,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(right: 30),
                                child: TextWidget(
                                  text: "Member Deactivate",
                                  color: white_text_color,
                                  size: text_font_medium18_size,
                                  weight: FontWeight.w500,
                                )),
                          )
                        ],
                      ))),
              body: SizedBox(
                  height: 650,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Image.asset(
                          ImageConstants.member_deactivate,
                          height: 200,
                          width: 200,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // _openUrl('mailto:support@gemsrewards.com');
                          _openUrl('mailto:${email[0].toString().trim()}?subject=Gems Profile ${GemsGLobals.membershipNo}');

                        },
                        child: Container(
                            alignment: Alignment.center,
                            child: TextWidget(
                              text: widget.text,
                              size: text_font_medium18_size,
                              weight: FontWeight.w500,
                              alignment: TextAlign.center,
                            )),
                      ),
                    ],
                  )),
            )),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
