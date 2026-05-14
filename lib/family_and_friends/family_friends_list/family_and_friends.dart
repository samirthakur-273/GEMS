import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gems_revamp/account/profile/profile_utils/user_apiconfig.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/bottombar.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/family_and_friends/add_family_friends.dart';
import 'package:gems_revamp/family_and_friends/family_friends_list/famil_friends_list_view.dart';
import 'package:gems_revamp/family_and_friends/family_friends_list/family_friends_list_model.dart';
import 'package:gems_revamp/family_and_friends/family_friends_list/family_friends_list_presenter.dart';
import 'package:gems_revamp/family_and_friends/family_friends_master_list/master_list_model.dart';
import 'package:gems_revamp/family_and_friends/family_friends_master_list/master_list_presenter.dart';
import 'package:gems_revamp/family_and_friends/family_friends_master_list/master_list_view.dart';
import 'package:gems_revamp/family_and_friends/master_list_db/master_list_db_helper.dart';
import 'package:gems_revamp/family_and_friends/master_list_db/master_list_db_model.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../utils/constants_files/text_constants.dart';

class FamilyandFriends extends StatefulWidget {
  const FamilyandFriends({Key? key}) : super(key: key);

  @override
  State<FamilyandFriends> createState() => _FamilyandFriendsState();
}

