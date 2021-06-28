/* DRIVING LOG TRACKER */

import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';

void main() {
  runApp(Home());
}

final pdf = File('file.txt');

int entryNum = 0;

int logNum = 1;
List<drivingEntry> container = [];
List<Data> entryInfo = [];
List<drivingLog> logs = [new drivingLog(), new drivingLog(), new drivingLog()];
List entries = [container, List<drivingEntry>(), List<drivingEntry>()];

Color iconTeal = Colors.teal;
Color iconTeal2 = Colors.teal;
final myController2 = TextEditingController();
var now = new DateTime.now();

class Data {
  int time;
  DateTime dateTime;
  String road;
  String weather;
  String dayOrNight;
  String notes;
  Data(
      {this.time,
        this.dateTime,
        this.road,
        this.weather,
        this.dayOrNight,
        this.notes});
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartStop(),
    );
  }
}

class StartStop extends StatefulWidget {
  @override
  _StartStopState createState() => _StartStopState();
}

class _StartStopState extends State<StartStop> {
  @override
  bool track = true;
  double tick = 0.0;
  int secNum = 0;
  int minNum = 0;
  int hourNum = 0;
  int totalMin = 0;
  String sec = '00';
  String min = '00';
  String hour = '00';
  String total = '0hrs 0min';

