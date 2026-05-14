import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_destination/database/database.dart';
import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_destination/hotel_desti_model.dart';
import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_destination/hotel_desti_presenter.dart';
import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_destination/hotel_desti_view.dart';
import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_destination/hotel_popular_searh_city_db/popularcity_helper.dart';
import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_destination/hotel_popular_searh_city_db/popularcitydb_model.dart';
import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_destination/popular_city_model.dart';
import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_guest.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:gems_revamp/utils/time_out.dart';
import 'package:intl/intl.dart';

class HotelDestination extends StatefulWidget {
  @override
  State<HotelDestination> createState() => _HotelDestinationState();
}

class _HotelDestinationState extends State<HotelDestination>
    implements AutoSuggestHotelView {
  late List<dynamic> recentSearchList = [];
  late AutoSuggestHotelPresenter _autoSuggestHotelPresenter;
  List popularCity = [];
  List<bool> recentBoolList = [];
  bool isPopularLoading = true,
      isPopular = false,
      isSuggestedLoading = false,
      isSuggest = false,
      isDataNotFound = false;
  late DateTime startDateTime, endDateTime;
  late String checkInDate, checkOutDate;
  RoomModel rmodel = RoomModel();
  final dbHelper = DatabaseHelper.instance;
  List<Suggestion> listSuggest = List.empty(growable: true);
  var noConnection;

  TextEditingController _searchtext = TextEditingController();
  String txt = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _autoSuggestHotelPresenter = AutoSuggestHotelPresenter(this);
    getAllRecentSearchFromDB();
    getPopularCityList();
    // getAllRecentSearch();
  }

  void getPopularCityList() {
    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _autoSuggestHotelPresenter.getpopularCity();
      } else {
        noConnection = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (noConnection != null) {
          getPopularCityList();
        }
      }
    });
  }

  void _searchListdata(searchtext) async {
    setState(() {
      if (_searchtext.text.length >= 2) {
        Internetconnectivity().isConnected().then((result) async {
          if (result) {
            _autoSuggestHotelPresenter.autoSuggest(_searchtext.text);
          } else {
            noConnection = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => NoInternet()));
            if (noConnection != null) {
              getPopularCityList();
            }
          }
        });

        isSuggest = true;
      }
    });
  }

  void getAllRecentSearchFromDB() async {
    List allRows = await dbHelper.getHotelRecentSearch();

    setState(() {
      recentSearchList = allRows;
      for (int i = 0; i < recentSearchList.length; i++) {
        recentBoolList.add(false);
      }
      if (recentSearchList.length > 0) {
        startDateTime = DateTime.parse(recentSearchList[0]["checkindate"]);
        endDateTime = DateTime.parse(recentSearchList[0]["checkoutdate"]);
        if (startDateTime.isBefore(new DateTime.now())) {
          startDateTime = new DateTime.now();
          endDateTime = new DateTime.now().add(Duration(days: 1));
        }
      }
      rmodel.roomList.add(GuestModel(1, 0));
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _searchBar() {
      return Container(
          height: 50,
          decoration: BoxDecoration(
            color: white_text_color,
            border: Border.all(width: 0.3, color: grey_gunsmoke_text_color),
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.4,
                child: TextField(
                  autofocus: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.only(top: 10, left: 3, bottom: 11),
                    hintText: "CITY / AREA / HOTEL NAME",
                    hintStyle: TextStyle(
                        color: black_color.withAlpha((0.3 * 255).toInt()),
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  controller: _searchtext,
                  style: TextStyle(
                      color: Color(0xff949494),
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  onChanged: (searchtext) {
                    setState(() {
                      if (searchtext.length >= 2) {
                        _searchListdata(searchtext);
                        isPopular = false;
                        isSuggestedLoading = true;
                        isSuggest = true;
                      } else {
                        listSuggest.clear();
                        isSuggest = false;
                        isPopular = true;
                        isSuggestedLoading = false;
                      }
                    });
                  },
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isPopular = true;
                    isSuggest = false;
                    _searchtext.text = '';
                  });
                },
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(2.0, 5, 2, 2),
                    child: _searchtext.text.length < 2
                        ? SvgPicture.asset(
                            ImageConstants.searchicon,
                            height: 18,
                          )
                        : Icon(
                            Icons.clear,
                            color: grey600_color,
                            size: 18,
                          )),
              ),
            ],
          ));
    }

    Widget hotelListSuggest(List<Suggestion> listData) {
      return listData.length > 0
          ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
              itemCount: listData.length > 0 ? listData.length : 0,
              itemBuilder: (context, index) {
                var _city = [];

                _city = listData[index].searchText!.split(",");
                

                return GestureDetector(
                  onTap: () {
                    Navigator.pop(
                        context,
                        Suggestion(
                            destinationId: listData[index].destinationId,
                            searchType: listData[index].searchType,
                            searchText: listData[index].searchText,
                            count: listData[index].count,
                            destType: listData[index].destType));
                  },
                  child: Container(
                    color: transColor,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: blue_color,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Wrap(
                            children: <Widget>[
                              TextWidget(
                                text: _city[0],
                                color: black_color,
                                weight: FontWeight.w600,
                                size: 14,
                              ),
                              TextWidget(
                                text: ", " + _city[1],
                                color: Color(0xff888b8d),
                                weight: FontWeight.w500,
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              })
          : isDataNotFound
              ? Container(
                  child: Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: TextWidget(
                          text: "No records found",
                          weight: FontWeight.w700,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ))
              : Container();
    }

    /* get Adult */
    _getAdultdata(adult) {
      if (adult == '1') {
        return ", $adult Adult";
      } else {
        return ", $adult Adults";
      }
    }

/* get child */
    _getChildData(child) {
      if (child != '0') {
        if (child == '1') {
          return ", $child Child";
        } else {
          return ", $child Children";
        }
      } else {
        return "";
      }
    }

    /* get Guest data */
    _getGuestData(checkin, checkout, adult, child) {
      if (adult != null && child != null) {
        return (DateFormat("dd MMM yyyy").format(DateTime.parse(checkin))) +
            ' - ' +
            (DateFormat("dd MMM yyyy").format(DateTime.parse(checkout))) +
            _getAdultdata(adult) +
            _getChildData(child);
      } else {
        return '';
      }
    }

    Widget hotelRecentSearch() {
      // return recentSearchList == null
      //     ? Container(
      //         child: Center(
      //           child: TextWidget(text: "No Recent Search"),
      //         ),
      //       ):
      return recentSearchList.length != 0
          ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
              itemCount: recentSearchList.length,
              shrinkWrap: true,
              itemBuilder: (context, i) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(
                              context,
                              Suggestion(
                                  destinationId: int.parse(
                                      recentSearchList[i]["destination_id"]),
                                  searchType: int.parse(
                                      recentSearchList[i]["searchType"]),
                                  searchText:
                                      recentSearchList[i]["searchText"] ?? '',
                                  count:
                                      int.parse(recentSearchList[i]["guests"]),
                                  destType: recentSearchList[i]
                                      ["destinationType"]),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                ImageConstants.pinMarkerIcon,
                                // AppAssets.htl_map,
                                height: 20,
                                color: blue_color,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 90,
                                    child: Wrap(
                                      children: <Widget>[
                                        TextWidget(
                                          text:
                                              "${((recentSearchList[i]["city"].toString().split(',').length) > 0 ? recentSearchList[i]["city"].toString().split(',')[0] : recentSearchList[i]["city"].toString())}",
                                          size: text_font_medium14_size,
                                          weight: FontWeight.bold,
                                          color: black_color,
                                        ),
                                        TextWidget(
                                          text: ((recentSearchList[i]["city"]
                                                      .toString()
                                                      .split(',')
                                                      .length) >
                                                  1)
                                              ? ", ${(recentSearchList[i]["city"].toString().split(',')[1])}"
                                              : '',
                                          size: text_font_medium14_size,
                                          weight: FontWeight.w600,
                                          color: black_color,
                                        ),
                                        TextWidget(
                                          text: ((recentSearchList[i]["city"]
                                                      .toString()
                                                      .split(',')
                                                      .length) >
                                                  2)
                                              ? ", ${(recentSearchList[i]["city"].toString().split(',')[2])}"
                                              : '',
                                          size: text_font_medium14_size,
                                          weight: FontWeight.w600,
                                          color: black_color,
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextWidget(
                                    text: _getGuestData(
                                        recentSearchList[i]["checkindate"],
                                        recentSearchList[i]["checkoutdate"],
                                        recentSearchList[i]["adult"],
                                        recentSearchList[i]["child"]),
                                    size: text_font_size_x_small,
                                    weight: FontWeight.w500,
                                    color: Colors.grey[800],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              })
          : Container(
              child: Center(
                child: TextWidget(text: "No Recent Search"),
              ),
            );
    }

     List<Widget> _popularlist() {
    List<Widget> _popList = [];
    for (int i = 0; i < popularCity.length; i++) {
      _popList.add(Container(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(
                          context,
                          Suggestion(
                            destinationId: int.parse(
                                popularCity[i].destinationId.toString()),
                            searchType: popularCity[i].searchType,
                            searchText: popularCity[i].searchText ?? '',
                            count: popularCity[i].count ?? 0,
                            destType: popularCity[i].destType ?? '',
                          ));
                    },
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: blue_color,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text.rich(
                                    TextSpan(
                                      children: <TextSpan>[
                                        new TextSpan(
                                          text:
                                              '${popularCity[i].searchText}',
                                          style: new TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: black_color,
                                            fontSize: text_font_medium14_size,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider()
                      ],
                    ),
                  ),
                ));
    }
    return _popList;
  }

 


    Widget hotelListPopular(popularCity) {
      return popularCity.length > 0
          ?
          Column(children: _popularlist())
          //  ListView.builder(
          //     itemCount: popularCity.length,
          //     itemBuilder: (context, index) {
          //       return Container(
          //         child: InkWell(
          //           onTap: () {
          //             Navigator.pop(
          //                 context,
          //                 Suggestion(
          //                   destinationId: int.parse(
          //                       popularCity[index].destinationId.toString()),
          //                   searchType: popularCity[index].searchType,
          //                   searchText: popularCity[index].searchText ?? '',
          //                   count: popularCity[index].count ?? 0,
          //                   destType: popularCity[index].destType ?? '',
          //                 ));
          //           },
          //           child: Column(
          //             children: <Widget>[
          //               Padding(
          //                 padding: const EdgeInsets.symmetric(vertical: 10),
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.start,
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Icon(
          //                       Icons.location_on,
          //                       color: blue_color,
          //                     ),
          //                     SizedBox(
          //                       width: 10,
          //                     ),
          //                     new Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: <Widget>[
          //                         Text.rich(
          //                           TextSpan(
          //                             children: <TextSpan>[
          //                               new TextSpan(
          //                                 text:
          //                                     '${popularCity[index].searchText}',
          //                                 style: new TextStyle(
          //                                   fontWeight: FontWeight.w700,
          //                                   color: black_color,
          //                                   fontSize: text_font_medium14_size,
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               Divider()
          //             ],
          //           ),
          //         ),
          //       );
          //     })
          : Container(
              child: Center(
                child: TextWidget(text: "Popular not available"),
              ),
            );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.0),
        child: GradientAppBar(
          title: "Select Destination",
          color: white_text_color,
          size: 18,
          weight: FontWeight.w500,
          centerTitle: true,
          height: 90,
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(height: 15),
          _searchBar(),
          Padding(
              padding: EdgeInsets.fromLTRB(15, 9, 15, 15),
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              isSuggest == true
                  ? Container()
                  : recentSearchList.length != 0
                      ? Container(
                        // height: 200,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextWidget(
                                text: "RECENT SEARCHES",
                                size: text_font_medium16_size,
                                color: Colors.black87,
                                weight: FontWeight.w600,
                              ),
                              SizedBox(height: 5),
                              Divider(),
                              hotelRecentSearch()
                            ],
                          ),
                      )
                      : Container(
                          height: 0,
                        ),
              isSuggest == true
                  ? Container(height: 500, child: hotelListSuggest(listSuggest))
                  : Container(),
              SizedBox(
                height: 10,
              ),
              isPopularLoading == true
                  ? SpinKitCircle(
                      color: blue_color,
                    )
                  : isPopular
                      ? SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextWidget(
                                text: "POPULAR DESTINATION",
                                size: text_font_medium16_size,
                                color: Colors.black87,
                                weight: FontWeight.w600,
                              ),
                              SizedBox(height: 5),
                              Divider(),
                            ],
                          ),
                      )
                      : Container(),
              isPopular
                  ? Container (height: 500, child: hotelListPopular(popularCity))
                  : Container()
            ],
              ),
            )
          ],
        ),
      // ),
    );
  }

  @override
  void allErr(error) {
    // TODO: implement allErr
  }

  @override
  Future<void> autosuggestList(
      AutoSuggestHotelModel autoSuggestHotelModel) async {
    setState(() {
      isSuggestedLoading = false;
      listSuggest.clear();
    });
    final _suggestion = autoSuggestHotelModel.values?.suggestion ?? [];
    if (autoSuggestHotelModel.status == true) {
      if (_suggestion.length > 0) {
        setState(() {
          isSuggest = true;
          isDataNotFound = false;
          listSuggest.addAll(_suggestion);
        });
      } else {
        setState(() {
          isSuggest = true;
          isDataNotFound = true;
          isSuggestedLoading = false;
        });
      }
    } else if (autoSuggestHotelModel.status == false) {
      setState(() {
        isSuggest = false;
      });
      if (autoSuggestHotelModel.message == "timeout") {
        var notresponding = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => TimeOut()));
        if (notresponding != null) {
          _searchListdata(_searchtext.text);
        } else {
          Navigator.pop(context);
        }
      }
    }
  }

  Future<List<PopularCityListDbModel>> getpopularCityListdb() {
    var data = HotelPopularCityListDBHelper().getpopularCityListData();

    return data;
  }

  @override
  void cityResponse(PopularCityHotelModel popularCityHotelModel) {
    popularCity = popularCityHotelModel.values!.data!;
    setState(() {
      if (popularCityHotelModel.status == true) {
        isPopular = true;
        isPopularLoading = false;
        getpopularCityListdb().then((value) async {
          if (value.length < 1) {
            return HotelPopularCityListDBHelper().save(PopularCityListDbModel(
                null, json.encode(popularCityHotelModel.toJson())));
          }
        });
      }
    });
  }
}
