/* Author : Ruchita Manve
 Date created : 03-July-2019
 Discription : Common Wideget for Appbar */
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/internetconnectingbox.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_wishlisht_count_provider.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/View/product_list_view.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/View/product_search_view.dart';
import 'package:provider/provider.dart';

import 'font_size.dart';

class AppBarWidget extends StatelessWidget {
  final AsyncCallback? onLeftTap;

  final AsyncCallback? onRightTap;
  final String? title;
  final double? size;
  final Color? color;
  final FontWeight? weight;

  const AppBarWidget(
      {Key? key,
      this.onLeftTap,
      this.onRightTap,
      this.title,
      this.color,
      this.size,
      this.weight})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: theme_color,
          border:
              Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1))),
      height: 45,
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset(
                "assets/back_arrow.svg",
                height: 15,
                width: 15,
                color: white_text_color,
              ),
            ),
          ),
          TextWidget(
            text: this.title!,
            weight: FontWeight.w900,
            size: text_font_medium_x_size,
            color: white_color,
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () async {
                // var search = await showSearch(
                //     context: context, delegate: SearchProductList());
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (cxt) => SearchProductList())).then((value) {
                  var search = value;
                  if (search != null && search != '') {
                    internetCall(
                        context,
                        () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                    create: (context) => WishListCartCount(),
                                    child: ProductListView(
                                        catId: null, searchValue: search)))));
                  }
                });
              },
              child: Image.asset(
                "assets/shop_assets/Group 10091.png",
                color: white_color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatusBarColor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xff00A0DD),
//      elevation: 0.0,
    );
  }
}

class ShopGradientAppBar extends StatelessWidget {
  final AsyncCallback? onLeftTap;

  final AsyncCallback? onRightTap;
  final String? title;
  final double? size;
  final double? height;
  final Color? color;
  final FontWeight? weight;
  final bool? centerTitle;
  final List<Widget>? action;
  final Image? image;

  const ShopGradientAppBar(
      {Key? key,
      this.onLeftTap,
      this.onRightTap,
      this.title,
      this.color,
      this.size,
      this.weight,
      this.centerTitle,
      this.height,
      this.action,
      this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
          decoration: BoxDecoration(gradient: gradient_theme_color),
          alignment: Alignment.bottomLeft,
          padding: EdgeInsets.only(
            top: 25,
          ),
          height: height == null
              ? Platform.isIOS
                  ? 100
                  : 90
              : height,
          child: Container(
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    // Navigator.pop(context, true);
                    Navigator.of(context).maybePop();
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue[400],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Container(
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 22,
                          color: white_text_color,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: 30),
                    child: image == null
                        ? TextWidget(
                            text: this.title!,
                            size: this.size!,
                            weight: this.weight ?? FontWeight.w500,
                            color: white_text_color,
                          )
                        : image,
                  ),
                )
              ],
            ),
          )),
    );
  }
}

class GradientAppBarWithImage extends StatelessWidget {
  final AsyncCallback? onLeftTap;

  final AsyncCallback? onRightTap;
  final String? title;
  final double? size;
  final double? height;
  final Color? color;
  final FontWeight? weight;
  final bool? centerTitle;
  final List<Widget>? action;

  const GradientAppBarWithImage(
      {Key? key,
      this.onLeftTap,
      this.onRightTap,
      this.title,
      this.color,
      this.size,
      this.weight,
      this.centerTitle,
      this.height,
      this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
          decoration: BoxDecoration(gradient: gradient_theme_color),
          alignment: Alignment.bottomLeft,
          padding: EdgeInsets.only(
            top: 25,
          ),
          height: Platform.isIOS ? 100 : 90,
          child: Container(
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).maybePop();
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue[400],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Container(
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 27,
                          color: white_text_color,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: 30),
                    child: TextWidget(
                      text: this.title!,
                      size: this.size!,
                      weight: this.weight ?? FontWeight.w500,
                      color: white_text_color,
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
