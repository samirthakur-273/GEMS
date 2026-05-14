import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/eshop_module_new/address/address_model.dart';
import 'package:gems_revamp/eshop_module_new/address/address_presenter.dart';
import 'package:gems_revamp/eshop_module_new/address/address_view.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/address_save.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/internetconnectingbox.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/constants.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Database/my_profile_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Model/my_profile_db_model.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Model/my_profile_model.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/presenter/my_profile_pesenter.dart';
import 'package:gems_revamp/eshop_module_new/new_address.dart';
import 'package:gems_revamp/eshop_module_new/service_unavailable/service_unavailable.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressView extends StatefulWidget {
  final ProfileAddress? model;

  AddressView({Key? key, required this.model}) : super(key: key);

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<AddressView>
    implements MyProfileViewContract, CustomerAddressView {
  bool _isLoading = false;
  late CustomerAddressModel _response;
  AddressSave? _data;
  ProfileAddress? addressResponse;
  bool _isDelete = false;
  @override
  void initState() {
    super.initState();

    if (widget.model == null) {
      _isLoading = true;
      dbHelper.truncateMyProfileData();
      internetCall(context, () => MyProfilePresenter(this).getMyProfileData());
    } else {
      addressResponse = widget.model;
    }
  }

  void deleteaddress(String addressid) {
    var request = {
      "email": GemsGLobals.useremail,
      "shopuserid": GemsGLobals.custEncryptedId,
      "address_id": addressid
    };
    internetCall(context,
        () => CustomerAddressPresenter(this).deleteAddressResponse(request));
  }

  // Widget defaultAddress(int index) {
  //   return Container(
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Row(
  //           children: [
  //             Container(
  //               height: 20,
  //               width: 20,
  //               decoration: BoxDecoration(
  //                 shape: BoxShape.circle,
  //                 border: Border.all(
  //                   color: grey_color,
  //                 ),
  //               ),
  //               child: Icon(
  //                 Icons.check,
  //                 color: theme_color,
  //                 size: 15,
  //               ),
  //             ),
  //             SizedBox(
  //               width: 10,
  //             ),
  //             TextWidget(
  //               text: "Use as default address",
  //               color: grey_color,
  //             ),
  //           ],
  //         ),
  //         Container(
  //           height: 20,
  //           width: 20,
  //           decoration: BoxDecoration(
  //             shape: BoxShape.circle,
  //             color: black_color,
  //           ),
  //           child: Icon(
  //             Icons.delete_forever_outlined,
  //             color: white_color,
  //             size: 15,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    List<Widget> _additionalAddresses() {
      List<Widget> _additionalList = [];
      List<AdditionalAddress> _addresslist =
          addressResponse?.additionalAddress ?? [];
      _additionalList.add(addressResponse?.billingAddress!.firstname == null
          ? Container()
          : Container(
              margin: EdgeInsets.only(bottom: 10, left: 15, right: 15),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20),
              decoration: _containerBorder("default"),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                                      padding: EdgeInsets.only(left: 5),
                              width: MediaQuery.of(context).size.width/1.5,
                              child: TextWidget(
                                softwrap: true,
                                text: addressResponse!.billingAddress!.firstname
                                        .toString() +
                                    " " +
                                    addressResponse!.billingAddress!.lastname
                                        .toString(),
                                color: theme_color,
                                size: text_font_medium_x_size,
                                weight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    final _data = AddressSave(
                                        "",
                                        addressResponse!
                                            .billingAddress!.firstname,
                                        addressResponse!
                                            .billingAddress!.lastname,
                                        "",
                                        addressResponse!.billingAddress!.city,
                                        addressResponse!.billingAddress!.region,
                                        addressResponse!
                                            .billingAddress!.address1,
                                        addressResponse!.billingAddress!.address2 != ""
                                            ? widget
                                                .model?.billingAddress!.address2
                                            : widget
                                                .model?.billingAddress!.street,
                                        addressResponse!
                                            .billingAddress!.address2,
                                        addressResponse!
                                            .billingAddress!.countryCode,
                                        addressResponse!
                                            .billingAddress!.carrierCode,
                                        addressResponse!
                                            .billingAddress!.telephone,
                                        addressResponse!
                                            .billingAddress!.addressId,
                                        "",
                                        addressResponse!
                                            .billingAddress!.customAddressType,
                                        "",
                                        "", true);

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NewAddress(
                                                title: "editaddress",
                                                editaddress: _data,
                                                type: "edit"))).then((value) {
                                      if (value != null && value != false) {
                                        _isLoading = true;
                                        dbHelper.truncateMyProfileData();
                                        internetCall(
                                            context,
                                            () => MyProfilePresenter(this)
                                                .getMyProfileData());
                                        setState(() {});
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    // margin: EdgeInsets.only(top: 5),
                                    child: SvgPicture.asset(
                                        ImageConstants.eshop_edit),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                                                  padding: EdgeInsets.only(left: 5),

                          child: TextWidget(
                            softwrap: true,
                            text:
                                "${addressResponse?.billingAddress!.address2 == null ? "" : (addressResponse?.billingAddress!.address2 ?? "" + ",")} ${addressResponse!.billingAddress?.address1 == null ? "" : addressResponse!.billingAddress!.address1},\n${addressResponse?.billingAddress!.city == null ? "" : addressResponse!.billingAddress!.city},\n${addressResponse?.billingAddress!.region == null ? "" : addressResponse!.billingAddress!.region},\n${addressResponse?.billingAddress!.carrierCode == null ? "" : addressResponse!.billingAddress!.carrierCode}${addressResponse?.billingAddress!.telephone == null ? "" : addressResponse?.billingAddress!.telephone}",
                            color: Color(0XFF545453),
                            size: text_font_size_x_small,
                            weight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 25,
                                  width: 25,
                                  child: Icon(
                                    Icons.radio_button_checked,
                                    color: theme_color,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                TextWidget(
                                  text: "Use as default address",
                                  color: Color(0XFF9393A1),
                                  size: text_font_medium_x_size,
                                  weight: FontWeight.w400,
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                _isLoading = true;
                                _isDelete = true;
                                deleteaddress(addressResponse!
                                        .billingAddress!.addressId ??
                                    "");
                                setState(() {});
                              },
                              child: Container(
                                width: 25,
                                height: 25,
                                // margin: EdgeInsets.only(right: 7.0, top: 0.0),

                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: SvgPicture.asset(
                                                            ImageConstants
                                                                .delete,
                                                            color: greyshades,
                                                          )
                                 
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )));

      for (var i = 0; i < (_addresslist.length); i++) {
        _additionalList.add(Container(
            margin: EdgeInsets.only(bottom: 10, left: 15, right: 15),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20),
            decoration: _containerBorder("additional"),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                                                    padding: EdgeInsets.only(left: 5),

                            width: MediaQuery.of(context).size.width/1.5,
                            child: TextWidget(
                              
                              softwrap: true,
                              text:
                                  "${_addresslist[i].firstname} ${_addresslist[i].lastname}",
                              color: theme_color,
                              size: text_font_medium_x_size,
                                weight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  _data = AddressSave(
                                      "",
                                      _addresslist[i].firstname,
                                      _addresslist[i].lastname,
                                      "",
                                      _addresslist[i].city,
                                      _addresslist[i].region,
                                      _addresslist[i].address1,
                                      _addresslist[i].address2,
                                      _addresslist[i].address2,
                                      _addresslist[i].countryCode,
                                      _addresslist[i].carrierCode,
                                      _addresslist[i].telephone,
                                      _addresslist[i].addressId,
                                      "",
                                      _addresslist[i].customAddressType,
                                      "",
                                      "", false);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NewAddress(
                                              title: "EDIT ADDRESS",
                                              editaddress: _data,
                                              type: "edit"))).then((value) {
                                    if (value != null && value != false) {
                                      _isLoading = true;
                                      dbHelper.truncateMyProfileData();
                                      internetCall(
                                          context,
                                          () => MyProfilePresenter(this)
                                              .getMyProfileData());
                                      setState(() {});
                                    }
                                  });
                                },
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  child: SvgPicture.asset(
                                    ImageConstants.eshop_edit,
                                    color: black_color.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 5),
                        child: TextWidget(
                          softwrap: true,
                          text:
                              "${_addresslist[i].address2 == null ? "" : (_addresslist[i].address2)}, ${_addresslist[i].address1 == null ? "" : _addresslist[i].address1},\n${_addresslist[i].city == null ? "" : _addresslist[i].city},\n${_addresslist[i].region == null ? "" : _addresslist[i].region},\n${_addresslist[i].carrierCode == null ? "" : _addresslist[i].carrierCode + ","}${_addresslist[i].telephone == null ? "" : _addresslist[i].telephone}",
                            color: Color(0XFF545453),
                             size: text_font_size_x_small,
                            weight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  var request = {
                                    "email": GemsGLobals.useremail,
                                    "shopuserid": GemsGLobals.custEncryptedId,
                                    "address_id": _addresslist[i].addressId,
                                    "firstname": _addresslist[i].firstname,
                                    "lastname": _addresslist[i].lastname,
                                    "address1": _addresslist[i].address1,
                                    "address2": _addresslist[i].address2,
                                    "city": _addresslist[i].city,
                                    "area": _addresslist[i].region,
                                    "countrycode": "",
                                    "carrier_code": "",
                                    "mobile": _addresslist[i].telephone,
                                    "set_default": "1"
                                  };
                                  _isLoading = true;
                                  internetCall(
                                      context,
                                      () => CustomerAddressPresenter(this)
                                          .customeraddressResponse(request));
                                  setState(() {});
                                },
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  child: Icon(
                                    Icons.radio_button_off_outlined,
                                    color: theme_color,
                                    size: 25,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              TextWidget(
                                text: "Use as default address",
                               color: Color(0XFF9393A1),
                                  size: text_font_medium_x_size,
                                  weight: FontWeight.w400,
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              _isDelete = true;
                              deleteaddress(_addresslist[i].addressId ?? "");
                              _isLoading = true;
                              setState(() {});
                            },
                            child: Container(
                              width: 25,
                              height: 25,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: SvgPicture.asset(
                                  ImageConstants.delete,
                                  color: greyshades,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )));
      }
      return _additionalList;
    }

    Widget _additionalAddress() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewAddress(
                              title: "newaddress",
                              cartDetailsModel: null,
                              editaddress: null,
                              type: "new",
                              key: null,
                            ))).then((value) {
                  if (value != null && value != false) {
                    _isLoading = true;
                    dbHelper.truncateMyProfileData();
                    internetCall(context,
                        () => MyProfilePresenter(this).getMyProfileData());
                    setState(() {});
                  }
                });
              },
              child: Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                decoration: _containerBorder(""),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: "Add a New Address",
                      color: black_color,
                      weight: FontWeight.w500,
                      size: text_font_small,
                    ),
                    SizedBox(width: 10),
                    Container(
                      height: 25,
                      width: 25,
                      child: SvgPicture.asset(
                        ImageConstants.eshop_add,
                        color: theme_color,
                      ),
                    ),
                  ],
                ),
              )),
          SizedBox(
            height: 10,
          ),
          // addressResponse?.additionalAddress?.length == 0
          //     ? TextWidget(
          //         alignment: TextAlign.center,
          //         text: "No additional address available",
          //       )
          //     :
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _additionalAddresses(),
          ),
        ],
      );
    }

    Widget _nodataFound() {
      return Container(
        margin: EdgeInsets.fromLTRB(
            15, MediaQuery.of(context).size.height / 4, 15, 0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Image.asset(
                  ImageConstants.notFoundimg,
                  height: 200,
                  width: 200,
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  child: TextWidget(
                    text:
                        "You haven't save your address yet?\nPlease click on below button to add address.",
                    size: text_font_medium_size,
                    weight: FontWeight.w500,
                    alignment: TextAlign.center,
                  )),
              new SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      );
    }

    Widget _body() {
      return Column(
        children: <Widget>[
          Expanded(
            flex: 9,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _additionalAddress(),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 10,
          ),
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: new_gradient_color,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      child: SafeArea(
        bottom: false,
        top: false,
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(90.0),
              child: GradientAppBar(
                title: "My Address",
                color: white_text_color,
                size: 19,
                weight: FontWeight.w500,
                centerTitle: true,
                height: 90,
              ),
            ),
            backgroundColor: bg_color,
            body: _isLoading
                ? SpinKitCircle(
                    color: blue_color,
                  )
                : _body()),
      ),
    );
  }

  @override
  void onMyProfileViewError(error) {
    _isLoading = false;
    setState(() {});
  }

  static var dbHelper = MyProfileDBHelper();
  Future<List<MyProfileDataModel>> getProfileDataFromDb() {
    var data = dbHelper.getMyProfileData();
    return data;
  }

  _containerBorder(String addressType) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: addressType == "default" ? off_white_color: Colors.white,
     border: Border.all(color:Colors.grey,width:0.3),
    );
  }

  @override
  void onMyProfileViewSuccess(MyProfileModel response) {
    // setState(() {
      if (response.success == 'true') {
        addressResponse = response.address;
        setState(() {
        final snackBar = SnackBar(
          backgroundColor: Color(0xfffefbea),
          content: TextWidget(
            text: "Your address has been updated",
            alignment: TextAlign.center,
            color: theme_color,
          ),
        );
        _isLoading = false;

        getProfileDataFromDb().then((value) async {
          if (value.length < 1) {
            // if nodata Insert profile data into database /
            var prefs = await SharedPreferences.getInstance();
            prefs.setString('apiresponsetime', DateTime.now().toString());
            return dbHelper
                .save(MyProfileDataModel(null, json.encode(response.toJson())));
          }
        });
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
       _isDelete == false? Fluttertoast.showToast(
          msg: "Your address has been updated",
          backgroundColor: Color(0xAA000000),
          textColor: white_text_color,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM): Container();
        });
      } else {
        Fluttertoast.showToast(
            msg: response.message.toString(),
            backgroundColor: Color(0xAA000000),
            textColor: white_text_color,
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_LONG);
        _isLoading = false;
        setState(() {});
      }
    // });
  }

  @override
  void editAddressResponse(List<CustomerAddressModel> modelresponse) {
    if (modelresponse[0].success == "true") {
         setState(() {
      _response = modelresponse[0];
      dbHelper.truncateMyProfileData();
      internetCall(context, () => MyProfilePresenter(this).getMyProfileData());
      // _isLoading = false;
   });
    } else {
      Fluttertoast.showToast(
          msg: modelresponse[0].message.toString(),
          backgroundColor: Color(0xAA000000),
          textColor: white_text_color,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
      _isLoading = false;
      setState(() {});
    }
  }

  @override
  void responseFailure(error) {
    _isLoading = false;
    setState(() {});
  }

  @override
  void onAddressTimeout() {
    String? addressid;
    var request = {
      "brandcode": Constants.brandCode,
      "country_code": Constants.countryCode,
      "lang_code": Constants.langCode,
      "action": "delete",
      "address_id": addressid
    };
    if (mounted)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (cxt) => ServiceUnavailable(
                  onRetry: () => CustomerAddressPresenter(this)
                      .customeraddressResponse(request))));
  }

  @override
  void onProfileTimeout() {
    if (mounted)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (cxt) => ServiceUnavailable(
                  onRetry: () => MyProfilePresenter(this).getMyProfileData())));
  }

  @override
  void deleteaddressResponse(List<DeleteAddressModel> modelresponse) {
    if (modelresponse[0].success == "true") {
      dbHelper.truncateMyProfileData().then((value) {
        internetCall(
            context, () => MyProfilePresenter(this).getMyProfileData());
      });

      _isLoading = false;
      
       Fluttertoast.showToast(
          msg: "Address Deleted Successfully",//modelresponse[0].message.toString(),
          backgroundColor: Color(0xAA000000),
          textColor: white_text_color,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    } else {
      Fluttertoast.showToast(
          msg: "Something went wrong!",//modelresponse[0].message.toString(),
          backgroundColor: Color(0xAA000000),
          textColor: white_text_color,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
      _isLoading = false;
      setState(() {});
    }
  }

  @override
  void addAddressResponse(List<AddAddressModel> modelresponse) {}
}
