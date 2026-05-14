import 'package:intl/intl.dart';

class GemsGLobals {
  static const String timeOutText = 'timeout';
  static const String tryAgainErrorMessage = 'Please wait for a few minutes before you try again';
  static const String rootedDeviceText = 'Rooted Device Detected';
  static const String jailBrokenDeviceText = 'Jailbroken Device Detected';
  static const String exitAppText = 'Exit App';
  static const String warningMsg = 'Warning: ';
  static const String rootedDeviceMsg =
      'Your device is rooted, which may affect app functionality and security.';
  static const String jailBrokendeviceMsg =
      'Your device is jailbroken, which may affect app functionality and security.';
  static RegExp corporateCodePattern = RegExp(r'[^a-zA-Z0-9]');
  static String termsAndConditionsTitle = "Terms & Conditions";
  static String termsAgreementText = 'I agree to the ';
  static String gemsRewardsWebUrl = "https://www.gemsrewards.com/terms-and-conditions";
  static String corporateCodeLabel = "Corporate Code";
  static String termsAndConditionInstruction = "Please agree to the Terms & Conditions";
  static String skipText = "Skip";
  static String corporateNameLabel = "Corporate Name";
  static String accrualPaymentType = "accrual";
  static String transactionErrorMessage = "There seems to be have an error\nwith the transaction";
  static String eshopPaymentErrorMessage = "Kindly update your payment method and \ntry again or contact your bank in case \nthe issue persists.";
  static String tryAgainButtonText = "Try Again";
  static String paymentCapturedErrorMessage = "Payment not captured";
  static String paymentFailedMessage = "Your payment has failed";
  static String retryPaymentContinueMessage = "You can retry the payment\nbelow to continue this";
  static String cancelButtonText = "Cancel";
  static String earnUptoText  = "Earn upto ";
  static String gemsPointsText = "GEMS Points";
  static String purchaseMinimumText = "Purchase with minimum";
  static String notificationRouteType = "notification";
  static String notificationSyncDateText = 'notificationSyncDate';
  static String notificationDataText = 'notificationData';
  static String pushNotificationRouteType = "push_notification";
  static String airMilesToGemsHeading = "Air Miles To GEMS";
  static String insufficientGemsPointsMessage = "Insufficient GEMS Points";
  static int descriptionTextLength = 100;
  static int zeroCount = 0;
  static String eventIoLRedirection = "iOL Redirection";
  static String gemsRewardsTabLabel = "GEMS Rewards Plus";
  static String unidentifiedUser = "Unknown User";
  static String branchNames = "Branches";
  static String banner = "Banner";
  static String productInStock = "In stock";
  static String productOutOfStock = "Out of stock";
  static String footerTab = "Footer";
  static String searchKeyword = "Search";
  static String readMore = " read more";
  static String readLess = " read less";
  static String noRatingsMessage = "You haven't entered any ratings.";
  static String eventSplashscreenViewed = "Splashscreen Viewed";
  static String emailKey = 'email';
  static String notificationTitle = "Notifications";
  static String eShopHomePageName = 'Eshop Home Page';
  static String eventEcomAddCart = 'ecom add cart';
  static String eventEcomRemoveCart = 'ecom remove cart';
  static String eventEcomAddWishlist = 'ecom add wishlist';
  static String productListingPage = 'product listing page';
  static String eventEcomRemoveWishlist = 'ecom remove wishlist';
  static String eventEcomWishlistPage = 'ecom wishlist page';
  static String eventEcomOrderConfirmationPage = 'eShop order confirmation page';
  static String eShopOrderSuccessPage = 'Eshop Thank you Page';
  static String myOrdersText = 'My Orders';
  static String goToHomeText = 'Go to Home';
  static String eShopOrderReviewPage = 'Eshop Order Review Page';
  static String eventEcomHomePage = "ecom homepage";
  static String eventCategoryPage = "ecom category page";
  static String eventProductDetailPage = "ecom product detail page";
  static String eventCartPage = "ecom cart page";
  static String eventCheckOutPage = "ecom checkout page";
  static String eventPaymentPage = "Payment Page";
  static String eventOrderFailed = "Order Failed";
  static String orderConfirmationEvent = "ecom order confirmation page";
  static String successText = "success";
  static String failureText = "failure";
  static String eventRegistration = "Registration";
  static String eventEmailAddressVerification = "Email Address Verification";
  static String eventSplashscreenClicked = "Splashscreen Clicked";
  static String eventLoginViewed = "Login Viewed";
  static String eventOTPscreenViewed = "OTPscreen viewed";
  static String eventOTPSubmitted = "OTP Submitted";
  static String eventLoginFailed = "Login Failed";
  static String eventLoginSuccessful = "Login Successful";
  static String eventHomescreenViewed = "Homescreen Viewed";
  static String eventHomescreenClicked = "Homescreen Clicked";
  static String eventOfferlistingscreenViewed = "Offerlistingscreen Viewed";
  static String eventOfferscreenViewed = "Offerscreen Viewed";
  static String eventOfferscreenClicked = "Offerscreen Clicked";
  static String eventPinbasedRedemptionInitiated = "Pinbased Redemption Initiated";
  static String eventRedemptionPinSubmitted = "Redemption Pin Submitted";
  static String eventPinbasedRedemptionFailed = "Pinbased Redemption Failed";
  static String eventPinbasedRedemptionSuccessful = "Pinbased Redemption Successful";
  static String eventNotificationCenterViewed = "Notification Center Viewed";
  static String eventNotificationClicked = "Notification Clicked";
  static String eventSearchInitiated = "Search Initiated";
  static String eventSearchExecuted = "Search Executed";
  static String eventSearchResultClicked = "Search Result Clicked";
  static String eventGiftcardListingPage = "Giftcard Listing Page";
  static String eventGiftcardClicked = "Giftcard Clicked";
  static String eventGiftcardDetailPage = "Giftcard Detail Page";
  static String eventGiftcardCheckout = "Giftcard Checkout";
  static String eventGiftcardPaymentPage = "Giftcard Payment Page";
  static String eventGiftcardPaymentFailed = "Giftcard Payment Failed";
  static String eventGiftcardPaymentSuccessful = "Giftcard Payment Successful";
  static String eventPointExchangeListingPage = "PE Listing Page";
  static String eventPointExchangePartnerDetailsPage = "PE Partner Detail Page";
  static String eventPointExchangePage = "PE Exchange Page";
  static String eventPointExchangeFailed = "PE Exchange Failed";
  static String eventPointExchangeSuccessful = "PE Exchnage Successful";
  static String eventInsuranceListingPage = "Insurance Listing Page";
  static String eventInsurancePartnerSelected = "Insurance Partner Selected";
  static String eventEducationSpendsListingPage = "Education Spends Listing Page";
  static String eventEducationSpendsDetailPage = "Education Spends Detail Page";
  static String eventEducationSpendInitiated = "Education Spend Initiated";
  static String eventGroceryPartnerDetailPage = "Grocery Partner Detail Page";
  static String eventGroceryInitiated = "Grocery Initiated";
  static String reason = "reason";
  static String amount = "amount";
  static String discount = "discount";
  static String intSource = "int_source";
  static String navigationType = "navigation_type";
  static String clickedOnParam = "clicked_on";
  static String componentType = "component_type";
  static String internalText = "internal";
  static String pinBasedType = "pin based";
  static String whatsAppText = "WhatsApp";
  static String supportMailText = "Support Email";
  static String offerCategoryParam = "offer_category";
  static String offerSubCategoryParam = "offer_sub_category";
  static String offerTypeParam = "offer_type";
  static String offerNameParam = "offer_name";
  static String offerSummaryParam = "offer_summary";
  static String notificationsNoParam = "no_of_notifications";
  static String notificationsReadParam = "no_of_notifications_read";
  static String notificationsUnreadParam = "no_of_notifications_unread";
  static String notificationsTypeParam = "notification_type";
  static String notificationNameParam = "notification_name";
  static String notificationsUrlParam = "notification_url";
  static String pushText = 'push';
  static String offerText = 'offer';
  static String pageName = 'page_name';
  static String searchTermParam = 'search_term';
  static String numberOfResultsParam = 'number_of_results';
  static String elementTypeParam = 'element_type';
  static String elementNameParam = 'element_name';
  static String elementUrlParam = 'element_url';
  static String fromCurrencyParam = 'from_currency';
  static String toCurrencyParam = 'to_currency';
  static String conversionRateParam = 'conversion_rate';
  static String amtConvertedParam = 'amt_converted';
  static String amtCreditedParam = 'amt_credited';
  static String smilesText = 'Smiles';
  static String offerDetailPageName = 'Offer Detail Page';
  static String offerPinEnterPageName = 'Offer Pin Enter Page';
  static String switchOptionPageName = 'AirMiles Switch Options Page';
  static String lastVisitPageName = '';
  static String myAccountPageName = 'My Account Page';
  static String otpPageName = 'Otp Page';
  static String splashScreenPageName = 'Splashscreen Page';
  static String loginTypesPageName = 'Login Types Page';
  static String loginPage = 'Login Page';
  static String otpPage = 'Otp Page';
  static String feeRedemptionListingPage = 'Login Types Page';
  static String commonSearchPage = 'Common Search Page';
  static String notificationPage = 'Notification Page';
  static String offerListingPage = 'Offer Listing Page';
  static String giftCardSuccessPage = 'Gift Card Thank You Page';
  static String gemsToAirmilesPage = 'Gems to Airmiles Page';
  static String airmilesToGemsPage = 'Airmiles To Gems Page';
  static int? totalReadnotificationsCount = 0;
  static int? totalReadNotificationsCount = 0;
  static String? utmSource;
  static String? utmMedium;
  static String? utmCampaign;
  static String daysCountKey = "number_of_days";
  static int defaultUtmExpiryDays = 7;
  static const String collectText='Collect';
  static const String redeemText='Redeem';
  static const String giftCardText='GIFTCARD';
  static const String orderGeneratedText= 'Order generated';
  static var userId;
  static bool wantClink = false;
  static bool alumniStatus = false;
  static bool isDeepLink = false;
  static var brandcode;
  static var outletcode;
  static var partnerbrand;
  static var catCode;
  static bool isCategoryOfferLinkReceived = false;
  static var subSecCode = '';
  static var catName = "";
  static var altCatName = "";
  static var select = 0;
  static bool isDialogShowing = false;
  static var clinkType = "";
  static var useremail = "";
  static bool showAlumnipopup = true;
  static var decruserid;
  static String? userFirstName;
  static String? dob;
  static String? userLastName;
  static String? corporateName;
  static String? corporateCode;
  static String? corporateImage;
  static String? membershipId;
  static int pointbalance = 0;
  static var makesenseDeviceID;
  static var gender;
  // static var email;
  static var userType;
  static var searchText = "";
  static var offersearchdataGlobally;
  static var versioncode;
  static var mobilenumber;
  static var mobilenumberlength;
  static var countryImage;
  static var countryid;
  static var custEncryptedId;
  static var gccountries;
  static var gitcdflRangeValue;
  static var gitcdflsort;
  static var giftsortIndex;
  static var giftcurrency;
  static var giftcountry;
  static var countryCode;
  static var school;
  static var nationality;
  static var nationalityId;
  static var nationalityText = "Nationality";
  static var emirateText = "Emirate";
  static var activeText = "Active";
  static var channelCode = "app";
  static var emirate;
  static var schoolEmirate;
  static String selectEmirateErrorText = "Please select Emirate";
  static String partnerName = "";
  static var shopType;
  static var shopHomeId;
  static var mop;
  static double lat = 25.2048;
  static double long = 55.2708;
  static var providerMob;
  static bool? checkvalueno;
  static bool? openHomePage;
  static var homepageIndex;
  static String notificationVAlue = "0";
  static bool notificationLoader = false;
  static var useractualid;
  static var geustLoginFlag; // check for login pages to pop
  static var geustLoginCheck; // check for weather its a guest user
  static var gemstoAirMilesConvRate = 6.4;
  static String exchangeInstructionsGemsToAirmiles = "You can exchange your GEMS Points for Air Miles as follows:";
  static String noteText = "Note: ";
  static String yesText = "Yes";
  static String noText = "No";
  static String conversionInputText = "You don't have enough points for conversion";
  static String lowestConversionPoints = "You have 625 points for conversion";
  static String selectPointErrorText = "Please select the points";
  static String exchangeInstructionsAirmilesToGems = "You can exchange your Air Miles to GEMS Points as follows:";
  static String selectGemsPointsToBeConvert =  "Select GEMS points to be Converted";
  static String selectedGemsPoints = "Selected GEMS Points: ";
  static String airMiles = "Air Miles";
  static String selectText = 'Select';
  static String gemsText = 'GEMS';
  static String convertYourPoints = "Convert your Points";
  static List<String> gemsToMilesConvertInfo = [
    '625 GEMS Points = 4000 Air Miles',
    '1250 GEMS Points = 8000 Air Miles',
    '1875 GEMS Points = 12000 Air Miles',
    '2500 GEMS Points = 16000 Air Miles'
  ];
  static List<String> pointsConvertInfo = [
    '833 GEMS Points = 14000 Air Miles',
    '2083 GEMS Points = 35000 Air Miles',
    '4167 GEMS Points = 70000 Air Miles',
  ];
  static var appCurrency = "AED";
  static var hotelCurrency;
  static var gemsPlusIsMemberOrNot;
  static var gemsPlusMembershipNo;
  static var gemsPlusExpiryDate;
  static var gemsPlusMemberPhoto;
  static var gemsMemberRelationCode;
  static var gemsPlusAdvantagePlusMember;
  static var gemsPlusMembershipNoUpdate;
  static var gemsPlusMemberPhotoUpdate;
  static var gemsPlusExpiryDateUpdate;
  static bool locationPermision = false;
  static var usedGems = 'cash';
  static var deeplinkloader = false;
  static var appVersion;
  static var osType;
  static var fcmToken;
  static var deviceId;
  static var devicemodel;
  static var deviceName;
  static var deviceversion;
  static var notificationMessage;
  static var backbutton = "false";
  // static var gemsPlus

