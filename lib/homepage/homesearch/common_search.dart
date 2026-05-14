import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/bottombar.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/tabbarpage.dart';
import 'package:gems_revamp/homepage/apiconfig/apiconfighome.dart';
import 'package:gems_revamp/homepage/homesearch/common_search_model.dart';
import 'package:gems_revamp/homepage/homesearch/homesearch_model.dart';
import 'package:gems_revamp/homepage/homesearch/homesearch_presenter.dart';
import 'package:gems_revamp/homepage/homesearch/homesearch_view.dart';
import 'package:gems_revamp/homepage/offersearch_db/offer_search_db_helper.dart';
import 'package:gems_revamp/homepage/offersearch_db/offer_search_history_model.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../eshop_module_new/common_widget/internetconnectingbox.dart';
import '../../eshop_module_new/common_widget/text_widget.dart';
import '../../eshop_module_new/product_list_module/Database/product_list_db_helper.dart';
import '../../eshop_module_new/product_list_module/Model/product_search_history_model.dart';
import '../../eshop_module_new/product_list_module/Model/product_wishlisht_count_provider.dart';
import '../../eshop_module_new/product_list_module/View/product_list_view.dart';
import '../../eshop_module_new/utils/customloader/custome_circle_loader.dart';
import '../../flight_module/flighthomepage.dart';
import '../../giftcard_module/giftcard_homepage/giftcard_homepage.dart';
import '../../hotel_module/hotel_homepage/hotel_homepage.dart';
import '../../offer_module/offer_detail/offer_detail.dart';
import '../../utils/connectivity.dart';
import '../../utils/constants_files/imageconstants.dart';
import '../../utils/dialogAlert.dart';
import '../gemspointssearch_db/gemspoint_search_db_helper.dart';
import '../gemspointssearch_db/gemspoint_search_history_model.dart';

class CommonSearch extends StatefulWidget {
  final choose;
  const CommonSearch({Key? key, this.choose}) : super(key: key);

  @override
  State<CommonSearch> createState() => _CommonSearchState();
}

class _CommonSearchState extends State<CommonSearch> implements HomeSearchView {
  final myController = TextEditingController();
  HomeSearchPresenter? _homesearchpresenter;
  var offerData = [];
  var gemsPointsData = [];
  var eshopData = [];
  var _commonSearchModel;
  var offersearchresponse;
  var passgemspoints;
  var passAffiliatedId;
  var passeshopData;
  int _selectedIndexforgp = 0;
  List _choosegemsoptions = [];
  List _eshopTitle = [];
  List _affiliateid = [];
  List<OffersList>? offersearchdata;
  List<GemsPointList>? gemsPointsSearchData;
  List<EshopList>? eshopSearchData;
  bool _isoffersearchloading = false;
  bool commonApiCalled = false;
  bool noDataFound = false;
  bool isRecentData = false;

  @override
  void initState() {
    super.initState();
    _homesearchpresenter = HomeSearchPresenter(this);
    if (GemsGLobals.searchText.isNotEmpty || GemsGLobals.searchText != "") {
      myController.text = GemsGLobals.searchText;
      _isoffersearchloading = true;
      callcommonsearchapi();
    }
    GemsGLobals.lastVisitPageName = GemsGLobals.commonSearchPage;
  }

  static var dbofferHelper = OfferSearchListDBHelper();
  Future<List<OfferSearchHistory>> getofferSearchHistory() {
    var data = dbofferHelper.getofferSearchHistory();

    return data;
  }

  /* insert search history to offers db */
  void insertIntoofferDB(String text, dynamic offerdata) {
    if (text != "") {
      OfferSearchHistory property = OfferSearchHistory(null, text, offerdata);
      dbofferHelper.save(property);
    }
  }

