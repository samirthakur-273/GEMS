import 'dart:async';

import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/model/cart_details_model.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/constants.dart';
import 'package:gems_revamp/eshop_module_new/shipping_address/shipping_address.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as locationImport;

class AddressMap extends StatefulWidget {
  CartDetailsModel? cartDetailsModel;
  final route;

  AddressMap({
    Key? key,
    this.cartDetailsModel,
    this.route,
  }) : super(key: key);

  @override
  _AddressMapState createState() => _AddressMapState();
}

class _AddressMapState extends State<AddressMap> {
  List<ListItem> _dropdownItems = [
    ListItem(1, "Home"),
    ListItem(2, "Office"),
    ListItem(3, "Other House"),
  ];
  static const LatLng _center = const LatLng(25.2532, 55.3657);
  LatLng _lastMapPosition = _center;
  static const kGoogleApiKey = "AIzaSyDfGXj8CkiwHqpJ40xLq7mdwi60Iwc3C_0";
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  GoogleMapController? mapController;
  GoogleMapsGeocoding _geocoding = GoogleMapsGeocoding(apiKey: kGoogleApiKey);
  TextEditingController myController = new TextEditingController();
  // final Location location = Location();

  var latitude;
  var longitude;
  var city;
  String country = "";
  var area;
  String? address;
  var locality;
  var streetaddress;
  var start;
  var pincode;
  Position? _currentPosition;
  String? _currentAddress;
  var move = false;
  var _zoom = 25.0;
  var focusNode = FocusNode();
  String? error;

