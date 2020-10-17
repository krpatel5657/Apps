/* DRIVING LOG TRACKER */

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:driving_log/models/note.dart';
//import 'package:driving_log/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:printing/printing.dart';
import 'document.dart';
import 'viewer.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:transformer_page_view/transformer_page_view.dart';

void main() {
  runApp(Home());
}

int entryNum = 0;

int logNum = 1;
List<Data> entryInfo = [];
List<drivingLog> logs = [new drivingLog(), new drivingLog(), new drivingLog()];


List<drivingEntry> container = [];
List entries = [container, List<drivingEntry>(), List<drivingEntry>()];

int theme = 0;

Color iconTeal = Colors.teal;
Color iconTeal2 = Colors.teal;

final myController2 = TextEditingController();
var now = new DateTime.now();

//DatabaseHelper databaseHelper = DatabaseHelper();

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

Color themePicked = Colors.deepPurple[800];

List<Color> themeGradient = [
  Colors.deepPurple[800],
  Colors.indigo[600],
  Colors.deepPurpleAccent[400]
];

List<List<Color>> themeGradients = [
  [Colors.pink, Colors.pinkAccent, Colors.purpleAccent],
  [Colors.cyan, Colors.blue, Colors.teal],
  [Colors.orange, Colors.orangeAccent, Colors.deepOrange],
  [Colors.deepPurple[800], Colors.indigo[600], Colors.deepPurpleAccent[400]]
];

List<Color> themeList = [
  Colors.pink,
  Colors.cyan,
  Colors.orange,
  Colors.deepPurple[800]
];

class StartStop extends StatefulWidget {
  @override
  _StartStopState createState() => _StartStopState();
}

