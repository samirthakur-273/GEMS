import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/appbar_widget.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Model/details_model.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/View/policy.dart';

import '../../../common_widget/colors_widget.dart';
import '../../../common_widget/text_widget.dart';

class SellerWisePolicyPage extends StatefulWidget {
  final ContactUs? policyData;

  const SellerWisePolicyPage({Key? key, this.policyData}) : super(key: key);

  @override
  State<SellerWisePolicyPage> createState() => _SellerWisePolicyPageState();
}

class _SellerWisePolicyPageState extends State<SellerWisePolicyPage> {
  String? _appletitle = "Apple product from JTRS";
  String? _asustitle = "Asus product from Marsys";

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
                      builder: (cxt) => Policy(
                            routefrom: "apple",
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
                          text: "$_appletitle",
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
                      builder: (cxt) => Policy(
                            routefrom: "asus",
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
                          text: "$_asustitle",
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
