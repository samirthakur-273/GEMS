/* Author : Sanjana Shetty
 Date created : 11 July
 Discription : Offer Listing Page */

import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gems_revamp/account/favourites/my_favourites_page.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/tabbarpage.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/offer_module/offer_detail/offer_detail.dart';
import 'package:gems_revamp/offer_module/offer_favourite/model_offerfav.dart';
import 'package:gems_revamp/offer_module/offer_favourite/presenter_offerfav.dart';
import 'package:gems_revamp/offer_module/offer_favourite/view_offerfav.dart';
import 'package:gems_revamp/offer_module/offer_list/clinks/clinks_model.dart';
import 'package:gems_revamp/offer_module/offer_list/clinks/clinks_presenter.dart';
import 'package:gems_revamp/offer_module/offer_list/clinks/clinks_view.dart';
import 'package:gems_revamp/offer_module/offer_list/databasefiles/outlet_db_helper.dart';
import 'package:gems_revamp/offer_module/offer_list/databasefiles/outlet_db_model.dart';
import 'package:gems_revamp/offer_module/offer_list/model_offerlist.dart';
import 'package:gems_revamp/offer_module/offer_list/presenter_offerlist.dart';
import 'package:gems_revamp/offer_module/offer_list/view_offerlist.dart';
import 'package:gems_revamp/offer_module/offer_search/model_offersearch.dart';
import 'package:gems_revamp/offer_module/offer_search/presenter_offersearch.dart';
import 'package:gems_revamp/offer_module/offer_search/view_offersearch.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:gems_revamp/utils/time_out.dart';
import 'package:http/http.dart' as http;

import '../../common_widget/bottombar.dart';
import '../../common_widget/font_size.dart';
import '../../utils/customloader/custome_circle_loader.dart';

class OfferListing extends StatefulWidget {
  final String? categoryCode;
  final String? categoryName;
  final String? subcatname;
  final String? subcatcode;
  final String? routetap;
  final String? categoryheading;
  final String? subseccode;
  final String? route;
  const OfferListing(
      {Key? key,
      this.categoryCode,
      this.categoryName,
      this.subcatname,
      this.subcatcode,
      this.routetap,
      this.subseccode,
      this.categoryheading,
      this.route})
      : super(key: key);
  @override
  _OfferListingState createState() => _OfferListingState();
}

