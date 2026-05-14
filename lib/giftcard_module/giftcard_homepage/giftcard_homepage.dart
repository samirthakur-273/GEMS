/*Author:Jyoti Gite
Description:Gift Card Home Page


date: 26 apr 2022
*/

import 'dart:convert';
import 'dart:io';

import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/numberformat.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/giftcard_module/giftcard_detailspage/giftcard_detailpage.dart';
import 'package:gems_revamp/giftcard_module/giftcard_homepage/database/giftcard_list_category_helper.dart';
import 'package:gems_revamp/giftcard_module/giftcard_homepage/database/giftcard_list_db_model.dart';
import 'package:gems_revamp/giftcard_module/giftcard_homepage/giftcard_category/giftcardcategory_modal.dart';
import 'package:gems_revamp/giftcard_module/giftcard_homepage/giftcard_category/giftcardcategory_presenter.dart';
import 'package:gems_revamp/giftcard_module/giftcard_homepage/giftcard_category/giftcardcategory_view.dart';
import 'package:gems_revamp/giftcard_module/giftcard_homepage/giftcard_voucherlist/giftcard_voucherlist_modal.dart';
import 'package:gems_revamp/giftcard_module/giftcard_homepage/giftcard_voucherlist/giftcard_voucherlist_presenter.dart';
import 'package:gems_revamp/giftcard_module/giftcard_homepage/giftcard_voucherlist/giftcard_voucherlist_view.dart';
import 'package:gems_revamp/giftcard_module/giftcard_searchpage/giftcard_searchpage.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:http/http.dart' as http;

import '../../common_widget/bottombar.dart';

class GiftCardCategory extends StatefulWidget {
  //final int tabIndex;
  GiftCardCategory(
      {
      // @required this.tabIndex,
      Key? key})
      : super(key: key);
  @override
  _GiftCardCategoryState createState() => _GiftCardCategoryState();
}

