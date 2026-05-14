import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/appbar_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Model/details_model.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/View/policy_inner_htmlpages.dart';
import 'package:url_launcher/url_launcher.dart';

class Policy extends StatefulWidget {
  final ContactUs? policyData;
  final routefrom;
  Policy({Key? key, this.policyData, this.routefrom}) : super(key: key);

  @override
  _PolicyState createState() => _PolicyState();
}

class _PolicyState extends State<Policy> {
  launchURL(url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
      } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _body() {
      return Column(
        children: [
          SizedBox(
            height: 15,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (cxt) => PolicyInnerHtmlPages(
                            indentifier:
                                "cancellations-returns-${this.widget.routefrom}",
                            title: "Cancellation & Return",
                          )));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.all(10),
              child: Container(
                height: 55,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: AbsorbPointer(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: TextWidget(
                          text: "Cancellation & Return",
                          size: text_font_medium15_size,
                          color: flight_text_black_color,
                          weight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: flight_text_black_color,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (cxt) => PolicyInnerHtmlPages(
                            title: "Terms & Conditions",
                            indentifier:
                                "terms-conditions-${this.widget.routefrom}",
                          )));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.all(10),
              child: Container(
                height: 55,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: AbsorbPointer(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: TextWidget(
                          text: "Terms & Conditions",
                          size: text_font_medium15_size,
                          color: flight_text_black_color,
                          weight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: flight_text_black_color,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (cxt) => PolicyInnerHtmlPages(
                            indentifier: "warranty-${this.widget.routefrom}",
                            title: "Warranty",
                          )));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.all(10),
              child: Container(
                height: 55,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: AbsorbPointer(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: TextWidget(
                          text: "Warranty",
                          size: text_font_medium15_size,
                          color: flight_text_black_color,
                          weight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: flight_text_black_color,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: new_gradient_color,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        child: SafeArea(
            bottom: false,
            top: false,
            child: Scaffold(
              backgroundColor: bg_color,
              body: _body(),
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(90.0),
                child: ShopGradientAppBar(
                  title: "Policy",
                  color: white_text_color,
                  size: 19,
                  weight: FontWeight.w500,
                  centerTitle: true,
                  height: 90,
                ),
              ),
            )));
  }
}