  static String? membershipNo;
  static var editProfileTitle = 'Edit Profile'; 
  static var transactionId = '171810101';
  static var staffId = '4242424242';
  static var isStaffYes = 'Y';
  static var isStaffNo = 'N';
  static var flightRevisedTotal;
  static var providerEmail = "help@gemseducation.com";
  static var checkNeedHelp;
  static int userGEMSpoints = 100;
  static var userSavingsPoints = "0";
  static bool checkNotiRoute = false;
  static int? notificationCount = 0; // for count of notification(ANi)
  static bool notiBadge = false; //for count of notification(ANi)
  static bool updatedFireBaseToken = false;
  static bool dontShowPopup = false;
  static int? totalunreadnotifications = 0;
  static var emailFromDeeplink;
  // static FirebaseAnalytics? analytics;
  // static FirebaseAnalyticsObserver? observer;
  static int? rating;
  // Future<Null> sendAnalytics(String name, String eventName) async {
  //   await GemsGLobals.analytics
  //       .logEvent(name: name, parameters: <String, dynamic>{
  //     "eventname": eventName,
  //   }).catchError((error) {});
  // }

  static var etisaladSmilesID;
  static var otpp;
  static var guestcount = 1;
  static var roomcount = 1;
  static var saveusername = "";
  static var schoolcode = "";
  static var type = "";
  static var email = "";
  static var alumniEmail = "";
  static String? userSavingBalance;
  static String? routeTo;