class _GiftCardCategoryState extends State<GiftCardCategory>
    with SingleTickerProviderStateMixin
    implements CategoryListView, GiftVoucherView {
  var noConnection;
  final myController = TextEditingController();
  //GiftCategoryModal _giftCategoryModal;
  bool isLoading = true;
  // static List gccountries = ['AED', 'KWD'];
  late GiftCategoryModal _giftCategoryModal;
  var earnburnpoints = "earn";
  bool isLoadingSearch = false;
  bool earnpoint = true;
  bool reedempoint = false;
  bool _displayTypList = true;
  int _selectedIndex = 0;
  String _titleText = "Online";
  String _product_type = "";
  var _categorycode = "";
  String sort = "lh";
  // GiftVoucherModal _giftVoucherModal;
  bool _voucherLoader = false;
  String _paymentTyp = "accrual";
  var _value;
  bool _isLoading = true;
  // bool _showFilter = false;
  bool _isFirsttype = false;
  bool _isResult = false;
  List _voucherdbData = List.empty(growable: true);
  var _totalResultfound = 0;
  bool _showFilter = false;
  bool _updtFiltr = false;
  late GiftVoucherModal _giftVoucherModal;
  String? categoryName = '';

  @override
  void initState() {
    super.initState();
    catListapiCall();

    _showFilter = false;

    GemsGLobals.gitcdflRangeValue = "";
    GemsGLobals.gitcdflsort = "";
    GemsGLobals.gccountries = [];
    GemsGLobals.giftcountry = '';
  }

  void catListapiCall() {
    setState(() {
      isLoading = true;
    });
    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        CategoryPresenter().getList(this, context);
      } else {
        noConnection = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (noConnection != null) {
          catListapiCall();
        }
      }
    });
  }

  _makesenseEventCall(segmentreq, keyName) {
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentreq, keyName);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double itemWidth = size.width / 2;
/*giftcard vochergrid view */
    Widget _gridCards(objects) {
      return InkWell(
        onTap: () {
          String minValue = _giftVoucherModal.priceRange?.min.toString() ?? '';
          String maxValue = _giftVoucherModal.priceRange?.max.toString() ?? '';

          var segmentReq = {
            'giftcard_name': objects?.name,
            'category': categoryName,
            'giftcard_type': objects?.productType,
            'min_value': minValue,
            'max_value': maxValue,
            'int_source': GemsGLobals.lastVisitPageName
          };
          String eventName = GemsGLobals.eventGiftcardClicked;
          _makesenseEventCall(segmentReq, eventName);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => GiftCardDetailsPage(
                        brandId: objects?.giftcardId,
                        supplierCode: objects.supplierCode ?? "",
                        paymentTyp: _paymentTyp,
                        giftCardName: objects?.name,
                        minValue: minValue,
                        maxValue: maxValue,
                        categoryName: categoryName,
                        productType: objects?.productType,
                      )));
        },
        child: Container(
          color: transColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(children: [
                Container(
                  height: 85,
                  width: MediaQuery.of(context).size.width / 2.3,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 0.4, color: black_color.withOpacity(0.4)),
                      // boxShadow: [
                      //   new BoxShadow(
                      //       color: black_color.withOpacity(0.3),
                      //       offset: new Offset(0.0, 1.0),
                      //       blurRadius: 1.0,
                      //       spreadRadius: 1.0)
                      // ],
                      borderRadius: BorderRadius.circular(10)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      alignment: Alignment.center,
                      imageUrl: objects?.mobileImage != null
                          ? objects?.mobileImage
                          : "",
                      placeholder: (context, url) => Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width / 2.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey, width: 3),
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
                          height: 90,
                          width: MediaQuery.of(context).size.width / 2.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
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
                ),
                // Positioned(
                //     right: 3,
                //     top: 3,
                //     child: TextWidget(
                //       text: "AED 500",
                //       weight: FontWeight.w600,
                //       size: text_font_size_xx_small,
                //     ))
              ]),
              SizedBox(
                height: 10,
              ),
              TextWidget(
                text: "${objects?.name ?? ""}",
                size: text_font_size_x_small,
                weight: FontWeight.w600,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              TextWidget(
                text: _paymentTyp == "accrual"
                    ? "Earn upto ${objects?.earnPoints} GEMS Points"
                    : "Purchase with minimum\n${objects?.payWithPoints ?? 0} GEMS Points",
                color: blue_color,
                size: text_font_size_xx_small,
                weight: FontWeight.w500,
              )
            ],
          ),
        ),
      );
    }

    Widget _gridGiftCards(objects) {
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        alignment: Alignment.topCenter,
        child: GridView.count(
            padding: const EdgeInsets.only(top: 10, bottom: 80),
            crossAxisCount: 2,
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 15.0,
            childAspectRatio: Platform.isIOS ? 3 / 2.5 : 3 / 2.84,
            children: List.generate(objects?.length ?? 0, (index) {
              return _gridCards(objects[index]);
            })),
      );
    }

    Widget _listCard(objects) {
      return InkWell(
        onTap: () {
          String minValue = _giftVoucherModal.priceRange?.min.toString() ?? '';
          String maxValue = _giftVoucherModal.priceRange?.max.toString() ?? '';

          var segmentReq = {
            'giftcard_name': objects?.name,
            'category': categoryName,
            'giftcard_type': objects?.productType,
            'min_value': minValue,
            'max_value': maxValue,
            'int_source': GemsGLobals.lastVisitPageName
          };
          String eventName = GemsGLobals.eventGiftcardClicked;
          _makesenseEventCall(segmentReq, eventName);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => GiftCardDetailsPage(
                        brandId: objects?.giftcardId,
                        supplierCode: objects?.supplierCode ?? "",
                        paymentTyp: _paymentTyp,
                        giftCardName: objects?.name,
                        minValue: minValue,
                        maxValue: maxValue,
                        categoryName: categoryName,
                        productType: objects?.productType,
                      )));
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 0, top: 0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        height: 85,
                        width: MediaQuery.of(context).size.width / 2.5,
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.3, color: Colors.grey
                                // color: black_color
                                ),
                            // boxShadow: [
                            //   new BoxShadow(
                            //       color: black_color.withOpacity(0.3),
                            //       offset: new Offset(0.0, 1.0),
                            //       blurRadius: 1.0,
                            //       spreadRadius: 1.0)
                            // ],
                            borderRadius: BorderRadius.circular(10)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            alignment: Alignment.center,
                            imageUrl: objects?.mobileImage != null
                                ? objects?.mobileImage
                                : "",
                            placeholder: (context, url) {
                              return Image.asset(
                                ImageConstants.noimages,
                                fit: BoxFit.fill,
                              );
                            },
                            fit: BoxFit.fill,
                            errorWidget: (context, url, error) {
                              return Image.asset(
                                ImageConstants.noimages,
                                fit: BoxFit.fill,
                              );
                            },
                          ),
                        ),
                      ),
                      // Positioned(
                      //     right: 3,
                      //     top: 3,
                      //     child: TextWidget(
                      //       text: "AED 500",
                      //       weight: FontWeight.w600,
                      //       size: text_font_size_xx_small,
                      //     ))
                    ],
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: TextWidget(
                          text: "${objects?.name ?? ""}",
                          size: text_font_size_x_small,
                          weight: FontWeight.w600,
                          softwrap: true,
                          overflow: TextOverflow.clip,
                        ),
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 5,
                          ),
                          TextWidget(
                            text: _paymentTyp == "accrual"
                                ? "Earn upto ${objects?.earnPoints} GEMS Points"
                                : "Purchase with minimum\n${objects?.payWithPoints ?? 0} GEMS Points",
                            color: blue_color,
                            size: text_font_size_xx_small,
                            weight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      // _paymentTyp != "accrual"
                      //     ? Column(
                      //         mainAxisAlignment: MainAxisAlignment.start,
                      //         children: <Widget>[
                      //           SizedBox(
                      //             height: 5,
                      //           ),
                      //           TextWidget(
                      //             text: "100 Gems points",
                      //             size: text_font_x_small,
                      //             weight: FontWeight.bold,
                      //           )
                      //         ],
                      //       )
                      //     : Container(
                      //         height: 0,
                      //       )
                    ],
                  ),
                ],
              ),
              Divider(
                indent: 100,
              )
            ],
          ),
        ),
      );
    }

