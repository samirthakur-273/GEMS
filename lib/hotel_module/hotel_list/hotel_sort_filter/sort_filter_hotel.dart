import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:another_xlider/another_xlider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/checkinternet.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/numberformat.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/hotel_module/hotel_list/hotel_sort_filter/hotel_filter_model.dart';
import 'package:gems_revamp/hotel_module/hotel_list/hotel_sort_filter/hotel_filter_presenter.dart';
import 'package:gems_revamp/hotel_module/hotel_list/hotel_sort_filter/hotel_filter_view.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:gems_revamp/utils/time_out.dart';

class SortFilter extends StatefulWidget {
  final city, checkin, checkout, room, rqid, filtermenu;
  SortFilter(
      {Key? key,
      this.city,
      this.checkin,
      this.checkout,
      this.room,
      this.rqid,
      this.filtermenu})
      : super(key: key);

  @override
  _SortFilterState createState() => _SortFilterState();
}

class _SortFilterState extends State<SortFilter> implements FilterCountView {
  bool isstarRating = false,
      ispricelowtohigh = false,
      ispricehightolow = false,
      isuserRatingHL = false,
      isCancellation = false,
      isEarlyCheckin = false,
      isAbove = false,
      isfreeWifi = false,
      isfreebreak = false,
      isPrepay = false,
      isPayBounz = false,
      ishotel = false,
      isresort = false,
      isvilla = false,
      isUserRate5 = false,
      isUserRate4 = false,
      isUserRate3 = false,
      quickfreewifi = false,
      quickfreebreakfast = false;
  bool showpprty = false,
      showhtlaminity = false,
      showChaindata = false,
      showtheme = false,
      isLoading = true;
  String usercount5 = '0', usercount4 = '0', usercount3 = '0';
  int pprtycount = 0;
  int minvalue = 100;
  int maxvalue = 10000;
  String minval = '';
  String maxval = '';
  var _startvalue = '100';
  var _endvalue = '10000';
  List<double> range = [100, 10000];
  final _startrangecontroller = TextEditingController();
  final _endrangecontroller = TextEditingController();

  FilterCountPresenter? filterCountPresenter;
  List star = List.empty(growable: true);
  List price = List.empty(growable: true);
  List pprty = List.empty(growable: true);
  List htlchain = List.empty(growable: true);
  List htlamties = List.empty(growable: true);
  List htltheme = List.empty(growable: true);
  List starRatingData = List.empty(growable: true);
  List priceData = List.empty(growable: true);
  List custRatingData = List.empty(growable: true);
  List amenitiesData = List.empty(growable: true);
  List themesData = List.empty(growable: true);
  List chainData = List.empty(growable: true);
  List priceSlotData = List.empty(growable: true);
  List prprtyData = List.empty(growable: true);
  var filterdetails;
  String sortby = '',
      quickfilter = '',
      modeOfpayment = '',
      starrate = '',
      priceslot = '',
      prpttype = '',
      custrate = '',
      amenities = '',
      chain = '',
      theme = '';
  bool isempty = true;

  @override
  void initState() {
    super.initState();

    filterCountPresenter = FilterCountPresenter(this);
    setState(() {
      filterdetails = this.widget.filtermenu;
    });
    internet();
  }

/* initialize starrating */
  void addstar() {
    var count = starRatingData.length < 0 ? 0 : starRatingData.length;
    for (int j = 0; j < count; j++) {
      star.add(false);
    }
  }

/* initialize price */
  void addprice() {
    var slotcount = priceSlotData.length < 0 ? 0 : priceSlotData.length;
    for (int i = 0; i < slotcount; i++) {
      price.add(false);

      setState(() {
        if (i == 0) {
          minvalue = int.parse(
              priceSlotData[i].value.toString().split('-')[1].toString());
        } else if (i == (priceSlotData.length - 1)) {
          maxvalue = int.parse(
              priceSlotData[i].value.toString().split('-')[1].toString());
        }
      });
    }
    setState(() {
      range = [minvalue.toDouble(), maxvalue.toDouble()];
    });
  }

/* initialize property */
  void addpprty() {
    var pprtycount = prprtyData.length < 0 ? 0 : prprtyData.length;
    for (int i = 0; i < pprtycount; i++) {
      pprty.add(false);
    }
  }

/* initialize aminity */
  void addhtlaminity() {
    var htlcount = amenitiesData.length < 0 ? 0 : amenitiesData.length;
    for (int i = 0; i < htlcount; i++) {
      htlamties.add(false);
      if (amenitiesData[i].value.toString().contains('wifi')) {
        setState(() {
          quickfreewifi = true;
        });
      } else if (amenitiesData[i].value.toString().contains('Free Breakfast')) {
        setState(() {
          quickfreebreakfast = true;
        });
      }
    }
  }

/* initialize hotel chain */
  void addhtlchain() {
    var chaincount = chainData.length < 0 ? 0 : chainData.length;
    for (int i = 0; i < chaincount; i++) {
      htlchain.add(false);
    }
  }

/* initialize hotel theme */
  void addhtltheme() {
    var themecount = themesData.length < 0 ? 0 : themesData.length;
    for (int i = 0; i < themecount; i++) {
      htltheme.add(false);
    }
  }

