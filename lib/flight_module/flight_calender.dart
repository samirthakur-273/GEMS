import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/flight_module/vertical_calender.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/constants_files/text_constants.dart';
import 'package:intl/intl.dart';

class CalenderPageFlight extends StatefulWidget {
  final DateTime? selectedStartDate;
  final DateTime? returnDate;
  final String? checkSingleorReturn;

  CalenderPageFlight(
      {required this.selectedStartDate,
      this.returnDate,
      this.checkSingleorReturn});

  @override
  _CalenderPageHotelState createState() => _CalenderPageHotelState();
}

class _CalenderPageHotelState extends State<CalenderPageFlight>
    with SingleTickerProviderStateMixin {
  final List<String> _weekDays = ['MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU'];
  DateSelection? dateSelection;
  int indexType = 0;

  @override
  void initState() {
    dateSelection =
        new DateSelection(widget.selectedStartDate, widget.returnDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: blue_color),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
            backgroundColor: white_color,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(90.0),
              child: GradientAppBar(
                title: "Select Dates",
                color: white_text_color,
                size: 18,
                weight: FontWeight.w500,
                centerTitle: true,
                height: 90,
              ),
            ),
            body: buildSingleDateSelect(),
            bottomNavigationBar:  Container(
              height: 90,
              child: Column(
                children: [
                  widget.checkSingleorReturn == "2"
                      ? Container(
                          height: 55,
                          width: 130,
                          margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
            
                          decoration: BoxDecoration(
                              gradient: gradient_theme_color,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24))),
                          child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop(dateSelection);
                              },
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: TextWidget(
                                      text: AppTexts.doneText,
                                      color: white_text_color,
                                      weight: FontWeight.w400,
                                      size: text_font_large20_size,
                                    ),
                                  ),
                                 
                                ],
                              )),
                        )
                      : Container(),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget buildAppBarReturn() {
    return Container(
      decoration: BoxDecoration(color: Colors.blue[900], boxShadow: [
        BoxShadow(blurRadius: 0.0, color: grey_gunsmoke_text_color)
      ]),
      child: Stack(children: <Widget>[
        Positioned.fill(
          child: Align(
            alignment: Alignment.topRight,
            child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 40, left: 20, right: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    indexType = 0;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextWidget(
                        text: "Departure",
                        size: 12,
                        color: Colors.grey,
                      ),
                      Row(children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          child: TextWidget(
                            text: DateFormat("dd")
                                .format(dateSelection!.selectedStartDate!),
                            color: Colors.white70,
                            alignment: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            size: 35,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextWidget(
                              text: DateFormat("MMM yy")
                                  .format(dateSelection!.selectedStartDate!),
                              color: Colors.white70,
                              alignment: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              size: 15,
                            ),
                            TextWidget(
                              text: DateFormat("EEEE")
                                  .format(dateSelection!.selectedStartDate!),
                              color: Colors.white70,
                              alignment: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              size: 15,
                            )
                          ],
                        )
                      ]),
                      SizedBox(
                        height: 2,
                      )
                    ],
                  ),
                ),
              ),
              widget.checkSingleorReturn != "2"
                  ? SizedBox(
                      width: 0,
                    )
                  : Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white70,
                        size: 30,
                      )),
              widget.checkSingleorReturn != "2"
                  ? SizedBox(
                      width: 0,
                    )
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          indexType = 1;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextWidget(
                              text: "Return",
                              size: 12,
                              color: Colors.grey,
                            ),
                            Row(children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                child: TextWidget(
                                  text: DateFormat("dd")
                                      .format(dateSelection!.returnDate!),
                                  color: Colors.white70,
                                  alignment: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  size: 35,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  TextWidget(
                                    text: DateFormat("MMM yy")
                                        .format(dateSelection!.returnDate!),
                                    color: Colors.white70,
                                    alignment: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    size: 15,
                                  ),
                                  TextWidget(
                                    text: DateFormat("EEEE")
                                        .format(dateSelection!.returnDate!),
                                    color: Colors.white70,
                                    alignment: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    size: 15,
                                  )
                                ],
                              )
                            ]),
                            SizedBox(
                              height: 2,
                            )
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        )
      ]),
    );
  }

  Widget buildSingleDateSelect() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, right: 15, top: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TextWidget(
                      text: "DEPART",
                      alignment: TextAlign.left,
                      color: flight_text_black_color,
                      weight: FontWeight.w300,
                      size: text_font_medium14_size,
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Container(
                      height: 35,
                      width: MediaQuery.of(context).size.width / 2.4,
                      decoration: BoxDecoration(
                          // border: Border(
                          //   bottom: BorderSide(width: 0.5, color: shadow_color),
                          // ),
                          ),
                      child: Row(
                        children: <Widget>[
                          SvgPicture.asset(ImageConstants.flt_calender,
                              height: 18, color: flight_blue_text_color),
                          SizedBox(
                            width: 5,
                          ),
                          TextWidget(
                            text: DateFormat("dd MMM yyyy")
                                .format(dateSelection!.selectedStartDate!),
                            size: text_font_medium16_size,
                            weight: FontWeight.w600,
                            color: flight_text_black_color,
                            // textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              widget.checkSingleorReturn == "2"
                  ? Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          TextWidget(
                            text: "RETURN",
                            alignment: TextAlign.left,
                            color: flight_text_black_color,
                            weight: FontWeight.w300,
                            size: text_font_medium14_size,
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Container(
                            height: 35,
                            width: MediaQuery.of(context).size.width / 2.4,
                            decoration: BoxDecoration(
                                // border: Border(
                                //   bottom:
                                //       BorderSide(width: 0.5, color: shadow_color),
                                // ),
                                ),
                            child: Row(
                              children: <Widget>[
                                SvgPicture.asset(ImageConstants.flt_calender,
                                    height: 18, color: flight_blue_text_color),
                                SizedBox(
                                  width: 5,
                                ),
                                TextWidget(
                                  text: DateFormat("dd MMM yyyy")
                                      .format(dateSelection!.returnDate!),
                                  size: text_font_medium16_size,
                                  weight: FontWeight.w600,
                                  color: flight_text_black_color,
                                  // textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container()
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          height: 6,
          width: MediaQuery.of(context).size.width,
          child: SvgPicture.asset(ImageConstants.flt_divider_line),
        ),
        Expanded(
          child: VerticalCalendar(
              minDate: DateTime.now(),
              maxDate: DateTime.now().add(const Duration(days: 365)),
              initialMaxDate: this.widget.checkSingleorReturn == "2"
                  ? dateSelection!.returnDate
                  : dateSelection!.selectedStartDate,
              initialMinDate: dateSelection!.selectedStartDate,
              onRangeSelected: (DateTime? d1, DateTime? d2) {
                setState(() {
                  if (widget.checkSingleorReturn != "2") {
                    dateSelection!.selectedStartDate = d1;
                    dateSelection!.returnDate = d1;
                    Navigator.of(context).pop(dateSelection);
                  } else {
                    dateSelection!.selectedStartDate = d1;
                    if (d2 == null) {
                      dateSelection!.returnDate = d1!.add(Duration(days: 2));
                    } else {
                      dateSelection!.returnDate = d2;
                    }
                  }
                });
              }),
        ),
      ],
    );
  }

  Widget buildReturnDateSelect() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 50,
          color: white_color,
        ),
        Container(
          height: 30,
          color: white_color,
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
                _weekDays.length,
                (index) => TextWidget(
                      text: _weekDays[index],
                      size: 15,
                    )),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: VerticalCalendar(
              minDate: dateSelection!.selectedStartDate!.add(Duration(days: 2)),
              maxDate: DateTime.now().add(const Duration(days: 365)),
              onRangeSelected: (DateTime? d1, DateTime? d2) {
                //Print('Range: from $d1 to $d2');
              }),
        ),
      ],
    );
  }
}

class DateSelection {
  DateTime? selectedStartDate;
  DateTime? returnDate;

  DateSelection(this.selectedStartDate, this.returnDate);
}
