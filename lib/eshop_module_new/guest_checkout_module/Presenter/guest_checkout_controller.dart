//guest_checkout_controller

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/eshop_module_new/api_config.dart';
import 'package:gems_revamp/eshop_module_new/guest_checkout_module/View/checkout_view.dart';
import 'package:gems_revamp/eshop_module_new/guest_checkout_module/model/checkout_model.dart';
import 'package:intl/intl.dart';

class GuestCheckoutPresenter {
  GuestCheckoutVieww? guestCheckoutVieww;

  /* DatePicker */
  void showDatePicker(BuildContext context, _date, _notifier) {
    var myFormat = DateFormat('MMM d, yyyy');
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
          itemTextStyle: TextStyle(
              color: theme_color, fontWeight: FontWeight.bold, fontSize: 18),
          cancelTextStyle: TextStyle(
              color: black_color, fontWeight: FontWeight.bold, fontSize: 16),
          confirmTextStyle: TextStyle(
              color: black_color, fontWeight: FontWeight.bold, fontSize: 16)),
      initialDateTime: new DateTime.now(),
      maxDateTime: new DateTime.now()
          .add(new Duration(days: (182.6210945).floor()))
          .add(new Duration(days: (365.242189 * 4).floor())),
      minDateTime: new DateTime.now(),
      dateFormat: 'dd-MMMM-yyyy',
      locale: DateTimePickerLocale.en_us,
      onConfirm: (dateTime, List<int> index) {
        _date.value =
            TextEditingValue(text: myFormat.format(dateTime).toString());
        _notifier.value = dateTime;
      },
    );
  }

  void guestcheckoutresp(GuestCheckoutVieww _guestCheckoutVieww, body) {
    guestCheckoutVieww = _guestCheckoutVieww;
    ApiConfig().checkout(body).then((response) {
      if (response == "timeout") {
        this.guestCheckoutVieww!.checkoutTimeOut();
      } else {
        this
            .guestCheckoutVieww!
            .checkoutResponse(checkoutModelFromJson(response.body.toString()));
      }
    }).catchError((onError) {
      this.guestCheckoutVieww!.checkoutResponseFailure(onError);
    });
  }

  void paymentMethod(GuestCheckoutVieww _guestCheckoutVieww, body) {
    guestCheckoutVieww = _guestCheckoutVieww;
    ApiConfig().getpaymentMethods(body).then((response) {
      if (response == "timeout") {
        this.guestCheckoutVieww!.paymentTimeOut();
      } else {
        this.guestCheckoutVieww!.paymentMethodResponse(
            paymentMethodModelFromJson(response.body.toString()));
      }
    }).catchError((onError) {
      this.guestCheckoutVieww!.paymentMethodresponseFailure(onError);
    });
  }

  void createToken(GuestCheckoutVieww _guestCheckoutVieww, body) {
    guestCheckoutVieww = _guestCheckoutVieww;
    ApiConfig().createToken(body).then((response) {
      this.guestCheckoutVieww!.paymentGatewayCreateToken(response);
    }).catchError((onError) {
      this.guestCheckoutVieww!.responseFailure(onError);
    });
  }

  void paymentCard(GuestCheckoutVieww _guestCheckoutVieww, body) {
    guestCheckoutVieww = _guestCheckoutVieww;
    ApiConfig().paymentByCard(body).then((response) {
      this.guestCheckoutVieww!.paymentByCard(response);
    }).catchError((onError) {
      this.guestCheckoutVieww!.responseFailure(onError);
    });
  }

  void applystorecredit(GuestCheckoutVieww _guestCheckoutVieww, body) {
    guestCheckoutVieww = _guestCheckoutVieww;
    ApiConfig().applystorecredit(body).then((response) {
      if (response == "timeout") {
        this.guestCheckoutVieww!.responseFailure(response);
      } else {
        this.guestCheckoutVieww!.applystorecreditResponse(
            storeCreditModelFromJson(response.body.toString()));
      }
    }).catchError((onError) {
      this.guestCheckoutVieww!.responseFailure(onError);
    });
  }

  void orderStatusUpdate(GuestCheckoutVieww _guestCheckoutVieww, body) {
    guestCheckoutVieww = _guestCheckoutVieww;
    ApiConfig().orderstatusupdate(body).then((response) {
      if (response == "timeout") {
        this.guestCheckoutVieww!.statusCheckTimeout();
      } else {
        this
            .guestCheckoutVieww!
            .statusCheck(orderStatusModelFromJson(response.body.toString()));
      }
    }).catchError((onError) {
      this.guestCheckoutVieww!.statusUpadetaResponseFailure(onError);
    });
  }
}
