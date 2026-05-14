import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gems_revamp/account/profile/profile_utils/user_apiconfig.dart';
import 'package:gems_revamp/account/profile/user_profile_db/user_profile_db_model.dart';
import 'package:gems_revamp/account/profile/user_profile_db/user_profile_dbhelper.dart';
import 'package:gems_revamp/account/profile/user_profile_model.dart';
import 'package:gems_revamp/account/profile/user_profile_presenter.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:http/http.dart' as http;

import '../../common_widget/bottombar.dart';
import '../../utils/constants_files/text_constants.dart';

class InterestPage extends StatefulWidget {
  final List? intrestList;
  final String? membershipId;

  InterestPage({Key? key, this.intrestList, this.membershipId})
      : super(key: key);

  @override
  _InterestPageState createState() => _InterestPageState();
}

class _InterestPageState extends State<InterestPage> {
  List? selectedInterest = [];
  List? unselectedInterest = [];
  String? membershipNo;
  var noConnection;
  List<dynamic>? itemList1;
  UserProfileModel? _userProfileModel;

  @override
  void initState() {
    itemList1 = widget.intrestList;
    membershipNo = widget.membershipId;

    super.initState();
  }

  bool? updateInterest = false;


  void updateIntrestList() {
    Internetconnectivity().isConnected().then((isConnected) {
      if (isConnected == true) {
        var updateIntrestReq = {
          "membership_no": membershipNo.toString(),
          "interests": selectedInterest,
          "device_id": GemsGLobals.deviceId
        };


        UserApiConfig()
            .updateIntrestApiCall(http.Client(), updateIntrestReq)
            .then((value) {
          if (value['status'] == true) {
            setState(() {
              updateInterest = false;
              UserProfileDbHelper().truncateTable().whenComplete(() {
                userProfileApi();
              });
            });
          } else {
            setState(() {
              updateInterest = false;
            });
          }
        });
      } else {
        updateIntrestList();
      }
    });
  }