  void internet() async {
    CheckInternet().apiCall().then((value) => {
          if (value == true)
            {
              setState(() {
                var req = {"rqid": "${this.widget.rqid}"};

                filterCountPresenter!.getFilterCount(req);
              }),
            }
          else
            {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => NoInternet()))
                  .then((value) {
                var req = {"rqid": "${this.widget.rqid}"};
                filterCountPresenter!.getFilterCount(req);
              }),
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return 

         Container(
          decoration: BoxDecoration(gradient: gradient_theme_color),
          child: SafeArea(
            top: false,
            bottom: true,
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(60.0),
                  child: GradientAppBar(
                    height: 90,
                    centerTitle: true,
                    title: "Sort & Filter",
                    size: 18,
                    weight: FontWeight.w600,
                    onLeftTap: () async {
                      Navigator.pop(context, filterdetails);
                    },
                  )),
              body: isLoading == true
                  ? SpinKitCircle(
                      color: blue_color,
                    )
                  : _body(),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 15),
                child: isLoading == true
                    ? new Container(
                        height: 0.0,
                      )
                    : botton(),
                ),
              ),
            ),
          // )
          );
  }

/* Common text widget */
  Widget _text(txt) {
    return TextWidget(
      text: txt,
      size: text_font_medium15_size,
      weight: FontWeight.w400 ,
    );
  }

/* Common heading text widget */

  Widget _headingtext(txt) {
    return TextWidget(
      text: txt,
      size: text_font_medium16_size,
      color: blackish,
      weight: FontWeight.w500,
    );
  }

  Widget _divider(ht) {
    return new SizedBox(
      height: ht,
    );
  }

  Widget _body() {
    return Container(
      color: Color(0XFFF6F8F6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 4.0),
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _sortBy(),
                _divider(20.0),
                _quickFilter(),
                _divider(20.0),
                starRatingData.length > 0 ? _starRating() : _divider(0.0),
                starRatingData.length > 0 ? _divider(20.0) : _divider(0.0),
                _price(),
                _divider(20.0),
                prprtyData.length > 0
                    ? _propertyType()
                    : Container(height: 0.0),
                prprtyData.length > 0 ? _divider(20.0) : _divider(0.0),
                amenitiesData.length > 0 ? _hotelAmenities() : _divider(0.0),
                amenitiesData.length > 0 ? _divider(20.0) : _divider(0.0),
                chainData.length > 0 ? _hotelChains() : _divider(0.0),
                chainData.length > 0 ? _divider(20.0) : _divider(0.0),
                themesData.length > 0 ? _hotelthemes() : _divider(0.0),
                themesData.length > 0 ? _divider(30.0) : _divider(0.0),
                _divider(20.0),
              ],
            )
          ],
        ),
      ),
    );
  }

