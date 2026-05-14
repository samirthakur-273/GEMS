import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';

int collapse = 0;

class HotelGuestRoom extends StatefulWidget {
  final RoomModel roomModel;

  HotelGuestRoom(this.roomModel);

  @override
  _HotelGuestRoomState createState() => _HotelGuestRoomState();
}

class _HotelGuestRoomState extends State<HotelGuestRoom>
    implements RemoveItemInterface {
  List<_TheRoom> roomList = [];
  bool _addRooms = true;

  var guestcount = 0, totalcount = 0;

  @override
  void initState() {
    collapse = 0;
    GuestCount.guest = 0;
    CollapseRoom.isExpanded = '0';
/* Initialize room data */
    if (widget.roomModel.roomList.length == 0) {
      GuestCount.guest = 1;
      roomList.add(_TheRoom(
        0,
        this,
        onchanged: (int count) {
          if (count > 8) {
            setState(() {
              _addRooms = false;
            });
          } else {
            setState(() {
              _addRooms = true;
            });
          }
        },
      ));
    } else {
      for (int i = 0; i < widget.roomModel.roomList.length; i++) {
        if (i == 0) {
          CollapseRoom().expand(i);
        }
        _TheRoom theRoom = _TheRoom(
          i,
          this,
          onchanged: (int count) {
            if (count > 8) {
              setState(() {
                _addRooms = false;
              });
            } else {
              setState(() {
                _addRooms = true;
              });
            }
          },
        );

        theRoom.textControllerAdult.text =
            widget.roomModel.roomList[i].adult.toString();
        theRoom.textControllerChildren.text =
            widget.roomModel.roomList[i].children.toString();
        roomList.add(theRoom);
        GuestCount.guest = GuestCount.guest +
            widget.roomModel.roomList[i].adult +
            widget.roomModel.roomList[i].children;
      }
    }
    if (GuestCount.guest > 8) {
      setState(() {
        _addRooms = false;
      });
    } else {
      setState(() {
        _addRooms = true;
      });
    }

    if (widget.roomModel.getRoomDetails().isEmpty) {
      SelectAge.childDetail = [];
      SelectAge().addChildDetail();
    } else {
      SelectAge.childDetail = widget.roomModel.getRoomDetails();
    }

    super.initState();
  }

  Widget _tabbar() {
    return Container(
      height: 90,
      child: Column(
        children: <Widget>[
          _button(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(90.0),
            child: GradientAppBar(
              title: "Select Guests and Room",
              color: white_text_color,
              size: 18,
              weight: FontWeight.w500,
              centerTitle: true,
              height: 90,
            ),
          ),
          body: Container(
            child: ListView(
              children: <Widget>[
                _body(),
              ],
            ),
          ),
          bottomNavigationBar: _tabbar(),
        ),
      ),
    );
  }

  Widget _body() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  key: UniqueKey(),
                  margin: EdgeInsets.only(left: 8, right: 8),
                  child: SingleChildScrollView(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: roomList.length,
                        itemBuilder: (context, index) {
                          return roomList[index];
                        }),
                  ),
                ),
                _addRooms
                    ? MaterialButton(
                        onPressed: roomList.length != 5
                            ? () {
                                setState(() {
                                  int len = roomList.length;
                                  /* check room counts */
                                  if (roomList.length < 5) {
                                    SelectAge().addChildDetail();

                                    if (GuestCount.guest < 9) {
                                      GuestCount.guest = GuestCount.guest + 1;
                                    }

                                    CollapseRoom().expand(len);

                                    setState(() {
                                      collapse = len;

                                      // collapse;
                                      // roomList;
                                    });
                                    /* add room */
                                    roomList.add(_TheRoom(len, this,
                                        onchanged: (int count) {
                                      if (count > 8) {
                                        setState(() {
                                          _addRooms = false;
                                        });
                                      } else {
                                        setState(() {
                                          _addRooms = true;
                                        });
                                      }
                                    }, onstateChange: () {
                                      setState(() {});
                                    }));
                                  }

                                  if (GuestCount.guest > 8) {
                                    setState(() {
                                      _addRooms = false;
                                    });
                                  } else {
                                    setState(() {
                                      _addRooms = true;
                                    });
                                  }
                                });
                              }
                            : () {},
                        child: TextWidget(
                          text:
                              roomList.length != 4 ? "+ Add another room" : "",
                          color: blue_color,
                          weight: FontWeight.w400,
                          textAlign: TextAlign.left,
                          size: text_font_medium_size,
                        ),
                      )
                    : Container(
                        height: 0,
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

/* Done button */
  Widget _button() {
    return GestureDetector(
      onTap: () {
        RoomModel rmodel = RoomModel();

        for (int i = 0; i < roomList.length; i++) {
          rmodel.roomList.add(GuestModel(
              int.parse(roomList[i].textControllerAdult.text),
              int.parse(roomList[i].textControllerChildren.text)));

          SelectAge().setAdultcount(
              i, int.parse(roomList[i].textControllerAdult.text));
        }

        if (rmodel.totalGuests() <= 9) {
          Navigator.pop(context, rmodel);
        } else {
          showDialogMessage("Maximum 9 guest(s) for a Trip");
        }
      },
      child: Container(
          color: white_text_color,
          height: 70,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Container(
                decoration: BoxDecoration(
                    gradient: gradient_theme_color,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: TextWidget(
                        text: "Done",
                        color: Colors.white,
                        weight: FontWeight.w500,
                        size: 20,
                      ),
                    ),
                  ],
                )),
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

/* remove room */
  @override
  void itemRemoved() {
    setState(() {
      roomList.removeLast();
    });
  }
}

class _TheRoom extends StatefulWidget {
  final int index;

  final void Function(int count)? onchanged;
  final void Function()? onstateChange;
  late TextEditingController textControllerAdult = index == 0
      ? TextEditingController(text: "2")
      : TextEditingController(text: "1");
  final TextEditingController textControllerChildren =
      TextEditingController(text: "0");

  final RemoveItemInterface removeItemInterface;

  _TheRoom(this.index, this.removeItemInterface,
      {Key? key, this.onchanged, this.onstateChange})
      : super(key: key);
  @override
  _TheRoomState createState() => _TheRoomState();
}

class _TheRoomState extends State<_TheRoom> {
  String tempValueAdult = "1", tempValueChildren = "0";
  RoomModel? roomModel;
  SelectAge? selectAge;
  int currentGuest = 1, childcount = 0;
  List selectedAge = [];
  List<_TheRoom> roomList = [];
  List children = [];
  List select = [];
  var age = 12;
  bool expanded = false;
  List<ScrollController> scrollcontroller = [];

  bool isExpanded() {
    if (collapse == widget.index) {
      return true;
    } else {
      return false;
    }
  }

  void addAge(child) {
    for (int l = 0; l < 12; l++) {
      setState(() {
        select[child - 1]["age"].insert(l, false);
      });
    }
  }

  void addscrollController() {
    for (int k = 0; k < childcount; k++) {
      setState(() {
        scrollcontroller.add(ScrollController(keepScrollOffset: true));
      });
    }
  }

  void setcurrentGuest(index) {
    setState(() {
      // currentGuest;
    });
  }

  @override
  void initState() {
    super.initState();

    currentGuest = int.parse(widget.textControllerAdult.text) +
        int.parse(widget.textControllerChildren.text);

    childcount = int.parse(widget.textControllerChildren.text);
    addscrollController();

    if (childcount != 0) {
      for (int j = 0; j < childcount; j++) {
        select.add({"child": childcount, "age": []});
        addAge(j + 1);
        int? age = SelectAge.childDetail[widget.index]['children'][j]['age'];

        children.add({"age": age});
        select[j]["age"][age] = true;

       // WidgetsBinding.instance?.addPostFrameCallback((_) {
          if (scrollcontroller[j].hasClients) {
            double _scrollto = 0;
            if (age! < 4) {
              _scrollto = age * 20.toDouble();
            } else {
              _scrollto = age * 40.toDouble();
            }
            /* scroll to the selected index position */
            scrollcontroller[j].animateTo(
              _scrollto,
              duration: Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
            );
          }
        // });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        key: UniqueKey(),
        margin: EdgeInsets.all(7),
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 4.0,
          ),
        )),
        child: collapse == widget.index
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                        child: TextWidget(
                          text: "Room ${widget.index + 1}",
                          textAlign: TextAlign.start,
                          weight: FontWeight.bold,
                          color: grey600_color,
                          size: text_font_medium19_size,
                        ),
                      ),
                      widget.index == 0
                          ? Container()
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.removeItemInterface.itemRemoved();
                                  GuestCount.guest =
                                      GuestCount.guest - currentGuest;

                                  SelectAge().removeRoomdata(widget.index);
                                  SelectAge.roomcount = SelectAge.roomcount - 1;
                                  widget.onchanged!(GuestCount.guest);
                                });
                              },
                              child: Container(
                                child: TextWidget(
                                    text: "Remove",
                                    alignment: TextAlign.right,
                                    color: blue_color),
                              ),
                            )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  increDecre("Adult", "(above 12 yrs)",
                      widget.textControllerAdult, tempValueAdult, 'adult'),
                  SizedBox(
                    height: 5,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[300]!,
                        ),
                      )),
                    ),
                  ),
                  increDecre(
                      "Children",
                      "(0-11 yrs)",
                      widget.textControllerChildren,
                      tempValueChildren,
                      'child'),
                  Container(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: childcount > 0 ? childcount : 0,
                        itemBuilder: (context, i) {
                          return childage(i);
                        },
                      ),
                    ),
                  ),
                ],
              )
            : Padding(
                padding: EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                          child: TextWidget(
                            text: "Room ${widget.index + 1}",
                            textAlign: TextAlign.start,
                            weight: FontWeight.bold,
                            color: grey600_color,
                            size: text_font_medium19_size,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 7.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TextWidget(
                            text:
                                '${widget.textControllerAdult.text} Adult, ${widget.textControllerChildren.text} Child',
                            weight: FontWeight.bold,
                            color: black_color,
                            size: text_font_medium_size,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                collapse = widget.index;
                                widget.onchanged!(GuestCount.guest);
                              });
                            },
                            child: Container(
                              child: TextWidget(
                                text: "Edit",
                                alignment: TextAlign.right,
                                size: text_font_medium16_size,
                                color: grey600_color,
                              ),
                            ),
                          ),
                          widget.index == 0
                              ? Container(
                                  width: 40,
                                )
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      widget.removeItemInterface.itemRemoved();
                                      GuestCount.guest =
                                          GuestCount.guest - currentGuest;

                                      SelectAge().removeRoomdata(widget.index);
                                      SelectAge.roomcount =
                                          SelectAge.roomcount - 1;
                                      widget.onchanged!(GuestCount.guest);
                                    });
                                  },
                                  child: Container(
                                    child: TextWidget(
                                        text: "Remove",
                                        alignment: TextAlign.right,
                                        size: text_font_medium16_size,
                                        color: blue_color),
                                  ),
                                )
                        ],
                      ),
                    ),
                  ],
                ),
              ));
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

  Widget increDecre(pnama, ageRestrict, textController, tempValue, type) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(flex: 2, child: theTitleText(pnama, ageRestrict)),
          Expanded(child: incrementDecrement(textController, tempValue, type))
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
              fontSize: text_font_medium_size,
              fontWeight: FontWeight.bold,
              color: black_color,
            ),
          ),
          new TextSpan(
            text: "\t" + subtitle,
            style: new TextStyle(
              fontSize: text_font_medium_size,
              fontWeight: FontWeight.w400,
              color: black_color,
            ),
          ),
        ]))
      ],
    );
  }

