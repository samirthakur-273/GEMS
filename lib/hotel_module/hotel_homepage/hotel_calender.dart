import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/flight_module/vertical_calender.dart';
import 'package:intl/intl.dart';

import '../../common_widget/bottombar.dart';
import '../../utils/constants_files/text_constants.dart';

class CalenderPageHotel extends StatefulWidget {
  DateTime? selectedStartDate;
  DateTime? returnDate;

  CalenderPageHotel({required this.selectedStartDate, this.returnDate});

  @override
  _CalenderPageHotelState createState() => _CalenderPageHotelState();
}

class _CalenderPageHotelState extends State<CalenderPageHotel>
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
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90.0),
          child: GradientAppBar(
            title: AppTexts.selectDatesText,
            color: white_text_color,
            size: 18,
            weight: FontWeight.w500,
            centerTitle: true,
            height: 90,
          ),
        ),
        body: buildSingleDateSelect(),
        bottomNavigationBar: InkWell(
            onTap: () {
              Navigator.of(context).pop(dateSelection);
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Container(
                height: 50,
                  decoration: BoxDecoration(
                      gradient: gradient_theme_color,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Align(
                    alignment: Alignment.center,
                    child: TextWidget(
                      text: AppTexts.doneText,
                      color: Colors.white,
                      weight: FontWeight.w500,
                      size: 20,
                    ),
                  )),
            ),
          ),
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
          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
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
                        text: "Check-in",
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
              Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white70,
                    size: 30,
                  )),
              GestureDetector(
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
                        text: "Check-out",
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

  Widget _tabbar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      // color: black_color,
      child: BottomBar(
        initialIndex: 0,
        tabvalue: "Home",
        //goback: true
      ),
    );
  }

  Widget buildSingleDateSelect() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, right: 15, top: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 2.25,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: grey_color),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      TextWidget(
                        text: "Check-In",
                        alignment: TextAlign.left,
                        size: text_font_medium19_size,
                        weight: FontWeight.normal,
                      ),
                      TextWidget(
                        text: DateFormat("dd MMM yyyy")
                            .format(dateSelection!.selectedStartDate!),
                        size: text_font_medium19_size,
                        weight: FontWeight.w700,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2.25,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: grey_color),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      TextWidget(
                        text: "Check-Out",
                        alignment: TextAlign.left,
                        size: text_font_medium19_size,
                        weight: FontWeight.normal,
                      ),
                      TextWidget(
                        text: DateFormat("dd MMM yyyy")
                            .format(dateSelection!.returnDate!),
                        size: text_font_medium19_size,
                        weight: FontWeight.w700,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height / 1.5,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: white_text_color,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: VerticalCalendar(
              minDate: DateTime.now(),
              maxDate: DateTime.now().add(const Duration(days: 365)),
              initialMaxDate: dateSelection!.returnDate,
              initialMinDate: dateSelection!.selectedStartDate,
              onRangeSelected: (DateTime? d1, DateTime? d2) {
                setState(() {
                  dateSelection!.selectedStartDate = d1;
                  if (d2 == null) {
                    dateSelection!.returnDate = d1!.add(Duration(days: 1));
                  } else {
                    dateSelection!.returnDate = d2;
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
          color: white_text_color,
        ),
        Container(
          height: 30,
          color: white_text_color,
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
              minDate: dateSelection!.selectedStartDate!.add(Duration(days: 1)),
              maxDate: DateTime.now().add(const Duration(days: 365)),
              onRangeSelected: (DateTime? d1, DateTime? d2) {
              }),
        ),
      ],
    );
  }

  Widget _appBar() {
    return Container(
      height: 100,
      decoration: BoxDecoration(color: white_text_color, boxShadow: [
        BoxShadow(blurRadius: 0.0, color: grey_gunsmoke_text_color)
      ]),
      child: Stack(children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    child: Image(
                        image: AssetImage("images/flight/46.png"),
                        color: blue_color,
                        height: 25,
                        width: 25)),
                Container(
                  alignment: Alignment.center,
                  child: TextWidget(
                    text: "Departure",
                    color: black_color,
                    size: text_font_large20_size,
                    weight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 6,
            ),
            Container(
              alignment: Alignment.center,
              child: TextWidget(
                text: DateFormat("dd MMMM EEEE")
                    .format(dateSelection!.selectedStartDate!),
                color: white10_color,
                size: text_font_medium16_size,
              ),
            ),
          ],
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
        ),
      ]),
    );
  }
}

class DateSelection {
  DateTime? selectedStartDate;
  DateTime? returnDate;

  DateSelection(this.selectedStartDate, this.returnDate);
}
