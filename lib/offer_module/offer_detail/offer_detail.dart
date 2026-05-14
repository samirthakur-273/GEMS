/* Author : Sanjana Shetty
 Date created : 14-April-2022
 Discription : Offer Detail Page */

import 'dart:async';
import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:barcode_widgets/barcode_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gems_revamp/Login_module/login_types/login_types.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/expandable_text.dart';
import 'package:gems_revamp/common_widget/no_fount_notif.dart';
import 'package:gems_revamp/common_widget/tabbarpage.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/homepage/apiconfig/apiconfighome.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/offer_module/offer_detail/model_offerdetail.dart';
import 'package:gems_revamp/offer_module/offer_detail/presenter_offerdetail.dart';
import 'package:gems_revamp/offer_module/offer_detail/view_offerdetail.dart';
import 'package:gems_revamp/offer_module/offer_favourite/model_offerfav.dart';
import 'package:gems_revamp/offer_module/offer_favourite/presenter_offerfav.dart';
import 'package:gems_revamp/offer_module/offer_pin/model_offerredeem.dart';
import 'package:gems_revamp/offer_module/offer_pin/new_offerredeem_model.dart';
import 'package:gems_revamp/offer_module/offer_pin/offer_pin.dart';
import 'package:gems_revamp/offer_module/offer_pin/presenter_offerredeem.dart';
import 'package:gems_revamp/offer_module/offer_pin/view_offerredeem.dart';
import 'package:gems_revamp/offer_module/offer_webview.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as Marker;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../common_widget/bottombar.dart';
import '../../common_widget/font_size.dart';
import '../../utils/constants_files/text_constants.dart';
import '../offer_favourite/view_offerfav.dart';

class OfferDetail extends StatefulWidget {
  final outletcode;
  final brandcode;
  final partnerbrandid;
  final catcode;
  final catname;
  final subcatheading;
  final isHomepage;
  final fromNotif;
  final route;
  @override
  _OfferDetailState createState() => _OfferDetailState();
  OfferDetail(
      {Key? key,
      this.catcode,
      this.outletcode,
      this.brandcode,
      this.partnerbrandid,
      this.catname,
      this.subcatheading,
      this.isHomepage,
      this.fromNotif,
      this.route
      })
      : super(key: key);
}

