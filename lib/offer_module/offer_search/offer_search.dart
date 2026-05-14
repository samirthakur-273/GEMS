/* Author : Sanjana Shetty
 Date created : 29-April-2022
 Discription : Offer Search Page*/

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/offer_module/offer_detail/offer_detail.dart';
import 'package:gems_revamp/offer_module/offer_search/model_offersearch.dart';
import 'package:gems_revamp/offer_module/offer_search/view_offersearch.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:gems_revamp/utils/time_out.dart';

import 'presenter_offersearch.dart';

class OfferSearchPage extends StatefulWidget {
  final catcode;
  final catname;
  OfferSearchPage({Key? key, this.catcode,this.catname}) : super(key: key);
  @override
  _OfferSearchPageState createState() => _OfferSearchPageState();
}

class _OfferSearchPageState extends State<OfferSearchPage>
    implements OfferSearchView {
  final myController = TextEditingController();
  OfferSearchModel corpcarddata = OfferSearchModel();
  OfferSearchPresenter? _offersearchpresenter;
  var offersearchresponse;
  var offersearchdata;
  bool _isoffersearchloading = false;

  @override
  void initState() {
    super.initState();
    _offersearchpresenter = OfferSearchPresenter(this);
  }

  void calloffersearchapi() {
    var request = {
      "limit": "",
      "offset": "",
      "searchtext": myController.text.toString().trim(),
      "customer_id": GemsGLobals.membershipNo??"12",
      "lat": GemsGLobals.lat,
      "long": GemsGLobals.long,
      "user_type": GemsGLobals.userType ?? "all"
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

  void _searchList() {
    if (myController.text.length >= 3) {
      setState(() {
        _isoffersearchloading = true;
        calloffersearchapi();
      });
    } else {
      setState(() {
        _isoffersearchloading = false;
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
              text: "Search Offers",
              size: text_font_medium18_size,
              weight: FontWeight.bold,
            ),
            Spacer(),
            InkWell(
              onTap: () {
                Navigator.pop(context);
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
           height: MediaQuery.of(context).size.height/2+120,
         
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextWidget(
                text: myController.text.isEmpty ? "" : "Whoops!",
                size: text_font_large25_size,
                weight: FontWeight.w600,
              ),
              TextWidget(
                text: myController.text.isEmpty
                    ? ""
                    : "We can't find your offer here.\n Do check if its a typo 🙂!!!",
                weight: FontWeight.w500,
                size: text_font_medium18_size,
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
                  color: white_color,
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
                        autofocus: true,
                        onChanged: (value) => _searchList(),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search by offers",
                            hintStyle: TextStyle(
                                color: hint_text_color,
                                fontSize: text_font_medium15_size),
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

    double calculateDistance(lat1, lon1, lat2, lon2) {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(a));
    }

    double _distance(lat, long) {
      var outletdistance = calculateDistance(GemsGLobals.lat, GemsGLobals.long,
          double.tryParse(lat.toString()), double.tryParse(long.toString()));
      return outletdistance;
    }

    Widget offerCards() {
      return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            Container(
                child: TextWidget(
                    text: widget.catname??"",
                    color: Colors.brown,
                    weight: FontWeight.bold,
                    size: text_font_medium15_size)),
            Expanded(
                child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: List.generate(
                        offersearchdata.length,
                        (index) => GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OfferDetail(
                                              outletcode: offersearchdata[index]
                                                  .outletCode,
                                              brandcode: offersearchdata[index]
                                                  .brandCode,
                                              partnerbrandid:
                                                  offersearchdata[index]
                                                      .partnerBrndid,
                                              catcode: offersearchdata[index]
                                                  .catCode??"",
                                              catname: offersearchdata[index].catName??"",    
                                            )));
                              },
                              child: 
                             
                              Column(children: [
                                //  if(offersearchdata[index]
                                //                       .outletlistingimage !=null)
                                // Container(
                                //   height: 120,
                                //   margin: EdgeInsets.only(
                                //       top: 8, bottom: 8, right: 12),
                                //   width: double.maxFinite,
                                //   decoration: BoxDecoration(
                                //       image: DecorationImage(
                                //           image: NetworkImage(
                                //               offersearchdata[index]
                                //                       .outletImage ??
                                //                   ''),
                                //           fit: BoxFit.cover),
                                //       boxShadow: [
                                //         BoxShadow(
                                //             color: black_color.withOpacity(0.1),
                                //             blurRadius: 2,
                                //             spreadRadius: 1)
                                //       ],
                                //       borderRadius: BorderRadius.circular(10)),
                                // ),
                              ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                                  child: CachedNetworkImage(
                                                      imageUrl: offersearchdata[index].outletlistingimage ?? '',
                                                     width: double.maxFinite,
                                                     height: 120,
                                                      fit: BoxFit.cover,
                                                      imageBuilder: (context, imageProvider) => Container(
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.fill,
                                                        )),
                                                      ),
                                                      fadeInDuration: Duration(microseconds: 0),
                                                      placeholderFadeInDuration: Duration(microseconds: 0),
                                                      fadeOutDuration: Duration(microseconds: 0),
                                                      placeholder: (context, url) => Image.asset(
                                                        ImageConstants.noimages,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      errorWidget: (context, url, error) => Image.asset(
                                                        ImageConstants.noimages,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          if( offersearchdata[index]
                                                                  .brandLogo!=null)
                                          new Container(
                                              width: 40.0,
                                              height: 40.0,
                                              decoration: new BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey[400]!,
                                                      width: 0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(45),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      blurRadius: 2.0,
                                                      color: Colors.grey
                                                          .withOpacity(.5),
                                                      offset: Offset(1.0, 1.0),
                                                    ),
                                                  ],
                                                  image: new DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: NetworkImage(
                                                          offersearchdata[index]
                                                                  .brandLogo ??
                                                              '')))),
                                          SizedBox(width: 10),
                                          Column(
                                            children: [
                                              if(offersearchdata[index]
                                                              .offertitle!=null)
                                              TextWidget(
                                                  text: offersearchdata[index]
                                                              .offertitle!
                                                              .trim() ==
                                                          'Multiple Offers'
                                                      ? 'Multiple Offers'
                                                      : offersearchdata[index]
                                                              .offertitle
                                                              .toString(),
                                                  color: pink_color,
                                                  weight: FontWeight.bold),
                                              SizedBox(height: 10),
                                              if(offersearchdata[
                                                                    index]
                                                                .outletname!=null)
                                              RichText(
                                                text: TextSpan(
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: offersearchdata[
                                                                    index]
                                                                .outletname ??
                                                            '',
                                                        style: TextStyle(
                                                            fontSize:
                                                                text_font_size_small,
                                                            color: black_km,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    // TextSpan(
                                                    //     text: ' - ',
                                                    //     style: TextStyle(
                                                    //         fontSize: text_font_size_small,
                                                    //         color: black_color)),
                                                    // TextSpan(
                                                    //     text: ' Indian',
                                                    //     style: TextStyle(
                                                    //         fontSize: text_font_size_small,
                                                    //         color: Colors
                                                    //             .black)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          if(offersearchdata[index].outletArea!=null)
                                          TextWidget(
                                            text: offersearchdata[index]
                                                    .outletArea ??
                                                '',
                                            color: grey_color,
                                          ),
                                          SizedBox(height: 10),
                                          // TextWidget(
                                          //   text:
                                          //    offersearchdata[index]
                                          //           .distance
                                          //           .toStringAsFixed(2) +
                                          //       ' km',
                                          //   weight: FontWeight.bold,
                                          //   color: black_km,
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                              ]),
                            )))),
            SizedBox(height: 200),
          ]));
    }

    Widget _body() {
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _title(),
            _search(),
            SizedBox(
              height: 15,
            ),
            _isoffersearchloading
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height/2+120,
                          child: SpinKitCircle(
                            
                            color: btn_bg_color,
                          ),
                        ),
                      ),
                    ],
                  )
                : offersearchresponse != null
                    ? offersearchresponse.status == true
                        ? offersearchresponse?.values?.offerslist.length >= 1
                            ? offerCards()
                            : _decisionWidget()
                        : _decisionWidget()
                    : Container()
          ],
        ),
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
  void offersearchResponseSuccess(OfferSearchModel offersearchModel) {
    offersearchresponse = offersearchModel;
    setState(() {
      if (offersearchresponse.status == true) {
        setState(() {
          _isoffersearchloading = false;
        });

        offersearchdata = offersearchresponse.values.offerslist;
      } else {
        _isoffersearchloading = false;
      }
    });
  }

  @override
  void getcorpcardFailure(error) {
    if (error == "timeout") {
      setState(() {
        _isoffersearchloading = false;
      });
    }
  }

  @override
  Future<void> timeOutError(String error) async {
    if (error == "timeout") {
      setState(() {
        _isoffersearchloading = false;
      });
      bool isRetry = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => TimeOut()));
      if (isRetry && isRetry != null) {
        calloffersearchapi();
      }
    }
  }
}
