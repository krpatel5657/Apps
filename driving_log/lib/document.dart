import 'dart:async';
import 'package:driving_log/document.dart';
import 'package:flutter/widgets.dart' as fw;
import 'package:driving_log/models/note.dart';
import 'package:driving_log/utils/database_helper.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

const PdfColor green = PdfColor.fromInt(0xff9ce5d0);
const PdfColor lightGreen = PdfColor.fromInt(0xffcdf1e7);

class MyPage extends Page {
  MyPage(
      {PdfPageFormat pageFormat = PdfPageFormat.a4,
      BuildCallback build,
      EdgeInsets margin})
      : super(pageFormat: pageFormat, margin: margin, build: build);

  @override
  void paint(Widget child, Context context) {
    context.canvas
      ..setColor(lightGreen)
      ..moveTo(0, pageFormat.height)
      ..lineTo(0, pageFormat.height - 230)
      ..lineTo(60, pageFormat.height)
      ..fillPath()
      ..setColor(green)
      ..moveTo(0, pageFormat.height)
      ..lineTo(0, pageFormat.height - 100)
      ..lineTo(100, pageFormat.height)
      ..fillPath()
      ..setColor(lightGreen)
      ..moveTo(30, pageFormat.height)
      ..lineTo(110, pageFormat.height - 50)
      ..lineTo(150, pageFormat.height)
      ..fillPath()
      ..moveTo(pageFormat.width, 0)
      ..lineTo(pageFormat.width, 230)
      ..lineTo(pageFormat.width - 60, 0)
      ..fillPath()
      ..setColor(green)
      ..moveTo(pageFormat.width, 0)
      ..lineTo(pageFormat.width, 100)
      ..lineTo(pageFormat.width - 100, 0)
      ..fillPath()
      ..setColor(lightGreen)
      ..moveTo(pageFormat.width - 30, 0)
      ..lineTo(pageFormat.width - 110, 50)
      ..lineTo(pageFormat.width - 150, 0)
      ..fillPath();

    super.paint(child, context);
  }
}

class Block extends StatelessWidget {
  Block({this.title});

  final String title;

  @override
  Widget build(Context context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(top: 2.5, left: 2, right: 5),
              decoration:
                  const BoxDecoration(color: green, shape: BoxShape.circle),
            ),
            Text(title,
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(fontWeight: FontWeight.bold)),
          ]),
          Container(
            decoration: const BoxDecoration(
                border: BoxBorder(left: true, color: green, width: 2)),
            padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
            margin: const EdgeInsets.only(left: 5),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Lorem(length: 20),
                ]),
          ),
        ]);
  }
}

class Category extends StatelessWidget {
  Category({this.title});

  final String title;



  @override
  Widget build(Context context) {
    return Container(
        decoration: const BoxDecoration(color: lightGreen, borderRadius: 6),
        margin: const EdgeInsets.only(bottom: 10, top: 20),
        padding: const EdgeInsets.fromLTRB(10, 7, 10, 4),
        child: Text(title, textScaleFactor: 1.5));
  }
}

int getTimeAsInt (String t) {
  //return "${t ~/ 60}hrs ${t % 60}min";
  return int.parse(t.substring(0, t.indexOf('h')))*60 + int.parse(t.substring(t.indexOf('s')+1, t.indexOf('m')));
}



Future<Document> generateDocument(String enteredName, List<Note> n, PdfPageFormat format) async {

  final Document pdf = Document(title: 'Driving Log', author: '$enteredName');

  int totalTime = 0;
  int dayTime = 0;
  int nightTime = 0;


  final List<List<String>> entries = [['Date', 'Time driven', 'Road type', 'Weather', 'Notes']];

  for (int i = 0; i < n.length; i++) {
    totalTime += getTimeAsInt(n[i].time);
    if (n[i].dayOrNight == "Day") {
      dayTime += getTimeAsInt(n[i].time);
    } else {
      nightTime += getTimeAsInt(n[i].time);
    }
  }

  for (Note i in n) {
    List <String> s = [i.dateTime, i.time, i.road, i.weather, i.notes];
    entries.add(s);
  }


  pdf.addPage(MyPage(
    pageFormat: format.applyMargin(
        left: 2.0 * PdfPageFormat.cm,
        top: 4.0 * PdfPageFormat.cm,
        right: 2.0 * PdfPageFormat.cm,
        bottom: 2.0 * PdfPageFormat.cm),
    build: (Context context) => Row(children: <Widget>[
      Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
            Container(
                padding: const EdgeInsets.only(left: 30, bottom: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Driving Log',
                          textScaleFactor: 2,
                          style: Theme.of(context)
                              .defaultTextStyle
                              .copyWith(fontWeight: FontWeight.bold)),
                      Padding(padding: const EdgeInsets.only(top: 20)),
                      Text('$enteredName',
                          textScaleFactor: 1.5,
                          style: Theme.of(context)
                              .defaultTextStyle
                              .copyWith(fontWeight: FontWeight.bold)),
                      Padding(padding: const EdgeInsets.only(top: 20)),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Total hours: ${totalTime ~/ 60}hrs ${totalTime % 60}min'),
                            Text('Day: ${dayTime ~/ 60}hrs ${dayTime % 60}min'),
                            Text('Night: ${nightTime ~/ 60}hrs ${nightTime % 60}min'),
                            Padding(padding: EdgeInsets.zero)
                          ]),
                    ])),
                Table.fromTextArray(context: context, data: entries),
          ])),


    ]),
  ));
  return pdf;
}