/* Sort BY widget */
  Widget _sortBy() {
    return Container(
      decoration: BoxDecoration(
          color: white_text_color, borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.only(right: 0, left: 0),
      padding: EdgeInsets.all(10),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _headingtext('SORT BY'),
          new SizedBox(
            height: 20,
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _text('Star Rating',),
              InkWell(
                onTap: () {
                  setState(() {
                    isstarRating = !isstarRating;
                    if (isstarRating == true) {
                      ispricelowtohigh = false;
                      ispricehightolow = false;
                      isuserRatingHL = false;
                      sortby = 'star_desc';
                    } else {
                      sortby = '';
                    }
                    statusofResetbtn();
                  });
                },
                child: SvgPicture.asset(
                  isstarRating
                      ? ImageConstants.select_Option
                      : 
                      ImageConstants.unselect_Option,
                  height: 23,
                  width: 23,
                ),
              ),
            ],
          ),
          _divider(20.0),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _text('Price - Low to High'),
              InkWell(
                onTap: () {
                  setState(() {
                    ispricelowtohigh = !ispricelowtohigh;
                    if (ispricelowtohigh == true) {
                      ispricehightolow = false;
                      isuserRatingHL = false;
                      isstarRating = false;

                      sortby = 'price_lth';
                    } else {
                      sortby = '';
                    }
                    statusofResetbtn();
                  });
                },
                child: SvgPicture.asset(
                  ispricelowtohigh
                      ? ImageConstants.select_Option
                      : ImageConstants.unselect_Option,
                  height: 23,
                  width: 23,
                ),
              ),
            ],
          ),
          _divider(20.0),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _text('Price - High to Low'),
              InkWell(
                onTap: () {
                  setState(() {
                    ispricehightolow = !ispricehightolow;
                    if (ispricehightolow == true) {
                      ispricelowtohigh = false;

                      isuserRatingHL = false;
                      isstarRating = false;
                      sortby = 'price_htl';
                    } else {
                      sortby = '';
                    }
                    statusofResetbtn();
                  });
                },
                child: SvgPicture.asset(
                  ispricehightolow
                      ? ImageConstants.select_Option
                      : ImageConstants.unselect_Option,
                  height: 23,
                  width: 23,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

/* Quick filter widget */
  Widget _quickFilter() {
    return Container(
      decoration: BoxDecoration(
          color: white_text_color, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(10),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _headingtext('QUICK FILTERS'),
          new SizedBox(
            height: 0,
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _text('4 Star'),
              Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(
                    activeTrackColor: blue_color,
                    value: isAbove,
                    onChanged: (value) {
                      setState(() {
                        isAbove = value;
                        statusofResetbtn();
                      });
                    },
                  ))
            ],
          ),
          quickfreewifi ? _divider(10.0) : _divider(0.0),
          quickfreewifi
              ? new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _text('Free Wifi'),
                    Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          activeTrackColor: blue_color,
                          value: isfreeWifi,
                          onChanged: (value) {
                            setState(() {
                              isfreeWifi = value;
                              statusofResetbtn();
                            });
                          },
                        ))
                  ],
                )
              : new Container(
                  height: 0.0,
                ),
          quickfreebreakfast ? _divider(10.0) : _divider(0.0),
          quickfreebreakfast
              ? new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _text('Free BreakFast'),
                    Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          activeTrackColor: blue_color,
                          value: isfreebreak,
                          onChanged: (value) {
                            setState(() {
                              isfreebreak = value;
                              statusofResetbtn();
                            });
                          },
                        ))
                  ],
                )
              : new Container(
                  height: 0.0,
                ),
        ],
      ),
    );
  }

