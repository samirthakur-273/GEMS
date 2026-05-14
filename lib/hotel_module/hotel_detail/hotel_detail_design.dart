//  Author: Ashlesha Dhumalj
//  Description: Hotel Details page

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/numberformat.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/hotel_module/hotel_detail/hotel_detail_model.dart';
import 'package:gems_revamp/hotel_module/hotel_detail/hotel_detail_presenter.dart';
import 'package:gems_revamp/hotel_module/hotel_detail/hotel_detail_view.dart';
import 'package:gems_revamp/hotel_module/hotel_detail/select_room/select_room.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/dialogAlert.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class HoteldetailPage extends StatefulWidget {
  final hotelid;
  final searchid;
  final uniqueid;
  final checkindate;
  final checkoutedate;
  final roomcount;
  final mop;
  final roomdata;
  final roomMember;
  final hotellocation;
  final hotelcountry;

  const HoteldetailPage(
      {Key? key,
      this.hotelid,
      this.searchid,
      this.uniqueid,
      this.checkindate,
      this.checkoutedate,
      this.roomcount,
      this.mop,
      this.roomdata,
      this.roomMember,
      this.hotellocation,
      this.hotelcountry})
      : super(key: key);

  @override
  _HotelDetailPageState createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HoteldetailPage>
    implements HoteldetailView {
  bool _isLoading = true;
  HotelDetailPresenter? _hotelDetailPresenter;
  double lat = GemsGLobals.lat;
  double long = GemsGLobals.long;
  LatLng? _kMapCenter;

  GoogleMapController? mapController;
  var hoteldetailData;
  PageController _pageControlller = PageController(
    initialPage: 0,
  );
  final _currentPageNotifier = ValueNotifier<int>(0);
  BitmapDescriptor? customIcon;
  bool _showmoreAmenity = false;

  List<dynamic> hoteldetail = [
    {'facilities': "Wheelchair accessible path of travel"},
    {'facilities': "Elevator"},
    {'facilities': "Accessible Bathroom"},
    {'facilities': "in-room accessibility"},
    {'facilities': "accessible spa"},
    {'facilities': "acceesible desk"},
    {'facilities': "acceesible desk"},
    {'facilities': "Wheelchair accessible path of travel"},
    {'facilities': "Elevator"},
    {'facilities': "acceesible desk"},
    {'facilities': "acceesible desk"}
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top:false,
      child: Scaffold(
      
        body: _isLoading == true
            ? SpinKitCircle(
                color: blue_color,
              )
            : _body(),
        bottomNavigationBar:
            _isLoading == true ? SpinKitCircle(color: blue_color) : bottomBar(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _hotelDetailPresenter = HotelDetailPresenter(this);
    getCustomMarker();
    _apicall();
  }

  void getCustomMarker() async {
    // customIcon = await BitmapDescriptor.asset(
    //     ImageConfiguration(size: Size(2.0, 4.0)), ""
    //     );
  }

  _apicall() {
    setState(() {
      GemsGLobals.mop = "${this.widget.mop}";
      var request = {
        "hotel_id": this.widget.hotelid,
        "search_id": this.widget.searchid,
        "unique_id": this.widget.uniqueid,
        "currency": "USD",
        "mop": "${this.widget.mop}"
      };

      Internetconnectivity().isConnected().then((result) async {
        if (result) {
          _hotelDetailPresenter!.hoteldetail(request);
        } else {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => NoInternet()))
              .then((value) {
            _hotelDetailPresenter!.hoteldetail(request);
          });
        }
      });
    });
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _coursel(),
              _hotelNameRomms(),
              overviewWid(),
              checkInOut(),
              _amentitesTitle(),
              _locationWid()
            ]),
      ),
    );
  }