/*Giftcard list view*/
    Widget _listTypCard(objects) {
      return ListView.builder(
          itemCount: objects?.length ?? 0,
          padding: EdgeInsets.only(top: 5, bottom: 60),
          itemBuilder: (context, index) {
            return _listCard(objects[index]);
          });
    }

    Widget giftCards() {
      return new Expanded(
        child: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(left: 20, right: 20),
          color: white_text_color,
          child: _displayTypList
              ? _listTypCard(_voucherdbData)
              : _gridGiftCards(_voucherdbData),
        ),
      );
    }

    Widget _noDataFound() {
      return _isLoading
          ? SpinKitCircle(
              color: blue_color,
            )
          : Container(
              padding: EdgeInsets.only(top: 80, left: 20, right: 20),
              child: Center(
                child: TextWidget(
                  text:
                      "Whoops! We can't find your Gift card here. Do check if its a typo!!!", //"Whoops! Gift cards are not available to show you right now.",
                  alignment: TextAlign.center,
                  weight: FontWeight.w600,
                  size: text_font_medium_x_size,
                ),
              ),
            );
    }

    Widget _displayTyp() {
      return Container(
        margin: EdgeInsets.only(left: 20, right: 15, top: 0, bottom: 15),
        color: transColor,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 1.6,
                  child: TextWidget(
                    text: "$_titleText Shopping",
                    weight: FontWeight.w600,
                    color: blackish,
                    size: text_font_medium14_size,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextWidget(
                  text: "$_totalResultfound results found",
                  weight: FontWeight.w500,
                  color: common_grey_text_color,
                  size: text_font_size_small,
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    setState(() {
                      _displayTypList = true;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: grey200_color),
                      borderRadius: BorderRadius.circular(10),
                      color: _displayTypList ? blue_color : grey200_color,
                    ),
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      ImageConstants.selectlistview,
                      height: 18,
                      width: 18,
                      color: _displayTypList ? white_text_color : black_color,
                    ),
                  ),
                ),
                new SizedBox(
                  width: 10,
                ),
                // Spacer(),
                InkWell(
                    onTap: () {
                      setState(() {
                        _displayTypList = false;
                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: grey200_color),
                          borderRadius: BorderRadius.circular(10),
                          color: _displayTypList == false
                              ? blue_color
                              : grey200_color,
                        ),
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        child: ClipOval(
                            child: Icon(
                          Icons.grid_view,
                          color: _displayTypList == false
                              ? white_text_color
                              : black_color,
                        )))),

                // SizedBox(
                //   width: 15,
                // ),
                Spacer(),
                InkWell(
                  onTap: () async {
                    _showFilter = !_showFilter;
                    setState(() {});
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.7,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    height: 40,
                    decoration: BoxDecoration(
                        // gradient: _showFilter
                        //     ? gradient_theme_color
                        //     : LinearGradient(
                        //         colors: [Color(0xffb2b2b2), Color(0xffb2b2b2)]),
                        color: _showFilter ? blue_color : grey200_color,
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          ImageConstants.sortandfilter,
                          color: _showFilter ? white_text_color : black_color,
                          height: 20,
                          width: 24,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        TextWidget(
                          text: "Sort & Filter",
                          weight: FontWeight.w500,
                          color: _showFilter ? white_text_color : black_color,
                          size: text_font_medium15_size,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    }

    Widget _appbar() {
      return Container(
          decoration: BoxDecoration(gradient: gradient_theme_color),
          alignment: Alignment.bottomLeft,
          padding: EdgeInsets.only(
            top: 25,
          ),
          height: Platform.isIOS ? 100 : 90,
          child: Container(
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
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
                    margin: EdgeInsets.only(right: 10),
                    child: TextWidget(
                      text: "Gift Cards",
                      size: text_font_medium18_size,
                      weight: FontWeight.w500,
                      color: white_text_color,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet<dynamic>(
                        isScrollControlled: true,
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (BuildContext bc) {
                          return SearchPage(
                            paymentTyp: _paymentTyp,
                          );
                        });
                  },
                  child: Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.only(right: 10, top: 5),
                    height: 24,
                    width: 28,
                    child: SvgPicture.asset(
                      ImageConstants.gift_search,
                      color: white_text_color,
                    ),
                  ),
                ),
              ],
            ),
          ));
    }