  void userProfileApi() {
    Internetconnectivity().isConnected().then((connected) async {
      if (connected) {
        UserApiConfig.userProfileApiCall(http.Client(), membershipNo)
            .then((value) {
          _userProfileModel = value;

          if (_userProfileModel!.status == true) {
            UserProfileDbHelper()
                .insertUserProfileData(UserProfileDbModel(
                    null, json.encode(_userProfileModel!.toJson())))
                .whenComplete(() {
              Navigator.pop(context, true);
              // getuserProfileData();
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _btnRegister() {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {});
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: deepdark_orange_color,
                      borderRadius: BorderRadius.circular(12)),
                  child: MaterialButton(
                    padding: const EdgeInsets.all(12),
                    onPressed: () {
                      Navigator.pop(context);
                      for (int i = 0; i < selectedInterest!.length; i++) {
                        if (itemList1![selectedInterest![i] - 1]
                                .customerStatus ==
                            'YES') {
                          setState(() {
                            itemList1![selectedInterest![i] - 1]
                                .customerStatus = 'NO';
                          });
                        } else {
                          setState(() {
                            itemList1![selectedInterest![i] - 1]
                                .customerStatus = 'YES';
                          });
                        }
                      }
                      for (int i = 0; i < unselectedInterest!.length; i++) {
                        if (itemList1![unselectedInterest![i] - 1]
                                .customerStatus ==
                            'YES') {
                          setState(() {
                            itemList1![unselectedInterest![i] - 1]
                                .customerStatus = 'NO';
                          });
                        } else {
                          setState(() {
                            itemList1![unselectedInterest![i] - 1]
                                .customerStatus = 'YES';
                          });
                        }
                      }
                    },
                    child: TextWidget(
                      text: 'Cancel',
                      size: text_font_medium15_size,
                      color: white_text_color,
                      weight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {

                    setState(() {
                      updateInterest = true;
                    });
                    updateIntrestList();
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  decoration: BoxDecoration(
                      color: green_color,
                      borderRadius: BorderRadius.circular(12)),
                  child: updateInterest == true
                      ? SpinKitCircle(
                          color: white_text_color,
                          size: 15,
                        )
                      : TextWidget(
                          text: "Save",
                          color: white_text_color,
                          size: text_font_medium15_size,
                          weight: FontWeight.w500,
                        ),
                ),
              ),
            ),
          ],
        )),
      );
    }

    Widget _body() {
      return Container(
        color: white_text_color,
        child: Column(
          children: <Widget>[
            Flexible(
              child: Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  padding: EdgeInsets.only(left: 20, right: 20, top: 40),
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topCenter,
                  child: GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio: (MediaQuery.of(context).size.width) /
                          (MediaQuery.of(context).size.height / 1.8),
                      mainAxisSpacing: 20,
                      children: List.generate(itemList1!.length, (index) {
                        return InkWell(
                          onTap: () {
                            setState(() {


                              if (itemList1![index].customerStatus == 'YES') {
                                setState(() {
                                  itemList1![index].customerStatus = 'NO';
                                });
                              } else {
                                itemList1![index].customerStatus = 'YES';
                              }



                              if (itemList1![index].customerStatus == "YES") {
                                setState(() {
                                  selectedInterest!
                                      .add(itemList1![index].interestId);
                                  unselectedInterest!
                                      .remove(itemList1![index].interestId);
                                });
                              } else {
                                setState(() {
                                  selectedInterest!
                                      .remove(itemList1![index].interestId);
                                  unselectedInterest!
                                      .add(itemList1![index].interestId);
                                });
                              }
                            
                            });
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                  height: 90,
                                  width: 90,
                                  decoration: BoxDecoration(
                                      // color: green_color_500,
                                      shape: BoxShape.circle),
                                  child:
                                      // Stack(
                                      //   children: <Widget>[
                                      ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: CachedNetworkImage(
                                        errorWidget: (context, url, error) {
                                          return Image.asset(
                                              ImageConstants.gems_placeholder,
                                              fit: BoxFit.fill);
                                        },
                                        placeholder: (context, url) {
                                          return Image.asset(
                                            ImageConstants.gems_placeholder,
                                            fit: BoxFit.fill,
                                          );
                                        },
                                        imageUrl: itemList1![index]
                                                    .customerStatus
                                                    .toString()
                                                    .toLowerCase() ==
                                                'yes'
                                            ? itemList1![index].image != null
                                                ? itemList1![index].image
                                                : ImageConstants
                                                    .gems_placeholder
                                            : itemList1![index]
                                                        .unselectedImage !=
                                                    null
                                                ? itemList1![index]
                                                    .unselectedImage
                                                : ImageConstants
                                                    .gems_placeholder,
                                        fit: BoxFit.fill),
                                  )
                                  // ],
                                  //  ),
                                  ),
                              SizedBox(
                                height: 5,
                              ),
                              Flexible(
                                  child: TextWidget(
                                text: itemList1![index].name,
// ,                                 itemList1![index].name,
                                // maxLines: 2,
                                overflow: TextOverflow.ellipsis,

                                alignment: TextAlign.center,
                                // textScaleFactor: 1.0,
                                size: text_font_medium14_size,

                                weight: FontWeight.w400,
                              )),
                            ],
                          ),
                        );
                      }))),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: _btnRegister(),
            ),
            // SizedBox(
            //   height: 20,
            // )
          ],
        ),
      );
    }

    Widget _tabbar() {
      return Container(
        width: MediaQuery.of(context).size.width,
        // color: black_color,
        child: BottomBar(
          initialIndex: 2,
          tabvalue: "myaccount",
          // goback: true
        ),
      );
    }

    return SafeArea(
      top: false,
      child: Scaffold(
        extendBody: true,
        backgroundColor: white_color,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(90),
            child: GradientAppBar(
              title: AppTexts.whatInterestsYouText,
              color: white_text_color,
              size: 18,
              weight: FontWeight.w500,
              centerTitle: true,
              height: 90,
            )
            ),
        bottomNavigationBar:  SizedBox(height: 95, child: _tabbar()),
        body: _body(),
      ),
    );
  }
}
