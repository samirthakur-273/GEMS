import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/flight_module/date_modal.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:intl/intl.dart';
import 'date_utls.dart' as dateutls;

class VerticalCalendar extends StatefulWidget {
  final DateTime minDate;
  final DateTime maxDate;
  final MonthBuilder? monthBuilder;
  final DayBuilder? dayBuilder;
  final DateTime? initialMinDate;
  final DateTime? initialMaxDate;
  final ValueChanged<DateTime>? onDayPressed;
  final PeriodChanged? onRangeSelected;
  final EdgeInsetsGeometry? listPadding;

  VerticalCalendar(
      {required this.minDate,
      required this.maxDate,
      this.monthBuilder,
      this.dayBuilder,
      this.onDayPressed,
      this.onRangeSelected,
      this.initialMinDate,
      this.initialMaxDate,
      this.listPadding})
      : assert(minDate != null),
        assert(maxDate != null),
        assert(minDate.isBefore(maxDate));

  @override
  _VerticalCalendarState createState() => _VerticalCalendarState();
}

class _VerticalCalendarState extends State<VerticalCalendar> {
  DateTime? _minDate;
  DateTime? _maxDate;
  late List<Month> _months;
  DateTime? rangeMinDate;
  DateTime? rangeMaxDate;

  @override
  void initState() {
    super.initState();
    _months = dateutls.DateUtils.extractWeeks(widget.minDate, widget.maxDate);
    _minDate = widget.minDate.removeTime();
    _maxDate = widget.maxDate.removeTime();
    rangeMinDate = widget.initialMinDate;
    rangeMaxDate = widget.initialMaxDate;
  }

  @override
  void didUpdateWidget(VerticalCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.minDate != widget.minDate ||
        oldWidget.maxDate != widget.maxDate) {
      _months = dateutls.DateUtils.extractWeeks(widget.minDate, widget.maxDate);
      _minDate = widget.minDate.removeTime();
      _maxDate = widget.maxDate.removeTime();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
              cacheExtent:
                  (MediaQuery.of(context).size.width / DateTime.daysPerWeek) *
                      6,
              padding: widget.listPadding ?? EdgeInsets.zero,
              itemCount: _months.length,
              itemBuilder: (BuildContext context, int position) {
                return _MonthView(
                    month: _months[position],
                    minDate: _minDate,
                    maxDate: _maxDate,
                    monthBuilder: widget.monthBuilder,
                    dayBuilder: widget.dayBuilder,
                    onDayPressed: widget.onRangeSelected != null
                        ? (DateTime date) {
                            if (rangeMinDate == null || rangeMaxDate != null) {
                              setState(() {
                                rangeMinDate = date;
                                rangeMaxDate = null;
                              });
                            } else if (date.isBefore(rangeMinDate!)) {
                              setState(() {
                                rangeMaxDate = rangeMinDate;
                                rangeMinDate = date;
                              });
                            } else if (date.isAfter(rangeMinDate!)) {
                              setState(() {
                                rangeMaxDate = date;
                              });
                            }

                            widget.onRangeSelected!(rangeMinDate, rangeMaxDate);

                            if (widget.onDayPressed != null) {
                              widget.onDayPressed!(date);
                            }
                          }
                        : widget.onDayPressed,
                    rangeMinDate: rangeMinDate,
                    rangeMaxDate: rangeMaxDate);
              }),
        ),
      ],
    );
  }
}

class _MonthView extends StatelessWidget {
  final Month month;
  final DateTime? minDate;
  final DateTime? maxDate;
  final MonthBuilder? monthBuilder;
  final DayBuilder? dayBuilder;
  final ValueChanged<DateTime>? onDayPressed;
  final DateTime? rangeMinDate;
  final DateTime? rangeMaxDate;

  _MonthView(
      {required this.month,
      required this.minDate,
      required this.maxDate,
      this.monthBuilder,
      this.dayBuilder,
      this.onDayPressed,
      this.rangeMinDate,
      this.rangeMaxDate,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        monthBuilder != null
            ? monthBuilder!(context, month.month, month.year)
            : _DefaultMonthView(month: month.month, year: month.year),
        Table(
          children: month.weeks
              .map((Week week) => _generateFor(context, week))
              .toList(growable: false),
        ),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          height: 6,
          width: MediaQuery.of(context).size.width,
          child: SvgPicture.asset(ImageConstants.flt_divider_line),
        ),
      ],
    );
  }

  TableRow _generateFor(BuildContext context, Week week) {
    DateTime firstDay = week.firstDay;
    bool rangeFeatureEnabled = rangeMinDate != null;

    return TableRow(
        children: List<Widget>.generate(DateTime.daysPerWeek, (int position) {
      DateTime day = DateTime(week.firstDay.year, week.firstDay.month,
          firstDay.day + (position - (firstDay.weekday - 1)));

      if ((position + 1) < week.firstDay.weekday ||
          (position + 1) > week.lastDay.weekday ||
          day.isBefore(minDate!) ||
          day.isAfter(maxDate!)) {
        return const SizedBox();
      } else {
        bool isSelected = false;

        if (rangeFeatureEnabled) {
          if (rangeMinDate != null && rangeMaxDate != null) {
            isSelected = day.isSameDayOrAfter(rangeMinDate!) &&
                day.isSameDayOrBefore(rangeMaxDate!);
          } else {
            isSelected = day.isAtSameMomentAs(rangeMinDate!);
          }
        }

        return AspectRatio(
            aspectRatio: 1.0,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: onDayPressed != null
                  ? () {
                      if (onDayPressed != null) {
                        onDayPressed!(day);
                      }
                    }
                  : null,
              child: dayBuilder != null
                  ? dayBuilder!(context, day, isSelected: isSelected)
                  : _DefaultDayView(
                      date: day,
                      isSelected: isSelected,
                      rangeMinDate: rangeMinDate,
                      rangeMaxDate: rangeMaxDate,
                    ),
            ));
      }
    }, growable: false));
  }
}

