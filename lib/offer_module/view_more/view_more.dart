import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/offer_module/offer_detail/offer_detail.dart';
import 'package:gems_revamp/offer_module/offer_list/model_offerlist.dart';
import 'package:gems_revamp/offer_module/offer_list/offer_list.dart';
import 'package:gems_revamp/offer_module/offer_search/model_offersearch.dart';
import 'package:gems_revamp/offer_module/offer_search/presenter_offersearch.dart';
import 'package:gems_revamp/offer_module/offer_search/view_offersearch.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/dialogAlert.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';

import '../../common_widget/bottombar.dart';

class ViewMore extends StatefulWidget {
  final offerSubsection;
  const ViewMore({this.offerSubsection, Key? key}) : super(key: key);

  @override
  State<ViewMore> createState() => _ViewMoreState();
}

class _ViewMoreState extends State<ViewMore> implements OfferSearchView {
  var _offerSubsection;
  final myController = TextEditingController();
  bool _isofferlistloader = false;
  List<Outletlist> _outletList = [];
  OfferSearchPresenter? _offersearchpresenter;
  var offersearchresponse;
  List<Outletlist>? offersearchdata;

  @override
  void initState() {
    super.initState();
    _offerSubsection = widget.offerSubsection;
    _offersearchpresenter = OfferSearchPresenter(this);
  }

  void _searchList() {
    if (myController.text.length >= 3) {
      setState(() {
        _isofferlistloader = true;
        calloffersearchapi();
      });
    } else {
      setState(() {
        _isofferlistloader = false;
        // offerlistapi("km", "", "");
      });
    }
  }

