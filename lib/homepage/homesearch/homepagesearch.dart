/* Author : Sanjana Shetty
 Date created : 13-June-2022
 Discription : Home Search Page */

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/api_config.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Database/product_list_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_list_model.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_search_history_model.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_wishlisht_count_provider.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/View/product_list_view.dart';
import 'package:gems_revamp/flight_module/flighthomepage.dart';
import 'package:gems_revamp/giftcard_module/giftcard_homepage/giftcard_homepage.dart';
import 'package:gems_revamp/homepage/apiconfig/apiconfighome.dart';
import 'package:gems_revamp/homepage/gemspointssearch_db/gemspoint_search_db_helper.dart';
import 'package:gems_revamp/homepage/gemspointssearch_db/gemspoint_search_history_model.dart';
import 'package:gems_revamp/homepage/homesearch/common_search_model.dart';
import 'package:gems_revamp/homepage/homesearch/homesearch_model.dart';
import 'package:gems_revamp/homepage/homesearch/homesearch_presenter.dart';
import 'package:gems_revamp/homepage/homesearch/homesearch_view.dart';
import 'package:gems_revamp/homepage/offersearch_db/offer_search_db_helper.dart';
import 'package:gems_revamp/homepage/offersearch_db/offer_search_history_model.dart';
import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_homepage.dart';
import 'package:gems_revamp/offer_module/offer_detail/offer_detail.dart';
import 'package:gems_revamp/offer_module/offer_list/model_offerlist.dart';
import 'package:gems_revamp/offer_module/offer_search/model_offersearch.dart';
import 'package:gems_revamp/offer_module/offer_search/presenter_offersearch.dart';
import 'package:gems_revamp/offer_module/offer_search/view_offersearch.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/dialogAlert.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/internetconnectingbox.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:gems_revamp/utils/time_out.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common_widget/bottombar.dart';
import '../../makesense_module/makesense_apiconfig.dart';

class HomeSearchPage extends StatefulWidget {
  final choose;
  const HomeSearchPage({Key? key, this.choose}) : super(key: key);

  @override
  State<HomeSearchPage> createState() => _HomeSearchPageState();
}