  static String brandCodeKey = "brand_code";
  static String partnerBrandKey = "partner_brndid";

  static String catCodeKey = "category_code";

  static String catNameKey = "category_name";
  static String altCatnameKey = "alt_cat_name";
  static String subsecCodetKey = "sub_sec_code";
  static String offerOutletKey = "offer_brand_outlet";
  static String subsecHtmlKey = "subsec_html_desc";
  static String androidKey = "android_deep_link";

  static String iosKey = "ios_deep_link";
  static String gemspointsKey = "gemspoints";
  static String categoriesKey = "categoriesdeeplink";
  static String travelKey = "travel";
  static String insuranceKey = "insurance";
  static String otherPartnersKey = "otherPartners";
  static String exchangePointsKey = "exchangePoints";
  static String groceryKey = "grocery";
  static String educationSpendsKey = "educationSpends";
  static String giftcardsKey = "giftcards";
  static String eshopKey = "eshop";
  static String travel = "travel";
  static String insurance = "insurance";
  static String insuranceText = "Insurance";
  static String userToken = "userToken";
  static String partner = "partner";
  static String giftcard = "giftcard";
  static String ecommerce = "ecommerce";
  static String exchangePoints = "exchangepoints";
  static String fee = "fee";
  static String smilesGrocery = "smiles_grocery";
  static String alumni = "alumni";
  static String guest = "guest";
  static String staff = "staff";
  static String parent = "parent";
  static String capitalizeParent = "Parent";
  static String capitalizeEmployee = "Employee";
  static String capitalizeStaff = "Staff";
  static String capitalizeAlumni = "Alumni";
  static String capitalizeFnf = "Family\n& Friends";
  static String capitalizeGuest = "Guest";
  static String referral = "referral";
  static String capitalizeReferral = "Referral";
  static String selectedRelationship = "Junior";
  static String salesForceUrl = "salesforceSuccess";
  static String formSubmitSuccessText = "Form Submitted Successfully";
  static String smileMarketUrl =
      "https://smilesmobile.page.link/?link=https://smilesuae.ae/elgrocer/singlestore/GEMS&apn=ae.etisalat.smiles&ofl=https://smilesuae.ae&isi=1225034537&ibi=Etisalat.House";
  static String subsecname = 'sub_sec_name';
  static String subsecdesc = "sub_sec_desc";
  static String adroidlink = "android_deep_link";
  static String weblink = "web_deep_link";
  static String invalid = "Invalid value";
  static String gemsreward = "GEMS REWARDS";
  static String affiliateId = "affiliateId";
  static String schoolroute = "school_fee_redeemption";
  static String busroute = "bus_fee_redeemption";
  static String uniformroute = "uniform_redeemption";
  static String welcomepage = "welcomepage";
  static String homepage = "homepage";
  static String deeplinkindex = "index";
  static String gemsGlobalText = "GEMS REWARDS";
  static String ok = "Ok";
  static String inApp = "inapp";
  static String external = "external";
  static String cashValue = "cash";
  static String redeemValue = "redeem";

