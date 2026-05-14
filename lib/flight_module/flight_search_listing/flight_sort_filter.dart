/*
Auther Name: Animesh Banerjee
Discription : This is the flight FILTER PAGE
*/
import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/flight_module/common_widget/flight_appbar.dart';
import 'package:gems_revamp/flight_module/flight_search_listing/return_srch_modal.dart'
    as ret;
import 'package:gems_revamp/flight_module/flight_search_listing/search_list_model.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';

class Filter extends StatefulWidget {
  final FlightsMenu? flightsMenuSingle;
  final ret.FlightsMenu? flightsMenuRetrn;
  final String tripTyp;
  final callBackData;
  final nonStpFLT;
  Filter({
    required this.flightsMenuSingle,
    required this.flightsMenuRetrn,
    required this.tripTyp,
    required this.callBackData,
    required this.nonStpFLT,
    Key? key,
  }) : super(key: key);

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> with SingleTickerProviderStateMixin {
  late TabController _controller;

  ScrollController? _scrollController = ScrollController();

  List _sortDataList = [
    'Price',
    "Duration",
    "Departure",
    "Arrival",
  ];
  bool _refund = false;
  String? _sortByData;
  int tabIndex = 0;
  ret.FlightsMenu? flightsMenuRetrnValue;

  int? _selectedSortBy;
  int? _selectedDeparture;
  int? _depMin;
  int? _depMax;
  int? _selectedStp;
  final _startrangecontroller = TextEditingController();
  final _endrangecontroller = TextEditingController();
  int minvalue = 100;
  int maxvalue = 10000;
  var _startvalue = '100';
  var _endvalue = '10000';
  List _isSelectedANM = [];
  List _stps = [];
  List _selectedStps = [];
  double? _minStrt;
  double? _maxStrt;
  bool _sortSelected = true;
  bool _resetData = false;
  List<double>? _values;
  bool _addArilines = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    // _scrollController!.animateTo(_scrollController!.position.maxScrollExtent,
    // duration: Duration(seconds: 1), curve: Curves.ease);
    //     .then((value) async {
    //   await Future.delayed(Duration(seconds: 2));
    //   _controller.animateTo(_controller.position.minScrollExtent,
    //       duration: Duration(seconds: 1), curve: Curves.ease);
    // });
    // });
    flightsMenuRetrnValue = widget.flightsMenuRetrn;
    _controller = TabController(length: 2, vsync: this);
    if (widget.tripTyp == "1") {
      minvalue = widget.flightsMenuSingle?.normal?.stats?.totalPrice?.min ?? 0;
      maxvalue = widget.flightsMenuSingle?.normal?.stats?.totalPrice?.max ?? 0;
    } else {
      minvalue = flightsMenuRetrnValue?.normal?.stats?.totalPrice?.min ?? 0;
      maxvalue = flightsMenuRetrnValue?.normal?.stats?.totalPrice?.max ?? 0;
    }

    if (widget.nonStpFLT == true && widget.callBackData == null) {
      _selectedStp = 0;
      _selectedStps.clear();
      _selectedStps.add(0);
      _resetData = true;
    }
    if (widget.callBackData != null) {
      _refund = widget.callBackData["is_refund"] == 0 ? false : true;

      switch (widget.callBackData["sort_by"]) {
        case "prc_lth":
          _sortSelected = false;
          _selectedSortBy = 0;
          _sortByData = "prc_lth";
          break;
        case "prc_htl":
          _sortSelected = true;
          _selectedSortBy = 0;
          _sortByData = "prc_htl";
          break;
        case "jtym_htl":
          _sortSelected = true;
          _selectedSortBy = 1;
          _sortByData = "jtym_htl";
          break;
        case "jtym_lth":
          _sortSelected = false;
          _selectedSortBy = 1;
          _sortByData = "jtym_lth";
          break;
        case "dtym_htl":
          _sortSelected = true;
          _sortByData = "dtym_htl";
          _selectedSortBy = 2;
          break;
        case "dtym_lth":
          _sortSelected = false;
          _sortByData = "dtym_lth";
          _selectedSortBy = 2;
          break;
        case "atym_htl":
          _sortSelected = true;
          _sortByData = "atym_htl";
          _selectedSortBy = 3;
          break;
        case "atym_lth":
          _sortSelected = false;
          _sortByData = "atym_lth";
          _selectedSortBy = 3;
          break;
        case "pnts_htl":
          _sortSelected = true;
          _sortByData = "pnts_htl";
          _selectedSortBy = 4;
          break;
        case "pnts_lth":
          _sortSelected = false;
          _sortByData = "pnts_lth";
          _selectedSortBy = 4;
          break;
        default:
      }

      switch (widget.callBackData["pa_dtym_min"]) {
        case 0:
          _selectedDeparture = 1;
          _resetData = true;
          _depMin = 00;
          _depMax = 06;
          break;
        case 6:
          _selectedDeparture = 2;
          _resetData = true;
          _depMin = 06;
          _depMax = 12;
          break;
        case 12:
          _selectedDeparture = 3;
          _resetData = true;
          _depMin = 12;
          _depMax = 18;
          break;
        case 18:
          _selectedDeparture = 4;
          _resetData = true;
          _depMin = 18;
          _depMax = 00;
          break;
        default:
      }
      if (widget.callBackData["stp"] != null) {
        switch (widget.callBackData["stp"][0]) {
          case 0:
            _selectedStp = 0;
            _selectedStps.clear();
            _selectedStps.add(0);
            _resetData = true;
            break;
          case 1:
            _selectedStp = 1;
            _selectedStps.clear();
            _selectedStps.add(1);
            _resetData = true;
            break;
          case 2:
            _selectedStp = 2;
            _selectedStps.clear();
            _selectedStps.add(2);
            _resetData = true;
            break;
          default:
        }
      }
      if (widget.callBackData["min_price"] != '' &&
          widget.callBackData["max_price"] != '') {
        _minStrt = double.parse(widget.callBackData["min_price"]);
        _maxStrt = double.parse(widget.callBackData["max_price"]);
        _startrangecontroller.text = widget.callBackData["min_price"];
        _endrangecontroller.text = widget.callBackData["max_price"];
        _values = [_minStrt!, _maxStrt!];
      } else {
        if (widget.tripTyp == "1") {
          _values = [
            widget.flightsMenuSingle?.normal?.stats?.totalPrice?.min
                    ?.roundToDouble() ??
                0.0,
            widget.flightsMenuSingle?.normal?.stats?.totalPrice?.max
                    ?.roundToDouble() ??
                0.0
          ];
          _startvalue =
              "${widget.flightsMenuSingle?.normal?.stats?.totalPrice?.min ?? 0}";
          _endvalue =
              "${widget.flightsMenuSingle?.normal?.stats?.totalPrice?.max ?? 0}";
        } else {
          _values = [
            flightsMenuRetrnValue?.normal?.stats?.totalPrice?.min
                    ?.roundToDouble() ??
                0.0,
            flightsMenuRetrnValue?.normal?.stats?.totalPrice?.max
                    ?.roundToDouble() ??
                0.0
          ];
          _startvalue =
              "${flightsMenuRetrnValue?.normal?.stats?.totalPrice?.min ?? 0}";
          _endvalue =
              "${flightsMenuRetrnValue?.normal?.stats?.totalPrice?.max ?? 0}";
        }
      }
    } else {
      if (widget.tripTyp == "1") {
        _startvalue =
            "${widget.flightsMenuSingle?.normal?.stats?.totalPrice?.min ?? 0}";
        _endvalue =
            "${widget.flightsMenuSingle?.normal?.stats?.totalPrice?.max ?? 0}";
        _values = [
          widget.flightsMenuSingle?.normal?.stats?.totalPrice?.min
                  ?.roundToDouble() ??
              0.0,
          widget.flightsMenuSingle?.normal?.stats?.totalPrice?.max
                  ?.roundToDouble() ??
              0.0
        ];
      } else {
        _startvalue =
            "${flightsMenuRetrnValue?.normal?.stats?.totalPrice?.min ?? 0}";
        _endvalue =
            "${flightsMenuRetrnValue?.normal?.stats?.totalPrice?.max ?? 0}";
        _values = [
          flightsMenuRetrnValue?.normal?.stats?.totalPrice?.min
                  ?.roundToDouble() ??
              0.0,
          flightsMenuRetrnValue?.normal?.stats?.totalPrice?.max
                  ?.roundToDouble() ??
              0.0
        ];
      }
    }

    _controller.addListener(() {
      setState(() {});
    });

    final _list = widget.flightsMenuSingle?.normal?.pivot?.anm ?? [];
    if (widget.tripTyp == "1") {
      for (int i = 0; i < _list.length; i++) {
        if (widget.callBackData != null && widget.callBackData["anm"] != null) {
          for (var a = 0; a < widget.callBackData["anm"].length; a++) {
            if ((_list[i].value ?? '')
                .contains(widget.callBackData["anm"][a])) {
              _isSelectedANM
                  .add({"status": true, "name": widget.callBackData["anm"][a]});
              _addArilines = false;
              _resetData = true;
              break;
            } else {
              _addArilines = true;
            }
          }
          if (_addArilines) {
            _isSelectedANM.add({"status": false, "name": ""});
          }
        } else {
          _isSelectedANM.add({"status": false, "name": ""});
        }
      }

      _stps = widget.flightsMenuSingle?.normal?.pivot?.stp ?? [];
    } else {
      for (int i = 0; i < _list.length; i++) {
        if (widget.callBackData != null && widget.callBackData["anm"] != null) {
          for (var a = 0; a < widget.callBackData["anm"].length; a++) {
            if ((_list[i].value ?? '')
                .contains(widget.callBackData["anm"][a])) {
              _isSelectedANM
                  .add({"status": true, "name": widget.callBackData["anm"][a]});
              _addArilines = false;
              _resetData = true;
              break;
            } else {
              _addArilines = true;
            }
          }

          if (_addArilines) {
            _isSelectedANM.add({"status": false, "name": ""});
          }
        } else {
          _isSelectedANM.add({"status": false, "name": ""});
        }
      }
      _stps = flightsMenuRetrnValue?.normal?.pivot?.stp ?? [];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _appbar() {
      return Container(
        child: FlightGradientAppBarWidget(
          title: "Sort & Filter",
          color: white_text_color,
          size: text_font_medium17_size,
          weight: FontWeight.w500,
          // onLeftTap: () {
          //   return Container();
          // },
          // height: 80,
        ),
      );
    }

    Widget _title(String title) {
      return TextWidget(
        text: title,
        size: text_font_medium16_size,
        color: flight_text_black_color,
        weight: FontWeight.w500,
      );
    }

    // Widget _tabs() {
    //   return Container(
    //     height: 50,
    //     width: MediaQuery.of(context).size.width / 1.5,
    //     color: white_text_color,
    //     child: AppBar(
    //       elevation: 0.0,
    //       bottom: TabBar(
    //         isScrollable: false,
    //         indicator: UnderlineTabIndicator(
    //             insets: EdgeInsets.only(left: 10, right: 10),
    //             borderSide: BorderSide(color: golden_yellow, width: 3)),
    //         tabs: [
    //           Container(
    //             padding: EdgeInsets.only(bottom: 10),
    //             child: TextWidget(
    //               text: "Onward",
    //               color: _controller.index == 0
    //                   ? golden_yellow
    //                   : grey_gunsmoke_text_color,
    //               size: 18,
    //               weight: FontWeight.bold,
    //             ),
    //           ),
    //           Container(
    //             padding: EdgeInsets.only(bottom: 10),
    //             child: TextWidget(
    //               text: "Return",
    //               color: _controller.index == 1
    //                   ? golden_yellow
    //                   : grey_gunsmoke_text_color,
    //               size: 18,
    //               weight: FontWeight.w500,
    //             ),
    //           ),
    //         ],
    //         controller: _controller,
    //         indicatorColor: Colors.white,
    //         indicatorSize: TabBarIndicatorSize.tab,
    //       ),
    //       bottomOpacity: 1,
    //     ),
    //   );
    // }

    Widget _tabsFilter() {
      return Container(
        margin: EdgeInsets.only(top: 15, left: 20, right: 20),
        width: MediaQuery.of(context).size.width,
        height: 45,
        decoration: BoxDecoration(
            color: flt_bg_grey_color, borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: <Widget>[
            Expanded(
                child: InkWell(
              onTap: () {
                setState(() {
                  tabIndex = 0;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    gradient: tabIndex == 0
                        ? gradient_theme_color
                        : gradient_grey_theme_color,
                    borderRadius: BorderRadius.circular(20)),
                margin: EdgeInsets.only(top: 5, bottom: 5, left: 5),
                child: Center(
                  child: TextWidget(
                    text: 'Onward',
                    color: tabIndex == 0
                        ? white_text_color
                        : flight_text_black_color,
                    weight: FontWeight.w600,
                    size: text_font_medium15_size,
                  ),
                ),
              ),
            )),
            Expanded(
                child: InkWell(
              onTap: () {
                setState(() {
                  tabIndex = 1;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    gradient: tabIndex == 1
                        ? gradient_theme_color
                        : gradient_grey_theme_color,
                    borderRadius: BorderRadius.circular(20)),
                margin: EdgeInsets.only(top: 5, bottom: 5, right: 5),
                child: Center(
                  child: TextWidget(
                    text: 'Return',
                    color: tabIndex == 1
                        ? white_text_color
                        : flight_text_black_color,
                    weight: FontWeight.w600,
                    size: text_font_medium15_size,
                  ),
                ),
              ),
            )),
          ],
        ),
      );
    }

    Widget _dep(String path, duration, id, int? selected) {
      return Column(
        children: <Widget>[
          Image.asset(
            path,
            height: 50,
            color: selected == id ? appbar_color : flight_text_black_color,
          ),
          SizedBox(
            height: 15,
          ),
          TextWidget(
              text: duration,
              size: text_font_medium15_size,
              color: flight_text_black_color,
              weight: selected == id ? FontWeight.w600 : FontWeight.normal)
        ],
      );
    }

    Widget _selectStps() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _stps.length > 0
              ? InkWell(
                  onTap: () {
                    _selectedStp = 0;
                    _selectedStps.clear();
                    _selectedStps.add(0);
                    _resetData = true;
                    setState(() {});
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 55,
                        width: 55,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 0.5,
                              color: _selectedStp == 0
                                  ? appbar_color
                                  : shadow_color),
                        ),
                        child: TextWidget(
                          text: "0",
                          size: text_font_medium17_size,
                          color: _selectedStp == 0
                              ? appbar_color
                              : grey_background,
                          weight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(
                  height: 0,
                ),
          SizedBox(
            width: 20,
          ),
          _stps.length > 1
              ? InkWell(
                  onTap: () {
                    _selectedStp = 1;
                    _selectedStps.clear();
                    _selectedStps.add(1);
                    _resetData = true;
                    setState(() {});
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 55,
                        width: 55,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 0.5,
                              color: _selectedStp == 1
                                  ? appbar_color
                                  : shadow_color),
                        ),
                        child: TextWidget(
                          text: "1",
                          size: text_font_medium17_size,
                          color: _selectedStp == 1
                              ? appbar_color
                              : grey_background,
                          weight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(height: 0),
          SizedBox(
            width: 20,
          ),
          _stps.length > 2
              ? InkWell(
                  onTap: () {
                    _selectedStp = 2;
                    _selectedStps.clear();
                    _selectedStps.add(2);
                    _resetData = true;
                    setState(() {});
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 55,
                        width: 55,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 0.5,
                              color: _selectedStp == 2
                                  ? appbar_color
                                  : shadow_color),
                        ),
                        child: TextWidget(
                          text: "2+",
                          size: text_font_medium17_size,
                          color: _selectedStp == 2
                              ? appbar_color
                              : grey_background,
                          weight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(
                  height: 0,
                )
        ],
      );
    }

    Widget _departure() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _title("DEPARTURE"),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      _selectedDeparture = 1;
                      _resetData = true;
                      _depMin = 00;
                      _depMax = 06;
                      setState(() {});
                    },
                    child: _dep(ImageConstants.flt_nightTomorning, '00 - 06', 1,
                        _selectedDeparture)),
                InkWell(
                  onTap: () {
                    _selectedDeparture = 2;
                    _resetData = true;
                    _depMin = 06;
                    _depMax = 12;
                    setState(() {});
                  },
                  child: _dep(ImageConstants.flt_morningToafternooon, '06 - 12',
                      2, _selectedDeparture),
                ),
                InkWell(
                  onTap: () {
                    _selectedDeparture = 3;
                    _resetData = true;
                    _depMin = 12;
                    _depMax = 18;
                    setState(() {});
                  },
                  child: _dep(ImageConstants.flt_afternoonToEvening, '12 - 18',
                      3, _selectedDeparture),
                ),
                InkWell(
                  onTap: () {
                    _selectedDeparture = 4;
                    _resetData = true;
                    _depMin = 18;
                    _depMax = 00;
                    setState(() {});
                  },
                  child: _dep(ImageConstants.flt_eveningTonight, '18 - 00', 4,
                      _selectedDeparture),
                )
              ],
            )
          ],
        ),
      );
    }

    Widget _stops() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _title("STOPS"),
            SizedBox(
              height: 15,
            ),
            _selectStps(),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      );
    }

    Widget _slider() {
      return FlutterSlider(
        values: _values!,
        min: minvalue.toDouble(),
        max: maxvalue.toDouble(),
        rangeSlider: true,
        handlerWidth: 25,
        handlerHeight: 25,
        onDragging: (handlerIndex, lowerValue, upperValue) {
          setState(() {
            _startvalue = lowerValue.toString().split('.')[0];
            _endvalue = upperValue.toString().split('.')[0];
            _startrangecontroller.text = _startvalue;
            _endrangecontroller.text = _endvalue;
            _resetData = true;
            _values = [lowerValue, upperValue];
          });
        },
        onDragCompleted: (handlerIndex, lowerValue, upperValue) {
          setState(() {
            _startvalue = lowerValue.toString().split('.')[0];
            _endvalue = upperValue.toString().split('.')[0];
            _startrangecontroller.text = _startvalue;
            _endrangecontroller.text = _endvalue;
            _resetData = true;
            _values = [lowerValue, upperValue];
          });
        },
        onDragStarted: (handlerIndex, lowerValue, upperValue) {
          setState(() {
            _startvalue = lowerValue.toString().split('.')[0];
            _endvalue = upperValue.toString().split('.')[0];
            _startrangecontroller.text = _startvalue;
            _endrangecontroller.text = _endvalue;
            _resetData = true;
            _values = [lowerValue, upperValue];
          });
        },
        trackBar: FlutterSliderTrackBar(
          inactiveTrackBar: BoxDecoration(color: grey_color_300),
          activeTrackBarHeight: 4,
          activeTrackBar: BoxDecoration(color: appbar_color),
        ),
        handler: FlutterSliderHandler(
          decoration: BoxDecoration(),
          child: Container(
            decoration: BoxDecoration(
                color: appbar_color, borderRadius: BorderRadius.circular(25)),
            padding: EdgeInsets.all(2),
            child: Container(
              decoration: BoxDecoration(
                  color: white_text_color,
                  borderRadius: BorderRadius.circular(25)),
            ),
          ),
        ),
        jump: true,
        rightHandler: FlutterSliderHandler(
          decoration: BoxDecoration(),
          child: Container(
            decoration: BoxDecoration(
                color: appbar_color, borderRadius: BorderRadius.circular(25)),
            padding: EdgeInsets.all(2),
            child: Container(
              decoration: BoxDecoration(
                  color: white_text_color,
                  borderRadius: BorderRadius.circular(25)),
            ),
          ),
        ),
      );
    }

    Widget _applyBtn() {
      return Container(
        // height: 50,
        color: white_text_color,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        width: MediaQuery.of(context).size.width,

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  List _anm = [];
                  for (int i = 0; i < _isSelectedANM.length; i++) {
                    if (_isSelectedANM[i]["status"] == true) {
                      _anm.add(_isSelectedANM[i]["name"]);
                    }
                  }

                  var _filterData = {
                    "search_code": widget.tripTyp == "1"
                        ? "${widget.flightsMenuSingle?.searchCode ?? ""}"
                        : "${flightsMenuRetrnValue?.searchCode ?? ""}",
                    "is_refund": _refund == true ? 1 : 0,
                    "sort_by": _sortByData,
                    "min_price": _startrangecontroller.text,
                    "max_price": _endrangecontroller.text,
                    "stp": _selectedStps.length > 0 ? _selectedStps : null,
                    "anm": _anm.length > 0 ? _anm : null,
                    "pa_dtym_min": _depMin,
                    "pa_dtym_max": _depMax,
                  };
                  setState(() {});
                  Navigator.pop(context, _filterData);
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: gradient_theme_color,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: TextWidget(
                      text: 'Apply',
                      size: text_font_medium15_size,
                      color: white_text_color,
                      weight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _sortByData = null;
                  _selectedSortBy = null;
                  _refund = false;
                  _selectedStps.clear();
                  _selectedStp = null;
                  _startrangecontroller.clear();
                  _endrangecontroller.clear();
                  _selectedDeparture = null;
                  _depMin = null;
                  _depMax = null;

                  for (var i = 0; i < _isSelectedANM.length; i++) {
                    _isSelectedANM[i]["status"] = false;
                    // _isSelectedANM[i]["name"] = null;
                  }
                  _resetData = false;
                  if (widget.tripTyp == "1") {
                    minvalue = widget.flightsMenuSingle?.normal?.stats
                            ?.totalPrice?.min ??
                        0;
                    maxvalue = widget.flightsMenuSingle?.normal?.stats
                            ?.totalPrice?.max ??
                        0;
                    _startvalue =
                        "${widget.flightsMenuSingle?.normal?.stats?.totalPrice?.min ?? 0}";
                    _endvalue =
                        "${widget.flightsMenuSingle?.normal?.stats?.totalPrice?.max ?? 0}";
                  } else {
                    minvalue =
                        flightsMenuRetrnValue?.normal?.stats?.totalPrice?.min ??
                            0;
                    maxvalue =
                        flightsMenuRetrnValue?.normal?.stats?.totalPrice?.max ??
                            0;
                    _startvalue =
                        "${flightsMenuRetrnValue?.normal?.stats?.totalPrice?.min ?? 0}";
                    _endvalue =
                        "${flightsMenuRetrnValue?.normal?.stats?.totalPrice?.max ?? 0}";
                  }
                  _values = [minvalue.toDouble(), maxvalue.toDouble()];

                  setState(() {});
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          width: 0.8, color: black_color.withOpacity(0.2))),
                  child: Center(
                    child: TextWidget(
                      text: 'Reset',
                      size: text_font_medium15_size,
                      color: _resetData ? grey_background : text_color,
                      weight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        // child: Row(
        //   children: <Widget>[
        //     Expanded(
        //       child: GradientButtonWidget(
        //         borderRadius: BorderRadius.circular(24),
        //         onTap: () {
        //           List _anm = [];
        //           for (int i = 0; i < _isSelectedANM.length; i++) {
        //             if (_isSelectedANM[i]["status"] == true) {
        //               _anm.add(_isSelectedANM[i]["name"]);
        //             }
        //           }

        //           var _filterData = {
        //             "search_code": widget.tripTyp == "1"
        //                 ? "${widget.flightsMenuSingle?.searchCode ?? ""}"
        //                 : "${flightsMenuRetrnValue?.searchCode ?? ""}",
        //             "is_refund": _refund == true ? 1 : 0,
        //             "sort_by": _sortByData,
        //             "min_price": _startrangecontroller.text,
        //             "max_price": _endrangecontroller.text,
        //             "stp": _selectedStps.length > 0 ? _selectedStps : null,
        //             "anm": _anm.length > 0 ? _anm : null,
        //             "pa_dtym_min": _depMin,
        //             "pa_dtym_max": _depMax,
        //           };
        //           setState(() {});
        //           Navigator.pop(context, _filterData);
        //         },
        //         shadowColor: BoxShadow(
        //             color: flight_text_black_color.withOpacity(0.1),
        //             offset: new Offset(0, 10.0),
        //             blurRadius: 10.0,
        //             spreadRadius: 2.0),
        //         child: TextWidget(
        //           text: 'Apply',
        //           size: text_font_medium17_size,
        //           color: white_text_color,
        //           weight: FontWeight.w500,
        //         ),
        //       ),
        //     ),
        //     SizedBox(
        //       width: 15,
        //     ),
        //     Expanded(
        //       child: GradientButtonWidget(
        //         borderRadius: BorderRadius.circular(26),
        //         onTap: _resetData
        //             ? () {
        //                 _sortByData = null;
        //                 _selectedSortBy = null;
        //                 _refund = false;
        //                 _selectedStps.clear();
        //                 _selectedStp = null;
        //                 _startrangecontroller.clear();
        //                 _endrangecontroller.clear();

        //                 _selectedDeparture = null;
        //                 _depMin = null;
        //                 _depMax = null;

        //                 // for (var i = 0; i < _isSelectedANM.length; i++) {
        //                 //   _isSelectedANM[i]["status"] = false;
        //                 //   _isSelectedANM[i]["name"] = null;
        //                 // }
        //                 _resetData = false;
        //                 if (widget.tripTyp == "1") {
        //                   minvalue = widget.flightsMenuSingle?.normal?.stats
        //                           ?.totalPrice?.min ??
        //                       0;
        //                   maxvalue = widget.flightsMenuSingle?.normal?.stats
        //                           ?.totalPrice?.max ??
        //                       0;
        //                   _startvalue =
        //                       "${widget.flightsMenuSingle?.normal?.stats?.totalPrice?.min ?? 0}";
        //                   _endvalue =
        //                       "${widget.flightsMenuSingle?.normal?.stats?.totalPrice?.max ?? 0}";
        //                 } else {
        //                   minvalue = flightsMenuRetrnValue
        //                           ?.normal?.stats?.totalPrice?.min ??
        //                       0;
        //                   maxvalue = flightsMenuRetrnValue
        //                           ?.normal?.stats?.totalPrice?.max ??
        //                       0;
        //                   _startvalue =
        //                       "${flightsMenuRetrnValue?.normal?.stats?.totalPrice?.min ?? 0}";
        //                   _endvalue =
        //                       "${flightsMenuRetrnValue?.normal?.stats?.totalPrice?.max ?? 0}";
        //                 }
        //                 _values = [minvalue.toDouble(), maxvalue.toDouble()];

        //                 setState(() {});
        //               }
        //             : () {},
        //         gradientcolor: _resetData
        //             ? gradient_theme_color
        //             : gradient_grey_theme_color,
        //         shadowColor: BoxShadow(
        //             color: flight_text_black_color.withOpacity(0.09),
        //             offset: new Offset(0, 10.0),
        //             blurRadius: 10.0,
        //             spreadRadius: 2.0),
        //         child: TextWidget(
        //           text: 'Reset',
        //           size: text_font_medium17_size,
        //           color: _resetData ? white_text_color : text_color,
        //           weight: FontWeight.w500,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      );
    }

    Widget price() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: _title("PRICE")),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: _slider(),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextWidget(
                    text: "AED " +
                        (_startrangecontroller.text.isEmpty
                            ? gemsPointsFormatter(minvalue)
                            : gemsPointsFormatter(
                                int.parse(_startrangecontroller.text))),
                    size: text_font_medium16_size,
                    weight: FontWeight.w500,
                  ),
                ),
                TextWidget(
                  text: "AED " +
                      (_endrangecontroller.text.isEmpty
                          ? gemsPointsFormatter(maxvalue)
                          : gemsPointsFormatter(
                              int.parse(_endrangecontroller.text))),
                  size: text_font_medium16_size,
                  weight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget _filters() {
      return Container(
        decoration: BoxDecoration(
            color: white_text_color, borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.only(right: 20, left: 20),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: _title('FILTERS'),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                if (_refund) {
                  _refund = false;
                } else {
                  _refund = true;
                }
                _resetData = true;
                setState(() {});
              },
              child: Container(
                color: transColor,
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(width: 0.5),
                            color: white_text_color),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: SvgPicture.asset(
                            ImageConstants.select,
                            color: !_refund ? blue_color : transColor,
                          ),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    TextWidget(
                      text: 'Refundable flights',
                      size: text_font_medium15_size,
                      color: black_color,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            _departure(),
            SizedBox(
              height: 10,
            ),
            _stops(),
            SizedBox(
              height: 10,
            ),
            price(),
          ],
        ),
      );
    }

    Widget _card(int index, anm) {
      return InkWell(
        onTap: () {},
        child: Container(
          margin: EdgeInsets.only(left: 0, right: 20),
          color: transColor,
          child: Row(
            children: <Widget>[
              Container(
                height: 30,
                child: Checkbox(
                    value: _isSelectedANM[index]["status"] ? true : false,
                    activeColor: appbar_color,
                    onChanged: (value) {
                      _isSelectedANM[index]["status"] =
                          !_isSelectedANM[index]["status"];

                      _isSelectedANM[index]["name"] = anm?.value ?? "";
                      if (_isSelectedANM[index]["status"] == true) {
                        _resetData = true;
                      }
                      setState(() {});
                    }),
              ),
              TextWidget(
                text: "${anm.value ?? ""} (${anm.count})",
                size: text_font_medium15_size,
                color: text_color,
              ),
              Spacer(),
              TextWidget(
                text:
                    "AED ${gemsPointsFormatter(anm.stats?.statsFields?.totalPrice?.min ?? 0)}",
                size: text_font_medium15_size,
                color: text_color,
              )
            ],
          ),
        ),
      );
    }

    // Widget _cardRetrn(int index, ret.Anm anm) {
    //   return InkWell(
    //     onTap: () {},
    //     child: Container(
    //       margin: EdgeInsets.symmetric(vertical: 5),
    //       color: transColor,
    //       child: Row(
    //         children: <Widget>[
    //           Container(
    //             height: 30,
    //             child: Checkbox(
    //                 value: _isSelectedANM[index]["status"] ? true : false,
    //                 activeColor: golden_yellow,
    //                 onChanged: (value) {
    //                   _isSelectedANM[index]["status"] =
    //                       !_isSelectedANM[index]["status"];

    //                   _isSelectedANM[index]["name"] = anm?.value ?? "";
    //                   _resetData = true;
    //                   setState(() {});
    //                 }),
    //           ),
    //           TextWidget(
    //             text: "${anm?.value ?? ""} (${anm?.count})",
    //             size: 15,
    //             color: text_color,
    //           ),
    //           Spacer(),
    //           TextWidget(
    //             text:
    //                 "AED ${gemsPointsFormatter(anm?.stats?.statsFields?.totalPrice?.min ?? 0)}",
    //             size: 15,
    //             color: text_color,
    //           )
    //         ],
    //       ),
    //     ),
    //   );
    // }

    Widget _sortCard(int index, String title) {
      return InkWell(
        onTap: () {
          _selectedSortBy = index;
          _sortSelected = !_sortSelected;
          switch (_selectedSortBy) {
            case 0:
              if (_sortSelected) {
                _sortByData = "prc_htl";
              } else {
                _sortByData = "prc_lth";
              }
              break;
            case 1:
              if (_sortSelected) {
                _sortByData = "jtym_htl";
              } else {
                _sortByData = "jtym_lth";
              }
              break;
            case 2:
              if (_sortSelected) {
                _sortByData = "dtym_htl";
              } else {
                _sortByData = "dtym_lth";
              }
              break;
            case 3:
              if (_sortSelected) {
                _sortByData = "atym_htl";
              } else {
                _sortByData = "atym_lth";
              }
              break;

            default:
          }

          

          setState(() {
            _resetData = true;
          });
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          color: transColor,
          child: Row(
            children: <Widget>[
              _selectedSortBy == index
                  ? RotatedBox(
                      quarterTurns:
                          _selectedSortBy == index && _sortSelected ? 3 : 1,
                      child: SvgPicture.asset(
                        ImageConstants.flt_line_arrow_right,
                        height: 12,
                        color: appbar_color,
                      ),
                    )
                  : SizedBox(
                      width: 12,
                    ),
              SizedBox(
                width: 5,
              ),
              TextWidget(
                text: title,
                size: text_font_medium15_size,
                color: _selectedSortBy == index
                    ? appbar_color
                    : flight_text_black_color,
              ),
              Spacer(),
              if (_selectedSortBy == 0 && _selectedSortBy == index)
                TextWidget(
                  text: !_sortSelected ? "Low to High" : "High To Low",
                  size: text_font_medium15_size,
                  color: appbar_color,
                ),
              if (_selectedSortBy == 1 && _selectedSortBy == index)
                TextWidget(
                  text: !_sortSelected ? "Shortest First" : "Longest First",
                  size: text_font_medium15_size,
                  color: appbar_color,
                ),
              if (_selectedSortBy == 2 && _selectedSortBy == index)
                TextWidget(
                  text: !_sortSelected ? "Earlier First" : "Latest First",
                  size: text_font_medium15_size,
                  color: appbar_color,
                ),
              if (_selectedSortBy == 3 && _selectedSortBy == index)
                TextWidget(
                  text: !_sortSelected ? "Earlier First" : "Latest First",
                  size: text_font_medium15_size,
                  color: appbar_color,
                ),
              if (_selectedSortBy == 4 && _selectedSortBy == index)
                TextWidget(
                  text: !_sortSelected ? "Lowest First" : "Highest First",
                  size: text_font_medium15_size,
                  color: appbar_color,
                ),
            ],
          ),
        ),
      );
    }

    Widget _airlineList(FlightsMenu? flightsMenu) {
      final _list = flightsMenu?.normal?.pivot?.anm ?? [];
      return Container(
        // height: 500,
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _list.length,
            itemBuilder: (context, index) => _card(index, _list[index])),
      );
    }

    // Widget _airlineListRetrn(ret.FlightsMenu flightsMenu) {
    //   return ListView.builder(
    //       shrinkWrap: true,
    //       physics: NeverScrollableScrollPhysics(),
    //       itemCount: flightsMenu?.normal?.pivot?.anm?.length ?? 0,
    //       itemBuilder: (context, index) =>
    //           _cardRetrn(index, flightsMenu?.normal?.pivot?.anm[index]));
    // }

    Widget _sortData() {
      return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _sortDataList.length,
          itemBuilder: (context, index) =>
              _sortCard(index, _sortDataList[index]));
    }

    Widget _airlines() {     
      return Container(
        decoration: BoxDecoration(
            color: white_text_color, borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.only(right: 20, left: 20),
        // padding: EdgeInsets.only(right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: _title("AIRLINES"),
            ),
            SizedBox(
              height: 10,
            ),
            // widget.tripTyp == "1"
            //     ?
            _airlineList(widget.flightsMenuSingle)
            // : _airlineListRetrn(flightsMenuRetrnValue)
          ],
        ),
      );
    }

    Widget _sortBy() {
      return Container(
        decoration: BoxDecoration(
            color: white_text_color, borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.only(right: 20, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: _title("SORT BY"),
            ),
            SizedBox(
              height: 10,
            ),
            _sortData(),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    }

    Widget _body() {
      return Container(
        color: searchbar,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            widget.tripTyp == "1"
                ? SizedBox(
                    height: 0,
                  )
                : _tabsFilter(),
            SizedBox(
              height: 25,
            ),
            Expanded(
                child: ListView(
              children: [
                _sortBy(),
                SizedBox(
                  height: 20,
                ),
                _filters(),
                SizedBox(
                  height: 20,
                ),
               widget.flightsMenuSingle?.normal?.pivot?.anm == null?
               Container(height: 0,):
                _airlines(),
                SizedBox(
                  height: 20,
                ),
              ],
            )),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(gradient: gradient_theme_color),
      child: SafeArea(
          top: false,
          bottom: true,
          child: Scaffold(
            backgroundColor: white_text_color,
            appBar: PreferredSize(
                child: _appbar(), preferredSize: Size.fromHeight(60)),
            body: _body(),
            bottomNavigationBar: _applyBtn(),
          )),
    );
  }
}