/* checkout checkin widget */
  Widget checkInOut() {
    return Container(
      height: 115,
      padding: EdgeInsets.only(left: 15, right: 15, top: 10),
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: grey_color),
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(255, 181, 207, 236),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    TextWidget(
                      text: hoteldetailData?.hoteldetails?.info?.checkin
                              .replaceAll("check-in", "") ??
                          '',
                      color: black_color,
                      weight: FontWeight.w800,
                    ),
                    TextWidget(
                      text: " Check-In",
                      color: black_color,
                    ),
                  ],
                ),
                Container(
                  height: 20,
                  width: 1,
                  color: black_color,
                ),
                Row(
                  children: <Widget>[
                    TextWidget(
                      text: hoteldetailData?.hoteldetails?.info?.checkout
                              .replaceAll("check-out", "") ??
                          '',
                      color: black_color,
                      weight: FontWeight.w800,
                    ),
                    TextWidget(
                      text: " Check-Out",
                      color: black_color,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  height: 35,
                  width: 150,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: white_text_color,
                    border: Border.all(color: grey200_color, width: 1),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      new BoxShadow(
                          color: shadow_color.withOpacity(0.2),
                          offset: new Offset(1.0, 2.0),
                          blurRadius: 2.0,
                          spreadRadius: 2.0)
                    ],
                  ),
                  child: TextWidget(
                    text: DateFormat("dd MMM").format(this.widget.checkindate) +
                        " - " +
                        DateFormat("dd MMM").format(this.widget.checkoutedate),
                    color: black_color,
                  ),
                ),
                Container(
                  height: 35,
                  width: 150,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: white_text_color,
                    border: Border.all(color: grey200_color, width: 1),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      new BoxShadow(
                          color: shadow_color.withOpacity(0.2),
                          offset: new Offset(1.0, 2.0),
                          blurRadius: 2.0,
                          spreadRadius: 2.0)
                    ],
                  ),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: TextWidget(
                      text: this.widget.roomdata,
                      color: black_color,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

/* amentity widget */
  Widget _amentitesTitle() {
    int length =
        hoteldetailData?.hoteldetails?.facilities[0]?.amenities?.length;
    int _totalAmenity = length <= 7 ? length : 8;
    int _addAmenity = length - 7;

    return Container(
      margin: EdgeInsets.only(left: 20.0, top: 10, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextWidget(
            text: "Amenities",
            size: text_font_medium16_size,
            weight: FontWeight.w700,
          ),
          SizedBox(height: 2),
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Container(
              //  child: SingleChildScrollView(
              //     physics: NeverScrollableScrollPhysics(),
              child: Wrap(
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  runSpacing: 5,
                  spacing: 10.0,

                  //  direction: Axis.horizontal,
                  // crossAxisCount: 4,
                  // crossAxisSpacing: 2.0,
                  // mainAxisSpacing: 2.0,
                  // shrinkWrap: true,
                  // physics: BouncingScrollPhysics(),
                  children: !_showmoreAmenity
                      ? List.generate(
                          _totalAmenity,
                          (i) {
                            return Container(
                                child: i < 7
                                    ? Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: SvgPicture.asset(
                                              ImageConstants.select,
                                              color: blue_color,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          // Expanded(

                                          Container(
                                            width: 100,
                                            child: TextWidget(
                                              text: hoteldetailData
                                                  ?.hoteldetails
                                                  ?.facilities[0]
                                                  ?.amenities[i]
                                                  ?.name,
                                              size: text_font_size_small,
                                              alignment: TextAlign.center,
                                              softwrap: true,
                                              maxLines: 2,
                                              // overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          // ),
                                        ],
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _totalAmenity = hoteldetailData
                                                ?.hoteldetails
                                                ?.facilities[0]
                                                ?.amenities
                                                ?.length;
                                            _addAmenity = 0;
                                            _showmoreAmenity = true;
                                          });
                                        },
                                        child: Container(
                                            // padding: EdgeInsets.fromLTRB(
                                            //     6, 10, 6, 70),
                                            width: 60,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          deepdark_orange_color,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              child: Center(
                                                  child: TextWidget(
                                                text: '+ $_addAmenity',
                                                size: 17,
                                                color: deepdark_orange_color,
                                                weight: FontWeight.w700,
                                              )),
                                            )),
                                      ));
                          },
                        )
                      : List.generate(
                          hoteldetailData
                              ?.hoteldetails?.facilities[0]?.amenities?.length,
                          (i) {
                            return Container(
                                child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.check,
                                  color: deepdark_orange_color,
                                  size: 25,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                // Expanded(
                                //   child:
                                Container(
                                  width: 100,
                                  child: TextWidget(
                                    text: hoteldetailData?.hoteldetails
                                        ?.facilities[0]?.amenities[i]?.name,
                                    size: text_font_small,
                                    alignment: TextAlign.center,
                                    softwrap: true,
                                    maxLines: 2,
                                  ),
                                ),
                                // ),
                              ],
                            ));
                          },
                        )),
            ),
            // ),
            // child: Container(

            //   child: SingleChildScrollView(
            //     physics: NeverScrollableScrollPhysics(),
            //     child: GridView.count(
            //         // childAspectRatio: (MediaQuery.of(context).size.width) /
            //         //     (MediaQuery.of(context).size.height-100),
            //         crossAxisCount: 4,
            //         crossAxisSpacing: 2.0,
            //         mainAxisSpacing: 2.0,
            //         shrinkWrap: true,
            //         physics: BouncingScrollPhysics(),
            //         children: !_showmoreAmenity
            //             ? List.generate(
            //                 _totalAmenity,
            //                 (i) {
            //                   return Container(
            //                       child: i < 7
            //                           ? Column(
            //                               children: <Widget>[
            //                                 Padding(
            //                                   padding: const EdgeInsets.all(2.0),
            //                                   child: SvgPicture.asset(
            //                                     ImageConstants.select,
            //                                     color: blue_color,
            //                                   ),
            //                                 ),
            //                                 SizedBox(
            //                                   height: 5,
            //                                 ),
            //                                 Expanded(
            //                                   child: TextWidget(
            //                                     text: hoteldetailData
            //                                         ?.hoteldetails
            //                                         ?.facilities[0]
            //                                         ?.amenities[i]
            //                                         ?.name,
            //                                     size: text_font_size_small,
            //                                     alignment: TextAlign.center,
            //                                     softwrap: true,
            //                                   ),
            //                                 ),
            //                               ],
            //                             )
            //                           : GestureDetector(
            //                               onTap: () {
            //                                 setState(() {
            //                                   _totalAmenity = hoteldetailData
            //                                       ?.hoteldetails
            //                                       ?.facilities[0]
            //                                       ?.amenities
            //                                       ?.length;
            //                                   _addAmenity = 0;
            //                                   _showmoreAmenity = true;
            //                                 });
            //                               },
            //                               child: Container(
            //                                   padding: EdgeInsets.fromLTRB(
            //                                       6, 10, 6, 70),
            //                                   child: Container(
            //                                     decoration: BoxDecoration(
            //                                         border: Border.all(
            //                                             color:
            //                                                 deepdark_orange_color,
            //                                             width: 1),
            //                                         borderRadius:
            //                                             BorderRadius.circular(
            //                                                 30)),
            //                                     child: Center(
            //                                         child: TextWidget(
            //                                       text: '+ $_addAmenity',
            //                                       size: 17,
            //                                       color: deepdark_orange_color,
            //                                       weight: FontWeight.w700,
            //                                     )),
            //                                   )),
            //                             ));
            //                 },
            //               )
            //             : List.generate(
            //                 hoteldetailData
            //                     ?.hoteldetails?.facilities[0]?.amenities?.length,
            //                 (i) {
            //                   return Container(
            //                       child: Column(
            //                     children: <Widget>[
            //                       Icon(
            //                         Icons.check,
            //                         color: deepdark_orange_color,
            //                         size: 25,
            //                       ),
            //                       SizedBox(
            //                         height: 5,
            //                       ),
            //                       Expanded(
            //                         child: TextWidget(
            //                           text: hoteldetailData?.hoteldetails
            //                               ?.facilities[0]?.amenities[i]?.name,
            //                           size: text_font_small,
            //                           alignment: TextAlign.center,
            //                           softwrap: true,
            //                         ),
            //                       ),
            //                     ],
            //                   ));
            //                 },
            //               )),
            //   ),
            // ),
          ),
          SizedBox(
            height: 1,
          )
        ],
      ),
    );
  }