  void calloffersearchapi() {
    var request = {
      "limit": "",
      "offset": "",
      "searchtext": myController.text,
      "customer_id": GemsGLobals.membershipNo ?? "12",
      "lat": GemsGLobals.lat,
      "long": GemsGLobals.long,
      "user_type": GemsGLobals.userType ?? "all",
      // "category_code": "Dine"
    };
    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _offersearchpresenter!.offerSearchAPI(request);
      } else {
        bool connectionResult = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (connectionResult == null) {
          Navigator.pop(context);
        }
        if (connectionResult) {
          setState(() {});
          _offersearchpresenter!.offerSearchAPI(request);
        }
      }
    });
  }

  List<Widget> _maincategory(_info, context) {
    List<Widget> _catList = [];
    for (var i = 0; i < _info.length; i++) {
      _catList.add(Container(
        height: 172,
        padding: EdgeInsets.only(left: 0),
        child: new ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            SizedBox(
              width: 0,
            ),
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    //                 if (data["subsection"][index]['sub_sec_name'] ==
                    // "Food Delivery") {
                    //   data["subsection"]
                    //                     [index]["offer_brand"] ??
                    if (_info[i]["offer_brand"] == 'noon_food_LLC') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OfferDetail(
                                    brandcode: _info[i]["offer_brand"] ?? "",
                                    outletcode:
                                        _info[i]["offer_brand_outlet"] ?? "",
                                    partnerbrandid:
                                        _info[i]["partner_brndid"] ?? "",
                                    catcode: _info[i]["category_code"] ?? "",
                                    catname: _info[i]["category_name"] ?? "",
                                    subcatheading:
                                        _info[i]["alt_cat_name"] ?? "",
                                  )));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => OfferListing(
                                subseccode: _info[i]["sub_sec_code"],
                                    categoryCode:
                                        _info[i]["category_code"] ?? '',
                                    categoryName:
                                        _info[i]["category_name"] ?? '',
                                    routetap: "viewmore",
                                    categoryheading:
                                        _info[i]["alt_cat_name"] ?? '',
                                  )));
                    }
                  },
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 7, bottom: 0),
                      ),
                      Container(
                        height: 140,
                        width: 107,
                        child: Stack(
                          children: <Widget>[
                            Card(
                              // elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: ClipRRect(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      _info[i]["more_category_image"] ?? "",
                                  // width: 120,
                                  // height: 170,
                                  height: 140,
                                  width: 107,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Image.asset(
                                    ImageConstants.noimages,
                                    fit: BoxFit.cover,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    ImageConstants.noimages,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            //     Positioned.fill(
                            //       bottom: 5,
                            //       child: Align(
                            //         alignment: Alignment.bottomCenter,
                            //         child: Container(
                            //             margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            //             width:
                            //                 MediaQuery.of(context).size.width / 3.3,
                            //             child: TextWidget(
                            //               text: _info[i]["sub_sec_name"] ?? "",
                            //               softwrap: false,
                            //               overflow: TextOverflow.ellipsis,
                            //                size: text_font_medium_x_size,
                            // weight: FontWeight.bold,
                            // color: brown,
                            //               // color: blackish,
                            //               // weight: FontWeight.bold,
                            //               alignment: TextAlign.center,
                            //               // size: 12,
                            //             )),
                            //       ),
                            //     ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          width: MediaQuery.of(context).size.width / 3.3,
                          child: TextWidget(
                            text: _info[i]["sub_sec_name"] ?? "",
                            softwrap: false,
                            overflow: TextOverflow.ellipsis,
                            color: brown,
                            size: text_font_size_small,
                            weight: FontWeight.w500,
                            // color: blackish,
                            // weight: FontWeight.bold,
                            alignment: TextAlign.center,
                            // size: 12,
                          )),
                    ],
                  ),
                ),
                new SizedBox(
                  width: 3, //this
                ),
               _info[i]["offer_brand"] == 'noon_food_LLC'?
               Container(height: 0,):
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: _subcategories(
                        _info[i]["subcategory"],
                        _info[i]["category_code"],
                        _info[i]["category_name"],
                        _info[i]["alt_cat_name"] ?? '',
                        _info[i]["sub_sec_code"] ?? '',
                        context))
              ],
            )
          ],
        ),
      ));
    }
    return _catList;
  }

  List<Widget> _subcategories(
    _subcatList,
    catcode,
    catname,
    cathead,
    subSecCode,
    context,
  ) {
    List<Widget> list = [];
    for (var i = 0; i < _subcatList.length; i++) {
      list.add(GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => OfferListing(
                          categoryCode: catcode,
                          categoryName: catname,
                          subcatname: _subcatList[i]['cat_name'],
                          subcatcode: _subcatList[i]['cat_code'],
                          subseccode: subSecCode,
                          routetap: "viewmore",
                          categoryheading: cathead ?? "",
                        )));
          },
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 7, bottom: 0),
              ),
              Container(
                height: 140,
                width: 107,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 1.0),
                      child: Card(
                        // elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ClipRRect(
                          child: CachedNetworkImage(
                            imageUrl: "${_subcatList[i]['cat_image'] ?? ""}",
                            // width: 120,
                            // height: 170,
                            height: 140,
                            width: 107,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Image.asset(
                              ImageConstants.noimages,
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              ImageConstants.noimages,
                              fit: BoxFit.cover,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    //     Positioned.fill(
                    //       bottom: 5,
                    //       child: Align(
                    //         alignment: Alignment.bottomCenter,
                    //         child: Container(
                    //             margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    //             width:
                    //                 MediaQuery.of(context).size.width / 3.3,
                    //             child: TextWidget(
                    //               text: _info[i]["sub_sec_name"] ?? "",
                    //               softwrap: false,
                    //               overflow: TextOverflow.ellipsis,
                    //                size: text_font_medium_x_size,
                    // weight: FontWeight.bold,
                    // color: brown,
                    //               // color: blackish,
                    //               // weight: FontWeight.bold,
                    //               alignment: TextAlign.center,
                    //               // size: 12,
                    //             )),
                    //       ),
                    //     ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  width: 107,
                  // MediaQuery.of(context).size.width / 3.3,
                  child: TextWidget(
                    text: _subcatList[i]["cat_name"] ?? "",
                    softwrap: false,
                    overflow: TextOverflow.ellipsis,
                    color: brown,
                    size: text_font_size_small,
                    weight: FontWeight.w500,
                    // color: blackish,
                    // weight: FontWeight.bold,
                    alignment: TextAlign.center,
                    // size: 12,
                  )),
            ],
          )));
      // child: Column(
      //   // crossAxisAlignment: CrossAxisAlignment.start,
      //   // mainAxisAlignment: MainAxisAlignment.start,
      //   children: <Widget>[
      //     Padding(
      //       padding: EdgeInsets.only(top: 7, bottom: 0),
      //     ),
      //     Row(
      //       children: [
      //         Container(
      //           // height: 150,
      //           // width: 120,
      //           height:140,
      //           width:110,

      //              child: Card(
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(7.0),
      //                 ),
      //                 elevation: 5,
      //                 child: ClipRRect(
      //                   child: CachedNetworkImage(
      //                     imageUrl: "${_subcatList[i]['cat_image']}",
      //                     fit: BoxFit.fill,
      //                     // width: 120,
      //                     // height: 170,
      //                     placeholder: (context, url) => Image.asset(
      //                       ImageConstants.noimages,
      //                       fit: BoxFit.cover,
      //                     ),
      //                     errorWidget: (context, url, error) => Image.asset(
      //                       ImageConstants.noimages,
      //                       fit: BoxFit.cover,
      //                     ),
      //                   ),
      //                   borderRadius: BorderRadius.circular(7),
      //                 ),
      //               )

      //         ),

      //       ],
      //     ),
      //     SizedBox(
      //       height: 5,

      //     ),
      //     Row(
      //       children: [
      //         Container(
      //             margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      //             width: 105,
      //             // width: MediaQuery.of(context).size.width / 3.3,
      //             child: TextWidget(
      //               // maxLines: 1,
      //               text: _subcatList[i]["cat_name"] ?? "",
      //                color: brown,
      //                                   size: text_font_size_small,
      //                                   weight: FontWeight.w500,

      //                   alignment: TextAlign.center,
      //               // softwrap: false,
      //               overflow: TextOverflow.ellipsis,
      //               // color: blackish,
      //               // weight: FontWeight.bold,
      //               // size: 12,
      //             )),
      //       ],
      //     ),
      //   ],
      // )));
    }
    return list;
  }

