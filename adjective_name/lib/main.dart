import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(Second());

class Second extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: names(),
    );
  }
}

class names extends StatefulWidget {
  @override
  _namesState createState() => _namesState();
}

class _namesState extends State<names> {
  @override
  int i = new Random().nextInt(10);
  String t = "Krishna Patel";
  List l = ["Keen", 'Krazy', "Kinetic", 'Kaleidoscopical', 'Key', 'Kind', 'Kingly', 'Killable', 'Knotty', 'Knowledgeable'];
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.amber,
            title: Center(
              child: Text(
                "Different Names Assignment",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            )),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'My Name:',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  '$t',
                  style: TextStyle(fontSize: 30),
                ),
                Container(
                  width: 120,
                  height: 70,
                  margin: EdgeInsets.fromLTRB(10, 50, 10, 10),
                  child: FlatButton(
                    color: Colors.amber,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                    onPressed: () {
                      setState(() {

                        t = 'Krishna Patel';
                      });
                    },
                    child: Container(
                      child: Center(
                        child: Text(
                          "Original",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 120,
                  height: 70,
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: FlatButton(
                    color: Colors.amber,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                    onPressed: () {
                      setState(() {
                        int j = i;
                        while(i == j) {
                          i = new Random().nextInt(10);
                        }
                        t = '${l[i]} Krishna';
                      });
                    },
                    child: Container(
                      child: Center(
                        child: Text(
                          "Random",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
        ),
        );
  }
}