/* Star rating widget */
  Widget _starRating() {
    return Container(
      decoration: BoxDecoration(
          color: white_text_color, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(10),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _headingtext('STAR RATING'),
          Container(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: ListView.builder(
                reverse: true,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount:
                    starRatingData.length < 0 ? 0 : starRatingData.length,
                itemBuilder: (contex, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      _divider(12.0),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          _text(starRatingData[index].value == 0
                              ? 'Unrated (${starRatingData[index].count})'
                              : '${starRatingData[index].value} Star (${starRatingData[index].count})'),
                          Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                activeTrackColor: blue_color,
                                value: star[index],
                                onChanged: (value) {
                                  setState(() {
                                    star[index] = value;
                                    statusofResetbtn();
                                  });
                                },
                              ))
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

/* Range slider widget */
  Widget _slider() {
    return FlutterSlider(
      values: range,
      min: minvalue.toDouble(),
      max: maxvalue.toDouble(),
      rangeSlider: true,
      handlerWidth: 28,
      handlerHeight: 28,
      onDragCompleted: (handlerIndex, lowerValue, upperValue) {
        setState(() {
          _startvalue = lowerValue.toString().split('.')[0];
          _endvalue = upperValue.toString().split('.')[0];

          _startrangecontroller.text = _startvalue;
          _endrangecontroller.text = _endvalue;
          minval = _startvalue;
          maxval = _endvalue;
          range = [lowerValue, upperValue];
          statusofResetbtn();
        });
      },
      onDragStarted: (handlerIndex, lowerValue, upperValue) {
        setState(() {
          _startvalue = lowerValue.toString().split('.')[0];
          _endvalue = upperValue.toString().split('.')[0];

          _startrangecontroller.text = _startvalue;
          _endrangecontroller.text = _endvalue;
          minval = _startvalue;
          maxval = _endvalue;
          range = [lowerValue, upperValue];
          statusofResetbtn();
        });
      },
      onDragging: (handlerIndex, lowerValue, upperValue) {
        setState(() {
          _startvalue = lowerValue.toString().split('.')[0];
          _endvalue = upperValue.toString().split('.')[0];

          _startrangecontroller.text = _startvalue;
          _endrangecontroller.text = _endvalue;
          minval = _startvalue;
          maxval = _endvalue;
          range = [lowerValue, upperValue];
          statusofResetbtn();
        });
      },
      trackBar: FlutterSliderTrackBar(
        inactiveTrackBar: BoxDecoration(color: grey_color_300),
        activeTrackBarHeight: 3,
        activeTrackBar: BoxDecoration(color: blue_color),
      ),
      handler: FlutterSliderHandler(
        decoration: BoxDecoration(),
        child: Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
              color: blue_color, borderRadius: BorderRadius.circular(25)),
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
          height: 20,
          width: 20,
          decoration: BoxDecoration(
              color: blue_color, borderRadius: BorderRadius.circular(25)),
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

/* Price  widget */
  Widget _price() {
    return Container(
      decoration: BoxDecoration(
          color: white_text_color, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(10),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _headingtext('PRICE OF 1 NIGHT'),
          new SizedBox(
            height: 5,
          ),
          Container(
            child: _slider(),
          ),
          Container(
            padding: EdgeInsets.only(left: 1, top: 3, right: 1),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextWidget(
                    text: "AED " +
                        (_startrangecontroller.text.isEmpty
                            ? pointsFormatter(minvalue.toInt())
                            : pointsFormatter(
                                int.parse(_startrangecontroller.text))),
                    size: text_font_medium16_size ,
                    weight: FontWeight.w500,
                  ),
                ),
                TextWidget(
                  text: "AED " +
                      (_endrangecontroller.text.isEmpty
                          ? pointsFormatter(maxvalue.toInt())
                          : pointsFormatter(
                              int.parse(_endrangecontroller.text))),
                  size: text_font_medium16_size,
                  weight: FontWeight.w500,
                ),
              ],
            ),
          ),
          _divider(16.0),
          Container(
              child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: priceSlotData.length < 0 ? 0 : priceSlotData.length,
                itemBuilder: (contex, index) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        _divider(12.0),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            _text(index == 0
                                ? 'Upto AED ${pointsFormatter(int.parse(priceSlotData[index].value.toString().split('-')[1]))} (${priceSlotData[index].count})'
                                : 'AED ${pointsFormatter(int.parse(priceSlotData[index].value.toString().split('-')[0]))} - AED ${pointsFormatter(int.parse(priceSlotData[index].value.toString().split('-')[1]))} (${priceSlotData[index].count})s'),
                            Transform.scale(
                                scale: 0.8,
                                child: CupertinoSwitch(
                                  activeTrackColor: blue_color,
                                  value: price[index],
                                  onChanged: (value) {
                                    setState(() {
                                      for (int k = 0;
                                          k < priceSlotData.length;
                                          k++) {
                                        price[k] = false;
                                      }
                                      price[index] = value;
                                      statusofResetbtn();
                                    });
                                  },
                                ))
                          ],
                        ),
                      ]);
                }),
          )),
        ],
      ),
    );
  }

/* Propert type widget */
  Widget _propertyType() {
    return Container(
      decoration: BoxDecoration(
          color: white_text_color, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(10),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _headingtext('PROPERTY TYPE'),
          new SizedBox(
            height: 10,
          ),
          Container(
              child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: prprtyData.length < 0 ? 0 : prprtyData.length,
                      itemBuilder: (contex, index) {
                        return index < 3 || showpprty == true
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                    new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        _text(
                                            '${prprtyData[index].value} (${prprtyData[index].count})'),
                                        Transform.scale(
                                            scale: 0.8,
                                            child: CupertinoSwitch(
                                              activeTrackColor: blue_color,
                                              value: pprty[index],
                                              onChanged: (value) {
                                                setState(() {
                                                  pprty[index] = value;
                                                  statusofResetbtn();
                                                });
                                              },
                                            )),
                                      ],
                                    ),
                                    _divider(12.0),
                                  ])
                            : new Container();
                      }))),
          (prprtyData.length - 3) > 0 && showpprty == false
              ? InkWell(
                  onTap: () {
                    setState(() {
                      showpprty = true;
                    });
                  },
                  child: TextWidget(
                    text: "Show More (${(prprtyData.length - 3)})",
                    color: blue_color,
                    size: text_font_medium15_size ,
                    weight: FontWeight.w500,
                  ),
                )
              : new Container(),
        ],
      ),
    );
  }