/*Gift card Category list */
    Widget _categoryList() {
      return Container(
        height: 100,
        child: ListView.builder(
          padding: EdgeInsets.only(
            left: 15,
          ),
          scrollDirection: Axis.horizontal,
          itemCount: _giftCategoryModal.objects?.length,
          itemBuilder: (context, index) {
            return Container(
              height: 100,
              padding: EdgeInsets.only(right: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap:  _isLoading
                           ? null
                             :
                    () {
                      _selectedIndex = index;
                      setState(() {
                        if (_selectedIndex != 0) {
                          _titleText =
                              "${_giftCategoryModal.objects![index].categoryName ?? ""}";
                          _categorycode =
                              _giftCategoryModal.objects![index].categoryCode ??
                                  "";
                          GemsGLobals.gitcdflRangeValue = "";
                          GemsGLobals.gitcdflsort = "";
                          GemsGLobals.giftcountry = '';
                          _isLoading = true;
                          GiftVoucherPresenter().getList(
                              this,
                              _titleText,
                              "",
                              "",
                              "",
                              "",
                              "",
                              true);
                        } else {
                          _titleText = "";
                          _categorycode = "";
                          _isLoading = true;
                          GiftVoucherPresenter().getList(
                              this,
                              _titleText, //_giftCategoryModal.objects![index].categoryCode ?? "",
                              "",
                              "",
                              "",
                              "",
                              "",
                              true);
                        }
                      });
                      categoryName =
                          _giftCategoryModal.objects![index].categoryName;
                      var segmentReq = {
                        'page_name': earnpoint == true
                            ? GemsGLobals.collectText
                            : GemsGLobals.redeemText,
                        'category': categoryName,
                        'int_source': GemsGLobals.lastVisitPageName
                      };
                      String eventName = GemsGLobals.eventGiftcardListingPage;
                      _makesenseEventCall(segmentReq, eventName);
                      setState(() {});
                    },
                    child: Container(
                      height: 55,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: _selectedIndex == index
                            ? blue_color
                            : grey200_color,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CachedNetworkImage(
                          alignment: Alignment.center,
                          imageUrl:
                              _giftCategoryModal.objects![index].categoryIcon,
                          width: 75,
                          height: 75,
                          color: _selectedIndex == index &&
                                  _giftCategoryModal
                                          .objects![index].categoryName ==
                                      'All'
                              ? null
                              : _selectedIndex == index
                                  ? white_color
                                  : null,
                          placeholder: (context, url) => Container(
                            height: 75,
                            width: 75,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.1),
                                  width: 2),
                            ),
                            padding: EdgeInsets.all(10),
                            child: Image.asset(
                              ImageConstants.gems_logo,
                              color: Colors.grey.withOpacity(0.1),
                            ),
                          ),
                          fit: BoxFit.contain,
                          errorWidget: (context, url, error) {
                            return Container(
                              height: 75,
                              width: 75,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.1),
                                    width: 2),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Image.asset(
                                ImageConstants.gems_logo,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),

                        // SvgPicture.asset(
                        //   ImageConstants.giftcard_category,
                        //   fit: BoxFit.fill,
                        //   color: _selectedIndex == index
                        //       ? white_text_color
                        //       : black_color,
                        // ),
                      ),
                    ),
                  ),
                  Container(
                    width: 70,
                    alignment: Alignment.center,
                    margin:
                        EdgeInsets.only(right: 5, bottom: 0, top: 5, left: 5),
                    child: TextWidget(
                      text: _giftCategoryModal.objects![index].categoryName,
                      size: text_font_x_small,
                      color: _selectedIndex == index ? black_color : blackish,
                      textAlign: TextAlign.center,
                      alignment: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      weight: _selectedIndex == index ? FontWeight.w500 : null,
                    ),
                  )
                ],
              ),
            );
          },
        ),
      );
    }

    Widget earnburnWidget() {
      return Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        height: 55,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Color(0XFFf4f4f4),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: grey_border, width: 0.8)),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    earnpoint = true;
                    reedempoint = false;
                    _paymentTyp = "accrual";
                  });
                },
                child: Container(
                  margin: EdgeInsets.all(3),
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: earnpoint == true
                        ? button_bgemail_color
                        : Color(0XFFf4f4f4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: TextWidget(
                      text: "Collect GEMS Points",
                      color: earnpoint == true
                          ? white_text_color
                          : flight_text_black_color,
                      size: text_font_medium14_size,
                      weight:
                          earnpoint == true ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    earnpoint = false;
                    reedempoint = true;
                    _paymentTyp = "redemption";
                  });
                },
                child: Container(
                  margin: EdgeInsets.all(3),
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: reedempoint == true
                        ? button_bgemail_color
                        : Color(0XFFf4f4f4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: TextWidget(
                      text: "Redeem GEMS Points",
                      color: reedempoint == true
                          ? white_color
                          : flight_text_black_color,
                      size: text_font_medium14_size,
                      weight: reedempoint == true
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    /* Filter api */
    _filterapiCall(_sort, currency, country) {
      Internetconnectivity().isConnected().then((result) async {
        if (result) {
          GiftVoucherPresenter()
              .getList(this, "", "", "", _sort, currency, country, false);
        } else {
          noConnection = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => NoInternet()));
          if (noConnection != null) {
            _filterapiCall(
                GemsGLobals.gitcdflsort,
                GemsGLobals.gitcdflRangeValue != ""
                    ? GemsGLobals.gitcdflRangeValue.join(",").toString()
                    : "",
                '');
          }
        }
      });
    }

    Widget _buildVoucherSection() {
      if (_voucherLoader) {
        return SizedBox(height: 300);
      }

      if (_showFilter) {
        if (!_isLoading && _voucherdbData.isNotEmpty) {
          return FilterSort(
            filterCurrency: GemsGLobals.gccountries,
            onchanged: (showfilter, updateFiltr, value) {
              _showFilter = showfilter;
              _updtFiltr = updateFiltr;

              if (updateFiltr == true && value != null) {
                sort = value["sort"];
                var _country = value["country"];
                var _currency = value["currency"];

                isLoading = true;
                setState(() {});
                _filterapiCall(sort, _currency, _country);
              }

              setState(() {});
            },
          );
        } else {
          return _noDataFound();
        }
      } else {
        if (!_isLoading && _voucherdbData.isNotEmpty) {
          return giftCards();
        } else {
          return _noDataFound();
        }
      }
    }

    Widget body() {
      try {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(1.0),
          ),
          child: Column(
            children: <Widget>[
              (GemsGLobals.referralRelationType != GemsGLobals.spouseValue &&
                      GemsGLobals.referralRelationType !=
                          GemsGLobals.childValue)
                  ? earnburnWidget()
                  // _tabs()
                  : SizedBox(),
              SizedBox(
                height: 5,
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 20),
                child: TextWidget(
                  text: "Categories",
                  size: text_font_medium17_size,
                  weight: FontWeight.w600,
                  color: blackish,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              _categoryList(),
              Divider(
                endIndent: 20.0,
                indent: 20.0,
                color: black_color,
              ),
              _displayTyp(),
              _buildVoucherSection(),
            ],
          ),
        );
      } catch (e, s) {
        return Container();
      }
    }

    Widget _tabbar() {
      return Container(
        width: MediaQuery.of(context).size.width,
        // color: black_color,
        child: BottomBar(
          initialIndex: 0,
          tabvalue: "home",
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(gradient: gradient_theme_color),
      child: SafeArea(
        bottom: true,
        top: false,
        child: Scaffold(
          extendBody: true,
          backgroundColor: white_text_color,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(90), child: _appbar()),
          body: isLoading == true
              ? Center(
                  child: SpinKitCircle(
                    color: btn_bg_color,
                  ),
                )
              : body(),
          bottomNavigationBar: SizedBox(height: 95, child: _tabbar()),
        ),
      ),
    );
  }

  @override
  void categoryerr(error) {
    // TODO: implement categoryerr
  }

  @override
  void response(GiftCategoryModal giftCategoryModal) {
    isLoading = false;
    this._giftCategoryModal = giftCategoryModal;

    /*Gift card Vocher List Api*/
    GiftVoucherPresenter().getList(
      this,
      "",
      "",
      "",
      "",
      "",
      "",
      _categorycode != "" ? false : true,
    );
    categoryName = _giftCategoryModal.objects?.first.categoryName ?? '';
    var segmentReq = {
      'page_name':
          earnpoint == true ? GemsGLobals.collectText : GemsGLobals.redeemText,
      'category': categoryName,
      'int_source': GemsGLobals.lastVisitPageName
    };
    String eventName = GemsGLobals.eventGiftcardListingPage;
    _makesenseEventCall(segmentReq, eventName);
    GemsGLobals.lastVisitPageName = GemsGLobals.eventGiftcardListingPage;
    setState(() {});
  }

  Future<List<GiftCardListDbModel>> getVocherListDataFromDb() {
    var data = GiftCardListDBHelper().getGiftcardListData();
    return data;
  }

  void _sortVoucherList() {
    for (int i = 0; i < _giftVoucherModal.objects!.length; i++) {
      if (_categorycode != '') {
        if (_giftVoucherModal.objects![i].categoryCode!
            .contains('$_categorycode')) {
          _voucherdbData.add(_giftVoucherModal.objects![i]);
        }
      } else {
        _voucherdbData.add(_giftVoucherModal.objects![i]);
      }
    }
  }

  @override
  void giftvoucherresponse(GiftVoucherModal giftVoucherModal) async {
    _isResult = true;
    _voucherdbData.clear();

    if (giftVoucherModal.status == true) {
      _isLoading = false;
      this._giftVoucherModal = giftVoucherModal;
      // ========sort data based on categories======
      _sortVoucherList();
      if (_isFirsttype == false) {
        getVocherListDataFromDb().then((value) async {
          if (value.length < 1) {
            // if nodata in db Insert vocher list data into database /
            return GiftCardListDBHelper().save(GiftCardListDbModel(
                null, json.encode(giftVoucherModal.toJson())));
          }
        });
        GemsGLobals.gccountries = _giftVoucherModal.countries;
        _isFirsttype = true;
      }
      setState(() {
        isLoading = false;
        _voucherLoader = false;
        _totalResultfound = _voucherdbData.length;
      });

      setState(() {});
    } else {
      setState(() {
        isLoading = false;
        _voucherLoader = false;
        _giftVoucherModal = giftVoucherModal;
        // ========sort data based on categories======

        _totalResultfound = _voucherdbData.length;
      });
      if (giftVoucherModal.message == "timeout") {
        var notresponding =
            await Navigator.of(context).pushNamed('/timeoutpage');
        if (notresponding != null) {
          isLoading = true;
          _voucherLoader = false;
          //  apiCall(CityGLobals.giftcountry);
        } else {
          Navigator.pop(context, true);
        }
      }
    }
  }

  // TODO: implement giftvoucherresponse

  @override
  void voucherlisterr(error) {
    // TODO: implement voucherlisterr
  }
}