class _HomeSearchPageState extends State<HomeSearchPage>
    implements OfferSearchView, HomeSearchView {
  var passcostcentre;
  int _selectedIndex = 0;
  var choosedvalue = "Offers";
  // List _choosegemsoptions = ["Flights", "Hotels", "Gift Cards"];
  List _choosegemsoptions = [];
  List _affiliateid = [];
  var passgemspoints;
  int _selectedIndexforgp = 0;
  final myController = TextEditingController();
  OfferSearchModel corpcarddata = OfferSearchModel();
  OfferSearchPresenter? _offersearchpresenter;
  var offersearchresponse;
  List<Outletlist>? offersearchdata;
  bool _isoffersearchloading = false;
  HomeSearchPresenter? _homesearchpresenter;
  HomeSearchModel? _homesearchdata;
  bool nodatafound = false;
  Future<List<Itemsss>>? suggestionList;
  bool shopdata = false;
  bool gempointloader = true;
  static var dbHelper = ProductListDBHelper();
  Future<List<ProductSearchHistory>> getSearchHistory() {
    var data = dbHelper.getSearchHistory();
    return data;
  }

  static var dbgemspointHelper = GemsPointListDBHelper();
  Future<List<GemsPointSearchHistory>> getGemsPointSearchHistory() {
    var data = dbgemspointHelper.getGemsPointSearchHistory();

    return data;
  }

  static var dbofferHelper = OfferSearchListDBHelper();
  Future<List<OfferSearchHistory>> getofferSearchHistory() {
    var data = dbofferHelper.getofferSearchHistory();

    return data;
  }

  @override
  void initState() {
    GemsGLobals.backbutton = "false";
    if (widget.choose != null) {
      choosedvalue = widget.choose;
    } else {
      choosedvalue = "Offers";
    }
    super.initState();
    _offersearchpresenter = OfferSearchPresenter(this);
    _homesearchpresenter = HomeSearchPresenter(this);
    if (GemsGLobals.searchText == null || GemsGLobals.searchText == "") {
      callhomesearchapi("");
    } else {
      myController.text = GemsGLobals.searchText;
      _isoffersearchloading = true;
      calloffersearchapi();
    }

    // callhomesearchapi("");
  }

 
  _makesenseCommonSearchApiCall(resultsCount, text) {
    String keyName = "Common Search";
    var segmentReq = {
      "source": "homepage",
      "search_keyword": text,
      "number_results_found": resultsCount
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

   _launchURL(url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
      }
      else {
        print("exceptiom =?=> $url");
        throw 'Could not launch $url';
      }
    }catch(e)
    {
      print('exp $e');
    }
  }

  void affilatePartnerAPi(String affilateID) {
    if (GemsGLobals.userType != "guest") {
      var body = {
        "customer_id": GemsGLobals.membershipNo,
        "partner_id": affilateID
      };
      HomeApiconfig.affilatePartner(http.Client(), body).then((result) async {
        if (result["status"] == true) {
          var url = result["values"]["partner_url"] ?? "";
          _launchURL(url);
        }
      });
    } else {
      DialogAlert.showLoginAlert(context);
    }
  }

  void callhomesearchapi(controllertext) {
    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _homesearchpresenter!.homeSearchAPI(controllertext);
      } else {
        bool connectionResult = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (connectionResult == null) {
          Navigator.pop(context);
        }
        if (connectionResult) {
          setState(() {});
          _homesearchpresenter!.homeSearchAPI(controllertext);
        }
      }
    });
  }

  void _searchList() {
    if (choosedvalue == "E Shop") {
      if (myController.text.length >= 3) {
        setState(() {
          suggestionList =
              ApiConfig().autosuggest(myController.text).then((value) {
            final _resp = autoSuggestModelFromJson(value.body.toString());
            if (_resp[0].success == 'true') {
              setState(() {
                shopdata = false;
              });
              _makesenseCommonSearchApiCall(
                  _resp[0].items!.length, myController.text);
              return _resp[0].items!;
            } else {
              setState(() {
                shopdata = true;
              });
              _makesenseCommonSearchApiCall(0, myController.text);
              return [];
            }
          });
          setState(() {});
        });
      } else {
        setState(() {
          // _isoffersearchloading = false;
          // offersearchdata = "";
        });
      }
    } else if (choosedvalue == "GEMS Points") {
      if (myController.text.length >= 3) {
        setState(() {
          callhomesearchapi(myController.text);
        });
      } else if (myController.text.length == 0) {
        setState(() {
          callhomesearchapi("");
        });
      }
    } else {
      if (myController.text.length >= 3) {
        setState(() {
          _isoffersearchloading = true;
        });
        Future.delayed(const Duration(seconds: 5)).then((value) {
          calloffersearchapi();
        });
      } else {
        setState(() {
          _isoffersearchloading = false;
          offersearchdata = [];
        });
      }
    }
  }

  void calloffersearchapi() {
    var request = {
      "limit": "",
      "offset": "",
      "searchtext": myController.text,
      "customer_id": GemsGLobals.membershipNo,
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

  /* insert search history to db */
  void insertIntoDB(String text) {
    if (text != "") {
      ProductSearchHistory property = ProductSearchHistory(
        null,
        text,
      );
      dbHelper.save(property);
    }
  }

  /* insert search history to Gems Points db */
  void insertIntogemspointDB(String text, String text2) {
    if (text != "") {
      GemsPointSearchHistory property =
          GemsPointSearchHistory(null, text, text2);
      dbgemspointHelper.save(property);
    }
  }

  /* insert search history to offers db */
  void insertIntoofferDB(String text, dynamic offerdata) {
    if (text != "") {
      OfferSearchHistory property = OfferSearchHistory(null, text, offerdata);
      dbofferHelper.save(property);
    }
  }

  void deleteFromDB(String text) {
    if (text != "") {
      dbHelper.delete(text);
    }
    setState(() {});
  }

  void deleteIntogemspointDB(String text) {
    if (text != "") {
      dbgemspointHelper.delete(text);
    }
    setState(() {});
  }

  void deleteIntoofferDB(String text) {
    if (text != "") {
      dbofferHelper.delete(text);
    }
    setState(() {});
  }

  Widget _searchbox() {
    return Stack(alignment: Alignment.center, children: [
      Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xfff6f6f6)),
          child: Container(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: TextFormField(
                inputFormatters: [
                  new LengthLimitingTextInputFormatter(75),
                ],
                controller: myController,
                onChanged: (value) {
                  _searchList();
                },
                autofocus: true,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    // hintText: choosedvalue == "GEMS Points" ? "" :
                    hintText: "Search",
                    hintStyle: TextStyle(
                        color: greyish, fontSize: text_font_medium16_size),
                    contentPadding: EdgeInsets.only(left: 10)),
                // enabled: choosedvalue == "GEMS Points" ? false : true,
                enabled: true,
              ),
            ),
          ),
        ),
      ),
      Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 5, bottom: 5),
            child: SvgPicture.asset(
              ImageConstants.search_icon,
              height: 15,
            ),
          )),
      if (myController.text.length >= 3)
        GestureDetector(
          onTap: () {
            setState(() {
              myController.text = "";
              gempointloader = true;
              callhomesearchapi("");
            });
          },
          child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 30.0, top: 5, bottom: 5),
                child: Icon(
                  Icons.close,
                  color: black_color,
                  size: 16,
                ),
              )),
        ),
    ]);
  }

  Widget _offersection() {
    return _isoffersearchloading
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height / 2 + 120,
                  child: SpinKitCircle(
                    color: btn_bg_color,
                  ),
                ),
              ),
            ],
          )
        : offersearchdata?.length == 0
            ? _decisionWidget()
            : Column(children: offerCards());
  }

  List<Widget> offerCards() {
    List<Widget> _offerList = [];
    var length = offersearchdata?.length ?? 0;
    final searchHistoryoffer = getofferSearchHistory();
    _offerList.add(Container(
      padding: EdgeInsets.only(bottom: 5),
      child: myController.text.length < 3
          ? FutureBuilder(
              future: searchHistoryoffer,
              builder: (context, snapshot) {
                return Container(
                    child: FutureBuilder(
                        future: searchHistoryoffer,
                        builder: (context, snapshot) {
                          List data = (snapshot.data ?? []) as List;

                          if (data.isEmpty) return SizedBox();
                          return Padding(
                            padding: const EdgeInsets.all(0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                // SizedBox(height: 10),
                                Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  child: ListTile(
                                    leading: TextWidget(
                                      text: 'Recent Searches',
                                      color: black_color,
                                      weight: FontWeight.w400,
                                      size: text_font_medium_size,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 6),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Wrap(
                                      alignment: WrapAlignment.start,
                                      spacing: 5,
                                      runSpacing: 10,
                                      children: <Widget>[
                                        for (var item
                                            in (snapshot.data ?? []) as List)
                                          Container(
                                            // margin: EdgeInsets.only(
                                            //     left: 15),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: blueaqua, width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            child: Wrap(
                                              // clipBehavior: Clip.none,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    if (item.offersearchdata !=
                                                            null &&
                                                        item.offersearchdata !=
                                                            "") {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      OfferDetail(
                                                                        outletcode:
                                                                            json.decode(item.offersearchdata)["outlet_code"],
                                                                        brandcode:
                                                                            json.decode(item.offersearchdata)["brand_code"],
                                                                        partnerbrandid:
                                                                            json.decode(item.offersearchdata)["partner_brndid"],
                                                                        catcode:
                                                                            json.decode(item.offersearchdata)["partner_brndid"],
                                                                        catname:
                                                                            json.decode(item.offersearchdata)["cat_name"],
                                                                      )));
                                                    }
                                                    //                                           // Navigator.of(
                                                    //                                           //         context)
                                                    //                                           //     .pop(item
                                                    //                                           //         .productNamee);
                                                  },
                                                  child: Container(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8,
                                                            bottom: 8.0,
                                                            left: 8),
                                                    child: TextWidget(
                                                      text: item.productNamee,
                                                      size: 10,
                                                      color: blackish,
                                                    ),
                                                  )),
                                                ),

                                                InkWell(
                                                  onTap: () {
                                                    deleteIntoofferDB(
                                                        item.productNamee);
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 7.0, left: 4),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2.0),
                                                      child: Icon(
                                                        Icons.close,
                                                        color: black_color,
                                                        size: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 6),
                                                // )
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }));
              })
          : Container(),
    ));
    for (int i = 0; i < length; i++) {
      _offerList.add(GestureDetector(
          onTap: () {
            if (offersearchresponse != null
                // && offersearchresponse?.values?.offerslist.length >= 1 &&
                //     offersearchresponse.status == true
                ) {
              insertIntoofferDB(offersearchdata?[i].outletname ?? '',
                  json.encode(offersearchdata?[i]));

              if (GemsGLobals.userType == "guest") {
                DialogAlert.showLoginAlert(context);
              } else {
                var data = Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OfferDetail(
                              outletcode: offersearchdata?[i].outletCode,
                              brandcode: offersearchdata?[i].brandCode,
                              partnerbrandid: offersearchdata?[i].partnerBrndid,
                              catcode: offersearchdata?[i].catCode ?? "",
                              catname: offersearchdata?[i].catName ?? "",
                              // subcatheading: offersearchdata?[i].catName??"",
                            ))).then((value) {
                  GemsGLobals.searchText = myController.text;
                  if (myController.text.isNotEmpty) {
                    calloffersearchapi();
                  } else {
                    callhomesearchapi("");
                  }
                });
              }
            }
            //
          },
          child:
              // offersearchresponse == null
              //     ? Container()
              //     : (offersearchresponse?.values?.offerslist.length ?? 0) >= 1 &&
              //             offersearchresponse.status == true
              //         ?
              Container(
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
                              imageBuilder: (context, imageProvider) =>
                                  Container(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                                    fontWeight:
                                                        FontWeight.w600)),
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
          )
          // : _decisionWidget(),
          ));
    }
    return _offerList;
  }