/* Hotel amentity widget */
  Widget _hotelAmenities() {
    return Container(
      decoration: BoxDecoration(
          color: white_text_color, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(10),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          amenitiesData.length == 0
              ? new Container(
                  height: 0.0,
                )
              : _headingtext('AMENITIES'),
          amenitiesData.length == 0
              ? new Container(
                  height: 0.0,
                )
              : new SizedBox(
                  height: 10,
                ),
          amenitiesData.length == 0
              ? new Container(
                  height: 0.0,
                )
              : _headingtext('Hotel Amenities'),
          amenitiesData.length == 0
              ? new Container(
                  height: 0.0,
                )
              : new SizedBox(
                  height: 10,
                ),
          Container(
              child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          amenitiesData.length < 0 ? 0 : amenitiesData.length,
                      itemBuilder: (contex, index) {
                        return index < 3 || showhtlaminity == true
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                    new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        _text(
                                            '${amenitiesData[index].value} (${amenitiesData[index].count})'),
                                        Transform.scale(
                                            scale: 0.8,
                                            child: CupertinoSwitch(
                                              activeTrackColor: blue_color,
                                              value: htlamties[index],
                                              onChanged: (value) {
                                                setState(() {
                                                  htlamties[index] = value;
                                                  statusofResetbtn();
                                                });
                                              },
                                            ))
                                      ],
                                    ),
                                    _divider(12.0),
                                  ])
                            : new Container();
                      }))),
          (amenitiesData.length - 3) > 0 && showhtlaminity == false
              ? InkWell(
                  onTap: () {
                    setState(() {
                      showhtlaminity = true;
                    });
                  },
                  child: TextWidget(
                    text: "Show More (${(amenitiesData.length - 3)})",
                    color: blue_color,
                    size: 15,
                    weight: FontWeight.w500,
                  ),
                )
              : new Container(),
        ],
      ),
    );
  }

/* Hotel chain data widget */
  Widget _hotelChains() {
    return Container(
       decoration: BoxDecoration(
          color: white_text_color, borderRadius: BorderRadius.circular(10)),
     
      padding: EdgeInsets.all(10),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          chainData.length == 0
              ? new Container(
                  height: 0.0,
                )
              : _headingtext('HOTEL CHAINS'),
          chainData.length == 0
              ? new Container(
                  height: 0.0,
                )
              : new SizedBox(
                  height: 10,
                ),
          Container(
              child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: chainData.length < 0 ? 0 : chainData.length,
                      itemBuilder: (contex, index) {
                        return index < 3 || showChaindata == true
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                    new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        _text(
                                            '${chainData[index].value} (${chainData[index].count})'),
                                        Transform.scale(
                                            scale: 0.8,
                                            child: CupertinoSwitch(
                                              activeTrackColor: blue_color,
                                              value: htlchain[index],
                                              onChanged: (value) {
                                                setState(() {
                                                  htlchain[index] = value;
                                                  statusofResetbtn();
                                                });
                                              },
                                            ))
                                      ],
                                    ),
                                    _divider(12.0),
                                  ])
                            : new Container();
                      }))),
          (chainData.length - 3) > 0 && showChaindata == false
              ? InkWell(
                  onTap: () {
                    setState(() {
                      showChaindata = true;
                    });
                  },
                  child: TextWidget(
                    text: "Show More (${(chainData.length - 3)})",
                    color: blue_color,
                    size: 15,
                    weight: FontWeight.w500,
                  ),
                )
              : new Container(),
        ],
      ),
    );
  }

/* Hotel theme widget */
  Widget _hotelthemes() {
    return Container(
       decoration: BoxDecoration(
          color: white_text_color, borderRadius: BorderRadius.circular(10)),
     
      padding: EdgeInsets.all(10),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          themesData.length == 0
              ? new Container(
                  height: 0.0,
                )
              : _headingtext('HOTEL THEMES'),
          themesData.length == 0
              ? new Container(
                  height: 0.0,
                )
              : new SizedBox(
                  height: 10,
                ),
          Container(
              child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: themesData.length < 0 ? 0 : themesData.length,
                      itemBuilder: (contex, index) {
                        return index < 3 || showtheme == true
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                    new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        _text(
                                            '${themesData[index].value} (${themesData[index].count})'),
                                        Transform.scale(
                                            scale: 0.8,
                                            child: CupertinoSwitch(
                                              activeTrackColor: blue_color,
                                              value: htltheme[index],
                                              onChanged: (value) {
                                                setState(() {
                                                  htltheme[index] = value;
                                                  statusofResetbtn();
                                                });
                                              },
                                            ))
                                      ],
                                    ),
                                    _divider(12.0),
                                  ])
                            : new Container();
                      }))),
          (themesData.length - 3) > 0 && showtheme == false
              ? InkWell(
                  onTap: () {
                    setState(() {
                      showtheme = true;
                    });
                  },
                  child: TextWidget(
                    text: "Show More (${(themesData.length - 3)})",
                    color: blue_color,
                    size: 15,
                    weight: FontWeight.w500,
                  ),
                )
              : new Container(),
        ],
      ),
    );
  }

