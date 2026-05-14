import 'package:intl/intl.dart';

String pointsFormatter(inputPoint) {
  return NumberFormat("#,###,###,###.##").format(inputPoint).toString();
}

dateformater(covertToTimezone) {
  var date = DateTime.parse(covertToTimezone);
  var covertedData = date.toLocal();

  var formatter = new DateFormat('dd MMM ');
  String formatted = formatter.format(covertedData);

  return "$formatted";
}

dateformate(format) {
  DateTime now = DateTime.parse(format);
  var formatter = new DateFormat('MMM-dd');
  var formated = formatter.format(now);

  return formated;
}
flightDobFrmt(format) {
  final DateTime now = format;
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  final String formatted = formatter.format(now);

  return formatted;
}

timeFormat(format) {
  var date = DateTime.parse(format);
  var covertedData = date.toLocal();

  var formatter = new DateFormat('hh:mm aaa');
  String formatted = formatter.format(covertedData);

  return "$formatted";
}

/*Date time format function to show offer expiry in detail page */
dateTimeFormat(format) {
  var date = DateTime.parse(format);
  var formatter = new DateFormat('dd, MMM yy HH:mm');
  String formatted = formatter.format(date);
  return "$formatted";
}

dateTimeFormatAMPM(formate) {
  var date = DateTime.parse(formate);
  var dateFormat = DateFormat("dd, MMM yyyy HH:mm"); //("dd-MM-yyyy hh:mmaa");
  String formatted = dateFormat.format(date);
  return "$formatted";
}

datetimeFormat(format) {
  var date = DateTime.parse(format);
  var formatter = new DateFormat('EEE, dd MMM yyyy');
  String formatted = formatter.format(date);
  return "$formatted";
}

flightPassportDateFormat(format) {
  final DateTime now = format;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(now);

  return formatted;
}

notificationDateFormate(format) {
  final DateTime now = DateTime.parse(format);
  final DateFormat formatter = DateFormat('dd-MMM-yyyy');
  final String formatted = formatter.format(now);

  return formatted;
}

/*My Bounz transaction Date formate function*/
bounzTransactionDateformate(formate) {
  final DateTime now = DateTime.parse(formate);
  final DateFormat formatter = DateFormat('dd-MMM-yyyy HH:mm');
  final String formatted = formatter.format(now);

  return formatted;
}

needGemsPointsCal(aedVal, burnRate) {
    var _needGemsPoints = aedVal / burnRate;
    return (_needGemsPoints).ceil();
  }