/* plus and minus button */
  Widget incrementDecrement(theController, tempValue, type) {
    return Container(
      padding: EdgeInsets.only(top: 2),
      width: 80,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (int.parse(theController.text) <
                        (int.parse(tempValue) + 1)) {
                      theController.text = tempValue;
                    } else {
                      theController.text =
                          "${int.parse(theController.text) - 1}";
                      currentGuest -= 1;
                      if (GuestCount.guest <= 0) {
                      } else {
                        GuestCount.guest = GuestCount.guest - 1;
                        widget.onchanged!(GuestCount.guest);
                      }

                      if (type == 'child' && childcount != 0) {
                        childcount--;
                        scrollcontroller.removeLast();
                        SelectAge().removeChildDetail(widget.index);
                      }
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: type == 'child'
                        ? int.parse(theController.text) == 0
                            ? Colors.grey[300]
                            : black_color
                        : int.parse(theController.text) > 1
                            ? black_color
                            : Colors.grey[300],
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Icon(
                    Icons.remove,
                    color: white_text_color,
                    size: 18,
                  ),
                ),
              ),
            ),
            Container(
              width: 10,
              alignment: Alignment.center,
              child: TextField(
                showCursor: false,
                enabled: false,
                style: TextStyle(
                  fontSize: text_font_medium_size,
                  fontFamily: "montserrat",
                  fontWeight: FontWeight.bold,
                ),
                controller: theController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: InkWell(
                onTap: () {
                  setState(() {
                    // RoomModel rmodel = RoomModel();

                    if (currentGuest < 4 && GuestCount.guest < 9) {
                      theController.text =
                          "${int.parse(theController.text) + 1}";
                      currentGuest += 1;
                      GuestCount.guest = GuestCount.guest + 1;
                      widget.onchanged!(GuestCount.guest);

                      if (type == 'child') {
                        childcount++;
                        children.add({"age": 1});
                        select.add({"child": childcount, "age": []});

                        addAge(childcount);
                        scrollcontroller.add(ScrollController());

                        SelectAge().setChildAge(widget.index, children);
                        select[childcount - 1]["age"][1] = true;
                      }
                      if (GuestCount.guest == 9) {}
                    } else {
                      widget.onchanged!(GuestCount.guest);
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: currentGuest < 4 && GuestCount.guest < 9
                        ? black_color
                        : Colors.grey[300],
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 18,
                    color: white_text_color,
                  ),
                ),
              ),
            ),
          ]),
    );
  }