  void showAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            title: new Text("Cannot Proceed"),
            content: new Text("Entry has to be longer than 1 minute"),
            actions: [
              CupertinoDialogAction(
                  isDefaultAction: true,
                  child: new Text("Continue Timing"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  newLog(String name, int n) async {
    return ListTile(
      title: Text('$name', style: TextStyle()),
      onTap: () {
        logNum = n;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => logs[n]));
      },
    );
  }

  List navBars = [];
  final rename = TextEditingController();

  renameLog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add new driving log:'),
            content: TextField(
              controller: rename,
              decoration: InputDecoration(hintText: "Driving Log 4"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  entries.add(List<drivingEntry>());
                  logs.add(new drivingLog());

                  logNum++;
                  navBars.add(newLog(rename.text, logNum));
                },
              )
            ],
          );
        });
  }

  Color circleteal = Colors.teal;
  Color circlewhite = Colors.white;

  Widget build(BuildContext context) {
    navBars.add(newLog("Driving 1", 0));
    navBars.add(newLog("Driving 2", 1));
    navBars.add(newLog("Driving 3", 2));

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[800],
          elevation: 0.0,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Row(
                  children: <Widget>[
                    Text('Logs',
                        style: TextStyle(color: Colors.white, fontSize: 30)),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          renameLog(context);
                        });
                      },
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.teal,
                ),
              ),
              ListTile(
                title: Text('Driving Log 1', style: TextStyle()),
                onTap: () {
                  logNum = 0;
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => logs[0]));
                },
              ),
              ListTile(
                title: Text('Driving Log 2', style: TextStyle()),
                onTap: () {
                  logNum = 1;
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => logs[1]));
                },
              ),
              ListTile(
                title: Text('Driving Log 3', style: TextStyle()),
                onTap: () {
                  logNum = 2;
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => logs[2]));
                },
              ),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            // Box decoration takes a gradient
            gradient: LinearGradient(
              // Where the linear gradient begins and ends
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              // Add one stop for each color. Stops should increase from 0 to 1
              stops: [0.1, 0.5, 0.9],
              colors: [
                Colors.deepPurple[800],
                Colors.indigo[600],
                Colors.deepPurpleAccent[400],
              ], /*Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          child: Center(
                            child: Text(
                              "Track Time:",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 30),
                            ),
                          ),
                        ),
                        /*Container(
                          child: Center(
                            child: Text(
                              "$total",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 30),
                            ),
                          ),
                        ),*/
                      ],
                    ),
                  ),*/
            ),
          ),
          child: Center(
            child: FractionallySizedBox(
              heightFactor: 0.75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: CircularPercentIndicator(
                        radius: 200.0,
                        lineWidth: 2.0,
                        percent: secNum / 60,
                        center: Text(
                          "$hour : $min",
                          style: TextStyle(color: Colors.white, fontSize: 45),
                        ),
                        backgroundColor: circlewhite,
                        progressColor: circleteal,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 200,
                      height: 70,
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: OutlineButton(
                          borderSide: BorderSide(
                            color: Colors.white, //Color of the border
                            style: BorderStyle.solid, //Style of the border
                            width: 0.8, //width of the border
                          ),
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          color: Colors.transparent,
                          child: Text(
                            "START",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                          onPressed: () {
                            track = true;
                            Timer.periodic(Duration(seconds: 1), (timer) {
                              print(DateTime.now());
                              setState(() {
                                if (!track) {
                                  timer.cancel();
                                } else {
                                  tick++;
                                  secNum = tick.round() % 60;
                                  minNum = tick ~/ 60;
                                  hourNum = minNum ~/ 60;
                                  if (secNum < 10) {
                                    sec = '0$secNum';
                                  } else {
                                    sec = '$secNum';
                                  }
                                  if (minNum < 10) {
                                    min = '0' + (tick ~/ 60).toString();
                                  } else {
                                    min = (tick ~/ 60).toString();
                                  }
                                  if (hourNum < 10) {
                                    hour = '0' + (minNum ~/ 60).toString();
                                  } else {
                                    hour = (minNum ~/ 60).toString();
                                  }
                                  totalMin += hourNum * 60 + minNum;
                                  total =
                                  '${totalMin ~/ 60}hrs ${totalMin % 60}min';
                                  if (minNum % 2 == 1) {
                                    circlewhite = Colors.teal;
                                    circleteal = Colors.white;
                                  } else {
                                    circlewhite = Colors.white;
                                    circleteal = Colors.teal;
                                  }
                                }
                              });
                            });
                          }),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 200,
                      height: 70,
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: OutlineButton(
                          borderSide: BorderSide(
                            color: Colors.white, //Color of the border
                            style: BorderStyle.solid, //Style of the border
                            width: 0.8, //width of the border
                          ),
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          color: Colors.transparent,
                          child: Text(
                            "PAUSE",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                          onPressed: () {
                            setState(() {
                              track = false;
                              print(track);
                            });
                          }),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 200,
                      height: 70,
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: OutlineButton(
                          borderSide: BorderSide(
                            color: Colors.white, //Color of the border
                            style: BorderStyle.solid, //Style of the border
                            width: 0.8, //width of the border
                          ),
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          color: Colors.transparent,
                          child: Text(
                            "STOP",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                          onPressed: () {
                            if (tick < 60) {
                              showAlert();
                            } else {
                              setState(() {
                                totalMin = hourNum * 60 + minNum;
                                track = false;
                                tick = 0;
                                secNum = 0;
                                sec = '00';
                                min = "00";
                                hour = '00';
                                minNum = 0;
                                hourNum = 0;
                                print(track);
                                total =
                                '${totalMin ~/ 60}hrs ${totalMin % 60}min';
                                final data = Data(
                                  time: totalMin,
                                  dateTime: new DateTime.now(),
                                  road: "",
                                  weather: "",
                                  dayOrNight: "Day",
                                  notes: "",
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => adjustDrive(
                                        data: data,
                                      )),
                                );
                              });
                            }
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class adjustDrive extends StatefulWidget {
  @override
  final Data data;
  adjustDrive({this.data});

  _adjustDriveState createState() => _adjustDriveState();
}

class _adjustDriveState extends State<adjustDrive> {
  List<String> reportList = [
    "Local",
    "Highway",
    "Freeway",
    "Business",
    "Main Road"
  ];

  List<String> selectedReportList = List();

  _showReportDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Road Type", style: TextStyle(fontSize: 20)),
            content: MultiSelectChip(
              reportList,
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedReportList = selectedList;
                });
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Select"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  List<String> weatherList = ["Sun", "Rain", "Snow", "Fog", "Hail"];

  List<String> selectedWeatherList = List();

  _showWeatherDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Weather", style: TextStyle(fontSize: 20)),
            content: MultiSelectChip(
              weatherList,
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedWeatherList = selectedList;
                });
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Select"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  pickLog() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Container(
        child:
        Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
            Widget>[
          Expanded(
            flex: 2,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Text(
                          "${widget.data.dateTime.month}/${widget.data.dateTime.day}",
                          style: TextStyle(
                              fontSize: 50,
                              color: Colors.teal,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Container(
                        decoration: new BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 1.0, color: Colors.teal),
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Text(
                          "${widget.data.time ~/ 60}hrs ${widget.data.time % 60}min",
                          style: TextStyle(fontSize: 35),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: ShapeDecoration(
                          shape: CircleBorder(),
                          color: iconTeal,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.brightness_5),
                          color: Colors.white,
                          onPressed: () {
                            setState(() {
                              print("day pressed");
                              iconTeal = Colors.tealAccent;
                              iconTeal2 = Colors.teal;
                              widget.data.dayOrNight = "Day";
                            });
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: ShapeDecoration(
                          shape: CircleBorder(),
                          color: iconTeal2,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.brightness_3),
                          color: Colors.white,
                          onPressed: () {
                            setState(() {
                              print("night pressed");
                              iconTeal2 = Colors.tealAccent;
                              iconTeal = Colors.teal;
                              widget.data.dayOrNight = "Night";
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.teal),
                  top: BorderSide(width: 1.0, color: Colors.teal),
                ),
                color: Colors.white,
              ),
              child: Row(
                children: <Widget>[
                  FlatButton(
                    color: Colors.white,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Text(
                        "Road Type",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    onPressed: () => _showReportDialog(),
                  ),
                  Flexible(
                    child: Text(
                      selectedReportList.join(", "),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: new BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.teal),
                ),
                color: Colors.white,
              ),
              child: Row(
                children: <Widget>[
                  FlatButton(
                    color: Colors.white,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Text(
                        "Weather",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    onPressed: () => _showWeatherDialog(),
                  ),
                  Flexible(
                    child: Text(
                      selectedWeatherList.join(", "),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(20),
              child: TextField(
                  style: TextStyle(color: Colors.teal, fontSize: 20),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(hintText: 'Notes:'),
                  controller: myController2,
                  onSubmitted: (text) {
                    widget.data.notes = text;
                    print(widget.data.notes);
                  }),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  child: RaisedButton(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Text(
                          "CANCEL",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: RaisedButton(
                      color: Colors.teal,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Text(
                          "SAVE",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      onPressed: () {
                        widget.data.road = selectedReportList.join(", ");
                        widget.data.weather = selectedWeatherList.join(", ");
                        widget.data.notes = myController2.text;
                        entryNum++;
                        entryInfo.add(
                          Data(
                              time: widget.data.time,
                              dateTime: widget.data.dateTime,
                              road: widget.data.road,
                              weather: widget.data.weather,
                              dayOrNight: widget.data.dayOrNight,
                              notes: widget.data.notes),
                        );
                        //print(entryInfo.length);
                        myController2.clear();
                        showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoActionSheet(
                                    title: const Text('Pick a log:',
                                        style: TextStyle(fontSize: 25)),
                                    actions: <Widget>[
                                      CupertinoActionSheetAction(
                                          child: const Text(
                                            'Driving Log 1',
                                            style: TextStyle(
                                                color: Colors.teal,
                                                fontSize: 20),
                                          ),
                                          onPressed: () {
                                            logNum = 0;
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                    logs[0]));
                                            setState(() {
                                              entries[logNum].add(drivingEntry(
                                                /*data: widget.data*/));
                                            });
                                          }),
                                      CupertinoActionSheetAction(
                                          child: const Text(
                                            'Driving Log 2',
                                            style: TextStyle(
                                                color: Colors.teal,
                                                fontSize: 20),
                                          ),
                                          onPressed: () {
                                            logNum = 1;
                                            setState(() {
                                              entries[logNum].add(drivingEntry(
                                                /*data: widget.data*/));
                                            });
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                    logs[1]));
                                          }),
                                      CupertinoActionSheetAction(
                                          child: const Text(
                                            'Driving Log 3',
                                            style: TextStyle(
                                                color: Colors.teal,
                                                fontSize: 20),
                                          ),
                                          onPressed: () {
                                            logNum = 2;
                                            setState(() {
                                              entries[logNum].add(drivingEntry(
                                                /*data: widget.data*/));
                                            });
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                    logs[2]));
                                          }),
                                    ]));

                        //logNum = 0;
                        //setState(() {
                        //entries[logNum]
                        //  .add(drivingEntry(/*data: widget.data*/));
                        //});

                        //Navigator.push(
                        //context,
                        //MaterialPageRoute(builder: (context) => logs[0]),
                        //);
                      }),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  final Function(List<String>) onSelectionChanged;

  MultiSelectChip(this.reportList, {this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  // String selectedChoice = "";
  List<String> selectedChoices = List();

  _buildChoiceList() {
    List<Widget> choices = List();

    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}

class newEntry extends StatefulWidget {
  @override
  _newEntryState createState() => _newEntryState();
}

class _newEntryState extends State<newEntry> {
  final newLogEntry = TextEditingController();
  final timeHour = TextEditingController();
  final timeMinute = TextEditingController();

  DateTime d = DateTime.now();
  int t = 0;
  String r = "";
  String w = "";
  String n = "";
  String don = "";

  bool local = false;
  bool highway = false;
  bool freeway = false;
  bool main = false;
  bool business = false;

  bool sun = false;
  bool rain = false;
  bool snow = false;
  bool hail = false;
  bool fog = false;

  bool isDay = false;

  final FocusNode focusHour = FocusNode();
  final FocusNode focusMin = FocusNode();

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  foundFit() {
    for (var i = 0; i < entries[logNum].length - 1; i++) {
      if (entries[logNum][i]
          .data
          .dateTime
          .isBefore(entryInfo[entryInfo.length - 1].dateTime) &&
          entries[logNum][i + 1]
              .data
              .dateTime
              .isAfter(entryInfo[entryInfo.length - 1].dateTime)) {
        return i+1;
      }

    }
    if (entries[logNum][entries[logNum].length-1]
        .data
        .dateTime
        .isBefore(entryInfo[entryInfo.length - 1].dateTime)) {
      return entries[logNum].length-1;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add new entry:'),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 50,
                child: TextFormField(
                  decoration: new InputDecoration(),
                  controller: timeHour,
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  textInputAction: TextInputAction.next,
                  focusNode: focusHour,
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  onFieldSubmitted: (term) {
                    _fieldFocusChange(context, focusHour, focusMin);
                  },
                ),
              ),
              Text(":"),
              SizedBox(
                width: 50,
                child: TextFormField(
                  decoration: new InputDecoration(),
                  controller: timeMinute,
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  textInputAction: TextInputAction.next,
                  focusNode: focusMin,
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  onFieldSubmitted: (value) {
                    focusMin.unfocus();
                  },
                ),
              ),
            ],
          ),
          MaterialButton(
            child: Text(
              "Pick Date",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.teal,
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext builder) {
                    return Container(
                        height:
                        MediaQuery.of(context).copyWith().size.height / 3,
                        child: CupertinoDatePicker(
                          initialDateTime: DateTime.now(),
                          onDateTimeChanged: (DateTime newdate) {
                            d = newdate;
                            print(d);
                          },
                          mode: CupertinoDatePickerMode.date,
                        ));
                  });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.brightness_3),
              Switch(
                value: isDay,
                onChanged: (value) {
                  setState(() {
                    isDay = value;
                  });
                },
                activeTrackColor: Colors.tealAccent,
                activeColor: Colors.teal,
              ),
              Icon(Icons.brightness_5),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("Road Types:",
                  style: TextStyle(color: Colors.teal, fontSize: 20)),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 15.0,
                children: <Widget>[
                  // [Monday] checkbox
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Local"),
                      Checkbox(
                        value: local,
                        onChanged: (bool value) {
                          setState(() {
                            local = value;
                          });
                        },
                      ),
                    ],
                  ),
                  // [Tuesday] checkbox
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Highway"),
                      Checkbox(
                        value: highway,
                        onChanged: (bool value) {
                          setState(() {
                            highway = value;
                          });
                        },
                      ),
                    ],
                  ),
                  // [Wednesday] checkbox
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Business"),
                      Checkbox(
                        value: business,
                        onChanged: (bool value) {
                          setState(() {
                            business = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Freeway"),
                      Checkbox(
                        value: freeway,
                        onChanged: (bool value) {
                          setState(() {
                            freeway = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Main"),
                      Checkbox(
                        value: main,
                        onChanged: (bool value) {
                          setState(() {
                            main = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("Weather:",
                  style: TextStyle(color: Colors.teal, fontSize: 20)),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8.0,
                children: <Widget>[
                  // [Monday] checkbox
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Sun"),
                      Checkbox(
                        value: sun,
                        onChanged: (bool value) {
                          setState(() {
                            sun = value;
                          });
                        },
                      ),
                    ],
                  ),
                  // [Tuesday] checkbox
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Rain"),
                      Checkbox(
                        value: rain,
                        onChanged: (bool value) {
                          setState(() {
                            rain = value;
                          });
                        },
                      ),
                    ],
                  ),
                  // [Wednesday] checkbox
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Fog"),
                      Checkbox(
                        value: fog,
                        onChanged: (bool value) {
                          setState(() {
                            fog = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Hail"),
                      Checkbox(
                        value: hail,
                        onChanged: (bool value) {
                          setState(() {
                            hail = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Snow"),
                      Checkbox(
                        value: snow,
                        onChanged: (bool value) {
                          setState(() {
                            snow = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          TextField(
            controller: newLogEntry,
            decoration: InputDecoration(hintText: "Notes:"),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: new Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: new Text('OK'),
          onPressed: () {
            setState(() {
              n = newLogEntry.text;

              if (local) {
                r += "Local, ";
              }
              if (highway) {
                r += "Highway, ";
              }
              if (freeway) {
                r += "Freeway, ";
              }
              if (main) {
                r += "Main Road, ";
              }
              if (business) {
                r += "Business";
              }

              if (sun) {
                w += "Sun, ";
              }
              if (rain) {
                w += "Rain, ";
              }
              if (snow) {
                w += "Snow, ";
              }
              if (hail) {
                w += "Hail, ";
              }
              if (fog) {
                w += "Fog";
              }

              if (isDay) {
                don = "Day";
              } else {
                don = "Night";
              }
              if (timeHour.text != "" && timeMinute.text != "") {
                t = int.parse(timeHour.text) * 60 + int.parse(timeMinute.text);
              } else if (timeHour.text == "" && timeMinute.text != "") {
                t = int.parse(timeMinute.text);
              } else if (timeHour.text != "" && timeMinute.text == "") {
                t = int.parse(timeHour.text) * 60;
              } else {
                t = 0;
              }
              entryInfo.add(new Data(
                  time: t,
                  road: r,
                  weather: w,
                  dateTime: d,
                  notes: n,
                  dayOrNight: don));
              entryNum++;
              print(entryInfo.length);
              if (entries[logNum].length >= 2) {
                entries[logNum].insert(foundFit(), new drivingEntry());
              } else if (entries[logNum].length == 1 && entries[logNum][0]
                  .data
                  .dateTime
                  .isAfter(entryInfo[entryInfo.length - 1].dateTime)) {
                entries[logNum].insert(0, new drivingEntry());
              } else {
                entries[logNum].add(new drivingEntry());
              }
            });

            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}

class drivingLog extends StatefulWidget {
  @override
  Data data;
  drivingLog({this.data});

  _drivingLogState createState() => _drivingLogState();
}

class _drivingLogState extends State<drivingLog> {
  @override
  int num = 1;

  int totalTime = 0;
  int dayTime = 0;
  int nightTime = 0;

  totalPrint(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Total Time:'),
            content: Container(
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('${totalTime ~/ 60}hrs ${totalTime % 60}min',
                      style: TextStyle(fontSize: 30, color: Colors.deepPurple)),
                  Text('Day: ${dayTime ~/ 60}hrs ${dayTime % 60}min',
                      style: TextStyle(fontSize: 20, color: Colors.blueAccent)),
                  Text('Night: ${nightTime ~/ 60}hrs ${nightTime % 60}min',
                      style: TextStyle(fontSize: 20, color: Colors.indigo)),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.arrow_back),
                iconSize: 30,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => StartStop()));
                }),
            Center(
              child: Text(
                'Driving Log ${logNum + 1}',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
            Align(
              //alignment: Alignment.center,
              child: IconButton(
                  icon: Icon(Icons.access_time),
                  color: Colors.white,
                  iconSize: 30,
                  onPressed: () {
                    totalPrint(context);
                  }),
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                color: Colors.black,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return newEntry();
                      }).then((_) => setState(() {}));
                }),
            NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowGlow();
              },
              child: ListView.builder(
                reverse: true,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                controller: ScrollController(),
                itemCount: entries[logNum].length,
                itemBuilder: (context, i) {
                  totalTime += entries[logNum][i].data.time;
                  if (entries[logNum][i].data.dayOrNight == "Day") {
                    dayTime += entries[logNum][i].data.time;
                  } else {
                    nightTime += entries[logNum][i].data.time;
                  }
                  print(totalTime);
                  if (entries[logNum].length != 0) {
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: entries[logNum][i],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class drivingEntry extends StatelessWidget {
  @override
  final Data data = entryInfo[entryNum - 1];
  Icon sunOrMoon = Icon(Icons.brightness_5);

  Widget build(BuildContext context) {
    if (data.dayOrNight == 'Day') {
      sunOrMoon = Icon(Icons.brightness_5, color: Colors.teal, size: 40);
    } else {
      sunOrMoon = Icon(Icons.brightness_3, color: Colors.teal, size: 40);
    }
    return new Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.black12,
      padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
      child: Wrap(
          spacing: 8.0, // gap between adjacent chips
          runSpacing: 4.0, // gap between lines
          alignment: WrapAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                sunOrMoon,
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('${data.dateTime.month}/${data.dateTime.day}   ',
                            style: TextStyle(fontSize: 30, color: Colors.teal)),
                        Text('${data.time ~/ 60}hrs ${data.time % 60}min',
                            style: TextStyle(fontSize: 30)),
                      ],
                    ),
                    Text('Road: ${data.road}'),
                    Text('Weather: ${data.weather}'),
                    Text('Notes: ${data.notes}'),
                  ],
                ),
              ],
            ),
          ]),
    );
  }
}
