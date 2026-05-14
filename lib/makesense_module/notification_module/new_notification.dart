import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/no_fount_notif.dart';
import 'package:gems_revamp/common_widget/tabbarpage.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/tab_bar_page.dart';
import 'package:gems_revamp/flight_module/flighthomepage.dart';
import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_homepage.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/makesense_module/notification_module/notification_cache.dart';
import 'package:gems_revamp/makesense_module/notification_module/notification_list_model.dart';
import 'package:gems_revamp/makesense_module/notification_module/notification_list_presenter.dart';
import 'package:gems_revamp/makesense_module/notification_module/notification_list_view.dart';
import 'package:gems_revamp/offer_module/offer_detail/offer_detail.dart';
import 'package:gems_revamp/offer_module/offer_list/offer_list.dart';
import 'package:gems_revamp/point_conversion/airmiles_module/airtogems_module/airmilestogems.dart';
import 'package:gems_revamp/point_conversion/airmiles_module/gemtoair_module/gemstoairmiles.dart';
import 'package:gems_revamp/point_conversion/smiles_module/check_status.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/constants_files/styles_constants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class NewNotificationPage extends StatefulWidget {
  const NewNotificationPage({Key? key}) : super(key: key);

  @override
  State<NewNotificationPage> createState() => _NewNotificationPageState();
}