class FilterSort extends StatefulWidget {
  // const FilterSort({
  //   Key? key,
  // }) : super(key: key);
  final List filterCurrency;
  final void Function(bool filterApplied, bool updateFiltr, dynamic filterData)
      onchanged;
  const FilterSort({
    Key? key,
    required this.filterCurrency,
    required this.onchanged,
  }) : super(key: key);

  @override
  _FilterSortState createState() => _FilterSortState();
}

class _FilterSortState extends State<FilterSort> {
  var chekRadio;
  var _sortListOptions = [
    "Price: Low - High",
    "Price: High - Low",
    "Order: A - Z",
    "Order: Z - A"
  ];
  bool _selectOption = false;
  bool _resetData = false;
  String? _sortBy;
  String _selectedCurrency = '';
  final _startrangecontroller = TextEditingController();
  final _endrangecontroller = TextEditingController();
  int minvalue = 5;
  int maxvalue = 5000;
  var _startvalue;
  var _endvalue;
  late List<double> _values;
  String _selectedCountry = '';
  var _selected;
  List _currencylist = [];
  // var _countrylist = [
  //   "UAE-AED",
  //   "KSA-SAR",
  //   "Kuwait-KWD",
  //   "Egypt-ECP",
  //   "Oman-OMR",
  //   "Qatar-QAR"
  // ];

  List _countrylist = [];