/* set applied filter */
  void addFilterData() {
    setState(() {
      if (this.widget.filtermenu != null) {
        isempty = false;
        var filterdata = this.widget.filtermenu['filterreq'];

        if (this.widget.filtermenu['freewifi'] == true) {
          isfreeWifi = true;
        }
        if (this.widget.filtermenu['freebreakfast'] == true) {
          isfreebreak = true;
        }
        if (this.widget.filtermenu['4star'] == true) {
          isAbove = true;
        }
        // set sort by value ====================
        if (filterdata['sortby'] != '') {
          if (filterdata['sortby'] == 'usr_rate_htl') {
            isuserRatingHL = true;
            sortby = filterdata['sortby'];
          } else if (filterdata['sortby'] == 'price_htl') {
            ispricehightolow = true;
            sortby = filterdata['sortby'];
          } else if (filterdata['sortby'] == 'price_lth') {
            ispricelowtohigh = true;
            sortby = filterdata['sortby'];
          } else if (filterdata['sortby'] == 'star_desc') {
            isstarRating = true;
            sortby = filterdata['sortby'];
          }
        }
        // set start rating======================
        if (filterdata['starRating'] != '') {
          var startrate = filterdata['starRating'].toString().split(',');

          for (int st = 0; st < starRatingData.length; st++) {
            for (int i = 0; i < startrate.length; i++) {
              if (int.parse(startrate[i]) == 4 &&
                  isAbove == true &&
                  starRatingData[st].value == 4) {
              } else if (int.parse(startrate[i]) == starRatingData[st].value) {
                star[st] = true;
              }
            }
          }
        }

        // set price slot ====================
        if (filterdata['min_price'] != '' && filterdata['max_price'] != '') {
          bool israngeval = false;
          for (int i = 0; i < priceSlotData.length; i++) {
            if (filterdata['min_price'] ==
                    priceSlotData[i].value.toString().split('-')[0] &&
                filterdata['max_price'] ==
                    priceSlotData[i].value.toString().split('-')[1]) {
              price[i] = true;
              israngeval = false;
              break;
            } else {
              israngeval = true;
            }
          }
          if (israngeval == true) {
            int start = int.parse(filterdata['min_price']);
            int end = int.parse(filterdata['max_price']);
            range = [start.toDouble(), end.toDouble()];

            _startrangecontroller.text = filterdata['min_price'];
            _endrangecontroller.text = filterdata['max_price'];
            minval = filterdata['min_price'];
            maxval = filterdata['max_price'];
          }
        }
        // set propert type=====================
        if (filterdata['prop_type'] != '') {
          var propType = filterdata['prop_type'].toString().split(',');
          for (int p = 0; p < propType.length; p++) {
            for (int k = 0; k < prprtyData.length; k++) {
              if (prprtyData[k].id.toString() == propType[p].toString()) {
                pprty[k] = true;
              }
            }
          }
        }
        // set amenities=====================
        if (filterdata['amentis'] != '') {
          var aminty = filterdata['amentis'].toString().split(',');
          for (int l = 0; l < aminty.length; l++) {
            for (int k = 0; k < amenitiesData.length; k++) {
              if (amenitiesData[k].id.toString() == aminty[l].toString()) {
                if (amenitiesData[k].value.toString().contains('wifi') &&
                    isfreeWifi == true) {
                  htlamties[k] = false;
                } else if (amenitiesData[k]
                        .value
                        .toString()
                        .contains('Free Breakfast') &&
                    isfreebreak == true) {
                  htlamties[k] = false;
                } else {
                  htlamties[k] = true;
                }
              }
            }
          }
        }

        // set theme=====================
        if (filterdata['themes'] != '') {
          var themes = filterdata['themes'].toString().split(',');
          for (int t = 0; t < themes.length; t++) {
            for (int k = 0; k < themesData.length; k++) {
              if (themesData[k].id.toString() == themes[t].toString()) {
                htltheme[k] = true;
              }
            }
          }
        }
        // set chain data=====================
        if (filterdata['chain_data'] != '') {
          var chainData = filterdata['chain_data'].toString().split(',');
          for (int c = 0; c < chainData.length; c++) {
            for (int k = 0; k < chainData.length; k++) {
              if (chainData[k].toString() == chainData[c].toString()) {
                htlchain[k] = true;
              }
            }
          }
        }
      }
    });
  }