  static String hotelDetails =
      "Details not available, please reach out to us at support@gemsrewards.com for more information.";
  static String smiletogems =
      "Convert your Smiles to GEMS Points to pay your annual school fees and get a 20% bonus, courtesy of GEMS Rewards. This is a limited time offer and transfers must be made before 15 April.";
  static String termcondition = 'Terms and Conditions ';
  static String linkbutton = "Link Your Account";

  static const String bookingTermCondition = '''
   <ul>
    <li><em>Accessed Booking.com only from the GEMS Rewards app after logging in to your account with the credentials provided.</em></li>
    <li><em>Completed a stay at an accommodation booked on Booking.com from the GEMS Rewards app.</em></li>
    <li><em>GEMS Points will be credited to your GEMS Rewards account within 75 days after your stay is completed.</em></li>
   </ul>
 ''';
  static String shop = "shop";
  static String bookingEarnText = "Earn GEMS Points for every hotel stay!";
  static String bookingOfferText =
      "Earn up to 36 GEMS Points for every AED 100";
  static String bookingSpend = "spent on booking.com";
  static String bookNow = "Book Now";
  static String bookigAppbar = "Booking.com";
  static String bookingCriteria =
      "GEMS Rewards members are eligible for GEMS Points if they meet the following criteria:";
  static String firstName = "firstname";
  static String lastName = "lastname";
  static String updateText = "update";
  static String premiumText = "PREMIUM";
  static String mobileErrorText = "Please enter mobile number";
  static String pleaseEnterText = "Please enter";
  static String mobileDigitText = "Mobile Number consists of 9 digits";
  static String submitText = "Submit";
  static String enterFirstNameErrorText = "Please enter first name";
  static String errorText = 'This field is required';
  static String invalidCharacterErrorText = "Invalid characters in name";
  static String enterLastNameErrorText = "Please enter last name";
  static String invalidCodeErrorText = "Invalid Code";
  static String mobileNoText = "Mobile No.";
  static String firstNameText = "First Name";
  static String lastNameText = "Last Name";
  static String maleValue = "M";
  static String femaleValue = "F";
  static String staffUserTypeValue = "1";
  static String corporateUserTypeValue = "4";
  static String emailIdText = "Email ID";
  static String smallCorporateText = "corporate";
  static String corporatePartnerText = 'Corporate Partner';
   static String gemsEmployeeText = 'I am a GEMS Employee';
  static String enterCorporateEmailInstrustions = 'Please enter your corporate email address';
  static String genderText = "Gender";
  static String maleText = "Male";
  static String femaleText = "Female";
  static String userTypeText = "User Type";
  static String sourceText = "Source";
  static String defaultSource = "Corporate";
  static String defaultEmirate = "Dubai";
  static String fullNameText = "Full Name";
  static String phoneNoText = "Phone No";
  static String dateFormatYearMonthDay = "yyyy-MM-dd";
  static String notificationDateFormatYearMonthDayWithTime = "yyyy-MM-dd'T'HH:mm:ss";
  static String dateFormatDayMonthYear = "dd.MM.yyyy";
  static dynamic namePattern = r"[a-zA-Z\s'-]+";
  static List<String>? emirateList = [
    'Abu Dhabi',
    'Ajman',
    'Dubai',
    'Fujairah',
    'Ras Al Khaimah',
    'Sharjah',
    'Umm Al Quwain',
  ];
  static String nationalityErrorText = "Please select Nationality";
  static String selectNationalityText = "Select Nationality";
  static String selectEmiratesText = "Select Emirate";
  static String myInterestTitle = "My Interests";
  static String membershipText = "membershipNo";
  static String registerFormTitle = "Registration Form";
  static String successfullyRegisterMsg = 'Successfully Registered';
  static String profileDetailUpdateSuccessMsg = 'Profile Details Updated Successfully';
  static String defaultCountryCode = "971";
  static String asteriskText = "*";
  static String schoolCodeKey = "schoolcode";
  static String hotelPrice = " per night Excl. Taxes.";
  static String hotelReedemPoints = " GEMS Points per night Excl. Taxes.";
  static String linkSmilesToGems = "You can now link your Smiles & GEMS";
  static String rewardAccount = "Rewards accounts, allowing you to transfer";
  static String smilesToGems = "your Smiles points to GEMS Rewards points in";
  static String childTutionFees =
      "real time to pay for your child’s tuition fees!";
  static String? referralRelationType = "";
  static String? spouseValue = "spouse";
  static String? childValue = "child";
  static String? redeem = "Redeem ";
  static String verificationOtpSent =
      "Verification OTP has been sent to\n Mob No. ";
  static String andEmailId = " and \n Email ID ";
  static String pleaseEnterOtpHere = "\n Please enter OTP here.";
  static const String smilesTermAndCondition = '''
   <ul>
    <li><em>Offer runs from 15 July to 15 September 2024.</em></li>
    <li><em>Participants receive 20% bonus points when converting from Air Miles to GEMS Points or vice versa.</em></li>
    <li><em>Bonus GEMS Points will be credited to the participant’s account within 72 hours after the transfer is initiated.</em></li>
    <li><em>GEMS Points can also be used to access other services across our network of partners on the GEMS Rewards app.</em></li>
    <li><em>A minimum balance of 14,000 Air Miles or 652 GEMS Points is required to make a transfer.</em></li>
    <li><em>Offer is subject to change or termination at the discretion of the organisers.</em></li>
    <li><em>Offer is open to all eligible Air Miles and GEMS Rewards members.</em></li>
    <li><em>The decision of the organisers regarding any aspect of the offer is final and binding.</em></li>
    <li><em>Participation in the offer implies acceptance of these terms and conditions.</em></li>
  </ul>
 ''';
  static const String voucherCodeText = "Voucher Code";
  static const String airmilesPromotionText =
      "Convert your Air Miles to GEMS Points \n and get 20% extra towards your annual school fees,\n courtesy of GEMS Rewards.Don’t delay – exchanges\n must be made before 15 September.";
  static String friendFamilyText = "friendfamliyform";
  static String airlinePageText = "airlinepage";
  static String smilesPageText = "smilesPage";
  static bool isEShopPDPDeepLink = false;
  static String eShopPDP = "eShopPDP";
  static String eShopHome = "eshop_home";
  static String eShopCategory = "eshopCategory";
  static bool isEShopSubcategory = false;
  static String catId = "cat_id";
  static String brandId = "brand_id";
  static String brandName = "brand_name";
  static String productCode = 'product_code';
  static String categoryName ='cat_name';
  static String burnRate = "burn_rate";
  static String customerIdText = 'Customer ID - ';
  static String referralValue = "referral";
  static String alumniValue = "alumni";
  static String free = "Free";
  static String value = "value";
  static String pleaseEnterAEDValue = "Please enter AED value";
  static String pleaseEnterValidPin = "Please enter valid PIN";
  static String copyClipboardText = 'Copied to Clipboard';
  static const String smilesPromotionText =
      "Convert your Smiles to GEMS Points to pay your annual school fees and get a 20% bonus, courtesy of GEMS Rewards. This is a limited time offer and transfers must be made before 15 September 2024.";