class _StartStopState extends State<StartStop> {
  void initState() {
    getColorPreference().then(updateColor);
    super.initState();
  }

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
              decoration: InputDecoration(hintText: "Driving Log 2"),
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
  int click = 1;
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: themePicked,
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
                  color: themePicked,
                ),
              ),
              ListTile(
                title: Text('Driving Log 1', style: TextStyle(fontSize: 20)),
                onTap: () {
                  logNum = 0;
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => logs[0]));
                },
              ),
              Container(
                color: Colors.black12,
                child: ListTile(
                  title: Text('Learn', style: TextStyle(fontSize: 20)),
                  onTap: () {
                    logNum = 0;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyHomePage()));
                  },
                ),
              ),
              Container(
                color: Colors.black26,
                child: ListTile(
                  title: Text('Practice Questions',
                      style: TextStyle(fontSize: 20)),
                  onTap: () {
                    logNum = 0;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FlashCard()));
                  },
                ),
              ),
              Container(
                color: Colors.black38,
                child: ListTile(
                  title: Text('Settings', style: TextStyle(fontSize: 20)),
                  onTap: () {
                    logNum = 0;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Settings()));
                  },
                ),
              ),
              Container(
                color: Colors.black54,
                child: ListTile(
                  title: Text('Map',
                      style: TextStyle(fontSize: 20, color: Colors.black)),
                  onTap: () {
                    logNum = 0;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => map()));
                  },
                ),
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
                themeGradient[0],
                themeGradient[1],
                themeGradient[2],
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: FractionallySizedBox(
                heightFactor: 0.75,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: 200,
                        height: 70,
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: FlatButton(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                            color: Colors.transparent,
                            child: Text(
                              "RESTART",
                              style:
                              TextStyle(color: Colors.white, fontSize: 25),
                            ),
                            onPressed: () {
                              setState(() {
                                track = false;
                                tick = 0;
                                secNum = 0;
                                sec = '00';
                                min = "00";
                                hour = '00';
                                minNum = 0;
                                hourNum = 0;
                                click = 1;
                                //print(track);
                              });
                            }),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: CircularPercentIndicator(
                          radius: MediaQuery.of(context).size.width / 2,
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
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            color: Colors.transparent,
                            child: Text(
                              "START",
                              style:
                              TextStyle(color: Colors.white, fontSize: 25),
                            ),
                            onPressed: () {
                              track = true;

                              if (click == 1) {
                                Timer.periodic(Duration(seconds: 1), (timer) {
                                  //print(DateTime.now());
                                  setState(() {
                                    if (!track) {
                                      click = 1;
                                      timer.cancel();
                                    } else {
                                      click = 0;
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
                              }
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
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            color: Colors.transparent,
                            child: Text(
                              "PAUSE",
                              style:
                              TextStyle(color: Colors.white, fontSize: 25),
                            ),
                            onPressed: () {
                              setState(() {
                                track = false;
                                //print(track);
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
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            color: Colors.transparent,
                            child: Text(
                              "STOP",
                              style:
                              TextStyle(color: Colors.white, fontSize: 25),
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
                                  //print(track);
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
          ),
        ));
  }

  void updateColor(int n) {
    setState(() {
      themePicked = themeList[n];
      themeGradient = themeGradients[n];
    });
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
      resizeToAvoidBottomInset: false,
      body: Container(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
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
      ),
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
        return i + 1;
      }
    }
    if (entries[logNum][entries[logNum].length - 1]
        .data
        .dateTime
        .isBefore(entryInfo[entryInfo.length - 1].dateTime)) {
      return entries[logNum].length - 1;
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
              } else if (entries[logNum].length == 1 &&
                  entries[logNum][0]
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
  final items = entries[logNum];


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

  int getTimeAsInt(String t) {
    return int.parse(t.substring(0, t.indexOf('h'))) * 60 +
        int.parse(t.substring(t.indexOf('s') + 1, t.indexOf('m')));
  }

  final GlobalKey<State<StatefulWidget>> shareWidget = GlobalKey();
  final GlobalKey<State<StatefulWidget>> previewContainer = GlobalKey();

  final enterN = TextEditingController();

  List<Note> noteList = [];

  List<Note> updateNoteList (List<drivingEntry> ent) {
    noteList = [];
    for(int i = 0; i < ent.length; i++) {
      noteList.add(Note('${ent[i].data.time ~/ 60}hrs ${ent[i].data.time % 60}min', '${ent[i].data.dateTime.month}/${ent[i].data.dateTime.day}', ent[i].data.dayOrNight, ent[i].data.road, ent[i].data.weather, ent[i].data.notes));
    }
    return noteList;
  }

  Future<void> _printPdf() async {
    print('Print ...');
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async =>
            (await generateDocument(enterN.text, updateNoteList(entries[logNum]), format)).save());
  }

  enterName(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter Name:'),
            content: TextField(
              controller: enterN,
              decoration: InputDecoration(hintText: "First Last"),
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
                onPressed: _printPdf,
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
        Container(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            IconButton(
                icon: Icon(Icons.print),
                color: Colors.black,
                onPressed: () {
                  setState(() {
                    enterName(context);
                  });
                }),
          ],
        ),),
            NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowGlow();
              },
              child: Expanded(
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
                      return Dismissible(
                        background: stackBehindDismiss(),
                        key: ObjectKey(entries[logNum][i]),
                        onDismissed: (direction) {
                          setState(() {
                            entries[logNum].removeAt(i);

                          });
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text("Entry deleted")));
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: entries[logNum][i],
                        ),
                      );
                    }
                  },
                ),
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

Widget stackBehindDismiss() {
  return Container(
    alignment: Alignment.centerRight,
    padding: EdgeInsets.only(right: 20.0),
    color: Colors.red,
    child: Icon(
      Icons.delete,
      color: Colors.white,
    ),
  );
}

class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.white,
  }) : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  // The base size of the dots
  static const double _kDotSize = 8.0;

  // The increase in the size of the selected dot
  static const double _kMaxZoom = 2.0;

  // The distance between the center of each dot
  static const double _kDotSpacing = 25.0;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return new Container(
      width: _kDotSpacing,
      child: new Center(
        child: new Material(
          color: color,
          type: MaterialType.circle,
          child: new Container(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: new InkWell(
              onTap: () => onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(itemCount, _buildDot),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final _controller = new PageController();

  static List<String> signNames = [
    "Railroad Crossing",
    'Stop Sign',
    'Yield',
    'Construction',
    'Speed Limit',
    'Guide Sign',
    'Caution',
    'Recreation',
    'Motorist Services',
    'Lane Reduction',
    'School Zone',
    'Slow Moving Vehicle',
    'Slippery',
    'No Passing',
    'Divided Highway',
    'Merge',
    'Crossroad',
    'Pedestrian Crossing',
    'Do Not Enter',
    'No U-Turn'
  ];
  static List<String> signPics = [
    'images/railroad.jpg',
    'images/stopsign.jpg',
    'images/yield.jpg',
    'images/construction.jpg',
    'images/speedlimit.jpg',
    'images/guidesign.jpg',
    'images/caution.jpg',
    'images/recreation.jpg',
    'images/motorist.jpg',
    'images/reduction.jpg',
    'images/school.jpg',
    'images/slow.jpg',
    'images/slipper.jpg',
    'images/nopassing.jpg',
    'images/dividedhighway.jpg',
    'images/merge.jpg',
    'images/crossroad.jpg',
    'images/pedestrian.jpg',
    'images/donotenter.jpg',
    'images/uturn.jpg'
  ];

  static const _kDuration = const Duration(milliseconds: 300);

  static const _kCurve = Curves.ease;

  final _kArrowColor = Colors.black.withOpacity(0.8);

  final List<Widget> _pages = <Widget>[
    new ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 15, 15, 30),
        child: new ListView(children: <Widget>[
          Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Text(
                "Rules of the Road",
                style: TextStyle(
                    color: themePicked,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Text(
              "Right Of Way",
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Text(
              "At a four way intersection, in order of importance:",
              style: TextStyle(color: Colors.black87, fontSize: 20),
            ),
          ),
          Container(
            child: Text(
              "  •   The first vehicle to arrive goes first",
              style: TextStyle(color: Colors.black87, fontSize: 20),
            ),
          ),
          Container(
            child: Text(
              "  •   If vehicles arrive at the same time, the rightmost vehicle (with an empty lane on their right side) goes first",
              style: TextStyle(color: Colors.black87, fontSize: 20),
            ),
          ),
          Container(
              child: Text(
                "  •   If all lanes are full, cars going straight take precedence over those turning",
                style: TextStyle(color: Colors.black87, fontSize: 20),
              )),
          Container(
            child: Text(
              "  •   If all else fails, the most aggressive driver goes first",
              style: TextStyle(color: Colors.black87, fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
            child: Image(
              image: AssetImage("images/fourway.jpg"),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Text(
              "Passing",
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
          ),
          Container(
            child: Text(
              "  •   Before passing another car, signal",
              style: TextStyle(color: Colors.black87, fontSize: 20),
            ),
          ),
          Container(
            child: Text(
              "  •   Make sure the left lane is clearly visible and free of oncoming traffic for a distance great enough for passing",
              style: TextStyle(color: Colors.black87, fontSize: 20),
            ),
          ),
          Container(
            child: Text(
              "  •   Drive ahead of the car in your original lane",
              style: TextStyle(color: Colors.black87, fontSize: 20),
            ),
          ),
          Container(
            child: Text(
              "  •   Turn back into your original lane when the entire veichle they have passed is visible in the rearview mirror",
              style: TextStyle(color: Colors.black87, fontSize: 20),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Text(
              "Signaling",
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Text(
                        "  •   Always signal before changing lanes, turning, or passing! Start signaling approximately 100 feet before you turn.",
                        style: TextStyle(color: Colors.black87, fontSize: 20),
                      ),
                      Text(
                        "  •   Start signaling approximately 100 feet before you turn.",
                        style: TextStyle(color: Colors.black87, fontSize: 20),
                      ),
                      Text(
                        "  •   Push the turn signal joystick up to signal right, and push down to signal left.",
                        style: TextStyle(color: Colors.black87, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image(
                      image: AssetImage("images/handsignals.jpg"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    ),
    new ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: new ListView.builder(
        itemCount: signNames.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: new BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 0.5, color: Colors.black38),
              ),
            ),
            padding: EdgeInsets.all(20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(signNames[index],
                      style: TextStyle(fontSize: 20, color: themePicked)),
                  Image(
                      image: AssetImage(signPics[index]),
                      width: 100,
                      height: 100),
                ]),
          );
        },
      ),
    ),
    new ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Image(
          image: AssetImage("images/dashboard.jpg"),
        ),
      ),
    ),
    new ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 30),
        child: new ListView(children: <Widget>[
          Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
              child: Text(
                "Traffic Signals",
                style: TextStyle(
                    color: themePicked,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Row(children: <Widget>[
            Expanded(
              flex: 1,
              child: Text(
                  "  •   Red Light - Driver must stop at the marked stop line or before entering the crosswalk. A driver may always make a right turn on red when there is no oncoming traffic, UNLESS there is a sign that specifies No Turn on Red. ",
                  style: TextStyle(fontSize: 20)),
            ),
            Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                    image: AssetImage("images/trafficsignal.jpg"),
                  ),
                ))
          ]),
          Container(
            child: Text(
              "  •   Yellow Light - Warns that the signal is changing from green to red",
              style: TextStyle(color: Colors.black87, fontSize: 20),
            ),
          ),
          Container(
            child: Text(
              "  •   Green Light - A driver may go after yielding the right of way to any pedestrian and vehicles in the intersection or the crosswalk",
              style: TextStyle(color: Colors.black87, fontSize: 20),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Text(
              "Flashing Lights",
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Image(
                image: AssetImage('images/flashinglights.jpg'),
              ),
            ),
          ),
          Container(
            child: Text(
              "  •   Flashing Red - Treat this like a stop sign. Follow Right of Way procedures at an intersection.",
              style: TextStyle(color: Colors.black87, fontSize: 20),
            ),
          ),
          Container(
            child: Text(
              "  •   Flashing Yellow - Proceed through the intersection with caution.",
              style: TextStyle(color: Colors.black87, fontSize: 20),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Text(
              "Arrows",
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
          ),
          Row(
              children: <Widget> [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image(
                      image: AssetImage('images/greenarrow.jpg'),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text('A driver may make a protected turn or proceed straight when this arrow is shown.', style: TextStyle(fontSize: 20)),
                ),
              ]
          )
        ]),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: AppBar(
          backgroundColor: themePicked,
          title: Text("Learn", style: TextStyle(fontSize: 30)),
        ),
      ),
      body: new IconTheme(
        data: new IconThemeData(color: _kArrowColor),
        child: new Stack(
          children: <Widget>[
            SafeArea(
              child: new PageView.builder(
                physics: new AlwaysScrollableScrollPhysics(),
                controller: _controller,
                itemBuilder: (BuildContext context, int index) {
                  return _pages[index % _pages.length];
                },
              ),
            ),
            new Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: new Container(
                color: Colors.grey[800].withOpacity(0.5),
                padding: const EdgeInsets.all(20.0),
                child: new Center(
                  child: new DotsIndicator(
                    controller: _controller,
                    itemCount: _pages.length,
                    onPageSelected: (int page) {
                      _controller.animateToPage(
                        page,
                        duration: _kDuration,
                        curve: _kCurve,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75.0),
        child: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text("Settings", style: TextStyle(fontSize: 30)),
        ),
      ),
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: new BoxDecoration(
                    border: new Border.all(color: Colors.black26)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(25),
                      child: Text("Theme",
                          style: TextStyle(color: Colors.black, fontSize: 30)),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              decoration: ShapeDecoration(
                                shape: CircleBorder(),
                                color: Colors.pink,
                              ),
                              child: IconButton(
                                  color: Colors.pink,
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    saveColor(0);
                                  }),
                            ),
                            Container(
                              decoration: ShapeDecoration(
                                shape: CircleBorder(),
                                color: Colors.cyan,
                              ),
                              child: IconButton(
                                  color: Colors.cyan,
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    saveColor(1);
                                  }),
                            ),
                            Container(
                              decoration: ShapeDecoration(
                                shape: CircleBorder(),
                                color: Colors.orange,
                              ),
                              child: IconButton(
                                  color: Colors.orange,
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    saveColor(2);
                                  }),
                            ),
                            Container(
                              decoration: ShapeDecoration(
                                shape: CircleBorder(),
                                color: Colors.deepPurple[800],
                              ),
                              child: IconButton(
                                  color: Colors.deepPurple[800],
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    saveColor(3);
                                  }),
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
              Text('Total Entries in Log: ${entryNum}',
                  style: TextStyle(fontSize: 20)),
              FlatButton(
                  color: Colors.black,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Clear Driving Log",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  onPressed: () {
                    entries[logNum] = [];
                    entryInfo = [];
                    entryNum = 0;
                  }),
              Container(
                decoration: new BoxDecoration(
                    border: new Border.all(color: Colors.black26)),
                child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                        '     Use this app to keep track of your practice driving hours. Once you have logged fifty hours, press the print icon in order to print out your entries formatted in a table. This app can also help prepare for the permit exam with all necessary content provided as well as sample questions.',
                        style: TextStyle(fontSize: 20))),
              ),
            ]),
      ),
    );
  }

  void saveColor(int n) {
    saveColorPreference(n).then((bool committed) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => StartStop()));
    });
  }
}