class _OfferDetailState extends State<OfferDetail>
    with AutomaticKeepAliveClientMixin
    implements OfferDetailsView, OfferFavouriteView, OfferRedeemView {
  var data = """<a>read more</a>""";
  bool _checkDisc = false;
  List _openvoucherbox = [];
  int isExpnd = 200;
  GoogleMapController? mapController;
  bool _isfavloader = false;
  bool _star = false;
  OfferDetailModel offerdetaildata = OfferDetailModel();
  OfferFavouriteModel offerfavdata = OfferFavouriteModel();
  OfferDetailsPresenter? _offerdetailpresenter;
  OfferFavPresenter? _offerfavpresenter;
  var offerdetailresponse;
  bool _isofferdetailloader = true;
  Value? _offerdata;
  bool _showterms = false;
  bool _showredeem = false;
  final _scrollcontroller = ScrollController();
  bool isFavOffer = false;
  double lats = 12;
  double longs = 12;
  BitmapDescriptor? customIcon;
  bool _isstatusfalse = false;
  LatLng? _kMapCenter;
  OfferRedeemPresenter? _redeempresenter;
  var offereddemresponse;
  var transactionId;
  var redeemOffersData;
  List<bool> _isRedeem = [];

  @override
  void initState() {
    super.initState();
    _offerdetailpresenter = OfferDetailsPresenter(this);
    _offerfavpresenter = OfferFavPresenter(this);
    _redeempresenter = OfferRedeemPresenter(this);
    getCustomMarker();
    callofferdetailapi();
  }

  makesenseEventCall() {
    String keyName = GemsGLobals.eventOfferscreenViewed;
    var segmentReq = {
      GemsGLobals.offerCategoryParam: widget.catname ?? '',
      GemsGLobals.offerSubCategoryParam: widget.subcatheading ?? '',
      GemsGLobals.offerTypeParam:
          _offerdata!.offers!.first.offerType.toString().toLowerCase() ==
                  GemsGLobals.onlineText
              ? GemsGLobals.onlineText
              : GemsGLobals.pinBasedType,
      GemsGLobals.offerNameParam: _offerdata!.outletName ?? '',
      GemsGLobals.offerSummaryParam: _offerdata!.outletDescription ?? '',
      GemsGLobals.intSource: GemsGLobals.lastVisitPageName
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  makesenseEventOfferScreenClickedCall(clickedOn) {
    String keyName = GemsGLobals.eventOfferscreenClicked;
    var segmentReq = {
      GemsGLobals.offerCategoryParam: widget.catname,
      GemsGLobals.offerSubCategoryParam: widget.subcatheading,
      GemsGLobals.offerTypeParam:
          _offerdata!.offers![0].offerType.toString().toLowerCase() ==
                  GemsGLobals.onlineText
              ? GemsGLobals.onlineText
              : GemsGLobals.pinBasedType,
      GemsGLobals.offerNameParam: _offerdata!.outletName,
      GemsGLobals.offerSummaryParam: _offerdata!.outletDescription,
      GemsGLobals.clickedOnParam: clickedOn,
      GemsGLobals.intSource: GemsGLobals.lastVisitPageName
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  void getCustomMarker() async {
    // customIcon = await BitmapDescriptor.asset(
    //     ImageConfiguration(size: Size(1.0, 4.0)), ImageConstants.pinMarkerIcon);
  }

  void callNewoffereddemapi(offerCode, merchantCode) {
    var request = {
      "customer_id": GemsGLobals.membershipNo,
      "offer_code":
          offerCode, //offerdetailresponse.values![0].offers[0].offerCode,
      "merchant_code":
          merchantCode, //offerdetailresponse.values![0].merchantCode,
      "outlet_code": widget.outletcode ?? "",
      "ofr_pin_mandatory": "0",
      "partner_brndid": null,
      "partner_offerid": null,
      "type": "initial",
    };

    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _redeempresenter!.newofferRedeemAPI(request);
      } else {
        bool connectionResult = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (connectionResult == null) {
          Navigator.pop(context);
        }
        if (connectionResult) {
          setState(() {});
          _redeempresenter!.newofferRedeemAPI(request);
        }
      }
    });
  }

  _launchURL(url) async {
    Uri tempLink = Uri.parse(url);
    String schema = tempLink.scheme;
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
      } else {
        print("exceptiom =?=> $url");
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('exp $e');
    }
  }

  Future<void> _sendMailHtml(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  void callofferdetailapi() {
    var request = {
      "outlet_code": widget.outletcode ?? "",
      "brand_code": widget.brandcode ?? "",
      "customer_id": GemsGLobals.membershipNo,
      "lat": GemsGLobals.lat,
      "long": GemsGLobals.long,
      "partner_brndid": widget.partnerbrandid ?? "",
      "user_type": GemsGLobals.userType

      // "outlet_code": "KalyanJewelleryAlMajaz",
      // "brand_code": "KALYAN JEWELLER",
      // "customer_id": "5929780330",
      // "lat": 40.72964,
      // "long": -73.98351,
      // "partner_brndid": 1

      // "outlet_code":"Shopzinia",
      // "brand_code":"Shopzinia",
      // "customer_id":"5929780330",
      // "lat":40.72964,
      // "long":-73.98351,
      // "partner_brndid":1
    };

    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _offerdetailpresenter!.offerDetailsAPI(request);
      } else {
        bool connectionResult = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (connectionResult == null) {
          Navigator.pop(context);
        }
        if (connectionResult) {
          setState(() {});
          _offerdetailpresenter!.offerDetailsAPI(request);
        }
      }
    });
  }

  void callofferfavapi(_star) {
    var request = {
      "customer_id": GemsGLobals.membershipNo,
//  "lat": 25.2532,
//   "long": 55.3657,
      "lat": GemsGLobals.lat,
      "long": GemsGLobals.long,
      "brand_code": widget.brandcode,
      "outlet_code": widget.outletcode,
      "isFav": _star == true ? 1 : 0,
      "category_code": widget.catcode
    };

    setState(() {
      _isfavloader = true;
    });
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

  redemptionLimit(redemptionLimit) {
    if (redemptionLimit == null) {
      return redemptionLimit = "Unlimited";
    } else if (redemptionLimit <= 0) {
      return redemptionLimit = 0;
    } else {
      return redemptionLimit;
    }
  }

  Widget _offerDetail() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              // if (_offerdata!.outletImage != null)
              AnimatedContainer(
                duration: Duration(milliseconds: 700),
                color: white_color,
                height: MediaQuery.of(context).size.height / 3.1,
                width: MediaQuery.of(context).size.width / 1,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: _offerdata!.outletImage.toString(),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fill,
                    )),
                  ),
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
              Positioned(
                  top: 40,
                  child: GestureDetector(
                    onTap: () {
                     
                      if (widget.isHomepage == true || widget.route == GemsGLobals.pushNotificationRouteType) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => TabsScreen(
                                      initialIndex: 0,
                                    )));
                      } else {
                        Navigator.pop(context, _star);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: white_color,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Container(
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 27,
                            color: black_color,
                          ),
                        ),
                      ),
                    ),
                  )),
              Positioned(
                top: 43,
                right: 25,
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(40)),
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _star = !_star;
                          callofferfavapi(_star);
                        });
                      },
                      child: _star
                          ? Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: white_color,
                              ),
                              child: Icon(
                                Icons.favorite,
                                color: theme_color,
                                size: 25,
                              ),
                            )
                          : Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: white_color,
                              ),
                              child: Icon(
                                Icons.favorite_border,
                                color: theme_color,
                                size: 25,
                              ),
                            )),
                ),
              ),
              Column(
                children: [
                  Container(
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 3.5,
                      ),
                      decoration: BoxDecoration(
                          color: white_color,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          if (_offerdata!.outletName != null)
                            Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(
                                  top: 55,
                                ),
                                child: TextWidget(
                                  text: _offerdata!.outletName ?? '',
                                  weight: FontWeight.bold,
                                  size: text_font_large20_size,
                                  color: brown,
                                  alignment: TextAlign.center,
                                )),
                          if (_offerdata!.outletDescription != null)
                            Container(
                                padding: EdgeInsets.only(
                                  top: 0,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    ExpandableText(
                                      text: _offerdata!.outletDescription ?? "",
                                      style: TextStyle(color: greyish),
                                    )
                                  ],
                                )),
                          Column(
                            children: _voucherdata(),
                          ),
                          if (_offerdata?.offers![0].offerTermsCon != null)
                            SizedBox(height: 15),
                          _termsandconditions(),
                          if (_offerdata?.offers![0].offerTermsCon != null)
                            SizedBox(height: 15),
                          if (_offerdata?.howToRedeem != null &&
                              _offerdata!.offers![0].offerType
                                      .toString()
                                      .toLowerCase() ==
                                  'online')
                            SizedBox(height: 10),
                          if (_offerdata!.offers![0].offerType
                                  .toString()
                                  .toLowerCase() ==
                              'online')
                            _howtoredeem(),
                          if (_offerdata?.howToRedeem != null &&
                              _offerdata!.offers![0].offerType
                                      .toString()
                                      .toLowerCase() ==
                                  GemsGLobals.onlineText)
                            SizedBox(height: 15),
                          _offerdata!.offers != null
                              ? _offerdata!.offers![0].isLocation == 0
                                  ? Container(
                                      height: 0,
                                    )
                                  : _offerdata?.outletLatitude == null ||
                                          _offerdata?.outletLatitude == ""
                                      ? Container()
                                      : _mapWid(
                                          _offerdata?.otherBranches!.length)
                              : Container(),
                          SizedBox(height: 15),
                          _whatsappandmail(),
                          _offerdata!.offers != null
                              ? _offerdata!.offers![0].offerType
                                              .toString()
                                              .toLowerCase() ==
                                          GemsGLobals.onlineText &&
                                      _offerdata!.offers![0].isLocation == 1
                                  ? _branches()
                                  : _offerdata!.offers![0].offerType
                                              .toString()
                                              .toLowerCase() ==
                                          GemsGLobals.onlineText
                                      ? Container(
                                          height: 0,
                                        )
                                      : _branches()
                              : Container(height: 0),
                          _offerdata!.offers != null
                              ? _offerdata!.offers![0].offerType
                                          .toString()
                                          .toLowerCase() ==
                                      GemsGLobals.onlineText
                                  ? Container(
                                      color: white_color,
                                      height: 20,
                                    )
                                  : SizedBox(
                                      height: 20,
                                    )
                              : Container(height: 0),
                          SizedBox(height: 70),
                        ],
                      )),
                ],
              ),
              // if (_offerdata!.brandLogo != null)
              Container(
                decoration: new BoxDecoration(
                  color: Color(0XFFBDBDBD),
                  border: Border.all(color: Colors.grey[400]!, width: 0.5),
                  borderRadius: BorderRadius.circular(45),
                ),
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 4.4,
                  left: MediaQuery.of(context).size.width / 2.6,
                ),
                width: 90.0,
                height: 90.0,
                child: Container(
                  margin: EdgeInsets.all(5),
                  //   width: 60.0,
                  // height: 60.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(45.0),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: _offerdata!.brandLogo.toString(),
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill,
                        )),
                      ),
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
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _mapWid(i) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextWidget(
              text: "Location",
              weight: FontWeight.bold,
              size: text_font_medium15_size,
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Container(
                  // height: 50,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.5,
                      color: Colors.grey[300]!,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    color: const Color(0xffe8f9ff),
                    // boxShadow: [
                    //   BoxShadow(
                    //     blurRadius: 3.0,
                    //     color: Colors.grey[350]!.withOpacity(.5),
                    //     offset: Offset(0.5, 0.5),
                    //   ),
                    // ],
                  ),
                  margin: EdgeInsets.only(left: 0, right: 0),
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 0,
                      left: 5,
                      right: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 90,
                          child: TextWidget(
                            text: "${_offerdata?.outletArea ?? ''}",
                            color: black_color,
                            size: 12,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            weight: FontWeight.bold,
                          ),
                        ),
                        if (_offerdata?.contactNo != null)
                          GestureDetector(
                            onTap: () {
                              if (Platform.isAndroid) {
                                launchUrl(Uri.parse(
                                    "tel:'${_offerdata?.contactNo}'"));
                              } else {
                                launchUrl(Uri.parse(
                                    "tel://${_offerdata?.contactNo.toString().replaceAll(" ", "%20")}"));
                              }
                            },
                            child: Container(
                              width: 110,
                              child: TextWidget(
                                text: '${_offerdata?.contactNo ?? ''}',
                                size: 12,
                                color: black_color,
                                weight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (_offerdata?.distance != null)
                          Container(
                            child: TextWidget(
                              text:
                                  "${double.tryParse(_offerdata!.distance!.toString())?.toStringAsFixed(2)} KM",
                              color: Colors.grey[600],
                              size: 12,
                            ),
                          ),
                        // Container(
                        //   height: 15,
                        //   child: RotatedBox(
                        //     quarterTurns: isExpnd == i ? 3 : 2,
                        //     child: Image(
                        //       image: AssetImage(ImageConstants.left_arrow),
                        //       color: const Color(0xff12ade6),
                        //       height: 22,
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Stack(
                    alignment: Alignment.center, // Center children in the Stack
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 0.0, right: 0),
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: GoogleMap(
                            zoomGesturesEnabled: true,
                            tiltGesturesEnabled: false,
                            mapToolbarEnabled: false,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(double.parse('$lats'),
                                  double.parse('$longs')),
                              zoom: 15.0,
                            ),
                            mapType: MapType.normal,
                            onMapCreated: _onMapCreated,
                            markers: <Marker.Marker>{
                              Marker.Marker(
                                markerId: MarkerId('marker_1'),
                                position: LatLng(
                                    double.parse(
                                        _offerdata?.outletLatitude ?? '12'),
                                    double.parse(
                                        _offerdata?.outletLongitude ?? '12')),
                                icon: BitmapDescriptor.defaultMarker,
                                infoWindow: InfoWindow(
                                  title: _offerdata?.outletArea ?? "",
                                  snippet: _offerdata?.outletArea ?? "",
                                  onTap: () {},
                                ),
                              ),
                            },
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          color: Colors.transparent,
                          margin: EdgeInsets.only(left: 0.0, right: 0),
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                        ),
                        onTap: () {
                          MapUtils.openMap(
                              double.parse(_offerdata?.outletLatitude ?? '12'),
                              double.parse(
                                  _offerdata?.outletLongitude ?? '12'));
                        },
                      )
                    ]),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _kMapCenter = LatLng(double.parse("${_offerdata?.outletLatitude}"),
          double.parse("${_offerdata?.outletLongitude}"));
    });
    // mapController = controller;
    mapController = controller;
  }

  void _gmailurl(String toMailId, String subject, String body) async {
    subject = subject.replaceAll(" ", "%20");
    subject = subject.replaceAll("&", "%26");
    body = body.replaceAll(" ", "%20");
    body = body.replaceAll("&", "%26");
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _termsandconditions() {
    return _offerdata?.offers![0].offerTermsCon == null
        ? Container(
            height: 0,
          )
        : Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    makesenseEventOfferScreenClickedCall(
                        GemsGLobals.termcondition);
                    setState(() {
                      if (_showterms != true) {
                        _showterms = true;
                        int? length =
                            _offerdata?.offers![0].offerTermsCon?.length ?? 0;

                        // _scrollcontroller.animateTo(
                        //   length < 250
                        //       ? (_scrollcontroller.position.pixels + 100)
                        //       : (_scrollcontroller.position.pixels + 300),
                        //   curve: Curves.easeInOut,
                        //   duration: const Duration(milliseconds: 600),
                        // );
                      } else {
                        _showterms = false;
                      }
                    });
                  },
                  child: Container(
                      // height: 65,
                      decoration: BoxDecoration(
                          color: Color(0XFFD8D8D8).withOpacity(0.4),
                          borderRadius: BorderRadius.circular(14)),
                      child: Column(
                        children: [
                          Container(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      child: TextWidget(
                                        text: "Terms & Conditions",
                                        weight: FontWeight.w500,
                                        size: text_font_medium15_size,
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: RotatedBox(
                                      quarterTurns: _showterms ? 3 : 2,
                                      child: Image.asset(
                                          ImageConstants.left_arrow,
                                          color: black_color,
                                          height: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (!_showterms) SizedBox(height: 15),
                          _showterms
                              ? Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(
                                      bottom: 5, top: 0, left: 10, right: 10),
                                  child: Html(
                                    data: _offerdata?.offers![0]
                                                    .offerTermsCon !=
                                                '' &&
                                            _offerdata?.offers![0]
                                                    .offerTermsCon !=
                                                null
                                        ? _offerdata?.offers![0].offerTermsCon!
                                        : 'Not applicable',
                                    onLinkTap: (url, __, ___) async {
                                      setState(() {
                                        _sendMailHtml('mailto:$url!');
                                      });
                                      _launchURL(url);
                                    },
                                    //  style: {
                                    //                   "body": Style(
                                    //                     fontSize: 13),

                                    //                 },
                                  )
                                  // TextWidget(
                                  //   text: _offerdata?.offers![0].offerTermsCon != '' &&
                                  //           _offerdata?.offers![0].offerTermsCon != null
                                  //       ? _offerdata?.offers![0].offerTermsCon!
                                  //       : 'Not applicable',
                                  //   size: text_font_size_x_small,
                                  // ),

                                  )
                              : Container(
                                  height: 0,
                                ),
                        ],
                      )),
                ),
              ],
            ),
          );
  }

  Widget _howtoredeem() {
    return _offerdata?.howToRedeem == null
        ? Container(
            height: 0,
          )
        : Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      makesenseEventOfferScreenClickedCall(GemsGLobals.redeem);
                      if (_showredeem != true) {
                        _showredeem = true;
                        int? length = _offerdata?.howToRedeem?.length ?? 0;

                        // _scrollcontroller.animateTo(
                        //   length < 250
                        //       ? (_scrollcontroller.position.pixels + 100)
                        //       : (_scrollcontroller.position.pixels + 300),
                        //   curve: Curves.easeInOut,
                        //   duration: const Duration(milliseconds: 600),
                        // );
                      } else {
                        _showredeem = false;
                      }
                      // String keyName = "Offer details page";
                      // var segmentReq = {
                      //   "Action": "Tnc",
                      // };
                      // MakesenseApiClass.makesenseEventsApi(
                      //     http.Client(), segmentReq, keyName);
                    });
                  },
                  child: Container(
                      // height: 65,
                      decoration: BoxDecoration(
                          color: Color(0XFFD8D8D8).withOpacity(0.4),
                          borderRadius: BorderRadius.circular(14)),
                      child: Column(
                        children: [
                          Container(
                            // height: 50,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      child: TextWidget(
                                        text: "How to Redeem",
                                        weight: FontWeight.w500,
                                        size: text_font_medium15_size,
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: RotatedBox(
                                      quarterTurns: _showredeem ? 3 : 2,
                                      child: Image.asset(
                                          ImageConstants.left_arrow,
                                          color: black_color,
                                          height: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (!_showredeem) SizedBox(height: 15),
                          _showredeem
                              ? Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(
                                      bottom: 5, top: 0, left: 10, right: 10),
                                  child: Html(
                                    data: _offerdata?.howToRedeem != '' &&
                                            _offerdata?.howToRedeem != null
                                        ? _offerdata?.howToRedeem
                                        : 'Not applicable',
                                    onLinkTap: (url, __, ___) async {
                                      if (await canLaunchUrl(
                                          Uri.parse(url.toString()))) {
                                        await launchUrl(
                                          Uri.parse(url.toString()),
                                          mode: LaunchMode.externalApplication,
                                        );
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                    //  style: {
                                    //                   "body": Style(
                                    //                     fontSize: 13),

                                    //                 },
                                  )
                                  // TextWidget(
                                  //   text: _offerdata?.offers![0].offerTermsCon != '' &&
                                  //           _offerdata?.offers![0].offerTermsCon != null
                                  //       ? _offerdata?.offers![0].offerTermsCon!
                                  //       : 'Not applicable',
                                  //   size: text_font_size_x_small,
                                  // ),

                                  )
                              : Container(
                                  height: 0,
                                ),
                          // if(_showredeem)SizedBox(height:5)
                        ],
                      )),
                ),
              ],
            ),
          );
  }

  void whatsappBottomModalold(
      BuildContext context, String namer, String offerName) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return   SafeArea(
          top: false,
            child: IntrinsicHeight(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 45,
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.only(bottom: 3, top: 15),
                        child: Center(
                          child: SvgPicture.asset(
                            ImageConstants.whatsapp,
                            height: 40,
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        margin: EdgeInsets.only(
                          top: 10,
                          right: 5,
                          bottom: 0,
                        ),
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          child: SvgPicture.asset(
                            ImageConstants.cross,
                            height: 35,
                            width: 35,
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: TextWidget(
                        text: AppTexts.connectingText,
                        textAlign: TextAlign.center,
                        size: appbar_text_size,
                        weight: FontWeight.bold),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 5),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextWidget(
                        text: AppTexts.connectingMessageText,
                        textAlign: TextAlign.center,
                        size: text_font_medium15_size,
                        color: black_color),
                  ),
                  GestureDetector(
                    child: Container(
                      margin: EdgeInsets.only(top: 5),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: aqua_blue,
                      ),
                      child: Center(
                        child: TextWidget(
                            text: AppTexts.proceedText,
                            textAlign: TextAlign.center,
                            color: white_color,
                            size: text_font_large20_size),
                      ),
                    ),
                    onTap: () {
                      whatsappcallnew(context, namer, offerName);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  static void whatsappcallnew(
      BuildContext context, outletname, offerName) async {
    var whatsappUrl;
    Navigator.of(context).pop();
    var whatsappstore = Platform.isAndroid
        ? "https://play.google.com/store/apps/details?id=com.whatsapp&hl=en_IN"
        : "https://apps.apple.com/in/app/whatsapp-messenger/id310633997";

    whatsappUrl =
        "whatsapp://send?phone=+971504350673&text=Hello,I%20am%20facing%20some%20issues%20with%20${outletname.replaceAll(new RegExp('&'), "%26")}%20(${offerName.replaceAll(new RegExp('&'), "%26")})offer%20in%20GEMS%20Rewards";

    whatsappUrl = whatsappUrl.replaceAll(" ", "%20");
    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      await launchUrl(Uri.parse(whatsappstore));
    }
  
  }

  Widget _whatsappandmail() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  makesenseEventOfferScreenClickedCall(
                      GemsGLobals.whatsAppText);
                  var title = _offerdata?.offers![0].offerTitle ?? '';
                  whatsappBottomModalold(
                      context,
                      "${_offerdata!.outletName!.replaceAll(new RegExp('&'), "%26")}",
                      "${title.replaceAll(new RegExp('&'), "%26")}");
                },
                child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                        color: const Color(0xfff2f2f2),
                        borderRadius: BorderRadius.circular(14)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: white_color,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: SvgPicture.asset(ImageConstants.whatsapp,
                                    height: 20),
                              )),
                          new SizedBox(
                            width: 10,
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              child: TextWidget(
                                text: "Whatsapp",
                                weight: FontWeight.w500,
                                size: text_font_medium15_size,
                              )),
                        ],
                      ),
                    )
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 0.0, right: 0),
                    //   child: Row(
                    //     children: [
                    //     Padding(
                    //       padding: const EdgeInsets.only(right: 5.0),
                    //       child: Container(
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(8),
                    //             color: white_color,
                    //           ),
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(5.0),
                    //             child: SvgPicture.asset(ImageConstants.whatsapp,
                    //                 height: 20),
                    //           )),
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.only(
                    //           left: 10, right: 10, top: 5, bottom: 5),
                    //       child: Container(
                    //           alignment: Alignment.centerLeft,
                    //           child: TextWidget(
                    //             text: "Whatsapp",
                    //             weight: FontWeight.w500,
                    //             size: text_font_medium15_size,
                    //           )),
                    //     ),
                    //   ],
                    // ),
                    // )
                    ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  makesenseEventOfferScreenClickedCall(
                      GemsGLobals.supportMailText);
                  String title = '';
                  if (_offerdata?.offers?.isNotEmpty == true) {
                    setState(() {
                      title = '(${_offerdata?.offers?[0].offerTitle})';
                    });
                  }
                  String subject1 = Uri.encodeComponent(
                      'Facing some issues with ${_offerdata!.outletName} $title offer in GEMS Rewards');
                  String body = Uri.encodeComponent(
                      'Hello Team,\n I am facing some issue with ${_offerdata!.outletName} - $title offer in GEMS Rewards.');
                  String toMailId = 'support@gemsrewards.com';
                  _gmailurl(toMailId, subject1, body);
                },
                child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                        color: common_gray_color,
                        borderRadius: BorderRadius.circular(14)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: white_color,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: SvgPicture.asset(ImageConstants.email,
                                    height: 20),
                              )),
                          new SizedBox(
                            width: 10,
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              child: TextWidget(
                                text: "Support Mail",
                                weight: FontWeight.w500,
                                size: text_font_medium15_size,
                              )),
                        ],
                      ),
                    )
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 15.0, right: 10),
                    //   child: Row(
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.only(right: 5.0),
                    //         child: Container(
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(8),
                    //             color: white_color,
                    //           ),
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(5.0),
                    //             child: SvgPicture.asset(ImageConstants.email,
                    //                 height: 20),
                    //           ),
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.only(
                    //             left: 10, right: 10, top: 5, bottom: 5),
                    //         child: Container(
                    //             alignment: Alignment.centerLeft,
                    //             child: TextWidget(
                    //               text: "Support Mail",
                    //               weight: FontWeight.w500,
                    //               size: text_font_medium15_size,
                    //             )),
                    //       ),
                    //     ],
                    //   ),
                    // )
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> copyVouchercode(
      BuildContext context, message, ofrUrl, routeType, offerid, offertitle) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6.0))),
          child: Container(
            margin: EdgeInsets.only(top: 0, left: 10, right: 5, bottom: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.maybePop(context);
                  },
                  child: Container(
                      margin: EdgeInsets.only(top: 5, bottom: 10, right: 5),
                      alignment: Alignment.topRight,
                      child: Icon(
                        Icons.close_outlined,
                        color: shadow_color,
                      )),
                ),
                message == 'null'
                    ? Center(
                        child: TextWidget(
                          alignment: TextAlign.center,
                          text: 'Voucher code is copied.',
                          size: 15,
                          weight: FontWeight.bold,
                          softwrap: true,
                        ),
                      )
                    : Container(
                        child: Center(
                            child: TextWidget(
                        alignment: TextAlign.center,
                        text: message,
                        size: 15,
                        weight: FontWeight.bold,
                        softwrap: true,
                      ))),
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 5),
                  child: Container(
                    height: 35,
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.0,
                          color: aqua_orange,
                        ),
                        borderRadius: BorderRadius.circular(3)),
                    child: TextButton(
                      child: TextWidget(
                        text: 'OK',
                        alignment: TextAlign.center,
                        color: aqua_orange,
                        size: text_font_size_small,
                        weight: FontWeight.bold,
                      ),
                      onPressed: () async {
                        setState(() {
                          if (ofrUrl.toString() != "null") {
                            if (routeType.toString().toLowerCase() ==
                                GemsGLobals.external) {
                              Navigator.of(context).pop();
                              launchUrl(Uri.parse(ofrUrl.toString()),
                                  mode: LaunchMode.externalApplication);
                            } else {
                              Navigator.of(context).pop();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForYouWeb(
                                            appbarname:
                                                GemsGLobals.gemsGlobalText,
                                            weburl: ofrUrl,
                                          )));
                            }
                          } else {
                            Navigator.of(context).pop();
                          }
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _voucherdata() {
    List<Widget> _offerList = [];
    for (var i = 0; i < _offerdata!.offers!.length; i++) {
      _isRedeem.add(false);
      _offerList.add(GestureDetector(
        onTap: () {
          if (_offerdata!.offers![0].offerType.toString().toLowerCase() ==
                  'online' &&
              _openvoucherbox[i] == true &&
              _offerdata!.offers![i].vouchercode != "" &&
              _offerdata!.offers![i].vouchercode != null) {
            Clipboard.setData(
                ClipboardData(text: _offerdata!.offers![i].vouchercode ?? ''));

            if (_offerdata!.offers![i].isBarCode != 1) {
              copyVouchercode(
                  context,
                  GemsGLobals.voucherCodeCopied,
                  _offerdata!.offers![i].ofrUrl,
                  _offerdata!.offers![i].routetype,
                  _offerdata!.offers![i].ofdId,
                  _offerdata!.offers![i].offerTitle);
              makesenseEventOfferScreenClickedCall(GemsGLobals.voucherCodeText);
            }
          } else if (_offerdata!.offers![0].offerType
                      .toString()
                      .toLowerCase() ==
                  'online' &&
              _openvoucherbox[i] == true &&
              (_offerdata!.offers![i].vouchercode == "" ||
                  _offerdata!.offers![i].vouchercode == null)) {
            if (_offerdata!.offers![i].routetype.toString().toLowerCase() ==
                    "external" ||
                _offerdata!.offers![i].routetype.toString().toLowerCase() ==
                    "web") {
              _launchURL(_offerdata!.offers![i].ofrUrl);
            } else if (_offerdata!.offers![i].routetype
                    .toString()
                    .toLowerCase() ==
                GemsGLobals.inApp) {
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ForYouWeb(
                            appbarname: GemsGLobals.gemsGlobalText,
                            weburl: _offerdata!.offers![i].ofrUrl,
                          )));
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Container(
            decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: _offerdata?.offers![i].redemptionLimit == 0
                    ? grey_color_pin_text
                    : _offerdata!.offers![0].offerType
                                .toString()
                                .toLowerCase() ==
                            'online'
                        ? aqua_orange
                        : aqua_blue),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(7),
                              bottomLeft: Radius.circular(7),
                              topRight: Radius.circular(7),
                              bottomRight: Radius.circular(7),
                            ),
                            color: Colors.white.withOpacity(0.3),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, bottom: 10, left: 10, right: 10),
                            child: SvgPicture.asset(
                              _offerdata!.offers![0].offerType
                                          .toString()
                                          .toLowerCase() ==
                                      'online'
                                  ? ImageConstants.smallvoucherorange
                                  : ImageConstants.smallvoucherblue,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // SizedBox(height: 2),
                            _offerdata!.offers![0].offerType
                                        .toString()
                                        .toLowerCase() ==
                                    'online'
                                ? Container(
                                    width: 240,
                                    child: TextWidget(
                                      text: _offerdata?.offers![i].offerTitle ??
                                          '',
                                      color: white_color,
                                      weight: FontWeight.w600,
                                      size: text_font_size_small,
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                : Container(
                                    width: 165,
                                    child: TextWidget(
                                      text: _offerdata?.offers![i].offerTitle ??
                                          '',
                                      color: white_color,
                                      weight: FontWeight.w600,
                                      size: text_font_size_small,
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                            SizedBox(height: 5),
                            if (_openvoucherbox[i] == false)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _openvoucherbox[i] = true;
                                  });
                                },
                                child: Container(
                                  child: TextWidget(
                                    text: "View Details",
                                    decoration: TextDecoration.underline,
                                    color: white_color,
                                    size: text_font_size_small,
                                  ),
                                ),
                              ),
                            if (!_openvoucherbox[i]) SizedBox(height: 15),
                          ],
                        ),
                      ),
                      if (_offerdata!.offers![0].offerType
                              .toString()
                              .toLowerCase() !=
                          'online')
                        SizedBox(width: 5),
                      if (_offerdata!.offers![0].offerType
                              .toString()
                              .toLowerCase() !=
                          'online')
                        // _makesenseOnline("Redeem",_offerdata!.offers![i].ofdId ?? "",_offerdata!.otherBranches![i].outletArea,_offerdata?.offers![0].offerTermsCon,_offerdata?.otherBranches,_offerdata!
                        //                               .offers![i].offerCode),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(top: 15),
                            child: _isRedeem[i] == true
                                ? SpinKitCircle(color: white10_color)
                                : ElevatedButton(
                                    onPressed: _offerdata!
                                                .offers![i].redemptionLimit ==
                                            0
                                        ? () {
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return PopScope(
                                                    canPop: true,
                                                    onPopInvoked:
                                                        (canPop) async {
                                                      Future.value(false);
                                                    },
                                                    child: Dialog(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5.0))),
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            top: 25,
                                                            left: 15,
                                                            right: 15),
                                                        height: 120,
                                                        child: Column(
                                                          children: <Widget>[
                                                            Container(
                                                              child: TextWidget(
                                                                text:
                                                                    "Oops! You have exceeded the offer redemption limit.",
                                                                size:
                                                                    text_font_size_small,
                                                                weight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .grey[700],
                                                                alignment:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 22,
                                                                      bottom:
                                                                          20),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: <Widget>[
                                                                  Container(
                                                                    height: 35,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            border:
                                                                                Border.all(
                                                                              width: 1.0,
                                                                              color: blue_color,
                                                                            ),
                                                                            borderRadius: BorderRadius.circular(3)),
                                                                    child:
                                                                        new TextButton(
                                                                      child:
                                                                          TextWidget(
                                                                        text:
                                                                            "OK",
                                                                        color:
                                                                            blue_color,
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        size:
                                                                            text_font_size_small,
                                                                        weight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                });
                                          }
                                        : () {
                                            if (GemsGLobals.userType ==
                                                "guest") {
                                              setState(() {
                                                showLoginAlert(context);
                                              });
                                            } else {
                                              makesenseEventOfferScreenClickedCall(
                                                  GemsGLobals.redeem);
                                              setState(() {
                                                _isRedeem[i] = true;
                                              });
                                              redeemOffersData =
                                                  _offerdata!.offers![i];
                                              callNewoffereddemapi(
                                                  _offerdata!
                                                      .offers![i].offerCode,
                                                  _offerdata!.merchantCode);
                                            }
                                          },
                                    style: ButtonStyle(
                                      textStyle: MaterialStateProperty.all(
                                          TextStyle(color: Color(0xffffffff))),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              white_color),
                                      minimumSize:
                                          MaterialStateProperty.all(Size(0, 0)),
                                      padding:
                                          MaterialStateProperty.all<EdgeInsets>(
                                              EdgeInsets.all(0)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0.0,
                                          right: 0,
                                          top: 8,
                                          bottom: 8),
                                      child: TextWidget(
                                        text: "Redeem",
                                        color: _offerdata?.offers![i]
                                                    .redemptionLimit ==
                                                0
                                            ? grey_color_pin_text
                                            : aqua_blue,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                    ],
                  ),
                  if (_openvoucherbox[i]) _openvoucher(i),
                ],
              ),
            ),
          ),
        ),
      ));
      _offerList.add(SizedBox(height: 8));
    }
    return _offerList;
  }

  /* ----------- Check Vouchers Validity ------------- */
  checkAvailability(String? outlettime) {
    if (outlettime != null) {
      DateTime dateTime = DateTime.now();
      DateTime? _pickedDate = DateTime.tryParse(outlettime.toString());
      if (dateTime.difference(_pickedDate!).inDays == 0) {
        return 'Voucher not Available';
      }
      return 'Voucher Available';
    }
    return "";
  }

  Widget _openvoucher(i) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 5),
        Row(
          children: [
            _offerdata!.offers![0].offerType.toString().toLowerCase() ==
                        'online' &&
                    _offerdata!.offers![i].vouchercode != null &&
                    _offerdata!.offers![i].vouchercode != ""
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 0.0, top: 5),
                    child: _offerdata!.offers![i].isBarCode == 1
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                text: _offerdata!.offers![i].vouchercode !=
                                            null &&
                                        _offerdata!.offers![i].vouchercode != ""
                                    ? '${GemsGLobals.voucherCodeText}: ${_offerdata!.offers![i].vouchercode ?? ''}'
                                    : "",
                                color: white_text_color.withOpacity(0.9),
                                size: text_font_size_xx_small,
                                weight: FontWeight.bold,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.10,
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: BarcodeWidget(
                                    barcode: Barcode.code128(),
                                    drawText: false,
                                    data: _offerdata!.offers![i].vouchercode ??
                                        '',
                                  ),
                                ),
                              ),
                            ],
                          )
                        : TextWidget(
                            text: _offerdata!.offers![i].vouchercode != null &&
                                    _offerdata!.offers![i].vouchercode != ""
                                ? '${GemsGLobals.voucherCodeText}: ${_offerdata!.offers![i].vouchercode ?? ''}'
                                : "",
                            color: white_text_color.withOpacity(0.9),
                            size: text_font_medium15_size,
                            weight: FontWeight.bold,
                          ),
                  )
                : Container()
          ],
        ),
        if (_offerdata?.offers![i].offerDescription.toString() != "null")
          SizedBox(height: 2),
        if (_offerdata?.offers![i].offerDescription.toString() != "null")
          Container(
              child: Html(
            data: _offerdata?.offers![i].offerDescription ?? '',
            style: {
              "body": Style(
                color: white_color,
                margin: Margins.zero,
                padding: HtmlPaddings.only(top: 0),
              ),
            },
          )

              //   ],
              // ),

              ),

        if (_offerdata?.offers![i].offerDescription.toString() == "null")
          SizedBox(
            height: 2,
          ),
        if (_offerdata!.offers![0].offerType.toString().toLowerCase() !=
            'online')
          TextWidget(
            text: _offerdata!.offers![i].availabiltyDate.toString() != "" &&
                    _offerdata!.offers![i].availabiltyDate != null
                ? checkAvailability(
                    _offerdata?.offers![i].availabiltyDate.toString())
                : '',
            color: white_text_color.withOpacity(0.9),
            size: _offerdata!.offers![i].availabiltyDate.toString() != "" &&
                    _offerdata!.offers![i].availabiltyDate != null
                ? 10.5
                : 0,
          ),
        // Row(
        //   children: [
        //     _offerdata!.offers![0].type.toString().toLowerCase() == 'online' &&
        //             _offerdata!.offers![i].vouchercode != null &&
        //             _offerdata!.offers![i].vouchercode != ""
        //         ? Padding(
        //             padding: const EdgeInsets.only(bottom: 0.0, top: 5),
        //             child: TextWidget(
        //               text: _offerdata!.offers![i].vouchercode != null &&
        //                       _offerdata!.offers![i].vouchercode != ""
        //                   ? 'Voucher Code : ${_offerdata!.offers![i].vouchercode ?? ''}'
        //                   : "",
        //               color: white_text_color.withOpacity(0.9),
        //               size: text_font_medium15_size,
        //               weight: FontWeight.bold,
        //             ),
        //           )
        //         : TextWidget(
        //             text: _offerdata!.offers![i].availabiltyDate.toString() !=
        //                         "" &&
        //                     _offerdata!.offers![i].availabiltyDate != null
        //                 ? checkAvailability(
        //                     _offerdata?.offers![i].availabiltyDate.toString())
        //                 : '',
        //             color: white_text_color.withOpacity(0.9),
        //             size: _offerdata!.offers![i].availabiltyDate.toString() !=
        //                         "" &&
        //                     _offerdata!.offers![i].availabiltyDate != null
        //                 ? 10.5
        //                 : 0,
        //           ),
        //   ],
        // ),
        // SizedBox(
        //   height: 5,
        // ),
        SizedBox(height: 3),
        if (_offerdata?.offers![i].offerLimit != null)
          Row(
            children: [
              Container(
                child: TextWidget(
                  text: "Vouchers: " +
                      "${redemptionLimit(_offerdata!.offers![i].redemptionLimit)}",
                  // "${_offerdata!.offers![i].redemptionLimit < 0 ? 0: _offerdata!.offers![i].redemptionLimit ?? 'Unlimited'}",
                  color: white_color,
                  weight: FontWeight.w600,
                  size: text_font_medium14_size,
                ),
              )
            ],
          ),
        if (_offerdata?.offers![i].offerLimit == null) SizedBox(height: 2),
        SizedBox(
          height: 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: TextWidget(
                      text: "Refer to Terms & Conditions below",
                      color: white_color,
                      size: text_font_small_10_size),
                ),
                Container(
                  child: TextWidget(
                      text: "for further details",
                      color: white_color,
                      size: text_font_small_10_size),
                ),
              ],
            ),
            SizedBox(width: 5),
            GestureDetector(
              onTap: () {
                setState(() {
                  _openvoucherbox[i] = false;
                });
              },
              child: Container(
                child: TextWidget(
                    text: "Close",
                    decoration: TextDecoration.underline,
                    color: white_color,
                    size: 14),
              ),
            )
          ],
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget _branches() {
    int? length = _offerdata?.otherBranches!.length;
    return length! >= 1
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin:
                    EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 7),
                child: TextWidget(
                  text: "Branches",
                  weight: FontWeight.bold,
                  size: text_font_medium15_size,
                ),
              ),
              _location()
            ],
          )
        : Container();
  }

  Widget _location() {
    return new Container(
      child: _mapLocationDetails(),
    );
  }

  Widget _mapLocationDetails() {
    var branchesdata = _offerdata?.otherBranches;
    int? length = _offerdata?.otherBranches!.length;
    return Container(
      // height: (10 * length!) + 270.0,
      child: Column(
        children: <Widget>[
          // Expanded(
          //   child:
          ListView.builder(
            padding: EdgeInsets.only(top: 0),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: length,
            itemBuilder: (BuildContext ctxt, int index) {
              return _locoaccotest(index, branchesdata);
            },
          ),
          // )
        ],
      ),
    );
  }

  Widget _locoaccotest(i, otherBranches) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            makesenseEventOfferScreenClickedCall(GemsGLobals.branchNames);
            setState(() {
              if (_offerdata?.otherBranches!.length == 1 && isExpnd == 0) {
                isExpnd = 1;
              } else if (isExpnd == i) {
                setState(() {
                  isExpnd = 200;
                });
              } else {
                setState(() {
                  isExpnd = i;
                });
              }
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.5,
                color: Colors.grey[300]!,
              ),
              borderRadius: BorderRadius.circular(14),
              color: const Color(0xffe8f9ff),
            ),
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Container(
              margin: EdgeInsets.only(
                top: 0,
                left: 5,
                right: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 90,
                    child: TextWidget(
                      text: "${otherBranches[i].outletArea ?? ''}",
                      color: black_color,
                      size: 12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      weight: FontWeight.bold,
                    ),
                  ),
                  if (otherBranches[i].contactNo != null)
                    GestureDetector(
                      onTap: () {
                        if (Platform.isAndroid) {
                          launchUrl(
                              Uri.parse("tel:'${otherBranches[i].contactNo}'"));
                        } else {
                          launchUrl(Uri.parse(
                              "tel://${otherBranches[i].contactNo.toString().replaceAll(" ", "%20")}"));
                        }
                      },
                      child: Container(
                        width: 110,
                        child: TextWidget(
                          text: '${otherBranches[i].contactNo ?? ''}',
                          size: 12,
                          color: black_color,
                          weight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (otherBranches[i].distance != null)
                    Container(
                      child: TextWidget(
                        text:
                            "${otherBranches[i].distance.toStringAsFixed(2)} KM",
                        color: Colors.grey[600],
                        size: 12,
                      ),
                    ),
                  Container(
                    height: 15,
                    child: RotatedBox(
                      quarterTurns: isExpnd == i ? 3 : 2,
                      child: Image(
                        image: AssetImage(ImageConstants.left_arrow),
                        color: const Color(0xff12ade6),
                        height: 22,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        isExpnd == i
            ? Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(14)),
                margin:
                    EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 5),
                child: Stack(
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(14)),
                        height: 200,
                        child: GoogleMap(
                          zoomGesturesEnabled: true,
                          tiltGesturesEnabled: false,
                          mapToolbarEnabled: false,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                                double.parse(otherBranches[i].outletLatitude),
                                double.parse(otherBranches[i].outletLongitude)),
                            zoom: 15.0,
                          ),
                          mapType: MapType.normal,
                          onMapCreated: _onMapCreated,
                          markers:
                              // _markerlist!,
                              <Marker.Marker>{
                            Marker.Marker(
                              markerId: MarkerId('marker_1'),
                              position: LatLng(
                                  double.parse(
                                      otherBranches[i].outletLatitude ?? '12'),
                                  double.parse(
                                      otherBranches[i].outletLongitude ??
                                          '12')),
                              icon: BitmapDescriptor.defaultMarker,
                              infoWindow: InfoWindow(
                                title: otherBranches[i].outletArea,
                                snippet: otherBranches[i].outletArea,
                                onTap: () {},
                              ),
                            ),
                          },
                        )),
                    GestureDetector(
                      onTap: () {
                        MapUtils.openMap(
                            double.parse(
                                otherBranches[i].outletLatitude.toString()),
                            double.parse(
                                otherBranches[i].outletLongitude.toString()));
                      },
                      child: Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width - 30,
                        color: Color.fromRGBO(0, 0, 0, 0.0),
                      ),
                    )
                  ],
                ),
              )
            : Container(
                height: 0,
              ),
        SizedBox(height: 15)
      ],
    );
  }

  Widget _body() {
    return _isofferdetailloader == true
        ? Center(
            child: SpinKitCircle(
            color: btn_bg_color,
          ))
        : _isstatusfalse == true && (widget.fromNotif ?? false)
            ? NoResultFoundNotification()
            : _isstatusfalse == true
                ? Center(
                    child: Container(child: TextWidget(text: "No Data Found")),
                  )
                : Stack(
                    children: [
                      Container(
                        child: ListView(
                            padding: EdgeInsets.only(top: 0),
                            controller: _scrollcontroller,
                            children: <Widget>[
                              _offerDetail(),
                              SizedBox(
                                height: 15,
                              ),
                            ]),
                      ),
                      _isfavloader == true
                          ? Center(
                              child: SpinKitCircle(
                                color: btn_bg_color,
                              ),
                            )
                          : Container()
                    ],
                  );
  }

  Widget _tabbar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      // color: black_color,
      child: BottomBar(
        initialIndex: 0,
      ),
    );
  }

  static Future<dynamic> showLoginAlert(BuildContext context) {
    return showDialog(
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
                    text: "To continue ahead you need to login.",
                    size: text_font_size_small,
                    weight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                new SizedBox(
                  height: 10,
                ),
                Container(
                  child: TextWidget(
                    text: "Do you want to login?",
                    size: text_font_size_small,
                    weight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 22),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        height: 35,
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.0,
                              color: blue_color,
                            ),
                            borderRadius: BorderRadius.circular(3)),
                        child: new TextButton(
                          child: TextWidget(
                            text: "No",
                            color: blue_color,
                            textAlign: TextAlign.center,
                            size: text_font_size_small,
                            weight: FontWeight.bold,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Container(
                        height: 35,
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.0,
                              color: blue_color,
                            ),
                            borderRadius: BorderRadius.circular(3)),
                        child: new TextButton(
                          child: TextWidget(
                            text: "Yes",
                            color: blue_color,
                            textAlign: TextAlign.center,
                            size: text_font_size_small,
                            weight: FontWeight.bold,
                          ),
                          onPressed: () async {
                           Navigator.of(context).pop();
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginHomePage()));

                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          // actions: <Widget>[],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: white_color,
        body: PopScope(
            canPop: true,
            onPopInvoked: (didPop) {
              if (didPop)
                return; 

              if (widget.isHomepage == true) {
                Navigator.popUntil(context, (route) => route.isFirst);
              }
              else if( widget.route == GemsGLobals.pushNotificationRouteType) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => TabsScreen(
                          initialIndex: 0,
                        )));
                        }
               else {
                Navigator.pop(context, _star);
              }
            },
            child: _body()),
        bottomNavigationBar:  SizedBox(height: 90, child: _tabbar()),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void offerdetailsResponseSuccess(OfferDetailModel offerdetailModel) {
    offerdetailresponse = offerdetailModel;

    setState(() {
      if (offerdetailModel.status == true) {
        _offerdata = offerdetailModel.values![0];
        makesenseEventCall();
        GemsGLobals.lastVisitPageName = GemsGLobals.offerDetailPageName;
        for (var i = 0; i < _offerdata!.offers!.length; i++) {
          _openvoucherbox.add(true);
        }

        if (_offerdata?.isFav.toString() == "1") {
          _star = true;
        } else {
          _star = false;
        }

        lats = double.parse(_offerdata?.outletLatitude ?? '12');
        longs = double.parse(_offerdata?.outletLongitude ?? '12');
        _isofferdetailloader = false;
        _isstatusfalse = false;
      } else {
        _isofferdetailloader = false;
        if (GemsGLobals.membershipNo == null) {
          showLoginAlert(context);
        }
        setState(() {
          _isstatusfalse = true;
        });
      }
    });
  }

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      margin: EdgeInsets.only(bottom: 30, left: 15, right: 15),
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1),
    ));
  }

  @override
  void offerfavResponseSuccess(OfferFavouriteModel offerfavModel) {
    if (offerfavModel.status == true) {
      setState(() {
        _isfavloader = false;
        showMessage(
            context,
            _star == true
                ? "Offer moved in favorite list."
                : "Offer removed from favorite list.");
      });
    } else {
      setState(() {
        _isfavloader = false;
        showMessage(context, offerfavModel.message ?? '');
      });
    }
  }

  @override
  void offeredeemResponseSuccess(OfferRedeemModel offeredeemModel) {}

  @override
  void newOfferedeemResponseSuccess(NewOfferRedeemModel newOfferRedeemModel) {
    if (newOfferRedeemModel.status == true) {
      setState(() {
        offereddemresponse = newOfferRedeemModel;
        transactionId = offereddemresponse.values.transactionId;
        _isRedeem = [false];

        // for (var i = 0; i < _offerdata!.offers!.length; i++) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OfferPin(
                      transactionId: transactionId,
                      offerdetail: _offerdata ?? "",
                      offerCode: redeemOffersData.offerCode ?? "",
                      offerTitle: redeemOffersData.offerTitle ?? "",
                      offerExpiryDate: redeemOffersData.availabiltyDate ?? "",
                      offerLimit: redeemOffersData.offerLimit ?? "",
                      offerdealdata: redeemOffersData,
                      partnerbrandid: widget.partnerbrandid ?? "",
                    )));
        // }
      });
    } else if (newOfferRedeemModel.status == false) {
      setState(() {
        _isRedeem = [false];
      });

      Fluttertoast.showToast(
          msg: newOfferRedeemModel.message.toString(),
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: blue_color,
          textColor: white_text_color,
          gravity: ToastGravity.BOTTOM);
    }
  }
}

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
  }
}

class LaunchUrl {
  static Future<void> openLink({
    String? url,
  }) async =>
      await _launchUrl(url!);

  static Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  static void openEmail(
      {String? toEmail, String? subject, String? body}) async {
    final url =
        'mailto:$toEmail?subject=${Uri.encodeFull(subject!)}&body=$body';
    await _launchUrl(url);
  }
}
