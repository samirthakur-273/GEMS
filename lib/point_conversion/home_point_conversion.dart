import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../common_widget/appbar_widget.dart';
import '../common_widget/bottombar.dart';
import '../common_widget/font_size.dart';
import '../flight_module/flighthomepage.dart';
import '../giftcard_module/giftcard_homepage/giftcard_homepage.dart';
import '../homepage/apiconfig/apiconfighome.dart';
import '../hotel_module/hotel_homepage/hotel_homepage.dart';
import '../makesense_module/makesense_apiconfig.dart';
import '../offer_module/offer_detail/offer_detail.dart';
import '../utils/constants_files/color_constants.dart';
import '../utils/constants_files/imageconstants.dart';
import '../utils/constants_files/styles_constants.dart';
import '../utils/constants_files/text_constants.dart';
import '../utils/dialogAlert.dart';
import '../utils/gemsGlobals.dart';
import 'airmiles_module/switch_options_airmiles.dart';
import 'mwm_points_conversion_module/affiliate_partner/affiliate_partner_request_model.dart';
import 'mwm_points_conversion_module/mwm_point_home_page.dart';
import 'mwm_points_conversion_module/partner_list/partner_list_model.dart';
import 'mwm_points_conversion_module/partner_list/partner_list_presenter.dart';
import 'mwm_points_conversion_module/partner_list/partner_list_view.dart';
import 'smiles_module/check_status.dart';

class PointConversionHomePage extends StatefulWidget {
  final List? data;
  PointConversionHomePage({Key? key, this.data})
      : super(
          key: key,
        );
  @override
  _PointConversionHomePageState createState() =>
      _PointConversionHomePageState();
}