/* hotel images... */
  Widget _coursel() {
    return Container(
      color: grey100_color,
      child: Stack(
        children: <Widget>[
          _buildPageView(),
          _buildCircleIndicator(),
          Positioned(
            top: 40,
            left: 5,
            child: InkWell(
                onTap: () async {
                  Navigator.pop(context, true);
                },
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white.withAlpha((0.5 * 255).toInt()),
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
                      ],
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }

/* image page view */
  _buildPageView() {
    try {
      return Container(
        height: MediaQuery.of(context).size.height / 3,
        child: PageView.builder(
            itemCount: hoteldetailData?.hoteldetails?.images != null
                ? hoteldetailData?.hoteldetails?.images?.length
                : 0,
            controller: _pageControlller,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      child: ClipRRect(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset(
                              ImageConstants.noimages,
                              // AppAssets.htl_placeholder,
                              fit: BoxFit.fill,
                            ),
                          ),
                          fit: BoxFit.fill,
                          imageUrl: hoteldetailData?.hoteldetails?.images[index]
                                  .image[0].imageUrl ??
                              "",
                          errorWidget: (context, url, error) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                ImageConstants.noimages,
                                // AppAssets.htl_placeholder,
                                fit: BoxFit.fill,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xCC000000),
                            Colors.black54,
                            const Color(0x00000000),
                            const Color(0x00000000),
                            const Color(0x00000000),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            onPageChanged: (int index) {
              _currentPageNotifier.value = index;
            }),
      );
    } catch (e) {
      //print(e);
      return Container();
    }
  }

  Widget _buildCircleIndicator() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CirclePageIndicator(
          dotColor: white_text_color,
          selectedDotColor: blue_color,
          selectedSize: 6,
          size: 6,
          itemCount: hoteldetailData?.hoteldetails?.images != null
              ? hoteldetailData?.hoteldetails?.images?.length
              : 0,
          currentPageNotifier: _currentPageNotifier,
        ),
      ),
    );
  }