  void _countryList() {
    for (int i = 0; i < widget.filterCurrency.length; i++) {
      _countrylist.add(widget.filterCurrency[i].countryName);
      _currencylist.add(widget.filterCurrency[i].currency);
      if (widget.filterCurrency[i].currency == 'AED' &&
          GemsGLobals.giftcountry == '') {
        setState(() {
          _selectedCountry = _countrylist[i];
          _selectedCurrency = _currencylist[i];

          minvalue = widget.filterCurrency[i].priceRange.min ?? 1;
          maxvalue = widget.filterCurrency[i].priceRange.max ?? 50000;
          /* === set Price Range */

          if (GemsGLobals.gitcdflRangeValue == "") {
            _startvalue = widget.filterCurrency[i].priceRange.min.toString();
            _endvalue = widget.filterCurrency[i].priceRange.max.toString();
            _values = [minvalue.toDouble(), maxvalue.toDouble()];
          } else {
            _values = GemsGLobals.gitcdflRangeValue;
            _startrangecontroller.text =
                (GemsGLobals.gitcdflRangeValue[0].toInt()).toString();
            _endrangecontroller.text =
                (GemsGLobals.gitcdflRangeValue[1].toInt()).toString();
            _startvalue = (GemsGLobals.gitcdflRangeValue[0].toInt()).toString();
            _endvalue = (GemsGLobals.gitcdflRangeValue[1].toInt()).toString();
          }
        });
      }
    }
  }