class _PointConversionHomePageState extends State<PointConversionHomePage>
    implements PartnerListView {
  List? exchangeSubsectionData = [];
  PartnerListPresenter? partnerListPresenter;
  PartnerListModel? partnerListModel;
  bool isPartnerListLoading = false;

  @override
  void initState() {
    super.initState();
    makesenseEventCall();
    partnerListPresenter = PartnerListPresenter(this);

    partnerListApiCall();
    GemsGLobals.lastVisitPageName = GemsGLobals.eventPointExchangeListingPage;
  }

  void makesenseEventCall() {
    final keyName = GemsGLobals.eventPointExchangeListingPage;
    final segmentReq = {AppTexts.intSourceKey: GemsGLobals.lastVisitPageName};
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  void partnerListApiCall() {
    setState(() {
      isPartnerListLoading = true;
    });
    partnerListPresenter?.partnerListResponse();
  }

  @override
  void partnerListSuccess(PartnerListModel partnerListModel) {
    isPartnerListLoading = false;
    setState(() {
      this.partnerListModel = partnerListModel;
      if (partnerListModel.status ?? false) {
        exchangeSubsectionData = partnerListModel.values;
      }
    });
  }

  @override
  void partnerListErr(String error) {
    setState(() {
      isPartnerListLoading = false;
    });
  }

  Future<void> _launchURLForyou(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw Exception('${AppTexts.couldNotLaunch} $url');
    }
  }

  void affilatePartnerAPi(String affilateID) {
    if (GemsGLobals.userType != AppTexts.guest) {
      final requestBody = AffiliatePartnerRequestModel(
        customerId: GemsGLobals.membershipNo ?? '',
        partnerId: affilateID,
      ).toJson();

      HomeApiconfig.affilatePartner(http.Client(), requestBody)
          .then((result) async {
        if (result[AppTexts.statusKey]) {
          final url = result[AppTexts.valuesKey][AppTexts.partnerUrlKey] ?? '';
          final uri = Uri.parse(url);

          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            throw Exception('${AppTexts.couldNotLaunch} $url');
          }
        }
      });
    }
  }

  Widget _body() => SingleChildScrollView(
        child: Column(
          children: [
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 4.1 / 4.6,
              primary: false,
              shrinkWrap: true,
              padding: const EdgeInsets.all(10),
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(
                widget.data!.length,
                (index) => GestureDetector(
                  onTap: () async {
                    if (GemsGLobals.userType == AppTexts.guest) {
                      setState(
                        () {
                          DialogAlert.showLoginAlert(context);
                        },
                      );
                    } else {
                      if (widget.data![index][AppTexts.subSecCodeKey] != null ||
                          widget.data![index][AppTexts.subSecCodeKey] != '') {
                        switch (widget.data![index][AppTexts.subSecCodeKey]
                            .toString()
                            .toLowerCase()) {
                          case AppTexts.affiliate:
                            affilatePartnerAPi(widget.data![index]
                                    [AppTexts.affiliateIdKey] ??
                                AppTexts.defaultAffiliateIdKey);
                            break;

                          case AppTexts.banner:
                            await LaunchUrl.openLink(
                                url: widget.data![index]
                                    [AppTexts.subSecUrlKey]);
                            break;

                          case AppTexts.partner:
                            await _launchURLForyou(widget.data![index]
                                    [AppTexts.subSecUrlKey] +
                                GemsGLobals.custEncryptedId);
                            break;

                          case AppTexts.offer:
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => OfferDetail(
                                  brandcode: widget.data![index]
                                      [AppTexts.brandCodeKey],
                                  outletcode: widget.data![index]
                                      [AppTexts.outletCodeKey],
                                  partnerbrandid: widget.data![index]
                                      [AppTexts.partnerBrandIdKey],
                                  catcode: widget.data![index]
                                          [AppTexts.categoryCodeKey] ??
                                      '',
                                  catname: widget.data![index]
                                          [AppTexts.categoryNameKey] ??
                                      '',
                                  subcatheading: widget.data![index]
                                          [AppTexts.altCatNameKey] ??
                                      '',
                                ),
                              ),
                            );
                            break;

                          case AppTexts.hotel:
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (contex) => HotelHomePage(),
                              ),
                            );
                            break;
                          case AppTexts.flight:
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (contex) => FlightHomePage(
                                  tabIndex: 0,
                                ),
                              ),
                            );
                            break;
                          case AppTexts.giftcard:
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (contex) => GiftCardCategory(),
                              ),
                            );
                            break;

                          case AppTexts.airmiles:
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AirMilesSwitchOptions(),
                              ),
                            );
                            break;
                          case AppTexts.smiles:
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckStatus(),
                              ),
                            );
                            break;

                          default:
                            await _launchURLForyou(
                                widget.data![index][AppTexts.subSecUrlKey]);
                            break;
                        }
                      }
                    }
                  },
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 160,
                          width: MediaQuery.of(context).size.width / 2.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Container(
                                child: Image.asset(
                                  ImageConstants.noimages,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                ImageConstants.noimages,
                                fit: BoxFit.fill,
                              ),
                              fit: BoxFit.cover,
                              imageUrl: widget.data![index]
                                      [AppTexts.subSecImageKey] ??
                                  '',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: Text(
                            widget.data![index][AppTexts.subSecNameKey] ?? '',
                            style: AppTheme.black15Medium,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            isPartnerListLoading
                ? const CircularProgressIndicator()
                : (partnerListModel?.values?.length ?? 0) > 0
                    ? GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 4.1 / 4.6,
                        primary: false,
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(10),
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(
                          partnerListModel?.values?.length ?? 0,
                          (index) {
                            final List<PartnerListDetails> activePartners =
                                (partnerListModel?.values ?? [])
                                    .where((partner) =>
                                        partner.status == AppTexts.activeText &&
                                        partner.displaySequence != null)
                                    .toList()
                                  ..sort((a, b) => a.displaySequence!
                                      .compareTo(b.displaySequence!));
                            final partner = activePartners[index];
                            return GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MwmPointsHomePage(
                                      partnerCurrencyCode:
                                          partner.partnerCurrencyId,
                                      partnerLogo: partner.partnerLogo,
                                      partnerType: partner.partnerType,

                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 160,
                                      width: MediaQuery.of(context).size.width /
                                          2.3,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              Container(
                                            child: Image.asset(
                                              ImageConstants.noimages,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                            ImageConstants.noimages,
                                            fit: BoxFit.fill,
                                          ),
                                          fit: BoxFit.cover,
                                          imageUrl: partner.partnerLogo ?? '',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      child: Text(
                                        partner.displayName ?? '',
                                        style: AppTheme.black15Medium,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : const SizedBox()
          ],
        ),
      );

  Widget _tabbar() => Container(
        width: MediaQuery.of(context).size.width,
        child: const BottomBar(
          initialIndex: 0,
        ),
      );

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          gradient: AppColors.gradientThemeColor,
        ),
        child: SafeArea(
          bottom: true,
          top: false,
          child: Scaffold(
            extendBody: true,
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(90.0),
              child: GradientAppBar(
                title: AppTexts.conversionPartners,
                color: AppColors.white,
                size: text_font_medium18_size,
                weight: FontWeight.w500,
                centerTitle: true,
                height: 90,
              ),
            ),
            body: widget.data != null && widget.data!.isNotEmpty
                ? _body()
                : Center(
                    child: Container(
                      child: const Text(
                        AppTexts.noDataFound,
                      ),
                    ),
                  ),
            bottomNavigationBar:  SizedBox(
              height: 95,
              child: _tabbar(),
            ),
          ),
        ),
      );
}