  static const String smilesPageTermAndCondition = '''
   <ul>
    <li><em>Offer will run from 05th August 2024 until 15 September 2024.</em></li>
    <li><em>Participants receive a 20% bonus in GEMS Points when converting Smiles points to GEMS Points.</em></li>
    <li><em>Bonus GEMS Points will be credited to the participant's account within 48 hours after the transfer is initiated.</em></li>
    <li><em>GEMS Points can also be used on other services across our network of partners on the GEMS Rewards App.</em></li>
    <li><em>A minimum balance of 7,500 Smiles points is required for the transfer to take place.</em></li>
    <li><em>The offer is subject to change or termination at the discretion of the organisers.</em></li>
    <li><em>The offer is open to all eligible Smiles and GEMS Rewards members.</em></li>
    <li><em>The decision of the organisers regarding any aspect of the offer is final and binding.</em></li>
    <li><em>Participation in the offer implies acceptance of these Terms and Conditions.</em></li>
  </ul>
 ''';
 static String onlineText = "online";
 static String voucherCodeCopied = "Voucher code is copied.";
 static String giftVerificationPin = "Gift Verification PIN";
 static String giftCardSentTo = "Gift card sent to";
 static String rdText = "RD";
 static String utmSourceKey='utm_source';
 static String utmMediumKey='utm_medium';
 static String utmCampaignKey='utm_campaign';
 static String utmDateFormat='dd:MM:yyyy HH:mm:ss.SSS';
 static String getStartedText ='Get Started';
 static String loginText ='Login';
 static String viewGemsPointsText = "View in GEMS Points";
 static String airmilesText = "Airmiles";
 static String mwmHomePageKey = 'mwmhomepage';
 static String partnerCurrencyIdKey = 'partnerCurrencyId';
 static String partnerLogoKey = 'partnerLogo';
 static String partnerTypeKey = 'partner_type';
}