class _DefaultMonthView extends StatelessWidget {
  final int month;
  final int year;
  final List<String> _weekDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thur',
    'Fri',
    'Sat',
    'Sun'
  ];

  _DefaultMonthView({required this.month, required this.year});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(12.0),
        color: white_color,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            // Divider(),
            SizedBox(
              height: 5,
            ),
            Container(
              alignment: Alignment.bottomLeft,
              child: TextWidget(
                text: DateFormat('MMMM, yyyy').format(DateTime(year, month)),
                color: flight_text_black_color,
                weight: FontWeight.w400,
                size: text_font_medium17_size,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(left: 0, right: 0),
              height: 6,
              width: MediaQuery.of(context).size.width,
              child: SvgPicture.asset(ImageConstants.flt_divider_line),
            ),
            Container(
              padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                    _weekDays.length,
                    (index) => TextWidget(
                          text: _weekDays[index],
                          size: text_font_medium15_size,
                          color: purchase_text_color,
                          weight: FontWeight.w500,
                        )),
              ),
            ),
          ],
        ));
  }
}

class _DefaultDayView extends StatelessWidget {
  final DateTime date;
  final bool? isSelected;
  final DateTime? rangeMinDate;
  final DateTime? rangeMaxDate;

  _DefaultDayView(
      {required this.date,
      this.isSelected,
      this.rangeMinDate,
      this.rangeMaxDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 1, bottom: 1),
      decoration: BoxDecoration(
        color: formatDate(date) == formatDate(rangeMinDate) ||
                formatDate(date) == formatDate(rangeMaxDate)
            ? blue_color.withOpacity(0.1)
            : dateCheck(date, rangeMinDate, rangeMaxDate)
                ? blue_color.withOpacity(0.1)
                : white_color,
        borderRadius: formatDate(date) == formatDate(rangeMinDate)
            ? BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              )
            : formatDate(date) == formatDate(rangeMaxDate)
                ? BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : dateCheck(date, rangeMinDate, rangeMaxDate)
                    ? BorderRadius.only(
                        topRight: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                        topLeft: Radius.circular(0),
                        bottomLeft: Radius.circular(0))
                    : BorderRadius.only(
                        topRight: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                        topLeft: Radius.circular(0),
                        bottomLeft: Radius.circular(0)),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: formatDate(date) == formatDate(rangeMinDate) ||
                  formatDate(date) == formatDate(rangeMaxDate)
              ? gradient_theme_color
              : dateCheck(date, rangeMinDate, rangeMaxDate)
                  ? trans_theme_color
                  : white_theme_color,
          color: formatDate(date) == formatDate(rangeMinDate) ||
                  formatDate(date) == formatDate(rangeMaxDate)
              ? red_color
              : dateCheck(date, rangeMinDate, rangeMaxDate)
                  ? transColor
                  : white_color,

          borderRadius: BorderRadius.all(Radius.circular(30)),
          // formatDate(date) == formatDate(rangeMinDate)
          //     ? BorderRadius.all(Radius.circular(10))
          //     : dateCheck(date, rangeMinDate, rangeMaxDate)
          //         ? BorderRadius.all(Radius.circular(10))
          //         : BorderRadius.all(Radius.circular(10)),
        ),
        child: Center(
          child: TextWidget(
            text: DateFormat('d').format(date),
            color: formatDate(date) == formatDate(rangeMinDate) ||
                    formatDate(date) == formatDate(rangeMaxDate)
                ? white_color
                : dateCheck(date, rangeMinDate, rangeMaxDate)
                    ? date_select_color
                    : black_color,
            weight: FontWeight.w500,
            size: text_font_medium15_size,
          ),
        ),
      ),
    );
  }
}

bool dateCheck(DateTime date, DateTime? rangeMinDate, DateTime? rangeMaxDate) {
  if (rangeMinDate == null || rangeMaxDate == null) {
    return false;
  } else {
    return (date.isAfter(rangeMinDate) && date.isBefore(rangeMaxDate));
  }
}

String? formatDate(date) {
  if (date != null) {
    return DateFormat("dd MMM yyyy").format(date);
  } else {
    return null;
  }
}

typedef MonthBuilder = Widget Function(
    BuildContext context, int month, int year);
typedef DayBuilder = Widget Function(BuildContext context, DateTime date,
    {bool? isSelected});
typedef PeriodChanged = void Function(DateTime? minDate, DateTime? maxDate);
