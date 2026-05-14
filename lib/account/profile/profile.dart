import 'package:barcode_widgets/barcode_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/account/interest/interest.dart';
import 'package:gems_revamp/account/my_account.dart';
import 'package:gems_revamp/account/profile/user_profile_db/user_profile_dbhelper.dart';
import 'package:gems_revamp/account/profile/user_profile_model.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/tabbarpage.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../common_widget/bottombar.dart';
import 'edit_profile/edit_profile.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  void initState() {
    fetchUserProfileDatafromDb();
    if (GemsGLobals.userType == GemsGLobals.alumni) {
      userType = GemsGLobals.capitalizeAlumni;
    } else if (GemsGLobals.userType == GemsGLobals.staff) {
      userType = GemsGLobals.capitalizeStaff;
    } else if (GemsGLobals.userType == GemsGLobals.parent) {
      userType =GemsGLobals.capitalizeParent;
    } else if (GemsGLobals.userType == GemsGLobals.smallCorporateText) {
      userType = GemsGLobals.defaultSource;
    }
    if (GemsGLobals.userType == GemsGLobals.referral) {
      userType = GemsGLobals.capitalizeReferral;
    }

    super.initState();
  }

  UserProfileModel? usermodel;

  String? fullUserName;
  String? phoneNo;
  var userType;

  List? intrestListData;

  fetchUserProfileDatafromDb() {
    UserProfileDbHelper().fetchUserProfileData().then((value) {
      setState(() {
        usermodel = userModelFromJson(value[0].userprofiledata);

        fullUserName = (usermodel!.values!.firstName! +
            " " +
            usermodel!.values!.lastName!);

        phoneNo =
            usermodel!.values!.countryCode! + " " + usermodel!.values!.phone!;

        intrestListData = usermodel!.values!.interestList;
      });
    });
  }

  late SnackBar snackBar;
  Widget _barcode() {
    return Column(
      children: [
        Center(
          child: BarCodeImage(
            params: Code39BarCodeParams(
              '${GemsGLobals.userId}',
              lineWidth: 1.9,
              barHeight: 50.0,
              withText: false,
            ),
            onError: (error) {},
          ),
        ),
      ],
    );
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
    return PopScope(
      canPop: false,
      onPopInvoked: (canPop) async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => TabsScreen(
              initialIndex: 2,
            )),
          (Route<dynamic> route) => false,
        );
        Future.value(false);
      },
      child: SafeArea(
        bottom: true,
        top: false,
        child: Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(70),
              child: GradientAppBar(
                title: "My Profile",
                color: white_text_color,
                size: 18,
                weight: FontWeight.w500,
                centerTitle: true,
                height: 100,
              )),
          body: _body1(),
          bottomNavigationBar:  SizedBox(height: 85, child: _tabbar()),
        ),
      ),
    );
  }

  Widget memberidWidget() {
    return Container(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
        color: Color(0XFFF2F2F1),
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 10, 10, 10),
          child: Row(
            children: [
              TextWidget(
                text: 'Customer Id - ' +
                    '${usermodel?.values?.gemsCustomerId ?? ''}',
                // text: 'Membership ID - ' +
                //     '${usermodel?.values?.membershipNo ?? ''}',
                weight: FontWeight.w500,
                size: text_font_medium15_size,
              ),
              Spacer(),
              Container(
                height: 40,
                width: 40,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: white_text_color,
                    borderRadius: BorderRadius.circular(8)),
                child: InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(
                              text:
                                  '${usermodel?.values?.gemsCustomerId ?? ''}'))
                          .then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            margin: EdgeInsets.only(
                                bottom: 33, left: 20, right: 20),
                            duration: Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                            content: Text('Copied to Clipboard')));
                      });
                    },
                    child: SvgPicture.asset(
                      ImageConstants.membershipCopy,
                      // color: grey_color,
                    )),
              ),              
            ],
          ),
        ),
      ),
    );
  }

  Widget _body1() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Expanded(
              child: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              GemsGLobals.userType == GemsGLobals.referral || GemsGLobals.userType == GemsGLobals.alumni
                  ? Container(
                      height: 0,
                    )
                  : _barcode(),
              GemsGLobals.userType == GemsGLobals.referral || GemsGLobals.userType == GemsGLobals.alumni
                  ? Container(
                      height: 0,
                    )
                  : SizedBox(
                      height: 10,
                    ),
              GemsGLobals.userType == GemsGLobals.referral || GemsGLobals.userType == GemsGLobals.alumni
                  ? Container(
                      height: 0,
                    )
                  : memberidWidget(),
              profileDetails(GemsGLobals.fullNameText, fullUserName),
              profileDetails(GemsGLobals.phoneNoText,  phoneNo),
              profileDetails(GemsGLobals.emailIdText, usermodel?.values?.email),
              profileDetails(GemsGLobals.genderText, usermodel?.values?.gender),
              profileDetails(GemsGLobals.userTypeText, userType),
              profileDetails(GemsGLobals.corporateNameLabel, usermodel?.values?.corporateName),
              profileDetails(GemsGLobals.sourceText, usermodel?.values?.school),
              profileDetails(GemsGLobals.emirateText, usermodel?.values?.emirateName),
              profileDetails(GemsGLobals.nationalityText, usermodel?.values?.nationality),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InterestPage(
                              membershipId:
                                  usermodel!.values!.membershipNo ?? "",
                              intrestList: intrestListData,
                            )),
                  );                 
                },
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      border: Border.all(color: grey_color_300),
                      borderRadius: BorderRadius.circular(15)),
                  width: MediaQuery.of(context).size.width / 1,
                  child: Row(
                    children: [
                      TextWidget(
                        text: 'My Interests',
                        weight: FontWeight.w600,
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.pink,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ))
        ],
      ),
    );
  }

  Widget profileDetails(label, info) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: label ?? '',
            color: grey600_color,
            weight: FontWeight.w400,
          ),
          SizedBox(
            height: 10,
          ),
          TextWidget(
            text: info == null || info == "null" ? '-' : info,
            weight: FontWeight.w500,
            size: text_font_medium16_size,
          ),
          Divider(),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Widget gender(label, info) {
    return Container(
      width: MediaQuery.of(context).size.width / 3.4,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: label,
            color: grey600_color,
            weight: FontWeight.w400,
          ),
          SizedBox(
            height: 10,
          ),
          TextWidget(
            text: info,
            weight: FontWeight.w500,
            size: text_font_medium16_size,
            color: label == 'Gender' ? black_color : grey_color_300,
          ),
          Divider(),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}

dateformate(format) {
  var now = DateTime.parse(format);
  var formatter = new DateFormat('dd MM yyyy');
  var formated = formatter.format(now);

  return formated;
}