class _FamilyandFriendsState extends State<FamilyandFriends>
    implements FamilyAndFriendsView, MasterListView {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  FamilyAndFriendsPresenter? _familyAndFriendsPresenter;
  FamilyFriendsListModel? _familyFriendsListModel;

  MasterListPresenter? _masterListPresenter;
  MasterListModel? _masterListModel;

  bool? isLoadingRefList = false;
  bool? isListFound = true;

  @override
  void initState() {
    _familyAndFriendsPresenter = FamilyAndFriendsPresenter(this);
    familyAndFriendsRefListRes();
    _masterListPresenter = MasterListPresenter(this);
    masterListResponse();

    super.initState();
  }

  void familyAndFriendsRefListRes() {
    Internetconnectivity().isConnected().then((value) {
      if (value) {
        setState(() {
          isLoadingRefList = true;
          _familyAndFriendsPresenter!
              .familyFriendsListResponse(GemsGLobals.membershipNo);
        });
      } else {
        _familyAndFriendsPresenter!
            .familyFriendsListResponse(GemsGLobals.membershipNo);
      }
    });
  }

  void masterListResponse() {
    Internetconnectivity().isConnected().then((value) {
      if (value == true) {
        _masterListPresenter!.masterListResponse();
      } else {
        _masterListPresenter!.masterListResponse();
      }
    });
  }

  referalDeleteApiCall(membershipNo, referralId) {
    var referalDeleteReq = {
      "membership_no": membershipNo,
      "referral_id": referralId
    };
    setState(() {
      isLoadingRefList = true;
    });
    UserApiConfig()
        .referalDelete(http.Client(), referalDeleteReq)
        .then((value) {
      if (value['status'] == true) {
        setState(() {
          isLoadingRefList = false;
          familyAndFriendsRefListRes();
        });
      }
      if (value['status'] == false) {
        setState(() {
          isLoadingRefList = false;
          Fluttertoast.showToast(
              msg: value['message'],
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Color(0xAA000000),
              textColor: white_text_color,
              gravity: ToastGravity.CENTER);
        });
      } else {
        setState(() {
          isLoadingRefList = false;
        });
      }
    });
  }

  Widget _tabbar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      // color: black_color,
      child: BottomBar(
        initialIndex: 2,
        tabvalue: "myaccount",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        extendBody: true,
        backgroundColor: white10_color,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90.0),
          child: GradientAppBar(
            title: AppTexts.myFamilyAndFriendsText,
            color: white_text_color,
            size: 18,
            weight: FontWeight.w500,
            centerTitle: true,
            height: 90,
          ),
        ),
        body: isLoadingRefList == true
            ? SpinKitCircle(
                color: appbar_color,
              )
            : _body(),
        bottomNavigationBar:  SizedBox(height: 95, child: _tabbar()),
      ),
    );
  }

  _body() {
    return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () {
          return Future.delayed(Duration(seconds: 1), () {
            setState(() {
              familyAndFriendsRefListRes();
              // mySavingapicall();
            });
          });
        },
        child: Column(
          mainAxisAlignment: isListFound == false
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            isListFound == false
                ? Expanded(
                    child: MediaQuery.removePadding(
                    context: context,
                    removeBottom: true,
                    removeTop: true,
                    child: ListView(
                      shrinkWrap: true,
                      children: _collectData(),
                    ),
                  ))
                : Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: Center(
                      child: TextWidget(
                        text:
                            "You have not yet referred any family & friends, Add and let your family & friends enjoy benefits of GEMS Rewards.",
                        size: text_font_medium14_size,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ),
            _logout(),
            SizedBox(
              height: 70,
            )
          ],
        ));
  }

  Widget _logout() {
    return InkWell(
      onTap: () async {
        var data = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddFamilyAndFriends()),
        );

        setState(() {
          // isLoadingRefList = true;
          _familyFriendsListModel!.values!.clear();
          familyAndFriendsRefListRes();
        });
      },
      child: Container(
        height: 56,
        margin: EdgeInsets.fromLTRB(20, 15, 20, 30),
        width: MediaQuery.of(context).size.width / 1,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: green_color),
        child: Center(
          child: TextWidget(
            text: 'Add family & friends',
            color: white_text_color,
            size: text_font_medium_size,
            weight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  List<Widget> _collectData() {
    List<Widget> data = <Widget>[];

    for (var i = 0; i < _familyFriendsListModel!.values!.length; i++) {
      data.add(InkWell(
        onTap: () {},
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 0.3, color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: _familyFriendsListModel!.values![i].firstName! +
                          ' ' +
                          _familyFriendsListModel!.values![i].lastName!,
                      weight: FontWeight.w500,
                      color: purchase_text_color,
                      size: text_font_size_x_small,
                    ),
                    TextWidget(
                      text: dateformate(
                          _familyFriendsListModel!.values![i].referralDate),
                      weight: FontWeight.w500,
                      color: purchase_text_color,
                      size: text_font_size_x_small,
                    )
                  ],
                ),
                new SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text:
                          '+${_familyFriendsListModel!.values![i].countryCode! + ' ' + _familyFriendsListModel!.values![i].phone!}',
                      weight: FontWeight.w500,
                      color: purchase_text_color,
                      size: text_font_size_x_small,
                    ),
                    TextWidget(
                      text: _familyFriendsListModel!.values![i].status,
                      color: fnf_list_status_green_color,
                      weight: FontWeight.w500,
                    )
                  ],
                ),
                new SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      //color: red_color,
                      child: TextWidget(
                        text: _familyFriendsListModel!.values![i].email,
                        weight: FontWeight.w500,
                        color: purchase_text_color,
                        maxLines: 1,
                        size: text_font_size_x_small,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextWidget(
                      text: _familyFriendsListModel!.values![i].type,
                      weight: FontWeight.w500,
                      color: purchase_text_color,
                      size: text_font_size_x_small,
                    )
                  ],
                ),
                new SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text:
                          "${_familyFriendsListModel!.values![i].totalFnfAvailablePoints.toString()} GEMS Points",
                      weight: FontWeight.w500,
                      color: purchase_text_color,
                      size: text_font_size_x_small,
                    ),
                    InkWell(
                      onTap: () {
                        _showlogoutDialog(
                            _familyFriendsListModel!.values![i].referralId);

                        // referalDeleteApiCall(GemsGLobals.membershipNo,
                        //     _familyFriendsListModel!.values![i].referralId);
                      },
                      child: Container(
                          width: 65,
                          alignment: Alignment.bottomRight,
                          child: SvgPicture.asset(
                            ImageConstants.delete,
                            color: Color(0XFFD9D8D8),
                          )),
                    )
                  ],
                )
              ]),
            ),
          ),
        ),
      ));
    }
    return data;
  }

  _showlogoutDialog(referralId) async {
    await Future.delayed(Duration(milliseconds: 50));
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: Container(
              margin: EdgeInsets.only(top: 25, left: 15, right: 15, bottom: 10),
              height: 120,
              child: Column(
                children: <Widget>[
                  Container(
                    child: TextWidget(
                      text: "Are you sure you want to\ndelete this user?",
                      size: text_font_size_small,
                      weight: FontWeight.bold,
                      color: Colors.grey[700],
                      alignment: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 22),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          height: 35,
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.0,
                                color: blue_color,
                              ),
                              borderRadius: BorderRadius.circular(3)),
                          child: new TextButton(
                            child: TextWidget(
                              text: "No",
                              color: blue_color,
                              textAlign: TextAlign.center,
                              size: text_font_size_small,
                              weight: FontWeight.bold,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Container(
                          height: 35,
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.0,
                                color: blue_color,
                              ),
                              borderRadius: BorderRadius.circular(3)),
                          child: new TextButton(
                            child: TextWidget(
                              text: "Yes",
                              color: blue_color,
                              textAlign: TextAlign.center,
                              size: text_font_size_small,
                              weight: FontWeight.bold,
                            ),
                            onPressed: () async {
                              referalDeleteApiCall(
                                  GemsGLobals.membershipNo, referralId);
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            // actions: <Widget>[],
          );
        });
  }

  @override
  void familyFriendsListError(Error error) {
    // TODO: implement familyFriendsListError
  }

  @override
  void familyFriendsListSuccessRes(
      FamilyFriendsListModel familyFriendsListModel) {
    if (familyFriendsListModel.status == true) {
      setState(() {
        isLoadingRefList = false;

        isListFound = false;

        _familyFriendsListModel = familyFriendsListModel;
      });
    } else {
      setState(() {
        isLoadingRefList = false;
        isListFound = true;
      });
    }
    // TODO: implement familyFriendsListSuccessRes
  }

  @override
  void masterListErrorResp(Error error) {}

  @override
  void masterListSuccessResp(MasterListModel masterListModel) {
    if (masterListModel.status == true) {
      _masterListModel = masterListModel;

      MasterListDbHelper().insertMasterListData(
          MasterListDBModel(null, json.encode(masterListModel.toJson())));
    }
  }
}

dateformate(format) {
  var now = DateTime.parse(format);
  var formatter = DateFormat('dd MMMM yyyy');
  var formated = formatter.format(now);

  return formated;
}