// === No voucher found widget ==========
  Widget _decisionWidget() {
    return Container(
      alignment: Alignment.center,
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
                "We're sorry what you were looking for.\n Please try another way",
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
    );
  }

  List<Widget> _gemspointsection() {
    final searchHistorynew = getGemsPointSearchHistory();
    List<Widget> _roomList = [];

    // _roomList.add(
    //   Container(
    //     padding: EdgeInsets.only(bottom: 5),
    //     child: FutureBuilder(
    //         future: searchHistorynew,
    //         builder: (context, snapshot) {
    //           return Container(
    //               child: FutureBuilder(
    //                   future: searchHistorynew,
    //                   builder: (context, snapshot) {
    //                     List data = (snapshot.data ?? []) as List;

    //                     if (data.isEmpty) return SizedBox();
    //                     return Padding(
    //                       padding: const EdgeInsets.all(0),
    //                       child: Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         mainAxisAlignment: MainAxisAlignment.start,
    //                         children: <Widget>[
    //                           // SizedBox(height: 10),
    //                           Container(
    //                             height: 50,
    //                             width: MediaQuery.of(context).size.width,
    //                             child: ListTile(
    //                               leading: TextWidget(
    //                                 text: 'Recent Searches',
    //                                 color: black_color,
    //                                 weight: FontWeight.w400,
    //                                 size: text_font_medium_size,
    //                               ),
    //                             ),
    //                           ),
    //                           SizedBox(height: 6),
    //                           Padding(
    //                             padding: const EdgeInsets.only(left: 15.0),
    //                             child: Align(
    //                               alignment: Alignment.topLeft,
    //                               child: Wrap(
    //                                 alignment: WrapAlignment.start,
    //                                 spacing: 5,
    //                                 runSpacing: 10,
    //                                 children: <Widget>[
    //                                   for (var item
    //                                       in (snapshot.data ?? []) as List)
    //                                     Container(
    //                                       //   margin: EdgeInsets.only(
    //                                       //       left: 15),
    //                                       decoration: BoxDecoration(
    //                                           border: Border.all(
    //                                               color: blueaqua, width: 1),
    //                                           borderRadius:
    //                                               BorderRadius.circular(20.0)),
    //                                       child: Wrap(
    //                                         // clipBehavior: Clip.none,
    //                                         children: [
    //                                           InkWell(
    //                                             onTap: () {
    //                                               // Navigator.of(
    //                                               //         context)
    //                                               //     .pop(item
    //                                               //         .productName);
    //                                               setState(() {
    //                                                 if (item.productNames
    //                                                         .toString()
    //                                                         .toLowerCase() ==
    //                                                     "flight") {
    //                                                   Navigator.push(
    //                                                     context,
    //                                                     MaterialPageRoute(
    //                                                         builder: (context) =>
    //                                                             FlightHomePage(
    //                                                               data: null,
    //                                                               tabIndex: 1,
    //                                                             )),
    //                                                   );
    //                                                 } else if (item.productNames
    //                                                         .toString()
    //                                                         .toLowerCase() ==
    //                                                     "hotel") {
    //                                                   Navigator.push(
    //                                                     context,
    //                                                     MaterialPageRoute(
    //                                                         builder: (context) =>
    //                                                             HotelHomePage()),
    //                                                   );
    //                                                 } else if (item.productNames
    //                                                         .toString()
    //                                                         .toLowerCase() ==
    //                                                     "giftcard") {
    //                                                   Navigator.push(
    //                                                       context,
    //                                                       MaterialPageRoute(
    //                                                           builder: (BuildContext
    //                                                                   context) =>
    //                                                               GiftCardCategory()));
    //                                                 } else {
    //                                                   affilatePartnerAPi(
    //                                                       item.affiliateId);
    //                                                 }
    //                                               });
    //                                             },
    //                                             child: Container(
    //                                                 child: Padding(
    //                                               padding:
    //                                                   const EdgeInsets.only(
    //                                                       top: 8,
    //                                                       bottom: 8.0,
    //                                                       left: 8),
    //                                               child: TextWidget(
    //                                                 text: item.productNames,
    //                                                 size: 10,
    //                                                 color: blackish,
    //                                               ),
    //                                             )),
    //                                           ),

    //                                           InkWell(
    //                                             onTap: () {
    //                                               deleteIntogemspointDB(
    //                                                   item.productNames);
    //                                             },
    //                                             child: Padding(
    //                                               padding:
    //                                                   const EdgeInsets.only(
    //                                                       top: 7.0, left: 4),
    //                                               child: Container(
    //                                                 padding:
    //                                                     const EdgeInsets.all(
    //                                                         2.0),
    //                                                 child: Icon(
    //                                                   Icons.close,
    //                                                   color: black_color,
    //                                                   size: 14,
    //                                                 ),
    //                                               ),
    //                                             ),
    //                                           ),
    //                                           SizedBox(width: 6),
    //                                           // )
    //                                         ],
    //                                       ),
    //                                     ),
    //                                 ],
    //                               ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     );
    //                   }));
    //         }),
    //   ),
    // );
    for (int i = 0; i < _choosegemsoptions.length; i++) {
      _roomList.add(Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedIndexforgp = i;
              passgemspoints = _choosegemsoptions[i];
              insertIntogemspointDB(_choosegemsoptions[i], _affiliateid[i]);
              if (passgemspoints.toString().toLowerCase() == "flight") {
                if (GemsGLobals.userType == "guest") {
                  DialogAlert.showLoginAlert(context);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FlightHomePage(
                              data: null,
                              tabIndex: 1,
                            )),
                  );
                }
              } else if (passgemspoints.toString().toLowerCase() == "hotel") {
                if (GemsGLobals.userType == "guest") {
                  DialogAlert.showLoginAlert(context);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HotelHomePage()),
                  );
                }
              } else if (passgemspoints.toString().toLowerCase() ==
                  "giftcard") {
                if (GemsGLobals.userType == "guest") {
                  DialogAlert.showLoginAlert(context);
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              GiftCardCategory()));
                }
              } else {
                if (GemsGLobals.userType == "guest") {
                  DialogAlert.showLoginAlert(context);
                } else {
                  affilatePartnerAPi(_affiliateid[i]);
                }
              }
            });
          },
          child: Column(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 0.0),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0.0, bottom: 0),
                    child: Container(
                        padding: EdgeInsets.only(top: 5, left: 0, bottom: 5),
                        decoration: BoxDecoration(
                            color: white_color,
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0))),
                        child: TextWidget(
                          text: _choosegemsoptions[i],
                          color: flight_text_black_color.withOpacity(0.9),
                          size: text_font_size_x_small,
                          weight: FontWeight.w500,
                        )),
                    // ),
                  )),
              Divider(
                color: greyish,
              )
            ],
          ),
        ),
      ));
    }

    return _roomList;
  }

  Widget eshopdata() {
    final searchHistory = getSearchHistory();
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned(
                right: 15,
                left: 0,
                top: 0,
                child: Container(
                  // padding: EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height / 1.15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withOpacity(0.8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 5),
                        child: FutureBuilder(
                            future: searchHistory,
                            builder: (context, snapshot) {
                              return Container(
                                  child: FutureBuilder(
                                      future: searchHistory,
                                      builder: (context, snapshot) {
                                        List data =
                                            (snapshot.data ?? []) as List;

                                        if (data.isEmpty) return SizedBox();
                                        return Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              // SizedBox(height: 10),
                                              Container(
                                                height: 50,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: ListTile(
                                                  leading: TextWidget(
                                                    text: 'Recent Searches',
                                                    color: black_color,
                                                    weight: FontWeight.w400,
                                                    size: text_font_medium_size,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 6),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0),
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Wrap(
                                                    alignment:
                                                        WrapAlignment.start,
                                                    spacing: 5,
                                                    runSpacing: 10,
                                                    children: <Widget>[
                                                      for (var item
                                                          in (snapshot.data ??
                                                              []) as List)
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color:
                                                                      blueaqua,
                                                                  width: 1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0)),
                                                          child: Wrap(
                                                            // clipBehavior: Clip.none,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    GemsGLobals
                                                                            .backbutton =
                                                                        "true";
                                                                  });

                                                                  var search = item
                                                                      .productName;
                                                                  if (search !=
                                                                          null &&
                                                                      search !=
                                                                          '') {
                                                                    internetCall(
                                                                        context,
                                                                        () => Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) => ChangeNotifierProvider(
                                                                                    create: (context) => WishListCartCount(),
                                                                                    child: ProductListView(
                                                                                      catId: null,
                                                                                      searchValue: search,
                                                                                      categorypage: "yes",
                                                                                    )))));
                                                                  }
                                                                },
                                                                child: Container(
                                                                    child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 8,
                                                                      bottom:
                                                                          8.0,
                                                                      left: 8),
                                                                  child:
                                                                      TextWidget(
                                                                    text: item
                                                                        .productName,
                                                                    size: 10,
                                                                    color:
                                                                        blackish,
                                                                  ),
                                                                )),
                                                              ),

                                                              InkWell(
                                                                onTap: () {
                                                                  deleteFromDB(item
                                                                      .productName);
                                                                },
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 7.0,
                                                                      left: 4),
                                                                  child:
                                                                      Container(
                                                                    // height: 20,
                                                                    // width: 20,
                                                                    // decoration:
                                                                    //     BoxDecoration(
                                                                    //   gradient:
                                                                    //       LinearGradient(
                                                                    //           colors:
                                                                    //               new_gradient_color),

                                                                    //   shape: BoxShape
                                                                    //       .circle,

                                                                    // ),
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            2.0),
                                                                    child: Icon(
                                                                      Icons
                                                                          .close,
                                                                      color:
                                                                          black_color,
                                                                      size: 14,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 6),
                                                              // )
                                                            ],
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }));
                            }),
                      ),
                      // suggestionList != null
                      //     ? Container(
                      //         margin: EdgeInsets.only(top: 10, bottom: 0),
                      //         padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      //         child: TextWidget(
                      //           text: "Searches",
                      //           color: black_color,
                      //           size: 18,
                      //           weight: FontWeight.bold,
                      //         ),
                      //       )
                      //     : Container(),
                      SizedBox(
                        height: 14,
                      ),

                      Flexible(
                        fit: FlexFit.loose,
                        child: FutureBuilder(
                            future: suggestionList,
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return Container(
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                    child: Center(
                                      child: SpinKitCircle(
                                        color: blue_color,
                                      ),
                                    ),
                                  );
                                default:
                                  if (snapshot.hasError)
                                    return Text('Error: ${snapshot.error}');
                                  else if (snapshot.data == null &&
                                      myController.text != "")
                                    return Container(
                                        child: Center(child: Text('')));
                                  else {
                                    List<Itemsss> list = snapshot.data != null
                                        ? snapshot.data as List<Itemsss>
                                        : [];

                                    return myController.text.length >= 3 &&
                                            shopdata == true
                                        ? _noserachresultshop()
                                        : Container(
                                            child: ListView.builder(
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      // _makesenseApiCall(query);
                                                      if (GemsGLobals
                                                              .userType ==
                                                          "guest") {
                                                        DialogAlert
                                                            .showLoginAlert(
                                                                context);
                                                      } else {
                                                        insertIntoDB(
                                                            list[index].title ??
                                                                '');
                                                        setState(() {
                                                          GemsGLobals
                                                                  .backbutton =
                                                              "true";
                                                        });

                                                        var search =
                                                            list[index].title ??
                                                                '';
                                                        if (search != null &&
                                                            search != '') {
                                                          internetCall(
                                                              context,
                                                              () => Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => ChangeNotifierProvider(
                                                                          create: (context) => WishListCartCount(),
                                                                          child: ProductListView(
                                                                            catId:
                                                                                null,
                                                                            searchValue:
                                                                                search,
                                                                            categorypage:
                                                                                "yes",
                                                                          )))));
                                                        }
                                                      }
                                                    },
                                                    //start
                                                    child:
                                                        myController.text
                                                                    .length >=
                                                                3
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            20.0),
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                0.0),
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              top: 0.0,
                                                                              bottom: 0),
                                                                          child: Container(
                                                                              padding: EdgeInsets.only(top: 5, left: 0, bottom: 5),
                                                                              decoration: BoxDecoration(color: white_color, borderRadius: BorderRadius.all(Radius.circular(4.0))),
                                                                              child: TextWidget(
                                                                                text: list[index].title ?? "",
                                                                                color: flight_text_black_color.withOpacity(0.9),
                                                                                size: text_font_size_x_small,
                                                                                weight: FontWeight.w500,
                                                                              )),
                                                                          // ),
                                                                        )),
                                                                    Divider(
                                                                      color:
                                                                          greyish,
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                            : Container(),
                                                    // child: Container(
                                                    //   margin: EdgeInsets.only(
                                                    //       left: 15, bottom: 10),
                                                    //   child: Row(
                                                    //     crossAxisAlignment:
                                                    //         CrossAxisAlignment.center,
                                                    //     mainAxisAlignment:
                                                    //         MainAxisAlignment.start,
                                                    //     children: [
                                                    //       Container(
                                                    //         height: 15,
                                                    //         width: 15,
                                                    //         child: Image.asset(
                                                    //           ImageConstants
                                                    //               .history_timer,
                                                    //         ),
                                                    //       ),
                                                    //       SizedBox(
                                                    //         width: 10,
                                                    //       ),
                                                    //       Expanded(
                                                    //         child: Container(
                                                    //           child: TextWidget(
                                                    //             text: list[index]
                                                    //                     .title ??
                                                    //                 "",
                                                    //             color: black_color,
                                                    //             size: text_font_small,
                                                    //             weight:
                                                    //                 FontWeight.w400,
                                                    //           ),
                                                    //         ),
                                                    //       ),
                                                    //       Container(
                                                    //         height: 15,
                                                    //         width: 15,
                                                    //         child: Image.asset(
                                                    //           ImageConstants
                                                    //               .left_top_arrow,
                                                    //         ),
                                                    //       ),
                                                    //     ],
                                                    //   ),
                                                    // ),
                                                  );
                                                },
                                                itemCount: list.length),
                                          );
                                  }
                              }
                            }),
                      ),
                      suggestionList != null
                          ? Container()
                          : Spacer(
                              flex: 30,
                            ),
                      // Container(
                      //     // height: 50,
                      //     child: Row(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   children: <Widget>[
                      //     Container(
                      //       // width: 100,
                      //       // width:
                      //       //     MediaQuery.of(context).size.width / 1.8,
                      //       decoration: BoxDecoration(
                      //           gradient: LinearGradient(
                      //               colors: new_gradient_color,
                      //               begin: Alignment.topLeft,
                      //               end: Alignment.bottomRight),
                      //           boxShadow: [
                      //             BoxShadow(
                      //                 color: Colors.grey[300]!, blurRadius: 5.0)
                      //           ],
                      //           borderRadius: BorderRadius.circular(10)),
                      //       child: TextButton(
                      //         child: Padding(
                      //           padding: const EdgeInsets.only(
                      //               left: 30.0, right: 30, top: 5, bottom: 5),
                      //           child: TextWidget(
                      //             text: "Search",
                      //             color: white_color,
                      //             weight: FontWeight.bold,
                      //             size: text_font_medium_size,
                      //           ),
                      //         ),
                      //         onPressed: () {
                      //           // _makesenseApiCall(query.text);
                      //           insertIntoDB(myController.text);
                      //           Navigator.of(context).pop(myController.text);
                      //         },
                      //       ),
                      //     ),
                      //     Container(
                      //       // width: 100,
                      //       // padding: EdgeInsets.only(
                      //       //     left: 10, right: 10, bottom: 0),
                      //       decoration: BoxDecoration(
                      //           color: Colors.grey[100],
                      //           borderRadius: BorderRadius.circular(10),
                      //           boxShadow: [
                      //             BoxShadow(
                      //                 color: Colors.grey[300]!, blurRadius: 5.0)
                      //           ]),
                      //       child: FlatButton(
                      //         onPressed: () {
                      //           dbHelper.truncateSearchHistory();
                      //           Fluttertoast.showToast(
                      //             msg: " Recent searches deleted.",
                      //             toastLength: Toast.LENGTH_SHORT,
                      //             gravity: ToastGravity.BOTTOM,
                      //           );
                      //           Navigator.of(context).pop();
                      //         },
                      //         child: Padding(
                      //           padding: const EdgeInsets.only(
                      //               left: 30.0, right: 30, top: 5, bottom: 5),
                      //           child: TextWidget(
                      //             text: "Reset",
                      //             color: black_color,
                      //             size: text_font_medium_size,
                      //             weight: FontWeight.bold,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ))
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _selectoptions() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: choosedvalue == "Offers" ? blue_color : searchbar),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                      child: Center(
                        child: TextWidget(
                          text: 'Offers',

                          size: 14,
                          weight: FontWeight.w500,
                          color: choosedvalue == "Offers"
                              ? white_color
                              : searchtextcolor,
                          // weight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        choosedvalue = "Offers";
                        myController.clear();
                      });
                    },
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: choosedvalue == "GEMS Points"
                          ? blue_color
                          : searchbar),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    // child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                      child: TextWidget(
                        text: 'GEMS Points',
                        color: choosedvalue == "GEMS Points"
                            ? white_color
                            : searchtextcolor,
                        size: 14,
                        weight: FontWeight.w500,

                        // ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        choosedvalue = "GEMS Points";
                        myController.clear();
                        callhomesearchapi("");
                      });
                    },
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: choosedvalue == "E Shop" ? blue_color : searchbar),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                      child: Center(
                        child: TextWidget(
                          text: 'eShop',
                          color: choosedvalue == "E Shop"
                              ? white_color
                              : searchtextcolor,
                          size: 14,
                          weight: FontWeight.w500,
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        choosedvalue = "E Shop";
                        myController.clear();
                      });
                    },
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _nosearchresultfound() {
    return Container(
      alignment: Alignment.center,
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
                "We're sorry what you were looking for.\n Please try another way",
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
    );
  }

  Widget _noserachresultshop() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
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
                "We're sorry what you were looking for.\n Please try another way",
            size: text_font_medium16_size,
            alignment: TextAlign.center,
            color: black_color,
          ),
          SizedBox(
            height: 30,
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
        ],
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(bottom: 70),
        child: Column(
          children: [
            if (choosedvalue == "Offers") _offersection(),
            if (choosedvalue == "GEMS Points")
              Container(
                child: nodatafound && myController.text.length >= 3
                    ? _nosearchresultfound()
                    : gempointloader == true
                        ? Container(
                            height: MediaQuery.of(context).size.height / 2,
                            child: Center(
                                child: SpinKitCircle(
                              color: btn_bg_color,
                            )),
                          )
                        : Column(children: _gemspointsection()),
              ),
            if (choosedvalue == "E Shop") eshopdata(),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  Widget _tabbar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: BottomBar(
        initialIndex: 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(gradient: gradient_theme_color),
        child: SafeArea(
            bottom: true,
            top: false,
            child: Scaffold(
              extendBody: true,
              backgroundColor: white_text_color,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(190.0),
                child: Column(
                  children: [
                    GradientAppBar(
                      title: "Search",
                      color: white_text_color,
                      size: text_font_large20_size,
                      weight: FontWeight.w500,
                      centerTitle: true,
                      height: 90,
                    ),
                    SizedBox(height: 20),
                    _selectoptions(),
                    SizedBox(height: 20),
                    _searchbox(),
                  ],
                ),
              ),
              body: _body(),
              bottomNavigationBar: SizedBox(height: 95, child: _tabbar()),
            )));
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
  void offersearchResponseSuccess(OfferSearchModel offersearchModel) {
    offersearchresponse = offersearchModel;
    setState(() {
      if (offersearchresponse.status == true) {
        setState(() {
          _isoffersearchloading = false;
        });

        offersearchdata = offersearchresponse?.values?.offerslist;
        _makesenseCommonSearchApiCall(
            offersearchdata!.length, myController.text);
      } else {
        setState(() {
          _isoffersearchloading = false;
          _makesenseCommonSearchApiCall(0, myController.text);
          offersearchdata?.clear();
        });
      }
    });
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

  @override
  void homesearchResponseSuccess(HomeSearchModel homesearchModel) {
    _homesearchdata = homesearchModel;
    setState(() {
      if (_homesearchdata!.status == true) {
        gempointloader = false;
        nodatafound = false;
        _choosegemsoptions.clear();
        _affiliateid.clear();
        for (int i = 0; i < _homesearchdata!.values!.length; i++) {
          _choosegemsoptions.add(_homesearchdata!.values![i].affiliateName);
          _affiliateid.add(_homesearchdata!.values![i].affiliateId);
        }
        if (myController.text.isNotEmpty) {
          _makesenseCommonSearchApiCall(
              _homesearchdata!.values!.length, myController.text);
        }
      } else {
        nodatafound = true;
        gempointloader = false;
        if (myController.text.isNotEmpty) {
          _makesenseCommonSearchApiCall(0, myController.text);
        }

        // _choosegemsoptions.clear();

      }
    });
  }

  @override
  void commonsearchResponseSuccess(CommonSearchModel commonSearchModel) {
    // TODO: implement commonsearchResponseSuccess
  }
}