/* Apply and reset button */
  Widget botton() {
    return Container(
      child:  Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
           Expanded(
             child: GestureDetector(
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
                onTap: () {
                  var _data;
                  setState(() {
                    setstarrating();
           
                    setPrice();
                    setPrpty();
                    setAmenity();
                    setChaindata();
                    setTheme();
           
                    if (sortby.isEmpty &&
                        starrate.isEmpty &&
                        custrate.isEmpty &&
                        prpttype.isEmpty &&
                        amenities.isEmpty &&
                        minval.isEmpty &&
                        maxval.isEmpty &&
                        theme.isEmpty &&
                        chain.isEmpty) {
                      isempty = true;
                    }
                    var filterdet = {
                      "rqid": "${this.widget.rqid}",
                      "sortby": sortby,
                      "starRating": starrate,
                      "amentis": amenities,
                      "min_price": minval,
                      "max_price": maxval,
                      "themes": theme,
                      "usr_rating": custrate,
                      "prop_type": prpttype,
                      "chain_data": chain
                    };
           
                    _data = {
                      "freewifi": isfreeWifi,
                      "freebreakfast": isfreebreak,
                      "4star": isAbove,
                      "filterreq": filterdet,
                      "isEmpty": isempty
                    };
                  });
           
                  Navigator.pop(context, _data);
                }),
           ),
            SizedBox(
              width: 20,
            ),
           Expanded(
             child: GestureDetector(
                child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Color(0xFFf4f4f4),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            width: 0.8, color: black_color.withAlpha((0.2 * 255).toInt()),)),
                    child: Center(
                      child: TextWidget(
                        text: 'Reset',
                        size: text_font_medium15_size,
                        color: isempty ? grey_background : text_color,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ),
                onTap: () {
                  resetData();
                }),
           ),
        ],
      ),
    );
  }

/* set star rating */
  void setstarrating() {
    setState(() {
      for (int i = 0; i < starRatingData.length; i++) {
        if (starRatingData[i].value == 4 && isAbove == true) {
          if (starrate.isEmpty) {
            starrate = '${starRatingData[i].value}';
          } else {
            starrate = starrate + ',${starRatingData[i].value}';
          }
        } else if (star[i] == true) {
          if (starrate.isEmpty) {
            starrate = '${starRatingData[i].value}';
          } else {
            starrate = starrate + ',${starRatingData[i].value}';
          }
        }
      }
    });
  }

/* set Price */
  void setPrice() {
    setState(() {
      for (int j = 0; j < priceSlotData.length; j++) {
        if (price[j] == true) {
          minval = priceSlotData[j].value.toString().split('-')[0].toString();
          maxval = priceSlotData[j].value.toString().split('-')[1].toString();
        }
      }
    });
  }

/* set Property */
  void setPrpty() {
    setState(() {
      for (int k = 0; k < prprtyData.length; k++) {
        if (pprty[k] == true) {
          if (prpttype.isEmpty) {
            prpttype = '${prprtyData[k].id}';
          } else {
            prpttype = prpttype + ',${prprtyData[k].id}';
          }
        }
      }
    });
  }

/* set Amentity */
  void setAmenity() {
    setState(() {
      for (int l = 0; l < amenitiesData.length; l++) {
        if (isfreeWifi == true &&
            amenitiesData[l].value.toString().contains('wifi')) {
          if (amenities.isEmpty) {
            amenities = '${amenitiesData[l].id}';
          } else {
            amenities = amenities + ',${amenitiesData[l].id}';
          }
        }
        if (isfreebreak == true &&
            amenitiesData[l].value.toString().contains('Free Breakfast')) {
          if (amenities.isEmpty) {
            amenities = '${amenitiesData[l].id}';
          } else {
            amenities = amenities + ',${amenitiesData[l].id}';
          }
        }
        if (htlamties[l] == true) {
          if (amenities.isEmpty) {
            amenities = '${amenitiesData[l].id}';
          } else {
            amenities = amenities + ',${amenitiesData[l].id}';
          }
        }
      }
    });
  }

/* set chain data */
  void setChaindata() {
    setState(() {
      for (int m = 0; m < chainData.length; m++) {
        if (htlchain[m] == true) {
          if (chain.isEmpty) {
            chain = '${chainData[m].id}';
          } else {
            chain = chain + ',${chainData[m].id}';
          }
        }
      }
    });
  }