  void deleteIntoofferDB(String text) {
    if (text != "") {
      dbofferHelper.delete(text);
    }
    setState(() {});
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

  static var dbgemspointHelper = GemsPointListDBHelper();
  Future<List<GemsPointSearchHistory>> getGemsPointSearchHistory() {
    var data = dbgemspointHelper.getGemsPointSearchHistory();

    return data;
  }

  /* insert search history to Gems Points db */
  void insertIntogemspointDB(String text, String text2) {
    if (text != "") {
      GemsPointSearchHistory property =
          GemsPointSearchHistory(null, text, text2);
      dbgemspointHelper.save(property);
    }
  }

  static var dbHelper = ProductListDBHelper();
  Future<List<ProductSearchHistory>> getSearchHistory() {
    var data = dbHelper.getSearchHistory();
    return data;
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

  void affilatePartnerAPi(String affilateID) {
    if (GemsGLobals.userType != "guest") {
      var body = {
        "customer_id": GemsGLobals.membershipNo,
        "partner_id": affilateID
      };
      HomeApiconfig.affilatePartner(http.Client(), body).then((result) async {
        if (result["status"] == true) {
          var url = result["values"]["partner_url"] ?? "";
          if (await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(Uri.parse(url));
          } else {
            throw 'Could not launch $url';
          }
        }
      });
    } else {
      DialogAlert.showLoginAlert(context);
    }
  }

  makesenseEventCall(pageName) {
    String keyName = GemsGLobals.eventSearchInitiated;
    var segmentReq = {
      GemsGLobals.pageName : pageName,GemsGLobals.intSource: GemsGLobals.lastVisitPageName
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

    makesenseEventSearchResultClickedCall(elementType,elementName,elementUrl) {
    String keyName = GemsGLobals.eventSearchResultClicked;
    var segmentReq = {
      GemsGLobals.elementTypeParam : elementType,
      GemsGLobals.elementNameParam : elementName,
      GemsGLobals.elementUrlParam : elementUrl,
      GemsGLobals.intSource: GemsGLobals.lastVisitPageName      
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }


  _makesenseCommonSearchApiCall(resultsCount, text) {
    String keyName = GemsGLobals.eventSearchExecuted;
    var segmentReq = {
      GemsGLobals.searchTermParam : text,
      GemsGLobals.numberOfResultsParam : resultsCount,
      GemsGLobals.intSource: GemsGLobals.lastVisitPageName

    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  void callcommonsearchapi() {
    var req = {
      "searchtext": myController.text.toString().trim(),
      "lat": GemsGLobals.lat,
      "long": GemsGLobals.long,
      "brandcode": "1",
      "country_code": "main_website_store",
      "lang_code": "1",
      "user_type": GemsGLobals.userType
    };
    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _homesearchpresenter!.commonSearchAPI(req);
      } else {
        bool connectionResult = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (connectionResult == null) {
          Navigator.pop(context);
        }
        if (connectionResult) {
          setState(() {});
          _homesearchpresenter!.commonSearchAPI(req);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _tabbar() {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: BottomBar(
          initialIndex: 0,
        ),
      );
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
                  onChanged: (value) async {
                    // _searchList();

                    setState(() {
                      _isoffersearchloading = true;
                    });

                    if (myController.text.length >= 3) {
                      if (myController.text.contains(" ")) {
                        Future.delayed(Duration(seconds: 4)).then((value) {
                          callcommonsearchapi();
                        });
                      } else {
                        callcommonsearchapi();
                      }
                    }
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
                  // enabled: true,
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
                offersearchdata!.clear();
                gemsPointsSearchData!.clear();
                eshopSearchData!.clear();
                _isoffersearchloading = false;
              });
            },
            child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 30.0, top: 5, bottom: 5),
                  child: Icon(
                    Icons.close,
                    color: black_color,
                    size: 16,
                  ),
                )),
          ),
      ]);
    }

    List<Widget> _gemspointsection() {
      List<Widget> _roomList = [];

      for (int i = 0; i < gemsPointsData.length; i++) {
        _roomList.add(Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15, top: 0),
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

                GemsGLobals.searchText = myController.text;
              });
            makesenseEventSearchResultClickedCall(GemsGLobals.gemspointsKey,_choosegemsoptions[i] ?? "","");

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