// === No voucher found widget ==========
  Widget _decisionWidget() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            SvgPicture.asset(ImageConstants.noResultFound),
            SizedBox(
              height: 25,
            ),
            TextWidget(
              text: "Sorry! No result found",
              size: text_font_large20_size,
              weight: FontWeight.bold,
              alignment: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            TextWidget(
              text:
                  "Please try another way as we were unable to find what you were looking for.",
              // "We're sorry what you were looking for.\n Please try another way",
              size: text_font_medium16_size,
              alignment: TextAlign.center,
              color: black_color,
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      bluishgradient,
                      blue_color,
                    ],
                  )),
              width: MediaQuery.of(context).size.width / 1.2,
              height: 50,
              child: TextButton(
                child: TextWidget(
                  text: "Try Again",
                  color: white_text_color,
                  size: 20,
                ),
                onPressed: () async {
                  Internetconnectivity().isConnected().then((result) {
                    if (result) {
                      Navigator.pop(context);
                    }
                  });
                },
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _offerCards() {
    List<Widget> _offerList = [];
    var length = offersearchdata?.length ?? 0;
    for (int i = 0; i < length; i++) {
      _offerList.add(GestureDetector(
        onTap: () {
          if (GemsGLobals.userType == "guest") {
            DialogAlert.showLoginAlert(context);
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OfferDetail(
                          outletcode: offersearchdata?[i].outletCode,
                          brandcode: offersearchdata?[i].brandCode,
                          partnerbrandid: offersearchdata?[i].partnerBrndid,
                          catcode: offersearchdata?[i].catCode ?? "",
                          catname: offersearchdata?[i].catName ?? "",
                          // subcatheading: offersearchdata?[i].catName??"",
                        )));
          }
          //
        },
        child: Container(
          child: Column(children: [
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Card(
                shadowColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    side: BorderSide(width: 0.3, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      height: 90,
                      width: 90,
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(width: 0.3, color: Colors.grey),
                            borderRadius: BorderRadius.circular(10)),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: offersearchdata?[i].brandLogo ?? '',
                            width: MediaQuery.of(context).size.width,
                            // height: 182,
                            fit: BoxFit.fill,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fill,
                              )),
                            ),
                            fadeInDuration: Duration(microseconds: 0),
                            placeholderFadeInDuration:
                                Duration(microseconds: 0),
                            fadeOutDuration: Duration(microseconds: 0),
                            placeholder: (context, url) => Image.asset(
                              ImageConstants.noimages,
                              fit: BoxFit.fill,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              ImageConstants.noimages,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 12, left: 2, right: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (offersearchdata?[i].outletname != null)
                                  Container(
                                    width: 160,
                                    child: RichText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: offersearchdata?[i]
                                                      .outletname ??
                                                  '',
                                              style: TextStyle(
                                                  fontSize: text_font_small,
                                                  color: black_km,
                                                  fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            if (offersearchdata?[i].offerTitle != null)
                              Container(
                                child: TextWidget(
                                    text: offersearchdata?[i]
                                                .offerTitle!
                                                .trim() ==
                                            'Multiple Offers'
                                        ? 'Multiple Offers'
                                        : (offersearchdata?[i]
                                                .offerTitle
                                                .toString() ??
                                            ''),
                                    overflow: TextOverflow.ellipsis,
                                    size: text_font_size_small,
                                    color: pink_color,
                                    weight: FontWeight.bold),
                              ),
                            if (offersearchdata?[i].outletArea != null)
                              Container(
                                child: TextWidget(
                                  text: offersearchdata?[i].outletArea ?? "",
                                  color: grey_color,
                                  size: text_font_small,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            if (offersearchdata?[i].distance != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: TextWidget(
                                  text: offersearchdata![i]
                                          .distance!
                                          .toStringAsFixed(2) +
                                      ' km',
                                  weight: FontWeight.w600,
                                  color: black_km,
                                  size: text_font_medium14_size,
                                ),
                              ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ]),
        ),
      ));
    }
    return _offerList;
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              Column(children: _maincategory(_offerSubsection, context)),
              SizedBox(
                height: 95,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabbar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: BottomBar(
        initialIndex: 0,
        tabvalue: "home",
      ),
    );
  }

  Widget _searchBox() {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 15, top: 0, bottom: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white.withAlpha((0.3 * 255).toInt()),
              ),
              height: 40,
              child: Row(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      height: 20,
                      child: SvgPicture.asset(
                        ImageConstants.searchicon,
                        color: white_color,
                        height: 15,
                      )),
                  Expanded(
                    child: TextFormField(
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(75),
                      ],
                      controller: myController,
                      autofocus: false,
                      onChanged: (value) => _searchList(),
                      style: TextStyle(
                        color: white_color,
                      ),
                      cursorColor: white_color,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type to search",
                          hintStyle: TextStyle(
                              color: white_color,
                              fontSize: text_font_medium15_size),
                          contentPadding:
                              EdgeInsets.only(left: 10, bottom: 10)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBar() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(gradient: gradient_theme_color),
          alignment: Alignment.topLeft,
          height: 103,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 15, top: 50),
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
                        size: appbar_text_size,
                        color: white_text_color,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(left: 3, top: 50),
                    child: _searchBox(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: gradient_theme_color),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
          extendBody: true,
          backgroundColor: white_color,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(65.0),
            child: _appBar(),
          ),
          body: _isofferlistloader
              ? Center(
                  child: SpinKitCircle(
                    color: btn_bg_color,
                  ),
                )
              : myController.text.length < 3
                  ? _body()
                  : offersearchresponse != null
                      ? offersearchresponse.status == true
                          ? offersearchresponse?.values?.offerslist.length >= 1
                              ? SingleChildScrollView(
                                  child: Column(children: _offerCards()))
                              : _decisionWidget()
                          : _decisionWidget()
                      : Container(),
          bottomNavigationBar: SizedBox(
            height: 95,
            child: _tabbar(),
          ),
        ),
      ),
    );
  }

  @override
  void getcorpcardFailure(error) {
    // TODO: implement getcorpcardFailure
  }

  @override
  void offersearchResponseSuccess(OfferSearchModel offersearchModel) {
    offersearchresponse = offersearchModel;
    setState(() {
      if (offersearchresponse.status == true) {
        setState(() {
          _isofferlistloader = false;
        });

        offersearchdata = offersearchresponse.values.offerslist;
      } else {
        _isofferlistloader = false;
      }
    });
  }

  @override
  void timeOutError(String error) {
    // TODO: implement timeOutError
  }
}