Future<bool> saveColorPreference(int n) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final themeColor = prefs.setInt('color', n);
  if (themeColor == null) {
    return false;
  }
  return themeColor;
}

Future<int> getColorPreference() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  theme = prefs.getInt('color');
  print(theme);
  return theme;
}

Future<void> _resetCounter() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('color', 0);
}

class FlashCard extends StatefulWidget {
  FlashCard({Key key}) : super(key: key);

  final String title = "Practice Questions";

  @override
  _FlashCardState createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: rootBundle.loadString('lib/assets/questions.csv'), //
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<List<dynamic>> csvTable =
          CsvToListConverter().convert(snapshot.data);
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(75.0),
              child: AppBar(
                backgroundColor: themePicked,
                title: Text(widget.title, style: TextStyle(fontSize: 30)),
              ),
            ),
            body: new TransformerPageView(
                loop: true,
                viewportFraction: 0.8,
                transformer: new PageTransformerBuilder(
                    builder: (Widget child, TransformInfo info) {
                      return new Padding(
                        padding: new EdgeInsets.all(20.0),
                        child: new Material(
                          elevation: 8.0,
                          textStyle: new TextStyle(color: Colors.white),
                          borderRadius: new BorderRadius.circular(10.0),
                          child: new Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              new Positioned(
                                child: new Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new ParallaxContainer(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            csvTable[info.index + 1][0],
                                            style: new TextStyle(
                                              fontSize: 24.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(20),
                                          ),
                                          Text(
                                            csvTable[info.index +
                                                ((csvTable.length) / 2).round()][0],
                                            style: new TextStyle(
                                              fontSize: 24.0,
                                              color: themePicked,
                                            ),
                                          ),
                                        ],
                                      ),
                                      position: info.position,
                                      translationFactor: 300.0,
                                    ),
                                  ],
                                ),
                                left: 50.0,
                                right: 50.0,
                                top: 100.0,
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                itemCount: ((csvTable.length) / 2).round() - 1),
          );
        });
  }
}

class map extends StatefulWidget {
  @override
  _mapState createState() => _mapState();
}

class _mapState extends State<map> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text("Map", style: TextStyle(fontSize: 30)),
        ),
      ),
      body: Stack(children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height - 140,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                  target: LatLng(
                    41.8781,
                    -87.6298,
                  ),
                  zoom: 12),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              }),
        ),
      ]),
    );
  }
}
