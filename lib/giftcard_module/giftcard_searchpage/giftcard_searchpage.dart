/*Author:Jyoti Gite
Description:giftcard search page
date: 27 apr 2022

*/

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gems_revamp/common_widget/checkinternet.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/numberformat.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/giftcard_module/giftcard_detailspage/giftcard_detailpage.dart';
import 'package:gems_revamp/giftcard_module/giftcard_homepage/giftcard_voucherlist/giftcard_voucherlist_modal.dart';
import 'package:gems_revamp/giftcard_module/giftcard_homepage/giftcard_voucherlist/giftcard_voucherlist_presenter.dart';
import 'package:gems_revamp/giftcard_module/giftcard_homepage/giftcard_voucherlist/giftcard_voucherlist_view.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/dialogAlert.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  final String? paymentTyp;
  SearchPage({Key? key, required this.paymentTyp}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> implements GiftVoucherView {
  final myController = TextEditingController();
  bool _searchLoader = false;
  GiftVoucherModal? _giftVoucherModal;
  @override
  void initState() {
    super.initState();
  }

  void _searchList() {
    if (myController.text.length >= 1) {
      _searchLoader = true;

      setState(() {});
      CheckInternet().apiCall().then((value) async {
        if (value == true) {
          GiftVoucherPresenter().getList(
            this,
            "",
            "",
            myController.text,
            "",
            "",
            "",
            false,
          );
        } else {
          noConnection = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => NoInternet()));
          if (noConnection != null) {
            GiftVoucherPresenter().getList(
              this,
              "",
              "",
              myController.text,
              "lh",
              "",
              "",
              false,
            );
          }
        }
      });
    } else {
      setState(() {
        _searchLoader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemWidth = size.width / 2;

    Widget _title() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: <Widget>[
            TextWidget(
              text: "Search Gift Card",
              size: text_font_medium18_size,
              weight: FontWeight.w500,
            ),
            Spacer(),
            InkWell(
              onTap: () {
                Navigator.of(context).maybePop();
              },
              child: Image.asset(
                ImageConstants.giftcloseicon,
                height: 30,
              ),
            )
          ],
        ),
      );
    }

// === No voucher found widget ==========
    Widget _decisionWidget() {
      return Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextWidget(
                text: myController.text.isEmpty ? "" : "Whoops!",
                size: 25,
                weight: FontWeight.bold,
              ),
              TextWidget(
                text: myController.text.isEmpty
                    ? ""
                    : "We cant find your voucher here.\n Do check if its a typo 🙂!!!",
                weight: FontWeight.w500,
                size: 18,
              ),
            ],
          ));
    }

// === search field ==========
    Widget _search() {
      return Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: grey_color_300),
                  borderRadius: BorderRadius.circular(20),
                  color: white_text_color,
                ),
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        inputFormatters: [
                          new LengthLimitingTextInputFormatter(75),
                        ],
                        controller: myController,
                        onChanged: (value) => _searchList(),
                        autofocus: true,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search by brands",
                            hintStyle:
                                TextStyle(color: hint_text_color, fontSize: 15),
                            contentPadding:
                                EdgeInsets.only(left: 10, bottom: 10)),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(5, 0, 15, 0),
                        child: SvgPicture.asset(
                          ImageConstants.gift_search,
                          height: 18,
                          color: blue_color,
                        )),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget _cardNumberView(_data) {
      return Container(
        child: TextWidget(
          text: _data + " " ?? "",
          size: text_font_medium14_size,
          weight: FontWeight.bold,
        ),
      );
    }

    List<Widget> _cardNumberWidget(_data) {
      List<Widget> list = [];
      for (var i = 0; i < _data.length; i++) {
        list.add(_cardNumberView(
          _data[i].voucherCode,
        ));
      }
      return list;
    }

    Widget _gridCards(_object) {
      return InkWell(
        onTap: () {
                GemsGLobals.membershipNo == null
                    ? DialogAlert.showLoginAlert(context)
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                GiftCardDetailsPage(
                                  brandId: _object?.giftcardId,
                                  // denomination: objects.fixedDenominationAmount,
                                  supplierCode: _object.supplierCode ?? "",
                                  paymentTyp: widget.paymentTyp.toString(),
                                )));
              },
        child: Container(
          color: transColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  alignment: Alignment.center,
                  imageUrl:
                      _object?.mobileImage != null ? _object?.mobileImage : "",
                  height: 100,
                  width: itemWidth,
                  placeholder: (context, url) => Container(
                    height: 100,
                    width: itemWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.1), width: 2),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Image.asset(
                      ImageConstants.gems_logo,
                      color: Colors.grey.withOpacity(0.1),
                    ),
                  ),
                  fit: BoxFit.fill,
                  errorWidget: (context, url, error) {
                    return Container(
                      height: 100,
                      width: itemWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.1), width: 2),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Image.asset(
                        ImageConstants.gems_logo,
                        color: Colors.grey.withOpacity(0.1),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextWidget(
                text: "${_object?.name ?? ""}",
                size: 15,
                weight: FontWeight.bold,
              ),
              SizedBox(
                height: 5,
              ),
              TextWidget(
                text: widget.paymentTyp == GemsGLobals.accrualPaymentType
                    ? GemsGLobals.earnUptoText +"${_object?.earnPoints} "+ GemsGLobals.gemsPointsText
                    : GemsGLobals.purchaseMinimumText+"\n${_object?.payWithPoints ?? 0} "+GemsGLobals.gemsPointsText,
                color: blue_color,
                size: text_font_size_xx_small,
                weight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    }

// == list of Gift cards========
    Widget listGiftCards(objects) {
      return new Container(
        margin: EdgeInsets.only(bottom: 10),
        alignment: Alignment.topCenter,
        child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 15.0,
            childAspectRatio: Platform.isIOS ? 3 / 2.6 : 3 / 3.2,
            children:
                List.generate(_giftVoucherModal?.objects?.length ?? 0, (index) {
              return _gridCards(objects[index]);
            })),
      );
    }

    Widget giftCards() {
      return new Expanded(
        child: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(left: 10, right: 10),
          color: white_text_color,
          child: listGiftCards(_giftVoucherModal?.objects),
        ),
      );
    }

    Widget _body() {
      return Column(
        children: <Widget>[
          _title(),
          _search(),
          SizedBox(
            height: 20,
          ),
          _searchLoader
              ? Center(
                  child: SpinKitCircle(
                  color: btn_bg_color,
                ))
              : (_giftVoucherModal?.objects?.length ?? 0) > 0
                  ? giftCards()
                  : _decisionWidget()
        ],
      );
    }

    return Container(
      height: MediaQuery.of(context).size.height / 1.12,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: white_text_color,
        borderRadius: BorderRadius.circular(7),
      ),
      child: _body(),
    );
  }

  @override
  void giftvoucherresponse(GiftVoucherModal giftVoucherModal) async {
    // TODO: implement giftvoucherresponse

    
    if (giftVoucherModal.status == true) {
      this._giftVoucherModal = giftVoucherModal;
      _searchLoader = false;

      setState(() {});
    } else {
      _searchLoader = false;

      if (giftVoucherModal.message == "timeout") {
        _searchLoader = true;

        var notresponding =
            await Navigator.of(context).pushNamed('/timeoutpage');
        if (notresponding != null) {
          _searchList();
        } else {
          Navigator.pop(context, true);
        }
      }
      setState(() {});
    }
  }

  @override
  void voucherlisterr(error) {
    // TODO: implement voucherlisterr
  }
}