var re = RegExp(r'\d(?!\d{0,-0}$)');

String gemsPointsFormatter(inputPoint) {
  return NumberFormat("#,###,###,###").format(inputPoint).toString();
}

String shopPointsFormatter(inputPoint) {
  return NumberFormat("#,###,###,##0.00").format(inputPoint).toString();
}

String mobileMasker(str) {
  if (str.length >= 9) {
    // var firstAlpha = str.substring(0, 2);
    var lastAlpha = str.substring(str.length - 5);
    var firstAlpha = str.substring(0, str.length - 5);
    var finalNumber = '$lastAlpha'.replaceAll(re, '*');
    var encryString = firstAlpha + finalNumber;
    return encryString; // 'art'
  } else {
    return "";
  }
}

String emailMasker(email) {
  int _substringEmailName = 0;
  if (email.length >= 5) {
    var emailregx = new RegExp("[a-zA-Z0-9[^\\w\\s-._]");
    String emailName = email.substring(0, email.indexOf("@"));
    if (emailName.length < 2 && emailName.length > 0) {
      _substringEmailName = 1;
    } else if (emailName.length < 3) {
      _substringEmailName = 1;
    } else if (emailName.length < 4) {
      _substringEmailName = 2;
    } else if (emailName.length == 4) {
      _substringEmailName = 3;
    } else if (emailName.length > 4) {
      _substringEmailName = 4;
    }
    var emailFirFourChar = emailName.substring(0, _substringEmailName);
    //  host name -- >
    var mailHost = email.substring(email.indexOf("@"));
    var hosttwochar = mailHost.substring(0, 2);
    String lastEmailalpha =
        emailName.substring(emailFirFourChar.length, emailName.length - 0);
    String nameencry = '$lastEmailalpha'.replaceAll(emailregx, "*");
    String hostName = mailHost.substring(0, mailHost.indexOf("."));
    String com = mailHost.substring(mailHost.indexOf("."));
    String prevCom =
        hostName.substring(hostName.length - 1, hostName.length - 0);
    var lasthost = hostName.substring(2, hostName.length - 1);
    String hostencr = '$lasthost'.replaceAll(emailregx, "*");
    String finalemail =
        emailFirFourChar + nameencry + hosttwochar + hostencr + prevCom + com;
    return finalemail;
  } else {
    return "";
  }
}