class _OfferListingState extends State<OfferListing>
    implements OfferListView, OfferFavouriteView, OfferSearchView, ClinksView {
  OfferList corpcarddata = OfferList();
  OfferListPresenter? _offerlistpresenter;
  OfferList? _outlistModel;
  bool _isofferlistloader = true;
  List<SubcatList> _subCategoryList = [];
  List<EmirateList> _emirateList = [];
  List<Outletlist> _outletList = [];
  List newlist = [];
  int outletListLength = 0;
  final myController = TextEditingController();
  List finalCuisinestext = [];
  List finalCuisinestextname = [];
  List finalEmiratestext = [];
  List finalEmiratestextname = [];
  List<bool>? _isCuisineChecked;
  List<bool>? _isEmiratesChecked;
  OfferFavPresenter? _offerfavpresenter;
  bool _isfavloader = false;
  bool checksorting = false;
  ScrollController _scrollController = ScrollController(initialScrollOffset: 0);
  double? _scrollPosition = 0.0;
  int totalength = 0;
  String sortby = "km";
  int current = 0;
  OfferSearchPresenter? _offersearchpresenter;
  ClinksPresenter? _clinksPresenter;
  bool statusBarChanged = false;
  bool getvalue = false;
  bool filteringsubcat = false;
  bool filteringemirate = false;
  bool filteringsubemirate = false;
  int _radioSelected = 1;
  int listType = 1;
  String _radioVal = 'isClink';
  bool clink = true;
  bool _selectClink = false;
  var iconContainerHeight = 50.00;
  String? clinkType = '';
  var choiceClink = '';

  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      bool isTop = _scrollController.position.pixels == 0;
      if (widget.subcatname == null) {
        if (isTop) {
        } else {
          if (totalength == 100) {
            _isofferlistloader = true;
            _isCuisineChecked = null;
            _isEmiratesChecked = null;
            getmoredata(sortby, finalCuisinestext, finalEmiratestext);
            if (!_scrollController.hasClients) {
              final position = _scrollController.position.minScrollExtent;
              Timer(Duration(milliseconds: 1), () {
                _scrollController.jumpTo(position);
              });
            }
          }
        }
      }
    }
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (iconContainerHeight != 0)
        setState(() {
          iconContainerHeight = 0;
        });
    }
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (iconContainerHeight == 0)
        setState(() {
          iconContainerHeight = 50;
        });
    }
  }

  @override
  void initState() {
    super.initState();
    // _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    _offerlistpresenter = OfferListPresenter(this);
    _offerfavpresenter = OfferFavPresenter(this);
    _offersearchpresenter = OfferSearchPresenter(this);
    _clinksPresenter = ClinksPresenter(this);

    if (statusBarChanged == false &&
        widget.routetap == "viewmore" &&
        widget.subcatcode != null) {
      if (widget.subcatname != null) {
        finalCuisinestext.add(widget.subcatcode);
        finalCuisinestextname.add(widget.subcatname);
        offerlistapi("km", finalCuisinestext, finalEmiratestext);

        statusBarChanged = true;
      }
    } else {
      if (widget.categoryName == 'Groceries') {
        offerlistapi("seq", "", "");
      } else {
        offerlistapi("km", "", "");
      }
    }
    makesenseEventCall();
    GemsGLobals.lastVisitPageName = GemsGLobals.offerListingPage;
  }

  makesenseEventCall() {
    String keyName = GemsGLobals.eventOfferlistingscreenViewed;
    var segmentReq = {
      GemsGLobals.offerCategoryParam: widget.categoryName,
      GemsGLobals.offerSubCategoryParam: widget.subcatname,
      GemsGLobals.intSource: GemsGLobals.lastVisitPageName
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void offerlistapi(sortby, subcatcode, emiratecode) {
    print(GemsGLobals.lat);
    var request = {
      "customer_id": GemsGLobals.membershipNo,
      "lat": GemsGLobals.lat,
      "long": GemsGLobals.long,
      "search_text": "",
      "sortby": sortby,
      "category_code":
          widget.categoryCode == "seemore" ? "" : widget.categoryCode,
      "limit": 100,
      "offset": 0,
      "subcategory_codes": subcatcode.length >= 1 ? subcatcode : "",
      "city_codes": emiratecode.length >= 1 ? emiratecode : "",
      "isclink": listType == 2? true : false,
      "user_type": GemsGLobals.userType
    };
    setState(() {
      if (sortby == "az") {
        checksorting = true;
      } else {
        checksorting = false;
      }
    });
    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _offerlistpresenter!.offerListAPI(request);
      } else {
        bool connectionResult = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (connectionResult == null) {
          Navigator.pop(context);
        }
        if (connectionResult) {
          setState(() {});
          _offerlistpresenter!.offerListAPI(request);
        }
      }
    });
  }

  void getmoredata(sortby, subcatcode, emiratecode) {
    current = current + 100;
    var request = {
      "customer_id": GemsGLobals.membershipNo,
      "lat": GemsGLobals.lat,
      "long": GemsGLobals.long,
      "search_text": "",
      "sortby": sortby,
      "category_code":
          widget.categoryCode == "seemore" ? "" : widget.categoryCode,
      "subcategory_codes": subcatcode.length >= 1 ? subcatcode : "",
      "city_codes": emiratecode.length >= 1 ? emiratecode : "",
      "limit": 100,
      "offset": current,
      "user_type": GemsGLobals.userType
    };
    setState(() {
      iconContainerHeight = 50.0;
      if (sortby == "az") {
        checksorting = true;
      } else {
        checksorting = false;
      }
    });
    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _offerlistpresenter!.offerListAPI(request);
      } else {
        bool connectionResult = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (connectionResult == null) {
          Navigator.pop(context);
        }
        if (connectionResult) {
          setState(() {});
          _offerlistpresenter!.offerListAPI(request);
        }
      }
    });
  }

  void addClinkApi(isClink) {
    var request = {
      "is_clink": isClink,
      "customer_id": GemsGLobals.membershipNo
    };
    _clinksPresenter!.clinkAPI(request);
  }

  Widget _appBar() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(gradient: gradient_theme_color),
          alignment: Alignment.topLeft,
          height: 94,
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
                  onTap: () {
                    // showModalBottomSheet<dynamic>(
                    //     isScrollControlled: true,
                    //     context: context,
                    //     backgroundColor: Colors.transparent,
                    //     builder: (BuildContext bc) {
                    //       return OfferSearchPage(
                    //           catcode: widget.categoryCode,
                    //           catname: widget.categoryName);
                    //     });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 3, top: 50),
                    child: _searchBox(),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Container(child: _choiceBox()),
        // Container(
        //     child: Padding(
        //   padding: const EdgeInsets.only(top: 15.0, left: 20),
        //   child: Row(
        //     children: [
        //       TextWidget(
        //           text: widget.categoryName! + " Offers",
        //           color: Colors.brown,
        //           weight: FontWeight.bold,
        //           size: text_font_medium15_size),
        //     ],
        //   ),
        // )),
      ],
    );
  }

  void _choiceclick(type) {
    showModalBottomSheet(
        barrierColor: Colors.black.withOpacity(0.7),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Stack(children: [
              _openCuisinefilterbox(setState, type),
            ]);
          });
        });
  }

  Widget _choiceBox() {
    return iconContainerHeight == 0
        ? Container(
            height: 0,
          )
        : Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 10),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          if (!_isofferlistloader) {
                            _choiceclick(widget.categoryName);
                          }
                        });
                      },
                      child: _sortlist("Cuisine")),
                  if (_emirateList.length > 0) SizedBox(width: 25),
                  if (_emirateList.length > 0)
                    widget.subseccode.toString().toLowerCase() ==
                                "onlineshop" ||
                            widget.subseccode.toString().toLowerCase() ==
                                "delivery"
                        ? Container(
                            height: 0,
                          )
                        : widget.categoryName == 'Groceries'
                            ? Container(
                                height: 0,
                              )
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (!_isofferlistloader) {
                                      _choiceclick("Emirates");
                                    }
                                  });
                                },
                                child: _sortlist("Emirates")),
                  widget.subseccode.toString().toLowerCase() == "onlineshop" ||
                          widget.subseccode.toString().toLowerCase() ==
                              "delivery"
                      ? Container(
                          height: 0,
                        )
                      : SizedBox(width: 25),
                  widget.subseccode.toString().toLowerCase() == "onlineshop" ||
                          widget.subseccode.toString().toLowerCase() ==
                              "delivery"
                      ? Container(
                          height: 0,
                        )
                      : _nearest(),
                  widget.subseccode.toString().toLowerCase() == "onlineshop" ||
                          widget.subseccode.toString().toLowerCase() ==
                              "delivery"
                      ? SizedBox(width: 0)
                      : SizedBox(width: 25),
                  // _atoZ(),
                  // SizedBox(width: 10),
                  _favourite()
                ],
              ),
            ),
          );
  }

  _isselected(text) {
    if (text == "Emirates" && (finalEmiratestext.length > 0)) {
      return city_color;
    } else if (text == "Cuisine" && (finalCuisinestext.length > 0)) {
      return subcat_color;
    } else {
      return white_color;
    }
  }

  _getSelectedCount(text) {
    if (text == "Emirates" && (finalEmiratestext.length > 0)) {
      return ' (${finalEmiratestext.length})';
    } else if (text == "Cuisine" && (finalCuisinestext.length > 0)) {
      return ' (${finalCuisinestext.length})';
    } else {
      return '';
    }
  }

  _getSelectedTextcolor(text) {
    if (text == "Emirates" && (finalEmiratestext.length > 0)) {
      return white_color;
    } else if (text == "Cuisine" && (finalCuisinestext.length > 0)) {
      return white_color;
    } else {
      return purchase_text_color;
    }
  }

  Widget _sortlist(text) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        decoration: BoxDecoration(
          color: _isselected(text),
          border: Border.all(color: common_gray_color, width: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 5),
              child: TextWidget(
                text: text == "Emirates"
                    ? "Cities${(_getSelectedCount(text))}"
                    : '${(widget.categoryheading != null ? widget.categoryheading! : _subCategoryList[0].altcatname != null ? _subCategoryList[0].altcatname : "")}${(_getSelectedCount(text))}',
                color: _getSelectedTextcolor(text),
                weight: FontWeight.w500,
                // size: widget.categoryName == "Automotive" ? 12 : 13
                size: text_font_size_x_small,
              ),
            ),
            SvgPicture.asset(ImageConstants.downarrow,
                color: _getSelectedTextcolor(text), width: 12),
            SizedBox(
              width: 7,
            )
          ],
        ),
      ),
    );
  }

  Widget _nearest() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isofferlistloader = true;
            if (sortby != 'km') {
              sortby = "km";
              offerlistapi("km", finalCuisinestext, finalEmiratestext);
            } else {
              sortby = '';
              offerlistapi("", finalCuisinestext, finalEmiratestext);
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: sortby == "km" ? nearest_color : white_color,
            border: Border.all(color: common_gray_color, width: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
            child: TextWidget(
                text: "Nearest",
                color: sortby == "km" ? white_color : blackshade,
                weight: FontWeight.w500,
                // size: widget.categoryName == "Automotive" ? 12 : 13,
                size: text_font_size_x_small),
          ),
        ),
      ),
    );
  }

  Widget _favourite() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, right: 10),
      child: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyFavourites()));
          },
          // child: Container(
          //   decoration: BoxDecoration(
          //     color: common_gray_color,
          //     border: Border.all(color: common_gray_color, width: 0.5),
          //     borderRadius: BorderRadius.circular(10),
          //   ),
          //   child: Padding(
          //     padding:
          //         const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          //     child: TextWidget(
          //       text: "Favorites",
          //       // text:""
          //       color: blackshade,
          //       weight: FontWeight.w600,
          //       size: 12,
          //     ),
          //   ),
          // ),
          child: SvgPicture.asset(
            ImageConstants.offerfavicon,
            // color: white_color,
            // height: 20,
          )),
    );
  }

  Widget _atoZ() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isofferlistloader = true;
            OutletDBHelper().truncateTable();
            if (sortby != "az") {
              offerlistapi("az", finalCuisinestext, finalEmiratestext);
              sortby = "az";
            } else {
              offerlistapi("", finalCuisinestext, finalEmiratestext);
              sortby = "";
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: sortby == "az" ? atoz_color : white_color,
            border: Border.all(color: common_gray_color, width: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 5, bottom: 5, left: 14, right: 14),
            child: TextWidget(
              text: "A-Z",
              weight: FontWeight.bold,
              color: sortby == "az" ? white_color : const Color(0xff3d384d),
              // size: widget.categoryName == "Automotive" ? 12 : 13,
              size: text_font_size_x_small,
            ),
          ),
        ),
      ),
    );
  }

  void calloffersearchapi(text) {
    var request = {
      "limit": "",
      "offset": "",
      "searchtext": text,
      "customer_id": GemsGLobals.membershipNo ?? "12",
      "lat": GemsGLobals.lat,
      "long": GemsGLobals.long,
      "user_type": GemsGLobals.userType ?? "all",
      "category_code": widget.categoryCode
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
        _isofferlistloader = true;
        _outletList.clear();

        calloffersearchapi(myController.text);
      });
    } else if (myController.text.length == 0) {
      setState(() {
        _isofferlistloader = false;
        _outletList.clear();
        offerlistapi("km", "", "");
      });
    }
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
                color: Colors.white.withOpacity(0.3),
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
                  // Expanded(
                  //   child: TextField(
                  //     controller: myController,
                  //     enabled: false,
                  //     style: TextStyle(color: Colors.white),
                  //     // onChanged: onSearchPressed,
                  //     decoration: InputDecoration(
                  //         border: InputBorder.none,
                  //         hintText: "Type to search",
                  //         hintStyle: TextStyle(
                  //             color: white_color,
                  //             fontSize: text_font_medium16_size,
                  //             fontWeight: FontWeight.w500),
                  //         contentPadding: EdgeInsets.only(left: 0, bottom: 8)),
                  //   ),
                  // ),
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
                  if (myController.text.length >= 3)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          myController.text = "";
                          _isofferlistloader = true;
                          offerlistapi("km", "", "");
                        });
                      },
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 10.0, top: 5, bottom: 5),
                            child: Icon(
                              Icons.close,
                              color: white10_color,
                              size: 16,
                            ),
                          )),
                    ),
                ],
              ),
            ),
          ),

          // GestureDetector(
          //   onTap: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => MyFavourites()));
          //   },
          //   child: Container(
          //       margin: EdgeInsets.only(left: 13, right: 15),
          //       height: 40,
          //       width: 40,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(8),
          //         color: Colors.blue[400],
          //       ),
          //       child: Icon(
          //         Icons.favorite,
          //         color: white_color,
          //         size: 30,
          //       )),
          // ),
        ],
      ),
    );
  }

  void callofferfavapi(brandcode, outletcode, catcode, fav) {
    // setState(() {
    //   _isfavloader = true;
    // });
    var request = {
      "customer_id": GemsGLobals.membershipNo,
      "lat": GemsGLobals.lat,
      "long": GemsGLobals.long,
      "brand_code": brandcode,
      "outlet_code": outletcode,
      "isFav": fav == 0 ? 1 : 0,
      "category_code": catcode,
      "sortby": sortby,
    };

    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _offerfavpresenter!.offerFavAPI(request);
      } else {
        bool connectionResult = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (connectionResult == null) {
          Navigator.pop(context);
        }
        if (connectionResult) {
          setState(() {});
          _offerfavpresenter!.offerFavAPI(request);
        }
      }
    });
  }

  Widget _offertabs() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
          decoration: BoxDecoration(
              color: white_color,
              border: Border.all(color: grey_color, width: 0.3),
              borderRadius: BorderRadius.circular(30)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      listType = 1;
                      _isCuisineChecked =
                          List<bool>.filled(_subCategoryList.length, false);
                      finalCuisinestext.clear();
                      _isEmiratesChecked =
                          List<bool>.filled(_emirateList.length, false);
                      finalEmiratestext.clear();
                      _isofferlistloader = true;
                      filteringsubcat = false;
                      filteringemirate = false;
                      filteringsubemirate = false;
                      offerlistapi("km", "", "");
                    });
                  },
                  child: Material(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: listType == 1 ? blue_color : white_color,
                          borderRadius: listType == 1
                              ? BorderRadius.circular(30.0)
                              : BorderRadius.only(
                                  bottomLeft: const Radius.circular(30.0),
                                  topLeft: const Radius.circular(30.0),
                                )),
                      child: AbsorbPointer(
                        child: TextWidget(
                          text: "All Offers",
                          color: listType == 1 ? white_color : black_color,
                          weight: FontWeight.w500,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      listType = 2;
                      // if (type == widget.categoryName) {
                      _isCuisineChecked =
                          List<bool>.filled(_subCategoryList.length, false);
                      finalCuisinestext.clear();
                      // } else {
                      _isEmiratesChecked =
                          List<bool>.filled(_emirateList.length, false);
                      finalEmiratestext.clear();
                      // }
                      _isofferlistloader = true;
                      filteringsubcat = false;
                      filteringemirate = false;
                      filteringsubemirate = false;
                      var request = {
                        "customer_id": GemsGLobals.membershipNo,
                        "lat": GemsGLobals.lat,
                        "long": GemsGLobals.long,
                        "search_text": "",
                        "sortby": sortby,
                        "category_code": widget.categoryCode == "seemore"
                            ? ""
                            : widget.categoryCode,
                        "limit": 100,
                        "offset": 0,
                        "subcategory_codes": "",
                        "city_codes": "",
                        "isclink": true,
                        "user_type": GemsGLobals.userType
                      };
                      _offerlistpresenter!.offerListAPI(request);
                    });
                  },
                  child: Material(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: listType == 2 ? blue_color : white_color,
                          borderRadius: listType == 2
                              ? BorderRadius.circular(30.0)
                              : BorderRadius.only(
                                  bottomRight: const Radius.circular(30.0),
                                  topRight: const Radius.circular(30.0),
                                )),
                      child: AbsorbPointer(
                        child: TextWidget(
                          text: "Clink",
                          color: listType == 2 ? white_color : black_color,
                          weight: FontWeight.w500,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _clinkOffers() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: clinkType == "1"
          ? _body()
          : Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        ImageConstants.clinkImg,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.3, color: Colors.grey),
                        borderRadius: BorderRadius.circular(7)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Radio(
                          value: 1,
                          groupValue: _radioSelected,
                          activeColor: blue_color,
                          onChanged: (value) {
                            setState(() {
                              _radioSelected = value as int;
                              _radioVal = 'isClink';
                            });
                          },
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                _radioSelected = 1;
                                _radioVal = 'isClink';
                              });
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: TextWidget(
                                  text:
                                      'I confirm I am legal drinking age in the GCC & non-Muslim',
                                  size: text_font_medium14_size,
                                ))),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.3, color: Colors.grey),
                        borderRadius: BorderRadius.circular(7)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Radio(
                          value: 2,
                          groupValue: _radioSelected,
                          activeColor: blue_color,
                          onChanged: (value) {
                            setState(() {
                              _radioSelected = value as int;
                              _radioVal = 'dontClink';
                            });
                          },
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                _radioSelected = 2;
                                _radioVal = 'dontClink';
                              });
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: TextWidget(
                                  text: 'I do not want Clink but thanks anyway',
                                  size: text_font_medium14_size,
                                )))
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: GestureDetector(
                      onTap: () {
                        if (_radioSelected == 1 || _radioSelected == 2) {
                          setState(() {
                            addClinkApi(true);
                            _selectClink = true;
                            if (_radioSelected == 1) {
                              clinkType = '1';
                              GemsGLobals.clinkType = '1';
                              _isofferlistloader = true;
                              var request = {
                                "customer_id": GemsGLobals.membershipNo,
                                "lat": GemsGLobals.lat,
                                "long": GemsGLobals.long,
                                "search_text": "",
                                "sortby": sortby,
                                "category_code":
                                    widget.categoryCode == "seemore"
                                        ? ""
                                        : widget.categoryCode,
                                "limit": 100,
                                "offset": 0,
                                "subcategory_codes": "",
                                "city_codes": "",
                                "isclink": true,
                                "user_type": GemsGLobals.userType
                              };
                              _offerlistpresenter!.offerListAPI(request);
                            } else {
                              _selectClink = true;
                              clinkType = '2';
                              GemsGLobals.clinkType = '2';
                              _isofferlistloader = true;
                              var request = {
                                "customer_id": GemsGLobals.membershipNo,
                                "lat": GemsGLobals.lat,
                                "long": GemsGLobals.long,
                                "search_text": "",
                                "sortby": sortby,
                                "category_code":
                                    widget.categoryCode == "seemore"
                                        ? ""
                                        : widget.categoryCode,
                                "limit": 100,
                                "offset": 0,
                                "subcategory_codes": "",
                                "city_codes": "",
                                "isclink": false,
                                "user_type": GemsGLobals.userType
                              };
                              // setState(() {

                              _offerlistpresenter!.offerListAPI(request);
                              addClinkApi(false);
                            }
                          });
                        } else {}
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        height: 45,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xff0ba1d6),
                              borderRadius: BorderRadius.circular(7)),
                          alignment: Alignment.center,
                          child: TextWidget(
                            text: "SUBMIT",
                            color: white_text_color,
                            size: 20,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  List<Widget> _offerCards() {
    List<Widget> _offerList = [];
    for (int i = 0; i < _outletList.length; i++) {
      _offerList.add(GestureDetector(
        onTap: () {       
          var data = Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OfferDetail(
                        // offerdetail: _outletList[i],
                        outletcode: _outletList[i].outletCode,
                        brandcode: _outletList[i].brandCode,
                        partnerbrandid: _outletList[i].partnerBrndid,
                        catcode: widget.categoryCode,
                        catname: widget.categoryName != null
                            ? widget.categoryName!
                            : _subCategoryList[0].catName != null
                                ? _subCategoryList[0].catName!
                                : "",
                        subcatheading: widget.categoryheading != null
                            ? widget.categoryheading!
                            : _subCategoryList[0].altcatname != null
                                ? _subCategoryList[0].altcatname
                                : "",
                      ))).then((value) {
            setState(() {
              iconContainerHeight = 50.0;
              _isofferlistloader = true;
            });
            OutletDBHelper().truncateTable();
            if (myController.text != "") {
              calloffersearchapi(myController.text);
            } else {
              if (widget.categoryName == 'Groceries') {
                offerlistapi("seq", "", "");
              } else {
                offerlistapi(sortby, finalCuisinestext, finalEmiratestext);
              }
            }
          });
        },
        child: Container(
          child: Column(children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
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
                            imageUrl: _outletList[i].brandLogo.toString(),
                            width: MediaQuery.of(context).size.width,
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
                                Container(
                                  width: 170,
                                  child: RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text:
                                                _outletList[i].outletname ?? '',
                                            style: TextStyle(
                                                fontSize: text_font_small,
                                                color: black_km,
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            //   _star = !_star;
                                            OutletDBHelper().truncateTable();
                                            getvalue = true;
                                            callofferfavapi(
                                                _outletList[i].brandCode,
                                                _outletList[i].outletCode,
                                                widget.categoryCode,
                                                _outletList[i].isFav);
                                            if (_outletList[i].isFav == 1) {
                                              _outletList[i].isFav = 0;
                                            } else {
                                              _outletList[i].isFav = 1;
                                            }
                                            showMessage(
                                                context,
                                                _outletList[i].isFav == 1
                                                    ? "Offer moved in favorite list."
                                                    : "Offer removed from favorite list.");
                                          });
                                        },
                                        child: _outletList[i].isFav == 1
                                            ? Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  // boxShadow: [
                                                  //   BoxShadow(
                                                  //       blurRadius: 4.0,
                                                  //       color: Colors.grey)
                                                  // ],
                                                  border: Border.all(
                                                      width: 0.3,
                                                      color: Colors.grey),
                                                  color: white_color,
                                                ),
                                                child: Icon(
                                                  Icons.favorite,
                                                  color: theme_color,
                                                  size: 15,
                                                ),
                                              )
                                            : Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: white_color,
                                                  border: Border.all(
                                                      width: 0.3,
                                                      color: Colors.grey),
                                                ),
                                                child: Icon(
                                                  Icons.favorite_border,
                                                  color: theme_color,
                                                  size: 15,
                                                ),
                                              )),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            if (_outletList[i].offerTitle != null)
                              Container(
                                child: TextWidget(
                                    text: _outletList[i].offerTitle!.trim() ==
                                            'Multiple Offers'
                                        ? 'Multiple Offers'
                                        : _outletList[i].offerTitle.toString(),
                                    // + " % Off",
                                    // maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    size: text_font_size_small,
                                    color: pink_color,
                                    weight: FontWeight.bold),
                              ),
                            if (_outletList[i].outletArea != null)
                              Container(
                                child: TextWidget(
                                  text: _outletList[i].outletArea,
                                  color: grey_color,
                                  size: text_font_small,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            _outletList[i]
                                            .outletArea
                                            .toString()
                                            .toLowerCase() !=
                                        "online" &&
                                    _outletList[i].outletArea.toString() != ""
                                ? _outletList[i].distance != null
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5.0),
                                        child: TextWidget(
                                          text: _outletList[i]
                                                  .distance!
                                                  .toStringAsFixed(2) +
                                              " km",
                                          weight: FontWeight.w600,
                                          color: black_km,
                                          size: text_font_medium14_size,
                                        ),
                                      )
                                    : Container(
                                        height: 0,
                                      )
                                : Container(
                                    height: 0,
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

  _getfilter(Widget child) {
    if (_scrollController.hasClients == true) {
      if (_scrollController.position.extentBefore > 4.0 && getvalue == false) {
        setState(() {
          getvalue = false;
        });
        return child;
      } else {
        return child;
      }
    }

    return child;
  }

  Widget _getAllselectedSubcat() {
    return Row(children: [
      finalCuisinestext.length > 0
          ? iconContainerHeight != 0
              ? Column(
                  children: [
                    Row(
                        children:
                            _getselectedFilter(widget.categoryName, setState)),
                    SizedBox(
                      height: 4,
                    )
                  ],
                )
              : Container()
          : Container(),
      finalEmiratestext.length > 0
          ? iconContainerHeight != 0
              ? Column(
                  children: [
                    Row(children: _getselectedFilter('Emirates', setState)),
                    SizedBox(
                      height: 4,
                    )
                  ],
                )
              : Container()
          : Container(),
    ]);
  }

  Widget _body() {
    return Container(
      height: widget.categoryName == 'Dine'
          ? MediaQuery.of(context).size.height / 1.3
          : MediaQuery.of(context).size.height,
      child: _isofferlistloader
          ? Center(
              child: SpinKitCircle(
                color: btn_bg_color,
              ),
            )
          : Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_outletList.isNotEmpty && !_isofferlistloader)
                        AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          // height: iconContainerHeight,
                          // color: red_color,
                          child: _getfilter(Container(child: _choiceBox())),
                        ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        // color: red_color,
                        child: _getfilter(
                          Container(
                            padding: EdgeInsets.fromLTRB(15, 15, 8, 5),
                            width: MediaQuery.of(context).size.width,
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: _getAllselectedSubcat()),
                          ),
                        ),
                      ),
                      Expanded(
                        // height: MediaQuery.of(context).size.height / 2,
                        child:
                            ListView(controller: _scrollController, children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _outletList.length == 0 && !_isofferlistloader
                                    ? Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            SvgPicture.asset(
                                                ImageConstants.noResultFound),
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
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  gradient:
                                                      const LinearGradient(
                                                    begin: Alignment.topRight,
                                                    end: Alignment.bottomLeft,
                                                    colors: [
                                                      bluishgradient,
                                                      blue_color,
                                                    ],
                                                  )),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.2,
                                              height: 50,
                                              child: TextButton(
                                                child: TextWidget(
                                                  text: "Try Again",
                                                  color: white_text_color,
                                                  size: 20,
                                                ),
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  // Internetconnectivity()
                                                  //     .isConnected()
                                                  //     .then((result) {
                                                  //   if (result &&
                                                  //       (myController
                                                  //               .text.length ==
                                                  //           0)) {
                                                  //     finalCuisinestext = [];
                                                  //     finalEmiratestext = [];
                                                  //     _isCuisineChecked = null;
                                                  //     _isEmiratesChecked = null;
                                                  //     changeOutletList(
                                                  //         finalCuisinestext,
                                                  //         finalEmiratestext);
                                                  //     offerlistapi(
                                                  //         "km", "", "");
                                                  //   }
                                                  // });
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              height: 50,
                                            )
                                          ],
                                        ),
                                      )
                                    // Container(
                                    //     padding: EdgeInsets.only(top: 150),
                                    //     child: TextWidget(
                                    //       text: 'No offers found',
                                    //       size: text_font_medium18_size,
                                    //       weight: FontWeight.w500,
                                    //     ))
                                    : Column(
                                        children: [
                                          _getfilter(
                                            Container(
                                                child: Container(
                                              padding: const EdgeInsets.only(
                                                  top: 0.0, left: 20),
                                              child: Row(
                                                children: [
                                                  TextWidget(
                                                      // text: widget.categoryName! +
                                                      //     " Offers",
                                                      text: widget.categoryName !=
                                                              null
                                                          ? widget.categoryName! +
                                                              " Offers"
                                                          : _subCategoryList[0]
                                                                      .catName !=
                                                                  null
                                                              ? _subCategoryList[
                                                                          0]
                                                                      .catName! +
                                                                  " Offers"
                                                              : "",
                                                      color: Colors.brown,
                                                      weight: FontWeight.bold,
                                                      size:
                                                          text_font_medium15_size),
                                                ],
                                              ),
                                            )),
                                          ),
                                          Column(
                                            children: _offerCards(),
                                          )
                                        ],
                                      )
                              ]),
                        ]),
                      ),
                    ],
                  ),
                ),
                _isfavloader == true
                    ? Center(
                        child: SpinKitCircle(
                          color: btn_bg_color,
                        ),
                      )
                    : Container()
              ],
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

