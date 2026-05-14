/* Author : Sanjana Shetty
 Date created : 04-May-2022
 Discription : Smiles Main Screen Page*/
import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/point_conversion/smiles_module/login_smiles/login_smiles.dart';
import 'package:gems_revamp/utils/constants_files/text_constants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';

import '../../common_widget/bottombar.dart';
import '../../common_widget/text_widget.dart';
import '../../utils/constants_files/imageconstants.dart';
import '../../utils/customloader/custome_circle_loader.dart';

class SmilesMainScreen extends StatefulWidget {
  final routesFrom;

  const SmilesMainScreen({Key? key, this.routesFrom}) : super(key: key);
  @override
  _SmilesMainScreenState createState() => _SmilesMainScreenState();
}

class _SmilesMainScreenState extends State<SmilesMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _isLoading = false;
  var noConnection;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _verificationDetails() {
      return Container(
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                TextWidget(
                  text: GemsGLobals.linkSmilesToGems,
                  size: text_font_medium_x_size,
                  color: grey_text,
                  weight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
                TextWidget(
                  text: GemsGLobals.rewardAccount,
                  size: text_font_medium_x_size,
                  color: grey_text,
                  weight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
                TextWidget(
                  text: GemsGLobals.smilesToGems,
                  size: text_font_medium_x_size,
                  color: grey_text,
                  weight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
                TextWidget(
                  text: GemsGLobals.childTutionFees,
                  size: text_font_medium_x_size,
                  color: grey_text,
                  weight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget _linkButton() {
      return GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SmilesLoginPage()));
          },
          child: _isLoading == false
              ? Container(
                  height: 50,
                  width: 50,
                  margin: EdgeInsets.only(top: 45, left: 20, right: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: greenboxcolor),
                  child: Center(
                    child: TextWidget(
                      text: GemsGLobals.linkbutton,
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
        margin: EdgeInsets.only(top: 50),
        child: Center(
          child: Image.asset(
            ImageConstants.brandLogo,
            height: 90,
          ),
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
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 10.0,
                    ),
                    _gemsLogo(),
                    SizedBox(
                      height: 40.0,
                    ),
                    _verificationDetails(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _linkButton(),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }

    Widget _tabbar() {
      return Container(
        width: MediaQuery.of(context).size.width,
        // color: black_color,
        child: BottomBar(initialIndex: 0),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (canPop, result) async {
             Future.value(false);
                if (widget.routesFrom == "grocery") {
                  Navigator.pop(context);
                  Future.value(false);
                } else {
                  Navigator.pop(context,AppTexts.isFromConversionSuccessfulText);               
                }
              },
      child: Container(
        decoration: BoxDecoration(gradient: gradient_theme_color),
        child: SafeArea(
          bottom: true,
          top: false,
          child: Scaffold(
            extendBody: true,
            key: _scaffoldKey,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(90.0),
              child: GradientAppBar(
                title: "Account Linking",
                color: white_text_color,
                size: text_font_medium18_size,
                weight: FontWeight.w500,
                centerTitle: true,
                height: 90,
              ),
            ),
            body: _body(),
            bottomNavigationBar: SizedBox(height: 95, child: _tabbar()),
          ),
        ),
      ),
    );
  }
}