/* Hotel room name widget */
  Widget _hotelNameRomms() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: TextWidget(
                  text: hoteldetailData?.hoteldetails?.info?.hotelName,
                  size: 19,
                  color: black_color,
                  weight: FontWeight.w600,
                  softwrap: true,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

/* Hotel overview widget */
  Widget overviewWid() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextWidget(
            text: "Overview",
            size: text_font_medium16_size,
            color: black_color,
            weight: FontWeight.bold,
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            child: TextWidget(
              softwrap: true,
              text: hoteldetailData?.hoteldetails?.descriptions ?? "",
              color: black_color,
              size: text_font_size_small,
            ),
          ),
          this.widget.mop == 'cash'
              ? Container(
                  margin: EdgeInsets.only(top: 7, bottom: 7),
                  child: TextWidget(
                    text:
                        "Earn Upto ${hoteldetailData?.hoteldetails?.bnzAccrPnts != null ? pointsFormatter(int.parse(hoteldetailData.hoteldetails.bnzAccrPnts.toString())) : 0} GEMS Points",
                    size: text_font_size_x_small,
                    color: blue_color,
                    weight: FontWeight.w500,
                  ),
                )
              : Container(),
          Divider(),
          TextWidget(
            text: "Other Details",
            size: text_font_medium16_size,
            color: black_color,
            weight: FontWeight.bold,
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 11,
                width: 74,
                alignment: Alignment.topLeft,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int i) {
                    int noofstar =
                        hoteldetailData.hoteldetails.info.starRating != null
                            ? int.parse(hoteldetailData
                                .hoteldetails.info.starRating
                                .toString())
                            : 0;

                    return i < noofstar
                        ? Padding(
                            padding: const EdgeInsets.only(right: 2.5),
                            child: SvgPicture.asset(
                              ImageConstants.unselect_Star,
                              color: blue_color,
                            ),
                          )
                        : SvgPicture.asset(
                            ImageConstants.select_Star,
                            color: grey_color,
                          );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

/* google map */
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _kMapCenter = LatLng(
          double.parse("${hoteldetailData?.hoteldetails?.info?.latitude}"),
          double.parse("${hoteldetailData?.hoteldetails?.info?.longitude}"));
    });
    mapController = controller;
  }