enum EducationEnum {
  sfee,
  bfee,
  uni_red,
  education,
}

enum TravelEnum {
  hotel,
  flight,
  affiliate,
  eletrips,
  travelpartner,
}

enum InsuranceEnum {
  affiliate,
  insurancehome,
}

enum SmileEnum { airmiles, smiles, points }

enum Constant {
  brandCode,
  offerBrandOutlet,
  partnerBrndId,
  categoryCode,
  categoryName,
  altCatName,
  subSecCode
}

Constant getEnumFromString(String value) {
  switch (value) {
    case "brand_code":
      return Constant.brandCode;
    case "offer_brand_outlet":
      return Constant.offerBrandOutlet;
    case "partner_brndid":
      return Constant.partnerBrndId;
    case "category_code":
      return Constant.categoryCode;
    case "category_name":
      return Constant.categoryName;
    case "alt_cat_name":
      return Constant.altCatName;
    case "sub_sec_code":
      return Constant.subSecCode;
    default:
      throw ArgumentError("${GemsGLobals.invalid} $value");
  }
}

TravelEnum getTravelEnumFromString(String value) {
  switch (value) {
    case "hotel":
      return TravelEnum.hotel;
    case "flight":
      return TravelEnum.flight;
    case "affiliate":
      return TravelEnum.affiliate;
    case "eletrips":
      return TravelEnum.eletrips;
    case "travelpartner":
      return TravelEnum.travelpartner;
    default:
      throw ArgumentError("${GemsGLobals.invalid} $value");
  }
}