  @override
  void initState() {
    if (widget.filterCurrency != null) {
      _countryList();
    }

    /* check filter values if globally set */
    setState(() {
      if (GemsGLobals.giftcountry != '' && GemsGLobals.giftcountry != null) {
        _selectedCountry = GemsGLobals.giftcountry;
        int index = _countrylist.indexOf(_selectedCountry);
        _selectedCurrency =
            _currencylist[_countrylist.indexOf(_selectedCountry)];

        minvalue = widget.filterCurrency[index].priceRange.min ?? 1;
        maxvalue = widget.filterCurrency[index].priceRange.max ?? 50000;
        /* === set Price Range */

        if (GemsGLobals.gitcdflRangeValue == "") {
          _startvalue = widget.filterCurrency[index].priceRange.min.toString();
          _endvalue = widget.filterCurrency[index].priceRange.max.toString();
          _values = [minvalue.toDouble(), maxvalue.toDouble()];
        } else {
          _values = GemsGLobals.gitcdflRangeValue;
          _startrangecontroller.text =
              (GemsGLobals.gitcdflRangeValue[0].toInt()).toString();
          _endrangecontroller.text =
              (GemsGLobals.gitcdflRangeValue[1].toInt()).toString();
          _startvalue = (GemsGLobals.gitcdflRangeValue[0].toInt()).toString();
          _endvalue = (GemsGLobals.gitcdflRangeValue[1].toInt()).toString();
        }
      }
      if (GemsGLobals.gitcdflsort == "") {
        _sortBy = "lh";
        chekRadio = 0;
      } else {
        _sortBy = GemsGLobals.gitcdflsort;
        chekRadio = GemsGLobals.giftsortIndex;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /* ----------- Spacer -----*/
    Widget _divider(ht) {
      return new SizedBox(
        height: ht,
      );
    }

    /* ====== Sort By======= */
    Widget _methods(context) {
      return Container(
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _sortListOptions.length,
              padding: EdgeInsets.only(top: 5),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              chekRadio = index;
                            });

                            if (index == chekRadio) {
                              setState(() {
                                _selectOption = true;
                                _resetData = true;
                              });
                            } else {
                              setState(() {
                                _selectOption = false;
                                chekRadio = index;
                                _resetData = false;
                              });
                            }
                            switch (index) {
                              case 0:
                                _sortBy = "lh";
                                break;
                              case 1:
                                _sortBy = "hl";
                                break;
                              case 2:
                                _sortBy = "az";
                                break;
                              case 3:
                                _sortBy = "za";
                                break;
                              default:
                            }
                            setState(() {});
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new SizedBox(
                                width: 2,
                              ),
                              Container(
                                height: 18,
                                width: 18,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 0.5, color: hint_text_color),
                                    color: grey200_color),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: SvgPicture.asset(
                                    ImageConstants.sortbyselect,
                                    color: chekRadio == index
                                        ? blue_color
                                        : white_text_color,
                                  ),
                                ),
                              ),
                              new SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Container(
                                  child: TextWidget(
                                    text: _sortListOptions[index],
                                    color: chekRadio == index
                                        ? blue_color
                                        : hint_text_color,
                                    size: text_font_medium15_size,
                                    weight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                );
              }));
    }

    Widget _sortByWidget() {
      return Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          padding: EdgeInsets.fromLTRB(15, 8, 15, 5),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 0.3),
              //   boxShadow: [
              //   BoxShadow(
              //     color: grey_color.withOpacity(0.9),
              //     offset: Offset(0.0, 3), //(x,y)
              //     blurRadius: 5.0,
              //   ),
              // ],
              color: white_text_color,
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Row(
                children: [
                  TextWidget(
                    text: "Sort By",
                    weight: FontWeight.w600,
                    size: text_font_medium16_size,
                    color: grey600_color,
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _sortBy = "lh";
                        chekRadio = 0;
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      decoration: BoxDecoration(
                          border: Border.all(color: light_grey, width: 1.0),
                          borderRadius: BorderRadius.circular(17)),
                      child: TextWidget(
                        text: "Reset Filters",
                        color: blue_color,
                        weight: FontWeight.w500,
                        size: text_font_size_x_small,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              _methods(context),
            ],
          ));
    }

    /* Price Range Slider */
    Widget _slider() {
      return FlutterSlider(
        values: _values,
        min: minvalue.toDouble(),
        max: maxvalue.toDouble(),
        rangeSlider: true,
        handlerWidth: 12,
        handlerHeight: 12,
        onDragging: (handlerIndex, lowerValue, upperValue) {
          setState(() {
            _startvalue = lowerValue.toString().split('.')[0];
            _endvalue = upperValue.toString().split('.')[0];
            _values = [lowerValue, upperValue];

            _startrangecontroller.text = _startvalue;
            _endrangecontroller.text = _endvalue;
          });
        },
        onDragCompleted: (handlerIndex, lowerValue, upperValue) {
          setState(() {
            _startvalue = lowerValue.toString().split('.')[0];
            _endvalue = upperValue.toString().split('.')[0];
            _values = [lowerValue, upperValue];

            _startrangecontroller.text = _startvalue;
            _endrangecontroller.text = _endvalue;
            _resetData = true;
          });
        },
        onDragStarted: (handlerIndex, lowerValue, upperValue) {
          setState(() {
            _startvalue = lowerValue.toString().split('.')[0];
            _endvalue = upperValue.toString().split('.')[0];
            _values = [lowerValue, upperValue];

            _startrangecontroller.text = _startvalue;
            _endrangecontroller.text = _endvalue;
          });
        },
        trackBar: FlutterSliderTrackBar(
          inactiveTrackBar: BoxDecoration(color: grey_color_300),
          activeTrackBarHeight: 9,
          activeTrackBar: BoxDecoration(color: blue_color),
        ),
        handler: FlutterSliderHandler(
          decoration: BoxDecoration(),
          child: Container(
            decoration: BoxDecoration(
                color: blue_color, borderRadius: BorderRadius.circular(25)),
            padding: EdgeInsets.all(2),
            child: Container(
              decoration: BoxDecoration(
                  color: white_text_color,
                  borderRadius: BorderRadius.circular(25)),
            ),
          ),
        ),
        jump: true,
        rightHandler: FlutterSliderHandler(
          decoration: BoxDecoration(),
          child: Container(
            decoration: BoxDecoration(
                color: blue_color, borderRadius: BorderRadius.circular(25)),
            padding: EdgeInsets.all(2),
            child: Container(
              decoration: BoxDecoration(
                  color: white_text_color,
                  borderRadius: BorderRadius.circular(25)),
            ),
          ),
        ),
      );
    }

    Widget price() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          TextWidget(
              text: "Price",
              weight: FontWeight.w500,
              color: hint_text_color,
              size: text_font_medium15_size),
          SizedBox(
            height: 5,
          ),
          Container(
            child: _slider(),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextWidget(
                    text: "$_selectedCurrency " +
                        pointsFormatter(int.parse(
                            _startrangecontroller.text.isEmpty
                                ? minvalue.toString()
                                : _startrangecontroller.text)),
                    size: text_font_medium14_size,
                    color: hint_text_color,
                    weight: FontWeight.w500,
                  ),
                ),
                TextWidget(
                  text: "$_selectedCurrency " +
                      pointsFormatter(int.parse(_endrangecontroller.text.isEmpty
                          ? maxvalue.toString()
                          : _endrangecontroller.text)),
                  size: text_font_medium14_size,
                  color: hint_text_color,
                  weight: FontWeight.w500,
                ),
              ],
            ),
          ),
          _divider(25.0),
        ],
      );
    }

    Widget _currency() {
      return Row(
        children: [
          Container(
            width: 100,
            child: TextWidget(
              text: "Currency",
              color: hint_text_color,
              weight: FontWeight.w600,
              size: text_font_medium16_size,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              // width: MediaQuery.of(context).size.width / 1.8,
              height: 30,
              decoration: BoxDecoration(
                  color: white_text_color,
                  border: Border.all(
                    width: 1.0,
                    color: grey_color,
                  ),
                  borderRadius: BorderRadius.circular(30)),
              child: DropdownButton(
                icon: Visibility(
                    visible: true,
                    child: Icon(
                      Icons.arrow_drop_down,
                      size: 28,
                      color: hint_text_color,
                    )),
                isExpanded: true,
                iconSize: 28,
                items: _countrylist.map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Container(
                        margin: EdgeInsets.only(left: 12, right: 12),
                        // width: MediaQuery.of(context).size.width / 3,
                        child: TextWidget(
                          text:
                              '$value - ${_currencylist[_countrylist.indexOf(value)] ?? ''}',
                          size: text_font_medium15_size,
                          color: hint_text_color,
                        )),
                  );
                }).toList(),
                value: _selectedCountry,
                underline: Container(),
                onChanged: (value) {
                  setState(() {
                    _selectedCountry = value.toString();
                    _selectedCurrency =
                        _currencylist[_countrylist.indexOf(value)] ?? '';
                    GemsGLobals.giftcountry = value;
                    // _resetData = true;

                    minvalue = widget
                            .filterCurrency[_countrylist.indexOf(value)]
                            .priceRange
                            .min ??
                        1;
                    maxvalue = widget
                            .filterCurrency[_countrylist.indexOf(value)]
                            .priceRange
                            .max ??
                        50000;
                    _values = [minvalue.toDouble(), maxvalue.toDouble()];
                    _startvalue = widget
                        .filterCurrency[_countrylist.indexOf(value)]
                        .priceRange
                        .min
                        .toString();
                    _endvalue = widget
                        .filterCurrency[_countrylist.indexOf(value)]
                        .priceRange
                        .max
                        .toString();
                    _startrangecontroller.text = widget
                        .filterCurrency[_countrylist.indexOf(value)]
                        .priceRange
                        .min
                        .toString();
                    _endrangecontroller.text = widget
                        .filterCurrency[_countrylist.indexOf(value)]
                        .priceRange
                        .max
                        .toString();
                  });
                },
              ),
            ),
          ),
        ],
      );
    }

    Widget _filterData() {
      return Container(
        child: Column(children: [
          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: 5),
            child: price(),
          ),
          _currency(),
          SizedBox(
            height: 10,
          )
        ]),
      );
    }

    Widget _filterWidget() {
      return Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 0.3),
              //   boxShadow: [
              //   BoxShadow(
              //     color: grey_color.withOpacity(0.9),
              //     offset: Offset(0.0, 3), //(x,y)
              //     blurRadius: 5.0,
              //   ),
              // ],
              color: white_text_color,
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Row(
                children: [
                  TextWidget(
                    text: "Filters",
                    weight: FontWeight.w600,
                    size: text_font_medium17_size,
                    color: grey600_color,
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _selected = null;
                        minvalue = 5;
                        maxvalue = 5000;
                        _values = [minvalue.toDouble(), maxvalue.toDouble()];
                        _startvalue = 1;
                        _endvalue = 200;

                        _startrangecontroller.text = 5.toString();
                        _endrangecontroller.text = 5000.toString();
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      decoration: BoxDecoration(
                          border: Border.all(color: light_grey, width: 1.0),
                          borderRadius: BorderRadius.circular(17)),
                      child: TextWidget(
                        text: "Reset Filters",
                        color: blue_color,
                        weight: FontWeight.w500,
                        size: text_font_size_x_small,
                      ),
                    ),
                  ),
                ],
              ),
              _filterData(),
            ],
          ));
    }

    /* Reset button Hightlight when values changes*/

    /* Apply Reset Button */
    Widget _applyResetBtn() {
      return Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    GemsGLobals.gitcdflRangeValue = _values;
                    GemsGLobals.gitcdflsort = _sortBy;
                    GemsGLobals.giftsortIndex = chekRadio;
                    var filterData = {
                      "sort": _sortBy,
                      "country": _selectedCountry,
                      "currency": _selectedCurrency
                    };

                    widget.onchanged(false, true, filterData);
                    setState(() {});
                  },
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                        gradient: gradient_theme_color,
                        color: blue_color,
                        borderRadius: BorderRadius.circular(25)),
                    child: Center(
                      child: TextWidget(
                        text: "Apply",
                        color: white_text_color,
                        size: text_font_medium_x_size,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                  child: GestureDetector(
                onTap:
                // _resetData?
                     () {
                        setState(() {
                          _sortBy = "lh";
                          chekRadio = 0;

                          GemsGLobals.giftcountry = '';
                          if (_countrylist.length > 0) {
                            _selectedCountry = _countrylist[0];
                            minvalue = widget
                                    .filterCurrency[
                                        _countrylist.indexOf(_selectedCountry)]
                                    .priceRange
                                    .min ??
                                1;
                            maxvalue = widget
                                    .filterCurrency[
                                        _countrylist.indexOf(_selectedCountry)]
                                    .priceRange
                                    .max ??
                                50000;
                            _values = [
                              minvalue.toDouble(),
                              maxvalue.toDouble()
                            ];
                            _startvalue = widget
                                .filterCurrency[
                                    _countrylist.indexOf(_selectedCountry)]
                                .priceRange
                                .min
                                .toString();
                            _endvalue = widget
                                .filterCurrency[
                                    _countrylist.indexOf(_selectedCountry)]
                                .priceRange
                                .max
                                .toString();

                            _startrangecontroller.text = widget
                                .filterCurrency[
                                    _countrylist.indexOf(_selectedCountry)]
                                .priceRange
                                .min
                                .toString();
                            _endrangecontroller.text = widget
                                .filterCurrency[
                                    _countrylist.indexOf(_selectedCountry)]
                                .priceRange
                                .max
                                .toString();
                            _selectedCurrency = _currencylist[
                                _countrylist.indexOf(_selectedCountry)];
                          }
                        });
                      },
                    // : () {},
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                      color: bg_color,
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.5), width: 1),
                      // boxShadow: [
                      //   new BoxShadow(
                      //       color: grey_color.withOpacity(0.5),
                      //       offset: new Offset(0, 5),
                      //       blurRadius: 5,
                      //       spreadRadius: 0.0),
                      // ],
                      borderRadius: BorderRadius.circular(40)),
                  child: Center(
                    child: TextWidget(
                      text: "Reset",
                      color: black_color,
                      size: text_font_medium_x_size,
                      weight: FontWeight.w500,
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      );
    }

    Widget _filterbody() {
      return SingleChildScrollView(
        child: Column(
          // shrinkWrap: true,
          children: [
            SizedBox(
              height: 8,
            ),
            _sortByWidget(),
            SizedBox(
              height: 10,
            ),
            _filterWidget(),
            SizedBox(
              height: 25,
            ),
            _applyResetBtn(),
            SizedBox(
              height: 90,
            ),
          ],
        ),
      );
    }

    return Expanded(
      // color: red_color,
      child: _filterbody(),
    );
  }
}
