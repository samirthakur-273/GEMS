import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class FlightGuestPage extends StatefulWidget {
  final guestData;
  FlightGuestPage({
    required this.guestData,
    Key? key,
  }) : super(key: key);
  @override
  _FlightGuestPageState createState() => _FlightGuestPageState();
}

class _FlightGuestPageState extends State<FlightGuestPage> {
  String tempValueAdult = "1", tempValueChildren = "0", tempValueInfant = "0";
  int currentGuest = 1;
  int _infantGuest = 0;
  int _adultGuest = 1;
  int? index;
  TextEditingController textControllerAdult = TextEditingController(text: "1");
  TextEditingController textControllerChildren =
      TextEditingController(text: "0");
  TextEditingController textControllerInfant = TextEditingController(text: "0");
  PassengerClass character = PassengerClass.Economy;
  RemoveItemInterface? removeItemInterface;
  PassengerModel pdata = PassengerModel();
  CabinClassModel? cabinClassModel;

  @override
  void initState() {
    cabinClassModel = widget.guestData;

    if (cabinClassModel == null) {
      cabinClassModel = CabinClassModel("Economy", "0", pdata, 1, 0, 0);
      character = PassengerClass.Economy;
      textControllerAdult = TextEditingController(text: "1");
      textControllerChildren = TextEditingController(text: "0");
      textControllerInfant = TextEditingController(text: "0");
    } else {
      textControllerAdult =
          TextEditingController(text: cabinClassModel!.adultNumber.toString());
      textControllerChildren =
          TextEditingController(text: cabinClassModel!.childNumber.toString());
      textControllerInfant =
          TextEditingController(text: cabinClassModel!.infentNumber.toString());
      currentGuest =
          cabinClassModel!.adultNumber! + cabinClassModel!.childNumber!;
      _infantGuest = cabinClassModel!.infentNumber!;
      _adultGuest = cabinClassModel!.adultNumber!;

      if (cabinClassModel!.cabinClassValue == null ||
          cabinClassModel!.cabinClassValue == "") {
        switch (cabinClassModel!.cabinClassName) {
          case "Economy":
            character = PassengerClass.Economy;
            _selectedIndex = 0;
            break;
          case "Premium Economy":
            character = PassengerClass.PremiumEconomy;
            _selectedIndex = 1;
            break;

          case "Business":
            character = PassengerClass.Business;
            _selectedIndex = 2;
            break;
          case "First Class":
            character = PassengerClass.FirstClass;
            _selectedIndex = 3;
            break;
        }
      } else {
        switch (cabinClassModel!.cabinClassValue) {
          case "1":
            character = PassengerClass.Economy;
            _selectedIndex = 0;
            break;
          case "2":
            character = PassengerClass.PremiumEconomy;
            _selectedIndex = 1;
            break;

          case "3":
            character = PassengerClass.Business;
            _selectedIndex = 2;
            break;
          case "4":
            character = PassengerClass.FirstClass;
            _selectedIndex = 3;
            break;
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        bottom: false,
        top: false,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(90.0),
            child: GradientAppBar(
              title: "Travellers",
              color: white_text_color,
              size: 18,
              weight: FontWeight.w500,
              centerTitle: true,
              height: 90,
            ),
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                _body(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  donebtn() {
    return Container(
      height: 55,
      width: 140,
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),

      // width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient: gradient_theme_color,
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: InkWell(
          onTap: () {
            pdata.adult = int.tryParse(textControllerAdult.text);
            pdata.children = int.tryParse(textControllerChildren.text);
            pdata.infant = int.tryParse(textControllerInfant.text);

            if (pdata.totalNumberOfPassengers() <= 9 &&
                pdata.infant! <= _adultGuest) {
              cabinClassModel!.adultNumber =
                  int.tryParse(textControllerAdult.text);
              cabinClassModel!.childNumber =
                  int.tryParse(textControllerChildren.text);
              cabinClassModel!.infentNumber =
                  int.tryParse(textControllerInfant.text);
              cabinClassModel!.passengerModel = pdata;

              Navigator.pop(context, cabinClassModel);
            }
          },
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: TextWidget(
                  text: "Done",
                  color: white_text_color,
                  weight: FontWeight.w400,
                  size: text_font_medium17_size,
                ),
              ),
            ],
          )),
    );
  }

  void showDialogMessage(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(msg),
          actions: [
            MaterialButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _body() {
    return Container(
      child: Column(
        children: <Widget>[
          _guestCount(),
          _travellerClass(),
          SizedBox(
            height: 50,
          ),
          donebtn()
        ],
      ),
    );
  }

  Widget _guestCount() {
    return Container(
      margin: EdgeInsets.all(12),
      child: Column(
        children: <Widget>[
          increDecre(
              "Adult", "(above 12 yrs)", textControllerAdult, tempValueAdult),
          SizedBox(
            height: 10,
          ),
          increDecre("Children", "(2-11 yrs)", textControllerChildren,
              tempValueChildren),
          SizedBox(
            height: 10,
          ),
          increDecre("Infants", "(Below 2 yrs)", textControllerInfant,
              tempValueInfant),
        ],
      ),
    );
  }

  Widget increDecre(pnama, ageRestrict, textController, tempValue) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Row(
        children: <Widget>[
          Expanded(flex: 2, child: theTitleText(pnama, ageRestrict)),
          incrementDecrement(textController, tempValue, pnama)
        ],
      ),
    );
  }

  Widget theTitleText(title, subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text.rich(TextSpan(children: <TextSpan>[
          new TextSpan(
            text: title,
            style: new TextStyle(
              fontSize: text_font_medium17_size,
              fontWeight: FontWeight.w700,
              color: passenger_black_text_color,
            ),
          ),
          new TextSpan(
            text: "\t" + subtitle,
            style: new TextStyle(
              fontSize: text_font_medium17_size,
              fontWeight: FontWeight.w400,
              color: passenger_black_text_color,
            ),
          ),
        ]))
      ],
    );
  }

  Widget incrementDecrement(theController, tempValue, name) {
    return Container(
      child: Row(children: <Widget>[
        InkWell(
          onTap: () {
            setState(() {
              if (int.parse(theController.text) < (int.parse(tempValue) + 1)) {
                theController.text = tempValue;
              } else {
                theController.text = "${int.parse(theController.text) - 1}";

                if (name == "Infants") {
                  _infantGuest--;
                } else {
                  if (name == "Adult") {
                    _adultGuest--;
                  }
                  currentGuest -= 1;
                }
              }
            });
          },
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: passenger_black_text_color, shape: BoxShape.circle),
            child: Icon(
              Icons.remove,
              color: white_color,
              size: text_font_medium15_size,
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Container(
          width: 16,
          alignment: Alignment.center,
          child: TextField(
            showCursor: false,
            enabled: false,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: text_font_medium14_size,
              fontWeight: FontWeight.bold,
            ),
            controller: theController,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
        SizedBox(
          width: 6,
        ),
        InkWell(
          onTap: () {
            setState(() {
              if (currentGuest < 9) {
                if (name == "Infants" && _adultGuest > _infantGuest) {
                  theController.text = "${int.parse(theController.text) + 1}";

                  _infantGuest++;
                }
                // else if (name == "Infants") {
                //   Fluttertoast.showToast(
                //     msg: "Infant count can not be greater than adult count.",
                //     toastLength: Toast.LENGTH_SHORT,
                //     gravity: ToastGravity.BOTTOM,
                //   );
                // }
                else if (name == "Children") {
                  theController.text = "${int.parse(theController.text) + 1}";
                  currentGuest += 1;
                } else if (name == "Adult") {
                  theController.text = "${int.parse(theController.text) + 1}";
                  currentGuest += 1;
                  _adultGuest++;
                }
              } else {
                if (_infantGuest < _adultGuest && name == "Infants") {
                  _infantGuest++;
                  theController.text = "${int.parse(theController.text) + 1}";
                } else {
                  // if (name == "Infants") {
                  //   Fluttertoast.showToast(
                  //     msg: "Infant count can not be greater than adult count",
                  //     toastLength: Toast.LENGTH_SHORT,
                  //     gravity: ToastGravity.BOTTOM,
                  //   );
                  // }
                  //  else if (name == "Adult") {
                  //   Fluttertoast.showToast(
                  //     msg: "More than 9 Adults are not allowed",
                  //     toastLength: Toast.LENGTH_SHORT,
                  //     gravity: ToastGravity.BOTTOM,
                  //   );
                  // }
                }
              }
            });
          },
          child: Container(
            padding: EdgeInsets.all(4),
            decoration:
                BoxDecoration(color: black_color, shape: BoxShape.circle),
            child: Icon(
              Icons.add,
              size: text_font_medium15_size,
              color: currentGuest < 9
                  ? white_color
                  : name == "Infants" && _infantGuest < _adultGuest
                      ? white_color
                      : grey_color,
            ),
          ),
        ),
      ]),
    );
  }

  Widget _travellerClass() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            child: TextWidget(
              text: "Cabin Class",
              size: text_font_medium17_size,
              color: flight_text_black_color,
              weight: FontWeight.w700,
            ),
          ),
          dynamicChips(),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  List<String> _dynamicChips = [
    'Economy',
    'Premium Economy',
    'Business',
    'First Class',
  ];
  int _selectedIndex = 0;

  dynamicChips() {
    return Wrap(
      runSpacing: 12.0,
      children: List<Widget>.generate(_dynamicChips.length, (int index) {
        return InkWell(
          onTap: () {
            setState(() {
              _selectedIndex = index;
              switch (_selectedIndex) {
                case 0:
                  character = PassengerClass.Economy;
                  setValueToChip(_dynamicChips[index]);
                  break;
                case 1:
                  character = PassengerClass.PremiumEconomy;
                  setValueToChip(_dynamicChips[index]);
                  break;

                case 2:
                  character = PassengerClass.Business;
                  setValueToChip(_dynamicChips[index]);
                  break;
                case 3:
                  character = PassengerClass.FirstClass;
                  setValueToChip(_dynamicChips[index]);
                  break;
              }
            });
          },
          child: Container(
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                gradient: _selectedIndex == index
                    ? gradient_theme_color
                    : white_theme_color,
                // color: _selectedIndex == index ? blue_color : white_color,
                border: Border.all(
                    color: _selectedIndex == index
                        ? white_text_color
                        : grey_background),
                borderRadius: BorderRadius.circular(30)),
            child: TextWidget(
              alignment: TextAlign.center,
              text: _dynamicChips[index],
              size: text_font_medium17_size,
              color: _selectedIndex == index
                  ? white_color
                  : flight_text_black_color,
            ),
          ),
        );
      }),
    );
  }

  void setValueToChip(chipValue) {
    switch (chipValue) {
      case "Economy":
        cabinClassModel!.cabinClassName = "Economy";
        cabinClassModel!.cabinClassValue = "1";
        break;
      case "Premium Economy":
        cabinClassModel!.cabinClassName = "Premium Economy";
        cabinClassModel!.cabinClassValue = "2";
        break;

      case "Business":
        cabinClassModel!.cabinClassName = "Business";
        cabinClassModel!.cabinClassValue = "3";
        break;

      case "First Class":
        cabinClassModel!.cabinClassName = "First Class";
        cabinClassModel!.cabinClassValue = "4";
        break;

      default:
        cabinClassModel!.cabinClassName = "Economy";
        cabinClassModel!.cabinClassValue = "1";
        break;
    }
  }
}

enum PassengerClass { Economy, PremiumEconomy, Business, FirstClass }

class RemoveItemInterface {
  void itemRemoved() {}
}

class PassengerModel {
  int? adult = 1, //GlobalValues.roleName == "Travel Desk" ? 0 : 1,
      children = 0,
      infant = 0;
  int totalNumberOfPassengers() {
    return adult! + children!;
  }
}

class CabinClassModel {
  String cabinClassName, cabinClassValue;
  int? adultNumber, childNumber, infentNumber;
  // SingingCharacter character;
  PassengerModel? passengerModel;
  CabinClassModel(
    this.cabinClassName,
    this.cabinClassValue, [
    this.passengerModel,
    this.adultNumber,
    this.childNumber,
    this.infentNumber,
    // this.character
  ]);
}