class _NewNotificationPageState extends State<NewNotificationPage>
    implements NotificationListView {
  bool _isLoading = true;
  // final dbHelper = DatabaseHelper.instance;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late List? _notificationList = [];

  var currrentTimestamp;
  var _noConnection;

  var _request;
  int _unReadNoticount = 0;
  var _nullNotification;
  NotificationListPresenter? _notificationListPresenter;

  @override
  void initState() {
    _isLoading = true;

    Internetconnectivity().isConnected().then((isConnected) async {
      if (isConnected == true) {
        _isLoading = true;
        getNotificationData();
        setState(() {
          readNotificationApicall("");
          GemsGLobals.totalunreadnotifications = 0;
        });
      } else {
        _noConnection = await Navigator.of(context).pushNamed('noInternetpage');
        if (_noConnection != null) {
          _isLoading = true;
          getNotificationData();
        }
      }
    });
    GemsGLobals.lastVisitPageName = GemsGLobals.notificationPage;
    super.initState();
  }

  makesenseEventNotificationCenterViewedCall() {
    String keyName = GemsGLobals.eventNotificationCenterViewed;
    var segmentReq = {
      GemsGLobals.notificationsNoParam: GemsGLobals.notificationCount,
      GemsGLobals.notificationsReadParam:
          GemsGLobals.totalReadNotificationsCount,
      GemsGLobals.notificationsUnreadParam: GemsGLobals.totalunreadnotifications,
      GemsGLobals.intSource: GemsGLobals.lastVisitPageName
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

   makesenseEventNotificationClickedCall(type,name,url,campaignId) {
    String keyName = GemsGLobals.eventNotificationClicked;
      var segmentReq = {
      'notification_type': type,
      'notification_name':name,
      'notification_url': url,
      'campaign_id': campaignId,
      'int_source': GemsGLobals.lastVisitPageName
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  /* Get cache Notification data*/
  getNotificationData() {
    NotificationCache()
        .getNotificationCacheData('notificationData')
        .then((getHomeData) {
      if (getHomeData.toString() == null.toString()) {
        setState(() {
          // _isLoading = false;
          NotificationCache().notificationSaveCache(
              jsonEncode(_nullNotification), 'notificationData');
          _notificationApiCall();
        });
      } else {
        setState(() {
          _isLoading = false;
          var _notificationData = jsonDecode(getHomeData);
          _notificationList = _notificationData;
        });
      }
    }).catchError((onError) {
      _notificationApiCall();
    });
  }

  _notificationApiCall() async {
    DateFormat dateFormat = DateFormat("yyyy-MM-ddHH:mm:ss");
    setState(() {
      _isLoading = true;
    });
    _notificationListPresenter = NotificationListPresenter(this);

    _notificationListPresenter!
        .notificationListApiCall();
  }

  setSyncTime(date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var date1 = prefs.getString('notificationSyncDate');

    var dddd = prefs.setString('notificationSyncDate', '${date.toString()}');
  }

  _launchURL(url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<Null> _refresh() async {
    setState(() {
      Internetconnectivity().isConnected().then((isConnected) async {
        if (isConnected) {
          setState(() {
            _notificationApiCall();
          });
        } else {}
      });
    });
  }

  readNotificationApicall(notificationid) {
    MakesenseApiConfig.readnotificationApi(http.Client(), notificationid)
        .then((resp) async {
      // if (resp['status'] == true) {
      //   _notifocationApiCall();
      // } else {}
    }).catchError((onError) {});
  }

  deleteNotificationApicall(request) {
    Internetconnectivity().isConnected().then((isConnected) async {
      if (isConnected == true) {
        MakesenseApiConfig.deletenotificationAp(http.Client(), request)
            .then((resp) async {
          if (resp['status'] == true) {
            _notificationApiCall();
          } else {
            if (resp['message'] == 'timeout') {
              setState(() {
                _isLoading = false;
              });
              var notresponding =
                  await Navigator.of(context).pushNamed('/timeoutpage');
              if (notresponding != null) {
                deleteNotificationApicall(_request);
              } else {
                Navigator.pop(context);
              }
              _isLoading = false;
            } else {
              setState(() {
                _isLoading = false;
              });
            }
          }
        }).catchError((onError) {});
      } else {
        _noConnection = await Navigator.of(context).pushNamed('noInternetpage');
        if (_noConnection != null) {
          deleteNotificationApicall(request);
        }
      }
    });
  }

  void _notificationRouting(index) async {
    print(jsonEncode(_notificationList![index]));
    if (_notificationList![index].deepLinking == 'internal') {
      makesenseEventNotificationClickedCall(GemsGLobals.inApp,_notificationList![index].campaignName??'', _notificationList![index].internalLink ??'',_notificationList![index].campaignId ??'');
      if (_notificationList![index].internalLink.toString().contains("/")) {
        var urlroute =
            _notificationList![index].internalLink.toString().split("/");

        switch (urlroute[0]) {
          case 'offer_listing_page':
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OfferListing(
                          categoryCode: urlroute[1],
                          //  categoryName: "All"
                        )));
            break;

          case "offer_details_page":
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OfferDetail(
                          fromNotif: true,
                          catcode: urlroute[1],
                          brandcode: urlroute[2],
                          outletcode: urlroute[3],
                          partnerbrandid: urlroute[4] == "undefined" ||
                                  urlroute[4] == "null"
                              ? null
                              : urlroute[4],
                        )));
            break;

          case "air_miles":
            if (urlroute[1] == "gems_to_airmiles") {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GemsToAimiles()));
            } else {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AimilesToGems()));
            }
            break;

          case 'hotel_booking':
            _notificationList![index].selectedCityHotel == "undefined"
                ? await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HotelHomePage()))
                : await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HotelHomePage(
                            stayCityNotif:
                                _notificationList![index].selectedCityHotel,
                            destiId: urlroute[1],
                            route: "notification")));
            break;

          case 'flight_booking':
            _notificationList![index].selectedCitySrc == "undefined" ||
                    _notificationList![index].selectedCityDst == "undefined"
                ? await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (contex) => FlightHomePage(
                              tabIndex: 0,
                            )))
                : await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FlightHomePage(
                              route: "notification",
                              sourceCity:
                                  _notificationList![index].selectedCitySrc,
                              destinationCity:
                                  _notificationList![index].selectedCityDst,
                              srcCity: _notificationList![index]
                                  .selectedCitySrcCitynameInapp,
                              destiCity: _notificationList![index]
                                  .selectedCityDestCitynameInapp,
                              srcCode: urlroute[1],
                              destiCode: urlroute[2],
                              tabIndex: 0,
                            )));
            break;
        }
      } else if (_notificationList![index].internalLink == null) {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NoResultFoundNotification()));
      } else {
        switch (
            _notificationList![index].internalModule.toString().toLowerCase()) {
          case 'smiles':
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => CheckStatus()));
            break;

          case 'shop':
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShopTabBarPage(
                          index: 0,
                          tabIndex: 0,
                        )));
            break;

          case 'homepage':
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TabsScreen(
                          initialIndex: 0,
                        )));
            break;

          default:
            TabsScreen(
              initialIndex: 0,
            );
        }
      }
    } else {
      if (_notificationList![index].externalLink != null) {
        makesenseEventNotificationClickedCall(GemsGLobals.inApp,_notificationList![index].campaignName??'', _notificationList![index].externalLink??'',_notificationList![index].campaignId ??'');
        _launchURL(_notificationList![index].externalLink);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget stackBehindDismiss() {
      return Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0, top: 5, bottom: 5),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      );
    }

    Widget _notificationUi(index) {
      return Card(
          margin: EdgeInsets.only(bottom: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          color:
              // _notificationList![index].isRead == 0
              //     ? blue_color:
              Color(0XFFf2f7f9),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              color: _notificationList![index].isRead == 0
                  ? white_text_color
                  : Color(0XFFf2f7f9),
            ),
            margin: EdgeInsets.only(
              left: 5,
            ),
            padding: EdgeInsets.only(right: 5),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _notificationList![index].logo != ""
                        ? Container(
                            width: 60,
                            height: 60,
                            padding: EdgeInsets.all(5),
                            // color:
                            // green_color,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                  errorWidget: (context, url, error) {
                                    return Image.asset(
                                        ImageConstants.gems_placeholder,
                                        fit: BoxFit.fill);
                                  },
                                  placeholder: (context, url) {
                                    return Image.asset(
                                      ImageConstants.gems_placeholder,
                                      fit: BoxFit.fill,
                                    );
                                  },
                                  fit: BoxFit.fill,
                                  imageUrl: _notificationList![index].logo),
                            ))
                        : Container(
                            width: 0,
                          ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment:
                          //     MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  // width: MediaQuery.,
                                  child: TextWidget(
                                    text: "${_notificationList![index].title}",
                                    // maxLines: 1,
                                    color: Colors.black,
                                    weight: FontWeight.w500,
                                    // softwrap: true,
                                    // overflow: TextOverflow.ellipsis,
                                    size: text_font_medium16_size,
                                  ),
                                ),
                                TextWidget(
                                    text: dateformate(
                                            "${_notificationList![index].timestamp}") +
                                        " ",
                                    color:
                                        // _notificationList![index].isRead == 0
                                        //     ? blue_color:
                                        dark_grey,
                                    weight: FontWeight.w500,
                                    size: text_font_x_small),
                                // _notificationList![index].isRead == 0
                                // ? Icon(Icons.circle,
                                //     color: blue_color, size: 8) :
                                //   Container(
                                //   width: 0,
                                // )
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: TextWidget(
                                text: _notificationList![index].body,
                                color:
                                    // _notificationList![index].isRead == 0
                                    //     ? black_color :
                                    common_grey_text_color,
                                weight: FontWeight.w400,
                                size: text_font_medium14_size,
                                // softwrap: true,
                                // maxLines: 3,
                                // overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                _notificationList![index].banner != ""
                    ? Container(
                        padding: EdgeInsets.all(5),
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        // height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: _notificationList![index].banner,
                            errorWidget: (context, url, error) {
                              return Image.asset(
                                  ImageConstants.gems_placeholder,
                                  fit: BoxFit.fill);
                            },
                            placeholder: (context, url) {
                              return Image.asset(
                                ImageConstants.gems_placeholder,
                                fit: BoxFit.fill,
                              );
                            },
                          ),
                        ))
                    : Container(
                        height: 0,
                      )
              ],
            ),
          ));
    }

    clearNotification() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child: Container(
                margin: EdgeInsets.only(top: 25, left: 15, right: 15),
                height: 120,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: TextWidget(
                        text:
                            'Do you really want to delete these records? This process cannot be undone.',
                        size: 12,
                        weight: FontWeight.bold,
                        alignment: TextAlign.center,
                        color: Colors.grey[700]!,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 22),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            height: 30,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.0,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(3)),
                            child: MaterialButton(
                              child: TextWidget(
                                  text: 'No',
                                  alignment: TextAlign.center,
                                  size: 12,
                                  weight: FontWeight.bold),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                          ),
                          Container(
                            height: 30,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.0,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(3)),
                            child: MaterialButton(
                              child: TextWidget(
                                  text: 'Yes',
                                  alignment: TextAlign.center,
                                  size: 12,
                                  weight: FontWeight.bold),
                              onPressed: () async {
                                setState(() {
                                  _notificationList!.clear();

                                  NotificationCache().notificationSaveCache(
                                      jsonEncode(_nullNotification),
                                      'notificationData');
                                  GemsGLobals.totalunreadnotifications = 0;
                                });
                                _request = {
                                  'membership_no':
                                      '${GemsGLobals.membershipNo}',
                                  'type': 'all',
                                };
                                deleteNotificationApicall(_request);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (canPop, result) async {
        setState(() {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => TabsScreen(
                        initialIndex: 2,
                      )));
        });
        Future.value(false);
      },
      child: Scaffold(
        backgroundColor: grey200_color,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(gradient: gradient_theme_color),
              // height: 90,
              alignment: Alignment.center,
            ),
            leading: GestureDetector(
              onTap: () {
                // Navigator.pop(context, true);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TabsScreen(
                              initialIndex: 2,
                            )));
              },
              child: Container(
                margin: EdgeInsets.all(8),
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
            title: Text(GemsGLobals.notificationTitle,
              style: AppTheme.interTextSize18Style),
            centerTitle: true,
            actions: <Widget>[
              _notificationList!.length != 0
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          // if(_notificationList!.length != 0){
                          clearNotification();
                          // }
                          // else{}
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: blue_color),
                        margin: const EdgeInsets.fromLTRB(0, 15, 10, 15),
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Center(
                            child: TextWidget(
                          text: 'Clear All',
                          size: 12,
                          weight: FontWeight.w500,
                        )),
                      ),
                    )
                  : Container(
                      height: 0,
                    )
            ],
          ),
        ),
        body: Column(
          children: [
            _isLoading == true
                ? Expanded(
                    child: SpinKitCircle(
                      color: blue_color,
                    ),
                  )
                : _notificationList!.length != 0
                    ? Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                          child: RefreshIndicator(
                            key: _refreshIndicatorKey,
                            onRefresh: _refresh,
                            color: appbar_color,
                            child: ListView.builder(
                                shrinkWrap: false,
                                itemCount: _notificationList!.length,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  return Dismissible(
                                      direction: DismissDirection.endToStart,
                                      confirmDismiss: (direction) async {
                                        // final bool res = await
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                content: TextWidget(
                                                  alignment: TextAlign.center,
                                                  text:
                                                      'Are you sure you want to delete?',
                                                  size: text_font_medium15_size,
                                                  weight: FontWeight.w500,
                                                  color: Colors.grey[700],
                                                ),
                                                actions: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 15),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Container(
                                                            width: 80,
                                                            height: 45,
                                                            alignment: Alignment
                                                                .center,
                                                            // padding: EdgeInsets
                                                            //     .symmetric(
                                                            //         horizontal:
                                                            //             20,
                                                            //         vertical:
                                                            //             5),
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  width: 0.8,
                                                                  color: Colors
                                                                      .grey),
                                                              color:
                                                                  white_color,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                            ),
                                                            child: TextWidget(
                                                              text: 'Cancel',
                                                              size: 14,
                                                              color:
                                                                  black_color,
                                                              weight: FontWeight
                                                                  .normal,
                                                            ),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            _request = {
                                                              'membership_no':
                                                                  '${GemsGLobals.membershipNo}',
                                                              'type':
                                                                  'notification_id',
                                                              'notification_id':
                                                                  _notificationList![
                                                                          index]
                                                                      .id
                                                            };

                                                            deleteNotificationApicall(
                                                                _request);

                                                            _notificationList!
                                                                .removeAt(
                                                                    index);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Container(
                                                            width: 80,
                                                            height: 45,
                                                            alignment: Alignment
                                                                .center,
                                                            // padding: EdgeInsets
                                                            //     .symmetric(
                                                            //         horizontal:
                                                            //             20,
                                                            //         vertical:
                                                            //             5),
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  width: 0.8,
                                                                  color: Colors
                                                                      .grey),
                                                              color:
                                                                  white_color,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                            ),
                                                            child: TextWidget(
                                                              text: 'Delete',
                                                              size: 14,
                                                              color:
                                                                  black_color,
                                                              weight: FontWeight
                                                                  .normal,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            });
                                        // return res;
                                      },
                                      background: stackBehindDismiss(),
                                      key: ObjectKey(_notificationList),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (_notificationList![index]
                                                  .isRead ==
                                              0) {
                                            //   for (var i = 0;
                                            //       i < _notificationList!.length;
                                            //       i++) {
                                            //     if (_notificationList![i].id ==
                                            //         _notificationList![index].id) {
                                            //       setState(() {
                                            //         _notificationList![i].isRead =
                                            //             0;
                                            //         if (GemsGLobals
                                            //                 .totalunreadnotifications ==
                                            //             1) {
                                            //           GemsGLobals
                                            //               .totalunreadnotifications = 1;
                                            //         } else {
                                            //           GemsGLobals
                                            //                   .totalunreadnotifications =
                                            //               GemsGLobals
                                            //                       .totalunreadnotifications! -
                                            //                   0;
                                            //         }
                                            //       });
                                            //     }
                                            //   }
                                            setState(() {
                                              _notificationList![index].isRead =
                                                  1;
                                              readNotificationApicall(
                                                  _notificationList![index].id);
                                              GemsGLobals
                                                      .totalunreadnotifications =
                                                  GemsGLobals
                                                          .totalunreadnotifications! -
                                                      1;
                                            });
                                          }
                                          _notificationRouting(index);
                                        },
                                        child: _notificationUi(index),
                                      ));
                                }),
                          ),
                        ))
                    : Expanded(
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(ImageConstants.no_Notification),
                              SizedBox(
                                height: 40,
                              ),
                              TextWidget(
                                text: "No Notifications",
                                size: 24,
                                weight: FontWeight.w600,
                                color: black_color,
                              ),
                              TextWidget(
                                text:
                                    "We'll notify you when something arrives.",
                                color: grey_gunsmoke_text_color,
                              ),
                              SizedBox(
                                height: 100,
                              ),
                            ],
                          ),
                        ),
                        //  Center(
                        //   child: DefaultTextStyle(
                        //     style: TextStyle(color: white_text_color),
                        //     child: TextWidget(
                        //       text: "No Notifications Received!",
                        //       size: 24,
                        //       weight: FontWeight.bold,
                        //       color: black_color,
                        //     ),
                        //   ),
                        // ),
                      ),
          ],
        ),
      ),
    );
  }

  @override
  void notificationListSuccessRees(
      NotificationListModel notificationListModel) {
    _unReadNoticount = 0;
    if (notificationListModel.status == true) {
      setState(() {
        setSyncTime(DateTime.now());
        _notificationList = notificationListModel.values!;
        GemsGLobals.totalReadNotificationsCount =
            notificationListModel.meta!.countsTotalRead;

        for (int i = 0; i < notificationListModel.values!.length; i++) {
          if (notificationListModel.values![i].isRead != 0) {
            _unReadNoticount++;
          }
        }

        GemsGLobals.notificationCount = _unReadNoticount;

        // NotificationCache().notificationSaveCache(
        //     jsonEncode(_nullNotification), 'notificationData');
        NotificationCache().notificationSaveCache(
            notificationListModel.values!, "notificationData");
        _isLoading = false;
      });
      makesenseEventNotificationCenterViewedCall();
    } else {
      if (notificationListModel.message == 'timeout') {
        setState(() {
          _isLoading = false;
          GemsGLobals.notificationCount = _unReadNoticount;
        });
      } else {
        setState(() {
          _isLoading = false;
          NotificationCache().notificationSaveCache(
              jsonEncode(_nullNotification), 'notificationData');
          GemsGLobals.notificationCount = 0;
        });
      }
    }
  }

  @override
  void notiificationListError(Error error) {
    // TODO: implement notiificationListError
  }
}

dateformate(format) {
  var now = DateTime.parse(format);
  var formatter = new DateFormat('dd MMM yyyy');
  var formated = formatter.format(now);

  return formated;
}

timeFormat(format) {
  var date = DateTime.parse(format);
  var covertedData = date.toLocal();

  var formatter = new DateFormat('hh:mm aaa');
  String formatted = formatter.format(covertedData);

  return "$formatted";
}

dateformater(covertToTimezone) {
  var date = DateTime.parse(covertToTimezone);
  var covertedData = date.toLocal();

  var formatter = new DateFormat('dd MMM yyyy');
  String formatted = formatter.format(covertedData);

  return "$formatted";
}