/* *************Filter Code ***************** */

  _getselectedFilter(type, setState) {
    List<Widget> list = [];

    int length = 0;
    if (type == widget.categoryName) {
      length = finalCuisinestext.length;
    } else if (type == "Emirates") {
      length = finalEmiratestext.length;
    }
    for (int i = 0; i < length; i++) {
      list.add(Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: type == "Emirates" ? offercity_color : offersubcat_color,
        ),
        child: Row(
          children: [
            TextWidget(
              text: type == "Emirates"
                  // ? finalEmiratestext[i]
                  ? finalEmiratestextname[i]
                  // : finalCuisinestext[i],
                  : finalCuisinestextname[i],
              size: text_font_size_small,
              weight: FontWeight.w500,
            ),
            GestureDetector(
              onTap: type == "Emirates"
                  ? () {
                      if (finalEmiratestext.contains(finalEmiratestext[i]) ==
                          true) {
                        setState(() {
                          _emirateList.forEach((element) {
                            int index = _emirateList.indexOf(element);
                            if (element.emirateCode == finalEmiratestext[i]) {
                              _isEmiratesChecked![index] = false;
                            }
                          });

                          finalEmiratestext.remove(finalEmiratestext[i]);
                          finalEmiratestextname
                              .remove(finalEmiratestextname[i]);
                        });
                      }
                      changeOutletList(finalCuisinestext, finalEmiratestext);
                    }
                  : () {
                      if (finalCuisinestext.contains(finalCuisinestext[i]) ==
                          true) {
                        setState(() {
                          _subCategoryList.forEach((element) {
                            int cuisineindex =
                                _subCategoryList.indexOf(element);
                            if (element.subcatCode == finalCuisinestext[i]) {
                              _isCuisineChecked![cuisineindex] = false;
                            }
                          });
                          finalCuisinestext.remove(finalCuisinestext[i]);
                          finalCuisinestextname
                              .remove(finalCuisinestextname[i]);
                        });
                      }
                      // finalCuisinestext.remove(finalCuisinestext[i]);
                      // _isCuisineChecked![i] = !_isCuisineChecked![i];
                      // if (_isCuisineChecked![i] == true) {
                      //   if (!finalCuisinestext
                      //       .contains(_subCategoryList[i].subcatName)) {
                      //     finalCuisinestext.add(_subCategoryList[i].subcatName);
                      //   }
                      // } else {
                      //   finalCuisinestext.remove(_subCategoryList[i].subcatName);
                      // }
                      changeOutletList(finalCuisinestext, finalEmiratestext);
                    },
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Icon(
                  Icons.close,
                  color: black_color,
                  size: 14,
                ),
              ),
            )
          ],
        ),
      ));
    }
    return list;
  }

  Widget _openCuisinefilterbox(setState, type) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _aboveheader(),
          Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 1.6,
                decoration: BoxDecoration(
                    color: white_color,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(10),
                      topRight: const Radius.circular(10),
                    )),
                child: Column(children: [
                  _heading(type),
                  Divider(),
                  SizedBox(height: 5),
                  if (type == widget.categoryName)
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 2, 8, 8),
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _getselectedFilter(type, setState),
                          )),
                    ),
                  if (type == widget.categoryName)
                    Expanded(
                      child: SingleChildScrollView(
                        child:
                            Column(children: _filterCuisineoptions(setState)),
                      ),
                    ),
                  if (type == "Emirates")
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 2, 8, 8),
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _getselectedFilter(type, setState),
                          )),
                    ),
                  if (type == "Emirates")
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _filterEmiratesoptions(setState),
                        ),
                      ),
                    ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _clearAll(setState, type),
                      _applybutton(setState, type),
                    ],
                  )
                ]),
              ))
        ],
      ),
    );
  }

  Widget _aboveheader() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 30),
      child: Container(
        height: 55,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    // _isCuisineChecked =
                    //     List<bool>.filled(_subCategoryList.length, false);
                    // finalCuisinestext.clear();
                    // _isEmiratesChecked =
                    //     List<bool>.filled(_emirateList.length, false);
                    // finalEmiratestext.clear();
                    // if(finalCuisinestext.length == 0 || finalEmiratestext.length == 0){
                    //   changeOutletList(finalCuisinestext, finalEmiratestext);
                    // }

                    Navigator.pop(context);
                  });
                },
                child: SvgPicture.asset(
                  ImageConstants.cross,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heading(type) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 10),
      child: Row(
        children: [
          TextWidget(
            text: type == widget.categoryName
                ? widget.categoryheading != null
                    ? widget.categoryheading!
                    : _subCategoryList[0].altcatname != null
                        ? _subCategoryList[0].altcatname
                        : ""
                : "Cities",
            weight: FontWeight.bold,
            size: text_font_medium_x_size,
          ),
        ],
      ),
    );
  }

  List<Widget> _filterCuisineoptions(setState) {
    List<Widget> _roomList = [];
    for (int i = 0; i < _subCategoryList.length; i++) {
      _roomList.add(GestureDetector(
        onTap: () {
          setState(() {
            _isCuisineChecked![i] = !_isCuisineChecked![i];
            if (_isCuisineChecked![i] == true) {
              if (!finalCuisinestext.contains(_subCategoryList[i].subcatCode)) {
                finalCuisinestext.add(_subCategoryList[i].subcatCode);
                finalCuisinestextname.add(_subCategoryList[i].subcatName);
              }
            } else {
              finalCuisinestext.remove(_subCategoryList[i].subcatCode);
              finalCuisinestextname.remove(_subCategoryList[i].subcatName);
            }
          });
        },
        child: Container(
          color: transColor,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 10, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: _isCuisineChecked![i]
                            ? Color.fromRGBO(242, 242, 242, 1)
                            : transColor,
                      ),
                      child: TextWidget(
                          color: _isCuisineChecked![i]
                              ? black_color
                              : grey_gunsmoke_text_color,
                          text: _subCategoryList[i].subcatName.toString())),
                  // _isCuisineChecked![i]
                  //     ? Container(
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(2.0),
                  //           color: pink_color,
                  //         ),
                  //         child: Padding(
                  //           padding: const EdgeInsets.only(
                  //               left: 2.0, right: 2, top: 3, bottom: 3),
                  //           child: SvgPicture.asset(
                  //             ImageConstants.checkboxtick,
                  //             height: 12,
                  //             width: 12,
                  //           ),
                  //         ),
                  //       )
                  //     : SvgPicture.asset(
                  //         ImageConstants.checkboxuntick,
                  //         height: 20,
                  //       ),
                ],
              ),
            ),
            if (_subCategoryList.length - 1 == i) Divider(),
          ]),
        ),
      ));
    }
    return _roomList;
  }

  List<Widget> _filterEmiratesoptions(setState) {
    List<Widget> _roomList = [];
    for (int i = 0; i < _emirateList.length; i++) {
      _roomList.add(GestureDetector(
        onTap: () {
          setState(() {
            _isEmiratesChecked![i] = !_isEmiratesChecked![i];
            if (_isEmiratesChecked![i] == true) {
              if (!finalEmiratestext.contains(_emirateList[i].emirateCode)) {
                finalEmiratestext.add(_emirateList[i].emirateCode);
                finalEmiratestextname.add(_emirateList[i].emirateName);
              }
            } else {
              finalEmiratestext.remove(_emirateList[i].emirateCode);
              finalEmiratestextname.remove(_emirateList[i].emirateName);
            }
          });
        },
        child: Container(
          color: transColor,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: _isEmiratesChecked![i]
                          ? Color.fromRGBO(242, 242, 242, 1)
                          : transColor,
                    ),
                    child: TextWidget(
                        color: _isEmiratesChecked![i]
                            ? black_color
                            : grey_gunsmoke_text_color,
                        text: _emirateList[i].emirateName.toString()),
                  ),
                  // _isEmiratesChecked![i]
                  //     ? Container(
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(2.0),
                  //           color: pink_color,
                  //         ),
                  //         child: Padding(
                  //           padding: const EdgeInsets.only(
                  //               left: 2.0, right: 2, top: 3, bottom: 3),
                  //           child: SvgPicture.asset(
                  //             ImageConstants.checkboxtick,
                  //             height: 12,
                  //             width: 12,
                  //           ),
                  //         ),
                  //       )
                  //     : SvgPicture.asset(
                  //         ImageConstants.checkboxuntick,
                  //         height: 20,
                  //       ),
                ],
              ),
            ),
            if (_emirateList.length - 1 == i) Divider(),
          ]),
        ),
      ));
    }

    return _roomList;
  }

  Widget _applybutton(setState, type) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 10),
      child: Container(
        width: 190,
        child: ElevatedButton(
          onPressed: () async {
            changeOutletList(finalCuisinestext, finalEmiratestext);
            Navigator.pop(context);
          },
          style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            textStyle:
                WidgetStateProperty.all(TextStyle(color: Color(0xffffffff))),
            backgroundColor: WidgetStateProperty.all(boxgreencolor),
            minimumSize: WidgetStateProperty.all(Size(0, 0)),
            padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 25.0, right: 25, top: 10, bottom: 10),
            child: TextWidget(
              text: "Apply",
              color: white_color,
              size: text_font_medium16_size,
              weight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _clearAll(setState, type) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (type == widget.categoryName) {
              _isCuisineChecked =
                  List<bool>.filled(_subCategoryList.length, false);
              finalCuisinestext.clear();
            } else {
              _isEmiratesChecked =
                  List<bool>.filled(_emirateList.length, false);
              finalEmiratestext.clear();
            }
          });
        },
        child: Container(
          child: TextWidget(
            text: "Clear all",
            color: pink_color,
            weight: FontWeight.bold,
          ),
        ),
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
          child: PopScope(
            canPop: true,
            onPopInvoked: (canPop) async {
              if (widget.route == GemsGLobals.pushNotificationRouteType) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => TabsScreen(
                              initialIndex: 0,
                            )));
              }
              return Future.value(false);
            },
            child: Scaffold(
              extendBody: true,
              backgroundColor: Colors.grey[200],
              appBar: PreferredSize(
                preferredSize: Platform.isIOS
                    ? Size.fromHeight(80.0)
                    : Size.fromHeight(65.0),
                child: _appBar(),
              ),
              body: widget.categoryName == 'Dine' || clinkType == '2'
                  ? clinkType == '2'
                      ? _body()
                      : Column(
                          children: [
                            _isofferlistloader
                                ? Container(
                                    height: 0,
                                  )
                                : _offertabs(),
                            listType == 2 ? _clinkOffers() : _body(),
                          ],
                        )
                  : _body(),
              bottomNavigationBar:  SizedBox(height: 95, child: _tabbar()),
            ),
            )));
  }

  @override
  void offerlistFailure(error) {
    if (error == "timeout") {
      setState(() {
        _isofferlistloader = false;
      });
    }
  }

  List<Outletlist> removeDuplicateOutlet(List<Outletlist> outletList) {
    List<Outletlist> newList = [];
    List<Outletlist> dupList = [];
    newList.addAll(outletList);
    for (int i = 0; i < outletList.length; i++) {
      for (int j = i + 1; j < outletList.length; j++) {
        if (outletList[i].brandCode!.trim() ==
            outletList[j].brandCode!.trim()) {
          dupList.add(outletList[j]);
        }
      }
      if (dupList.contains(outletList[i])) {
        dupList.add(outletList[i]);
        for (int x = 1; x < dupList.length; x++) {
          newList.remove(dupList[x]);
        }
      }
    }
    return newList;
  }

  changeOutletList(finalCuisinestext, finalEmiratestext) {
    var subCategoryCode;
    var emirateCode;
    if (finalCuisinestext.length < 1 && finalEmiratestext.length < 1) {
      subCategoryCode = 'All';
      _outletList.clear();
      _isofferlistloader = true;
      Future.delayed(Duration(milliseconds: 50), () {
        setState(() {
          filteringsubcat = false;
          filteringemirate = false;
          filteringsubemirate = false;
          offerlistapi(sortby, finalCuisinestext, finalEmiratestext);
        });
      }).then((value) {
        setState(() {
          outletListLength = _outletList.length;
        });
      });
    } else if (finalCuisinestext.length >= 1 && finalEmiratestext.length < 1) {
      subCategoryCode = finalCuisinestext;
      _outletList.clear();
      _isofferlistloader = true;
      Future.delayed(Duration(milliseconds: 20), () {
        setState(() {
          filteringsubcat = true;
          filteringemirate = false;
          filteringsubemirate = false;
          offerlistapi(sortby, finalCuisinestext, "");
        });
      }).then((value) {});
    } else if (finalCuisinestext.length < 1 && finalEmiratestext.length >= 1) {
      emirateCode = finalEmiratestext;
      _outletList.clear();
      _isofferlistloader = true;
      Future.delayed(Duration(milliseconds: 20), () {
        setState(() {
          filteringsubcat = false;
          filteringemirate = true;
          filteringsubemirate = false;
          offerlistapi(sortby, "", finalEmiratestext);
        });
      }).then((value) {});
    } else if (finalCuisinestext.length >= 1 && finalEmiratestext.length >= 1) {
      subCategoryCode = finalCuisinestext;
      emirateCode = finalEmiratestext;

      _outletList.clear();
      _isofferlistloader = true;
      Future.delayed(Duration(milliseconds: 20), () {
        setState(() {
          filteringsubcat = false;
          filteringemirate = false;
          filteringsubemirate = true;
          offerlistapi(sortby, finalCuisinestext, finalEmiratestext);
        });
      }).then((value) {});
    } else {
      subCategoryCode = 'All';
      _outletList.clear();
      _isofferlistloader = true;
      Future.delayed(Duration(milliseconds: 50), () {
        setState(() {
          _outletList
              .addAll(_outlistModel!.values!.outletlist!.where((element) {
            if (element.category != null) {
              if (element.category!.isNotEmpty) {
                return element.category?.first.catCode == widget.categoryCode;
              } else {
                return false;
              }
            }
            return false;
          }));
          _isofferlistloader = false;
        });
      }).then((value) {
        setState(() {
          outletListLength = _outletList.length;
        });
      });
    }
  }

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      margin: EdgeInsets.only(bottom: 30, left: 20, right: 20),
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1),
    ));
  }

  Future<List<OutletDBModel>> getOutletDB() {
    var data = OutletDBHelper().getOutletListData();
    return data;
  }

  @override
  void offerlistResponseSuccess(OfferList offerlistModel) {
    setState(() {
      if (offerlistModel.values != null) {
        totalength = offerlistModel.values!.outletFound!;
        clinkType = GemsGLobals.clinkType == ''
            ? offerlistModel.values!.isClink
            : GemsGLobals.clinkType;
      } else {
        totalength = 0;
      }
      if (offerlistModel.status == true) {
        _outlistModel = offerlistModel;
        _subCategoryList.clear();
        _emirateList.clear();

        _subCategoryList.addAll(_outlistModel!.values!.subcatList!
            .where((element) => element.catCode == widget.categoryCode));
        _emirateList.addAll(_outlistModel!.values!.emirateList!
            .where((element) => element.catCode == widget.categoryCode));

        if (_isCuisineChecked == null) {
          _isCuisineChecked = List<bool>.filled(_subCategoryList.length, false);
        }

        if (_isEmiratesChecked == null) {
          _isEmiratesChecked = List<bool>.filled(_emirateList.length, false);
        }
        if (statusBarChanged == false && widget.routetap == "viewmore") {
          if (widget.subcatname != null) {
            finalCuisinestext.add(widget.subcatcode);
            finalCuisinestextname.add(widget.subcatname);
            for (int i = 0; i < _subCategoryList.length; i++) {
              if (_subCategoryList[i]
                  .subcatCode!
                  .contains(widget.subcatcode!)) {
                _isCuisineChecked![i] = true;
              }
            }
            statusBarChanged = true;
          }
        }
        if (filteringsubcat == true) {
          _outletList.clear();
          _outletList
              .addAll(_outlistModel!.values!.outletlist!.where((element) {
            if (element.subcategory != null) {
              if (element.subcategory!.isNotEmpty) {
                return element.category?.first.catCode == widget.categoryCode &&
                    finalCuisinestext.any((item) =>
                        item == element.subcategory!.first.subcatCode!);
              } else {
                return false;
              }
            }
            return false;
          }));

          _isofferlistloader = false;
        } else if (filteringemirate == true) {
          _outletList.clear();
          _outletList
              .addAll(_outlistModel!.values!.outletlist!.where((element) {
            if (element.category != null) {
              return element.category?.first.catCode == widget.categoryCode &&
                  finalEmiratestext
                      .any((item) => item == element.emirateCode.toString());
            }
            return false;
          }));
          _isofferlistloader = false;
        } else if (filteringsubemirate == true) {
          _outletList.clear();
          _outletList
              .addAll(_outlistModel!.values!.outletlist!.where((element) {
            if (element.subcategory != null) {
              if (element.subcategory!.isNotEmpty) {
                return element.category?.first.catCode == widget.categoryCode &&
                    finalCuisinestext.any((item) =>
                        item == element.subcategory!.first.subcatCode!) &&
                    finalEmiratestext
                        .any((item) => item == element.emirateCode.toString());
              } else if (element.subcategory!.isEmpty) {
                return element.category?.first.catCode == widget.categoryCode &&
                    finalEmiratestext
                        .any((item) => item == element.emirateCode.toString());
              } else {
                return false;
              }
            }
            return false;
          }));
          _isofferlistloader = false;
        } else {
          _outletList.clear();
          // changeOutletList(finalCuisinestext, finalEmiratestext);
          _outletList
              .addAll(_outlistModel!.values!.outletlist!.where((element) {
            if (element.category != null) {
              if (element.category!.isNotEmpty) {
                return element.category?.first.catCode == widget.categoryCode;
              } else {
                return false;
              }
            }
            return false;
          }));
          _isofferlistloader = false;
        }
      } else {
        _isofferlistloader = false;
      }
    });
  }

  @override
  void timeOutError(String error) async {
    if (error == "timeout") {
      setState(() {
        _isofferlistloader = false;
      });
      bool isRetry = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => TimeOut()));
      if (isRetry && isRetry != null) {
        offerlistapi("km", "", "");
      }
    }
  }

  @override
  void offerfavResponseSuccess(OfferFavouriteModel offerfavModel) {
    if (offerfavModel.status == true) {
      // showMessage(context, offerfavModel.message ?? '');
      // offerlistapi(sortby);
    }
    setState(() {
      _isfavloader = false;
    });
  }

  @override
  void getcorpcardFailure(error) {
    setState(() {
      _isofferlistloader = false;
    });
  }

  @override
  void offersearchResponseSuccess(OfferSearchModel offersearchModel) {
    setState(() {
      if (offersearchModel.status == true) {
        setState(() {
          _isofferlistloader = false;
          _outletList.clear();
          totalength = 0;
          _outletList.addAll(offersearchModel.values!.offerslist!);
        });
      } else {
        setState(() {
          _isofferlistloader = false;
          _outletList.clear();
        });
      }
    });
  }

  @override
  void clinksFailure(error) {
    // TODO: implement clinksFailure
  }

  @override
  void clinksSuccess(ClinksDetailModel clinksDetailModel) {
    setState(() {
      if (clinksDetailModel.status == true) {
        setState(() {
          _isofferlistloader = false;
          Fluttertoast.showToast(
              msg: clinksDetailModel.message.toString(),
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Color(0xAA000000),
              textColor: white_text_color,
              gravity: ToastGravity.BOTTOM);
        });
      } else {
        setState(() {
          _isofferlistloader = false;
        });
      }
    });
  }
}