    List<Widget> eshopdataSearch() {
      List<Widget> _eshopData = [];

      for (int i = 0; i < eshopData.length; i++) {
        _eshopData.add(Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndexforgp = i;
                if (GemsGLobals.userType == "guest") {
                  DialogAlert.showLoginAlert(context);
                } else {
                  insertIntoDB(_eshopTitle[i] ?? '');
                  setState(() {
                    GemsGLobals.backbutton = "true";
                  });

                  var search = _eshopTitle[i] ?? '';
                  if (search != null && search != '') {
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

                  GemsGLobals.searchText = myController.text;
                }
              });

              makesenseEventSearchResultClickedCall(GemsGLobals.eshopKey,_eshopTitle[i] ?? "","");
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
                            text: _eshopTitle[i],
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

      return _eshopData;
    }

    Widget pointRecentData(searchHistorynew) {
      return FutureBuilder(
          future: searchHistorynew,
          builder: (context, snapshot) {
            return Container(
                child: FutureBuilder(
                    future: searchHistorynew,
                    builder: (context, snapshot) {
                      List data = (snapshot.data ?? []) as List;
                      if (data.isNotEmpty) {
                        isRecentData = true;
                      } else {
                        isRecentData = false;
                      }

                      return Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            // SizedBox(height: 10),

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
                                        //   margin: EdgeInsets.only(
                                        //       left: 15),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: blueaqua, width: 1),
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        child: Wrap(
                                          // clipBehavior: Clip.none,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                // Navigator.of(
                                                //         context)
                                                //     .pop(item
                                                //         .productName);
                                                setState(() {
                                                  if (item.productNames
                                                          .toString()
                                                          .toLowerCase() ==
                                                      "flight") {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              FlightHomePage(
                                                                data: null,
                                                                tabIndex: 1,
                                                              )),
                                                    );
                                                  } else if (item.productNames
                                                          .toString()
                                                          .toLowerCase() ==
                                                      "hotel") {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              HotelHomePage()),
                                                    );
                                                  } else if (item.productNames
                                                          .toString()
                                                          .toLowerCase() ==
                                                      "giftcard") {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                GiftCardCategory()));
                                                  } else {
                                                    affilatePartnerAPi(
                                                        item.affiliateId);
                                                  }
                                                });
                                              },
                                              child: Container(
                                                  child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8,
                                                    bottom: 8.0,
                                                    left: 8),
                                                child: TextWidget(
                                                  text: item.productNames,
                                                  size: 10,
                                                  color: blackish,
                                                ),
                                              )),
                                            ),

                                            InkWell(
                                              onTap: () {
                                                deleteIntogemspointDB(
                                                    item.productNames);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 7.0, left: 4),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Icon(
                                                    Icons.close,
                                                    color: black_color,
                                                    size: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 6,
                                            ),
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
          });
    }

    Widget eshopRecentSearch(searchHistory) {
      return FutureBuilder(
          future: searchHistory,
          builder: (context, snapshot) {
            return Container(
                child: FutureBuilder(
                    future: searchHistory,
                    builder: (context, snapshot) {
                      List data = (snapshot.data ?? []) as List;
                      if (data.isNotEmpty) {
                        isRecentData = true;
                      } else {
                        isRecentData = false;
                      }

                      if (data.isEmpty) return SizedBox();
                      return Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
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
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: blueaqua, width: 1),
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        child: Wrap(
                                          // clipBehavior: Clip.none,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  GemsGLobals.backbutton =
                                                      "true";
                                                });

                                                var search = item.productName;
                                                if (search != null &&
                                                    search != '') {
                                                  internetCall(
                                                      context,
                                                      () => Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ChangeNotifierProvider(
                                                                      create: (context) =>
                                                                          WishListCartCount(),
                                                                      child:
                                                                          ProductListView(
                                                                        catId:
                                                                            null,
                                                                        searchValue:
                                                                            search,
                                                                        categorypage:
                                                                            "yes",
                                                                      )))));
                                                }
                                              },
                                              child: Container(
                                                  child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8,
                                                    bottom: 8.0,
                                                    left: 8),
                                                child: TextWidget(
                                                  text: item.productName,
                                                  size: 10,
                                                  color: blackish,
                                                ),
                                              )),
                                            ),

                                            InkWell(
                                              onTap: () {
                                                deleteFromDB(item.productName);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 7.0, left: 4),
                                                child: Container(
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
                                                      const EdgeInsets.all(2.0),
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
          });
    }

    Widget offerRecentSearch(searchHistoryoffer) {
      return FutureBuilder(
          future: searchHistoryoffer,
          builder: (context, snapshot) {
            return Container(
                child: FutureBuilder(
                    future: searchHistoryoffer,
                    builder: (context, snapshot) {
                      List data = (snapshot.data ?? []) as List;
                      if (data.isNotEmpty) {
                        isRecentData = true;
                      } else {
                        isRecentData = false;
                      }

                      if (data.isEmpty) return SizedBox();
                      return Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
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
                                                BorderRadius.circular(20.0)),
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
                                                                        json.decode(
                                                                            item.offersearchdata)["outlet_code"],
                                                                    brandcode: json
                                                                        .decode(
                                                                            item.offersearchdata)["brand_code"],
                                                                    partnerbrandid:
                                                                        json.decode(
                                                                            item.offersearchdata)["partner_brndid"],
                                                                    catcode: json
                                                                        .decode(
                                                                            item.offersearchdata)["partner_brndid"],
                                                                    catname: json
                                                                        .decode(
                                                                            item.offersearchdata)["cat_name"],
                                                                  )));
                                                }
                                              },
                                              child: Container(
                                                  child: Padding(
                                                padding: const EdgeInsets.only(
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
                                                padding: const EdgeInsets.only(
                                                    top: 7.0, left: 4),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
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
          });
    }

    List<Widget> recentSearch() {
      List<Widget> _recentList = [];
      final searchHistoryoffer = getofferSearchHistory();
      final searchHistory = getSearchHistory();
      final searchHistorynew = getGemsPointSearchHistory();

      _recentList.add(Container(
        padding: EdgeInsets.only(bottom: 5),
        child: myController.text.length < 3 || myController.text == ""
            ? Column(
                children: [
                  isRecentData == true
                      ? Container(
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
                        )
                      : SizedBox(),
                  offerRecentSearch(searchHistoryoffer),
                  SizedBox(height: 6),
                  pointRecentData(searchHistorynew),
                  SizedBox(height: 6),
                  eshopRecentSearch(searchHistory),
                  SizedBox(height: 6),
                ],
              )
            : Container(),
      ));
      // }
      return _recentList;
    }

    List<Widget> offerCards() {
      List<Widget> _offerList = [];
      var length = offersearchdata?.length ?? 0;
      // final searchHistoryoffer = getofferSearchHistory();

      for (int i = 0; i < length; i++) {
        _offerList.add(GestureDetector(
            onTap: () {
              if (offersearchdata != null) {
                insertIntoofferDB(offersearchdata?[i].outletName ?? '',
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
                                partnerbrandid:
                                    offersearchdata?[i].partnerBrndid,
                                catcode: offersearchdata?[i].catCode ?? "",
                                catname: offersearchdata?[i].catName ?? "",
                                // subcatheading: offersearchdata?[i].catName??"",
                              ))).then((value) {
                    GemsGLobals.searchText = myController.text;

                    if (myController.text.isNotEmpty) {
                      callcommonsearchapi();
                    } else {
                      callcommonsearchapi();
                    }
                  });
                }
              }
            makesenseEventSearchResultClickedCall(GemsGLobals.offerTypeParam, offersearchdata?[i].outletName ??'', "");
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
                                side:
                                    BorderSide(width: 0.3, color: Colors.grey),
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
                                errorWidget: (context, url, error) =>
                                    Image.asset(
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
                                    if (offersearchdata?[i].outletName != null)
                                      Container(
                                        width: 160,
                                        child: RichText(
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: offersearchdata?[i]
                                                          .outletName ??
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
                                      text:
                                          offersearchdata?[i].outletArea ?? "",
                                      color: grey_color,
                                      size: text_font_small,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                offersearchdata?[i]
                                            .outletArea
                                            .toString()
                                            .toLowerCase() ==
                                        "online"
                                    ? Container(
                                        height: 0,
                                      )
                                    : (offersearchdata?[i].distance != null)
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5.0),
                                            child: TextWidget(
                                              text: offersearchdata![i]
                                                      .distance!
                                                      .toStringAsFixed(2) +
                                                  ' km',
                                              weight: FontWeight.w600,
                                              color: black_km,
                                              size: text_font_medium14_size,
                                            ),
                                          )
                                        : Container(
                                            height: 0,
                                          )
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

    Widget noResultFound() {
      return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(ImageConstants.noResultFound),
            SizedBox(
              height: 30,
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
              height: 50,
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
                      // Navigator.pop(context, "1");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (contex) => TabsScreen(
                                    initialIndex: 0,
                                  )));
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

    Widget _body() {
      print(noDataFound);
      print(myController.text.length);
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: 70),
          child: noDataFound == true && myController.text.length >= 3
              ? noResultFound()
              : Column(
                  children: [
                    offersearchdata != []
                        ? _isoffersearchloading == true
                            ? Container(
                                height: MediaQuery.of(context).size.height / 2,
                                child: Center(
                                    child: SpinKitCircle(
                                  color: btn_bg_color,
                                )),
                              )
                            : Column(children: offerCards())
                        : Container(
                            height: 0,
                          ),
                    gemsPointsSearchData != []
                        ? Container(
                            padding: EdgeInsets.only(top: 10),
                            child: _isoffersearchloading == true
                                ? Container(
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                    child: Center(
                                        child: SpinKitCircle(
                                      color: btn_bg_color,
                                    )),
                                  )
                                : Column(children: _gemspointsection()),
                          )
                        : Container(
                            height: 0,
                          ),
                    eshopSearchData != []
                        ? _isoffersearchloading == true
                            ? Container(
                                height: MediaQuery.of(context).size.height / 2,
                                child: Center(
                                    child: SpinKitCircle(
                                  color: btn_bg_color,
                                )),
                              )
                            : Column(children: eshopdataSearch())
                        // eshopdata()
                        : Container(
                            height: 0,
                          ),
                    SizedBox(height: 20)
                  ],
                ),
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
                preferredSize: Size.fromHeight(130.0),
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
                    // SizedBox(height: 20),
                    // _selectoptions(),
                    SizedBox(height: 20),
                    _searchbox(),
                  ],
                ),
              ),
              body: _isoffersearchloading == true
                  ? Container(
                      height: MediaQuery.of(context).size.height / 2,
                      child: Center(
                          child: SpinKitCircle(
                        color: btn_bg_color,
                      )),
                    )
                  : commonApiCalled == true
                      ? _body()
                      :
                      Column(children: recentSearch()),
            
              bottomNavigationBar: SizedBox(height: 95, child: _tabbar()),
            )));
  }

  @override
  void commonsearchResponseSuccess(CommonSearchModel commonSearchModel) {
    // TODO: implement commonsearchResponseSuccess
    _commonSearchModel = commonSearchModel;

    setState(() {
      commonApiCalled = true;

      if (commonSearchModel.status == true) {
        setState(() {
          _isoffersearchloading = false;
          noDataFound = false;
        });

        // _searchList();
        print(jsonEncode(commonSearchModel));
        if (commonSearchModel.searchList!.offersList!.length != 0) {
          offersearchdata = commonSearchModel.searchList!.offersList!;
          _makesenseCommonSearchApiCall(
              int.parse(offersearchdata!.length.toString()), myController.text);
            makesenseEventCall(GemsGLobals.offerText);

          gemsPointsSearchData!.clear();
          eshopSearchData!.clear();
        } else if (commonSearchModel.searchList!.gemsPointList!.length != 0) {
          gemsPointsSearchData = commonSearchModel.searchList!.gemsPointList!;
          gemsPointsData = commonSearchModel.searchList!.gemsPointList!;
          for (int i = 0; i < gemsPointsSearchData!.length; i++) {
            _choosegemsoptions.add(gemsPointsSearchData![i].affiliateName);
            _affiliateid.add(gemsPointsSearchData![i].affiliateId);
          }
          _makesenseCommonSearchApiCall(
              gemsPointsSearchData!.length, myController.text);
              makesenseEventCall(GemsGLobals.gemspointsKey);
          offersearchdata!.clear();
          eshopSearchData!.clear();
        } else if (commonSearchModel.searchList!.eshopList!.length != 0) {
          eshopSearchData = commonSearchModel.searchList!.eshopList!;
          eshopData = commonSearchModel.searchList!.eshopList!;
          for (int i = 0; i < eshopSearchData!.length; i++) {
            _eshopTitle.add(eshopSearchData![i].title);
          }
          _makesenseCommonSearchApiCall(
              eshopSearchData!.length, myController.text);
              makesenseEventCall(GemsGLobals.eshopKey);
          offersearchdata!.clear();
          gemsPointsSearchData!.clear();
        } else {}
      } else if (commonSearchModel.status == false) {
        setState(() {
          _isoffersearchloading = false;
          noDataFound = true;
        });
        makesenseEventCall("");
        _makesenseCommonSearchApiCall(0, myController.text);
      }
    });
  }

  @override
  void homesearchResponseSuccess(HomeSearchModel homesearchModel) {
  }
}