  //final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  @override
  void initState() {
    super.initState();
    myController.text = "";
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  _getCurrentLocation() async {
    locationImport.Location().getLocation().then((value) {
     
      _lastMapPosition = LatLng(value.latitude ?? 0.0, value.longitude ?? 0.0);
      // if (value != null) {
      mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 270.0,
          target: _lastMapPosition,
          tilt: 30.0,
          zoom: 20.0,
        ),
      ));
      //}
      setState(() {});
    });
    }

  showaddressoption() {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.white.withOpacity(0.1),
        builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(60),
                decoration: BoxDecoration(
                    color: theme_color.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15)),
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: TextWidget(
                        alignment: TextAlign.center,
                        text: "We Currently Only Deliver In UAE",
                        color: white_color,
                        softwrap: true,
                        weight: FontWeight.bold,
                        size: text_size_18,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

 
  Future<List<Prediction>> fetchPlaces(String query) async {
    final _fetch = await _places.autocomplete(query, language: 'en');
    return _fetch.predictions;
  }

  Future<void> fetchOnCameraMove(LatLng location) async {
    final _location = Location(lat: location.latitude, lng: location.longitude);
    final _data = await _geocoding.searchByLocation(_location, language: 'en');

    if (_data == null || _data.results.isEmpty && country == "") {
      showaddressoption();
    } else {
      final detail = _data.results.isNotEmpty ? _data.results.first : null;

      if (detail != null) {
        address = detail.formattedAddress;
        city = detail.addressComponents
            .firstWhere((e) => e.types.contains("locality"))
            .longName;
        area = detail.addressComponents
            .firstWhere((e) => e.types.contains("sublocality_level_1"))
            .longName;
        streetaddress = "";
        country = detail.addressComponents
            .firstWhere(
              (element) => element.types.contains("country"),
            )
            .longName;
        setState(() {});
        // if (Constants.brandCode == "1" && country != "United Arab Emirates") {
        //   showaddressoption();
        // } else if (Constants.brandCode == "8" && country != "Qatar") {
        //   showaddressoption();
        // } else if (Constants.brandCode == "10" && country != "Saudi Arabia") {
        //   showaddressoption();
        // } else {}
      }
    }
  }

  Future<Null> displayPrediction(Prediction? p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId!, language: 'en');
      double lat = detail.result.geometry!.location.lat;
      double lng = detail.result.geometry!.location.lng;
      
      country = detail.result.addressComponents
              .firstWhereOrNull((element) => element.types.contains("country"))
              ?.longName ??
          "";

     
      city = detail.result.addressComponents
              .firstWhereOrNull((element) => element.types.contains("locality"))
              ?.longName ??
          "";
      // detail.result.addressComponents
      //     .firstWhere((e) => e.types.contains("locality"))
      //     .longName;
      area = detail.result.addressComponents
              .firstWhereOrNull(
                  (element) => element.types.contains("sublocality_level_1"))
              ?.longName ??
          "";
      // detail.result.addressComponents
      //     .firstWhere((e) => e.types.contains("sublocality_level_1"))
      //     .longName;

      // address = detail?.result?.formattedAddress;
      streetaddress = "";

      setState(() {
        _lastMapPosition = LatLng(lat, lng);
        mapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 270.0,
            target: _lastMapPosition,
            tilt: 30.0,
            zoom: _zoom,
          ),
        ));
        myController.text = detail.result.name.toString();
      });
    }
  }

  _onCameraMove(CameraPosition position) async {
    _lastMapPosition = position.target;
    EasyDebounce.debounce('debouncer1', Duration(milliseconds: 500),
        () => fetchOnCameraMove(_lastMapPosition));
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0.0,
        target: _lastMapPosition,
        tilt: 0.0,
        zoom: _zoom,
      ),
    ));

    setState(() {
      _getCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _map() {
      return GestureDetector(
          child: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height / 1.3,
              width: MediaQuery.of(context).size.width,
              // decoration: BoxDecoration(
              //   border: Border.all(width: 1, color: grey200_color),
              // ),
              child: GoogleMap(
                  compassEnabled: false,
                  mapType: MapType.normal,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: false,
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: _lastMapPosition,
                    zoom: _zoom,
                  ),
                  onCameraMove: _onCameraMove,
                  onMapCreated: _onMapCreated)),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                move
                    ? CircularProgressIndicator()
                    : SizedBox(
                        height: 0,
                      ),
                Image.asset(
                  ImageConstants.pinMarkerIcon,
                  height: 40,
                ),
              ],
            ),
          )
        ],
      ));
    }

    Widget _seachbar() {
      return Positioned(
        top: 20,
        left: 20,
        right: 20,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                    color: white_text_color,
                    borderRadius: BorderRadius.circular(20)),
                child: TypeAheadField<Prediction>(
                  debounceDuration: Duration(milliseconds: 350),
                  onSuggestionSelected: (p) => displayPrediction(p),
                  suggestionsBoxDecoration: SuggestionsBoxDecoration(
                      offsetX: 30,
                      constraints: BoxConstraints(maxWidth: 280),
                      color: white_color,
                      borderRadius: BorderRadius.circular(10)),
                  suggestionsCallback: (query) => fetchPlaces(query),
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion.terms[0].value),
                      // subtitle: Text(suggestion.description),
                    );
                  },
                  hideOnEmpty: true,
                  textFieldConfiguration: TextFieldConfiguration(
                    focusNode: focusNode,
                    controller: myController,
                    decoration: InputDecoration(
                        prefixIcon: Container(
                            height: 25,
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: SvgPicture.asset(
                              ImageConstants.searchicon,
                              color: Colors.grey.shade400,
                            )),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        border: InputBorder.none,
                        hintText: "Search...",
                        hintStyle: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.grey.shade400,
                            fontSize: text_font_medium_x_size,
                            fontWeight: FontWeight.bold),
                        contentPadding: EdgeInsets.only(left: 20, top: 10)),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            GestureDetector(
              onTap: () {
                _getCurrentLocation();
              },
              child: AbsorbPointer(
                child: Container(
                    child: Icon(
                  Icons.location_searching_outlined,
                  size: 30,
                  color: blue_color,
                )),
              ),
            )
          ],
        ),
      );
    }

    Widget _confirmLocation() {
      return Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: GestureDetector(
            onTap: () {
              if (Constants.brandCode == "1" &&
                  country != "United Arab Emirates") {
                    showaddressoption();
              } else if (Constants.brandCode == "8" && country != "Qatar") {
                                    showaddressoption();

              } else if (Constants.brandCode == "10" &&
                  country != "Saudi Arabia") {
                                        showaddressoption();

              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (cxt) => ShippingAddress(
                              //   controller: scrollController,
                              address: address,
                              streestaddress: "",
                              cartDetailsModel: widget.cartDetailsModel,
                              route: widget.route,
                            )));
                // showModalBottomSheet<dynamic>(
                //     isScrollControlled: true,
                //     context: context,
                //     backgroundColor: Colors.transparent,
                //     builder: (BuildContext bc) {
                //       return DraggableScrollableSheet(
                //           initialChildSize: 0.70,
                //           minChildSize: 0.70,
                //           expand: false,
                //           builder: (context, scrollController) {
                //             return ShippingAddress(
                //               controller: scrollController,
                //               address: address,
                //               streestaddress: "",
                //               cartDetailsModel: widget.cartDetailsModel,
                //               route: widget.route,
                //             );
                //           });
                //     });
              }
            },
            child: Container(
                height: 45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    gradient: LinearGradient(
                        colors: 
                        // Constants.brandCode == "1" &&
                        //         country == "United Arab Emirates"?
                             new_gradient_color,
                            // : Constants.brandCode == "8" && country == "Qatar"
                            //     ? new_gradient_color
                            //     : Constants.brandCode == "10" &&
                            //             country == "Saudi Arabia"
                            //         ? new_gradient_color
                            //         : [
                            //             Colors.grey.shade400,
                            //             Colors.grey.shade400
                            //           ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 10,
                      )
                    ]),
                child: TextWidget(
                  text: "Confirm Location",
                  color: white_color,
                  weight: FontWeight.bold,
                  size: text_size_16,
                )),
          ));
    }

    // Widget _currentpostion() {
    //   return Positioned(
    //       top: 75,
    //       right: 20,
    //       child: GestureDetector(
    //         onTap: () {
    //           _getCurrentLocation();
    //         },
    //         child: Container(
    //           decoration: BoxDecoration(boxShadow: [
    //             BoxShadow(color: Colors.grey[350], blurRadius: 3.0)
    //           ], shape: BoxShape.circle),
    //           child: SvgPicture.asset(
    //             "assets/shop_assets/Group 12011.svg",
    //             fit: BoxFit.cover,
    //             height: 40,
    //             width: 40,
    //           ),
    //         ),
    //       ));
    // }

    Widget _body() {
      return Container(
        color: white_color,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _map(),
            _seachbar(),
            //_currentpostion(),
            _confirmLocation()
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: new_gradient_color,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
      child: SafeArea(
        bottom: false,
        top: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          // resizeToAvoidBottomPadding: false,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: GradientAppBar(
                title: 'My Address',
                color: white_text_color,
                size: 18,
                weight: FontWeight.w500,
                centerTitle: true,
                height: 100,
              )),
          body: _body(),
        ),
      ),
    );
  }

  Future<locationImport.LocationData> getGeoLocation() async {
    var _location = locationImport.Location();
    //final permissionStatus = await _location.hasPermission();
    var location;
    final servicesStatus = await _location.serviceEnabled();
    if (servicesStatus) {
      final position = await _location
          .getLocation()
          // ignore: null_argument_to_non_null_type
          .timeout(Duration(seconds: 15), onTimeout: () => Future.value(null));
      if ((position.latitude ?? 0) != 0) location = position;
      return location;
    }
    var _permission = await _location.requestPermission();
    if (_permission == locationImport.PermissionStatus.granted) {
      await _location.requestService();
      var servicesStatus = await _location.serviceEnabled();
      if (servicesStatus) {
        return await getGeoLocation();
      }
    }
    // ignore: null_argument_to_non_null_type
    return Future.value(null);
  }
}

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}