/* child age section */
  Widget childage(i) {
    return Container(
      padding: EdgeInsets.only(top: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              theTitleText('Age of Child ', '${i + 1}'),
            ],
          ),
          new SizedBox(
            height: 20,
          ),
          new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                height: 45,
                width: MediaQuery.of(context).size.width / 1.2,
                child: ListView.builder(
                    controller: scrollcontroller[i],
                    scrollDirection: Axis.horizontal,
                    key: PageStorageKey(i),
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            for (int k = 0; k < 12; k++) {
                              select[i]["age"][k] = false;
                            }
                            if (select[i]["age"][index] == false) {
                              select[i]["age"][index] = true;
                            }

                            children[i]["age"] = index;

                            SelectAge().setChildAge(widget.index, children);
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 5, right: 6),
                          width: 47,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: select[i]["age"][index] == true
                                    ? transColor
                                    : grey_color,
                                width: 0.8,
                              ),
                              color: select[i]["age"][index] == true
                                  ? blue_color
                                  : white_text_color),
                          child: Container(
                            height: 48,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: TextWidget(
                                  text: index == 0 ? '< 1' : '$index',
                                  alignment: TextAlign.center,
                                  size: text_font_medium15_size,
                                  color: select[i]["age"][index] == true
                                      ? white_text_color
                                      : black_color,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RemoveItemInterface {
  void itemRemoved() {}
}

class RoomModel {
  List<GuestModel> roomList = List.empty(growable: true);
  int count = 0;
  int totalRoom() {
    return roomList.length == 0 ? roomList.length + 1 : roomList.length;
  }

  int totalGuests() {
    int guest = 0;
    for (int i = 0; i < roomList.length; i++) {
      guest = guest + roomList[i].adult + roomList[i].children;
    }
    return guest;
  }

  int totalAdults() {
    int adults = 0;
    for (int i = 0; i < roomList.length; i++) {
      adults = adults + roomList[i].adult;
    }
    return adults == 0 ? adults + 2 : adults;
  }

  int totalChildren() {
    int children = 0;
    for (int i = 0; i < roomList.length; i++) {
      children = children + roomList[i].children;
    }
    return children;
  }

  int? totalcount(guestcount) {
    count = guestcount + count;
    return count;
  }

  List getRoomDetails() {
    return SelectAge.childDetail;
  }

  void resetRoomDetails() {
    SelectAge.childDetail = [];
  }
}

class GuestModel {
  int adult = 0, children = 0;
  GuestModel(this.adult, this.children);
}

class GuestCount {
  static int guest = 1;
}

class SelectAge {
  RoomModel? roomModel;
  static List childDetail = [];
  static int roomcount = 1;
  var detail = [];

  void addChildDetail() {
    SelectAge.childDetail.add({"adult_count": 1, "children": []});
  }

  void setChildAge(room, child) {
    SelectAge.childDetail[room]["children"] = child;
  }

  void removeChildDetail(room) {
    SelectAge.childDetail[room]["children"].removeLast();
  }

  void removeRoomdata(room) {
    SelectAge.childDetail.removeAt(room);
  }

  void setAdultcount(room, count) {
    SelectAge.childDetail[room]["adult_count"] = count;
  }
}

class CollapseRoom {
  static String isExpanded = '0';

  void expand(i) {
    isExpanded = '$i';
  }
}