/* Loaction widget */
  Widget _locationWid() {
    return Container(
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: TextWidget(
              text: "Location",
              size: text_font_medium16_size,
              weight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
              child: Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: GoogleMap(
                zoomGesturesEnabled: true,
                tiltGesturesEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      double.parse(
                          "${hoteldetailData?.hoteldetails?.info?.latitude}"),
                      double.parse(
                          "${hoteldetailData?.hoteldetails?.info?.longitude}")),
                  zoom: 7.0,
                ),
                mapType: MapType.normal,
                onMapCreated: _onMapCreated,
                markers: <Marker>[
                  Marker(
                    markerId: MarkerId("marker_1"),
                    position: LatLng(
                        double.parse(
                            "${hoteldetailData?.hoteldetails?.info?.latitude}"),
                        double.parse(
                            "${hoteldetailData?.hoteldetails?.info?.longitude}")),
                    // icon: customIcon!,
                  ),
                ].toSet(),
              ),
            ),
          ))
        ],
      ),
    );
  }

/* select room button  */
  Widget bottomBar() {
    return Container(
      height: 80,
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        // width: MediaQuery.of(context).size.width / 2.2,
                        child: GemsGLobals.usedGems == 'cash'
                            ? TextWidget(
                                text:
                                    "Upto AED ${pointsFormatter(int.parse(hoteldetailData.rooms[0].roomTypes[0].price.perNight.toString()).round())} per night",
                                size: text_font_medium14_size,
                                color: black_color,
                                weight: FontWeight.bold,
                                softwrap: true,
                              )
                            : TextWidget(
                                text:
                                    "Upto ${pointsFormatter(int.parse(hoteldetailData.rooms[0].roomTypes[0].price.bnzPrNigtReddemPnts.toString()))} GEMS Points per night",
                                size: text_font_medium14_size,
                                color: black_color,
                                weight: FontWeight.bold,
                                softwrap: true,
                              ))
                  ],
                ),
                SizedBox(
                  height: 3,
                ),
                GemsGLobals.usedGems == 'cash'
                    ? TextWidget(
                        text:
                            "Earn upto ${pointsFormatter(int.parse(hoteldetailData.hoteldetails.bnzAccrPnts.toString()))} GEMS Points",
                        size: text_font_size_x_small,
                        color: blue_color,
                        weight: FontWeight.w500,
                      )
                    : Container(
                        height: 0,
                      ),
              ],
            ),
            new SizedBox(
              width: 3,
            ),
            GestureDetector(
              onTap: () {
                GemsGLobals.membershipNo != null
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HotelRoomTypePage(
                                  mop: this.widget.mop,
                                  roomMember: this.widget.roomMember,
                                  uniqueid: this.widget.uniqueid,
                                  hotelName: hoteldetailData
                                      ?.hoteldetails?.info?.hotelName,
                                  star: hoteldetailData
                                      ?.hoteldetails?.info?.starRating
                                      .toString(),
                                  checkindate: this.widget.checkindate,
                                  checkoutdate: this.widget.checkoutedate,
                                  checkinTime: hoteldetailData
                                      ?.hoteldetails?.info?.checkin,
                                  checkoutTime: hoteldetailData
                                      ?.hoteldetails?.info?.checkout,
                                  roomtype: this.widget.roomdata,
                                  roomData: hoteldetailData?.rooms,
                                  roomcount: this.widget.roomcount,
                                  hotelAddress: hoteldetailData
                                      ?.hoteldetails?.info?.address,
                                  guestcount: this.widget.roomdata,
                                  redeemrate: hoteldetailData?.redeemRate,
                                  countrycode: hoteldetailData
                                      ?.hoteldetails?.info?.countryCode,
                                )))
                    : DialogAlert.showLoginAlert(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    gradient: gradient_theme_color,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: TextWidget(
                  text: "Select Room",
                  color: white_text_color,
                  weight: FontWeight.w500,
                  size: 17,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void hotelDetailPageError(error) {
    // TODO: implement hotelDetailPageError
  }

  @override
  void hotelDetailResponse(HoteldetailModel response) async {
    if (response.status == true) {
      setState(() {
        _isLoading = false;
        hoteldetailData = response.values;
      });
    } else {
      if (response.message == "timeout") {
        setState(() {
          _isLoading = false;
        });
        var notresponding =
            await Navigator.of(context).pushNamed('/timeoutpage');

        if (notresponding != null) {
          setState(() {
            _isLoading = true;
          });
          _apicall();
        } else {
          Navigator.pop(context);
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
