/* 
Animesh Banerjee
date- May 2021
*/

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/flight_module/flight_source_destination/flight_search_city_model.dart';
import 'package:gems_revamp/flight_module/flight_source_destination/flight_search_city_presenter.dart';
import 'package:gems_revamp/flight_module/flight_source_destination/flight_search_list_view.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';

class FlightSearchCity extends StatefulWidget {
  final String? hint;
  FlightSearchCity(this.hint);

  @override
  _FlightSearchCityState createState() => _FlightSearchCityState();
}

class _FlightSearchCityState extends State<FlightSearchCity>
    implements FlightSearchCityView {
  late FlightSearchCityPresenter flightSearchPresenter;
  bool isPolularCities = true, isData = true, isLoading = true;
  FlightSearchCityModel? _flightSearchCityModel;
  String? _text;
  final TextEditingController controller = TextEditingController();

  var _noConnection;

  @override
  void initState() {
    flightSearchPresenter = FlightSearchCityPresenter(this);
    _apicall();

    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  void _apicall() {
    Internetconnectivity().isConnected().then((isConnected) async {
      if (isConnected == true) {
        flightSearchPresenter.popularCityFn(this);
      } else {
        _noConnection = await Navigator.of(context).pushNamed('noInternetpage');

        if (_noConnection != null) {
          isLoading = true;

          flightSearchPresenter.popularCityFn(this);
        } else {
          isLoading = false;
          isPolularCities = false;
          Navigator.pop(context);
          setState(() {});
        }
      }
    });
  }

  Widget _appbarGradient() {
    return Container(
      child: GradientAppBar(
        title: 'Search '
            "${widget.hint == "From Where?" ? "Source" : "Destination"}",
        color: white_text_color,
        size: 19,
        height: 95,
        weight: FontWeight.w600,
        centerTitle: true,
      ),
    );
  }

  Widget appBar() {
    return Row(
      children: <Widget>[
        Expanded(
            child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: flight_search_color,
                  // border: Border.all(width: 0.5, color: flight_search_color),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                margin:
                    EdgeInsets.only(top: 15, left: 10, bottom: 5, right: 10),
                padding: EdgeInsets.only(left: 8),
                child: TextField(
                  autofocus: false,
                  controller: controller,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 7, left: 5),
                      hintText: widget.hint,
                      hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          color: flight_text_black_color,
                          fontSize: text_font_small,
                          fontWeight: FontWeight.w600),
                      suffixIcon: Visibility(
                        visible: controller.text.length > 0 ? true : false,
                        child: IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 20,
                            ),
                            color: flight_text_black_color,
                            onPressed: () {
                              controller.clear();
                            }),
                      )),
                  style:
                      TextStyle(color: grey_gunsmoke_text_color, fontSize: 14),
                  onChanged: (text) {
                    if (text.length > 2) {
                      setState(() {
                        isPolularCities = false;
                        _text = text;
                        Internetconnectivity()
                            .isConnected()
                            .then((isConnected) async {
                          if (isConnected == true) {
                            flightSearchPresenter.searchCity(this, text);
                            isLoading = true;
                          } else {
                            _noConnection = await Navigator.of(context)
                                .pushNamed('noInternetpage');
                            if (_noConnection != null) {
                              flightSearchPresenter.searchCity(this, text);
                              isLoading = true;
                            } else {
                              isLoading = false;
                              Navigator.pop(context);
                            }
                          }
                        });
                      });
                    }
                  },
                ))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _body() {
      return Container(
        child: Column(
          children: <Widget>[
            appBar(),
            Expanded(
                child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // isPolularCities
                        //     ?
                        TextWidget(
                          text: 'Popular Cities',
                          size: text_font_medium18_size,
                          color: flight_text_black_color,
                          weight: FontWeight.w700,
                        ),
                        //  : Container(),
                        SizedBox(
                          height: 20,
                        ),
                        isPolularCities
                            ? Expanded(child: _popularCitiesList())
                            : Expanded(child: decisionWidget())
                      ],
                    )))
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(gradient: gradient_theme_color),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
            appBar: PreferredSize(
                child: _appbarGradient(), preferredSize: Size.fromHeight(80.0)),
            body: _body()),
      ),
    );
  }

  Widget decisionWidget() {
    /**This widget shows the list of cities and if no data is found then the no data message is shown */
    if (isLoading) {
      return Container(
        child: Center(
            child: Container(
                height: 100,
                width: 100,
                child: SpinKitCircle(
                  color: appbar_color,
                ))),
      );
    } else {
      if ((_flightSearchCityModel?.values?.length ?? 0) > 0) {
        return theList();
      } else {
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
              width: MediaQuery.of(context).size.width,
              color: transColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 7,
                  ),
                  // Image.asset(
                  //   AppAssets.nodatapng,
                  //   height: 120,
                  // ),
                  SizedBox(
                    height: 25,
                  ),
                  TextWidget(
                    text: 'No records found',
                    size: 22,
                    weight: FontWeight.bold,
                  ),
                ],
              )),
        );
      }
    }
  }

  Widget theList() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Material(
            child: InkWell(
              splashColor: Colors.grey,
              onTap: () {
                Navigator.pop(context, _flightSearchCityModel?.values![index]);
              },
              child: Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 5),
                      // alignment: Alignment.topLeft,
                      height: 30,
                      width: 30,
                      child: SvgPicture.asset(
                          ImageConstants.flt_sourcedestination)),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextWidget(
                            text:
                                '${_flightSearchCityModel?.values![index].cityName}',
                            weight: FontWeight.bold,
                            color: Colors.black54,
                            maxLines: 1,
                            size: 14,
                          ),
                          TextWidget(
                            text:
                                '${_flightSearchCityModel?.values![index].airportName}',
                            size: 10,
                            color: Colors.black54,
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ]),
                  ),
                  Container(
                    width: 50,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.grey),
                        color: Colors.grey[200]),
                    child: Container(
                      alignment: Alignment.center,
                      child: TextWidget(
                        text:
                            '${_flightSearchCityModel?.values![index].airportCode}',
                        weight: FontWeight.bold,
                        color: Colors.black45,
                        size: 12,
                      ),
                    ),
                  ),
                ],
              )),
            ),
          );
        },
        itemCount: _flightSearchCityModel?.values!.length ?? 0,
      ),
    );
  }

  Widget _popularCitiesList() {
    if (isLoading) {
      return Container(
        child: Center(
            child: Container(
                height: 100,
                width: 100,
                child: SpinKitCircle(
                  color: appbar_color,
                ))),
      );
    } else {
      return Container(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Material(
              child: InkWell(
                splashColor: Colors.grey,
                onTap: () {
                  Navigator.pop(
                      context, _flightSearchCityModel?.values![index]);
                },
                child: Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 5),
                        // alignment: Alignment.topLeft,
                        height: 30,
                        width: 30,
                        child: SvgPicture.asset(
                            ImageConstants.flt_sourcedestination)),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextWidget(
                              text:
                                  '${_flightSearchCityModel?.values?[index].cityName}',
                              weight: FontWeight.w600,
                              color: grey_background,
                              maxLines: 1,
                              size: text_font_medium15_size,
                            ),
                            TextWidget(
                              text:
                                  '${_flightSearchCityModel?.values?[index].airportName}',
                              size: text_font_small_10_size,
                              color: grey_background,
                              weight: FontWeight.w500,
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ]),
                    ),
                    Container(
                      width: 50,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border: Border.all(color: shadow_color),
                          color: flt_bg_grey_color),
                      child: Container(
                        alignment: Alignment.center,
                        child: TextWidget(
                          text:
                              '${_flightSearchCityModel?.values?[index].airportCode}',
                          weight: FontWeight.w500,
                          color: grey_background,
                          size: text_font_size_small,
                        ),
                      ),
                    ),
                  ],
                )),
              ),
            );
          },
          itemCount: _flightSearchCityModel!.values?.length ?? 0,
        ),
      );
    }
  }

  @override
  void flightSearchCiyResponse(FlightSearchCityModel response) async {
    // TODO: implement flightSearchCiyResponse

    if ((response.message ?? '').contains("timeout")) {
      var notresponding = await Navigator.of(context).pushNamed('/timeoutpage');
      if (notresponding != null) {
        flightSearchPresenter.searchCity(this, _text);
      } else {
        Navigator.pop(context);
      }
    } else {
      setState(() {
        isLoading = false;
        _flightSearchCityModel = response;
      });
    }
  }

  @override
  void flightpopularCityResponse(FlightSearchCityModel response) {
    _flightSearchCityModel = response;

    isLoading = false;
    setState(() {});
  }

  @override
  void networkError(err) async {
isLoading = false;
    setState(() {});
    if (err is FormatException) {
      var notresponding = await Navigator.of(context).pushNamed('/timeoutpage');
      if (notresponding != null) {
        flightSearchPresenter.searchCity(this, _text);
      } else {
        Navigator.pop(context);
      }
    }
    if (err.toString().contains("TimeoutException")) {
      Navigator.of(context).pushNamed('/timeoutpage');
    }
  }
}

// Widget locationStrip() {
//   return Container(
//     height: 30,
//     decoration: BoxDecoration(
//         color: Color(GlobalValues.themeColorApp),
//         borderRadius: BorderRadius.all(Radius.circular(15))),
//     child: Row(
//       children: <Widget>[
//         Container(
//           height: 30,
//           padding: EdgeInsets.all(5),
//           decoration: BoxDecoration(
//               color: Color(GlobalValues.themeColorApp),
//               borderRadius: BorderRadius.all(Radius.circular(15))),
//           child: Icon(
//             Icons.gps_fixed,
//             color: Colors.white,
//             size: 18,
//           ),
//         ),
//         SizedBox(
//           width: 10,
//         ),
//         TextWidget(
//           text: 'Airport Near me',
//           size: 12,
//           color: Colors.white,
//         )
//       ],
//     ),
//   );
// }