/* set theme data */
  void setTheme() {
    setState(() {
      for (int n = 0; n < themesData.length; n++) {
        if (htltheme[n] == true) {
          if (theme.isEmpty) {
            theme = '${themesData[n].id}';
          } else {
            theme = theme + ',${themesData[n].id}';
          }
        }
      }
    });
  }

/* Reset status */
  void statusofResetbtn() {
    setState(() {
      if (isfreebreak == false &&
          isfreeWifi == false &&
          isAbove == false &&
          ispricelowtohigh == false &&
          ispricehightolow == false &&
          isuserRatingHL == false &&
          isstarRating == false &&
          star.contains(true) == false &&
          price.contains(true) == false &&
          pprty.contains(true) == false &&
          htlamties.contains(true) == false &&
          htlchain.contains(true) == false &&
          htltheme.contains(true) == false &&
          minval == '' &&
          maxval == '') {
        isempty = true;
      } else {
        isempty = false;
      }
    });
  }

/* reset all data  */
  void resetData() {
    setState(() {
      sortby = '';
      starrate = '';
      amenities = '';
      theme = '';
      custrate = '';
      prpttype = '';
      chain = '';
      isUserRate3 = false;
      isUserRate4 = false;
      isUserRate5 = false;
      minval = '';
      maxval = '';
      isfreebreak = false;
      isfreeWifi = false;
      isAbove = false;
      ispricelowtohigh = false;
      ispricehightolow = false;
      isuserRatingHL = false;
      isstarRating = false;
      isPayBounz = false;
      isPrepay = false;

      for (int k = 0; k < priceSlotData.length; k++) {
        if (k == 0) {
          minvalue = int.parse(
              priceSlotData[k].value.toString().split('-')[1].toString());
        } else if (k == (priceSlotData.length - 1)) {
          maxvalue = int.parse(
              priceSlotData[k].value.toString().split('-')[1].toString());
        }
      }

      _startvalue = minvalue.toString();
      _endvalue = maxvalue.toString();
      _startrangecontroller.clear();
      _endrangecontroller.clear();

      range = [minvalue.toDouble(), maxvalue.toDouble()];

      for (int i = 0; i < starRatingData.length; i++) {
        star[i] = false;
      }
      for (int j = 0; j < priceSlotData.length; j++) {
        price[j] = false;
      }
      for (int k = 0; k < prprtyData.length; k++) {
        pprty[k] = false;
      }
      for (int l = 0; l < amenitiesData.length; l++) {
        htlamties[l] = false;
      }

      for (int m = 0; m < chainData.length; m++) {
        htlchain[m] = false;
      }
      for (int n = 0; n < themesData.length; n++) {
        htltheme[n] = false;
      }
      statusofResetbtn();
    });
  }

  @override
  void filterCountresponse(FilterCount filterCount) async {
    if (filterCount.status == true) {
      setState(() {
        starRatingData = filterCount.values?.filterMenu?.starRating ?? [];
        priceData = filterCount.values?.filterMenu?.priceData ?? [];
        custRatingData = filterCount.values?.filterMenu?.custRating ?? [];
        amenitiesData = filterCount.values?.filterMenu?.amenities ?? [];
        themesData = filterCount.values?.filterMenu?.themesData ?? [];
        chainData = filterCount.values?.filterMenu?.chainData ?? [];
        priceSlotData = filterCount.values?.filterMenu?.priceSlot ?? [];
        prprtyData = filterCount.values?.filterMenu?.prprtyData ?? [];

        for (int c = 0; c < custRatingData.length; c++) {
          if (custRatingData[c].value == '0') {
            usercount3 = '0';
            usercount4 = '0';
            usercount5 = '0';
          } else if (custRatingData[c].value == '3') {
            usercount3 = custRatingData[c].value;
          } else if (custRatingData[c].value == '4') {
            usercount4 = custRatingData[c].value;
          } else if (custRatingData[c].value == '4') {
            usercount4 = custRatingData[c].value;
          } else if (custRatingData[c].value == '5') {
            usercount5 = custRatingData[c].value;
          }
        }
        addstar();
        addprice();
        addpprty();
        addhtlaminity();
        addhtlchain();
        addhtltheme();
        addFilterData();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      if (filterCount.message == "timeout") {
        var notresponding = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => TimeOut()));
        if (notresponding != null) {
          setState(() {
            isLoading = true;
          });
          internet();
        } else {
          Navigator.pop(context);
        }
      }
    }
  }

  @override
  void allErr(error) async {
    // await Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => NoResultFound(
    //                 "images/hotel/placeholder.png", error.toString())))
    //     .then((value) {
    //   Navigator.pop(context);
    // });
  }
}