EducationEnum getEducationEnumFromString(String value) {
  switch (value) {
    case "sfee":
      return EducationEnum.sfee;
    case "bfee":
      return EducationEnum.bfee;
    case "uni_red":
      return EducationEnum.uni_red;
    case "education":
      return EducationEnum.education;
    default:
      throw ArgumentError("${GemsGLobals.invalid} $value");
  }
}

InsuranceEnum getInsuranceEnumFromString(String value) {
  switch (value) {
    case "affiliate":
      return InsuranceEnum.affiliate;
    case "insurancehome":
      return InsuranceEnum.insurancehome;
    default:
      throw ArgumentError("${GemsGLobals.invalid} $value");
  }
}

SmileEnum getSmileEnumFromString(String value) {
  switch (value) {
    case "airmiles":
      return SmileEnum.airmiles;
    case "smiles":
      return SmileEnum.smiles;
    case "points":
      return SmileEnum.points;
    default:
      throw ArgumentError("${GemsGLobals.invalid} $value");
  }
}

enum UtmEnum { utmSource, utmMedium, utmCampaign }

UtmEnum? getUtmEnumFromString(String value) {
  switch (value) {
    case "utm_source":
      return UtmEnum.utmSource;
    case "utm_medium":
      return UtmEnum.utmMedium;
    case "utm_campaign":
      return UtmEnum.utmCampaign;
    default:
      return null;
  }
}