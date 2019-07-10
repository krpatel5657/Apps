import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.amber,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
              backgroundImage: AssetImage('images/cloud.gif'),
                  maxRadius:70,
            ),
                Container(
                  margin: EdgeInsets.fromLTRB(10,10,10,10),
                  child:Text(
                    "Krishna Patel",
                    style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontSize: 36),
                  ),

                ),
                Container(
                  child:Text(
                    "Application Developer",
                    style: TextStyle(
                        color: Colors.black45,
                        fontSize: 30),
                  ),

                ),
                Container(
                  color: Colors.white,
                  height: 100,
                  width:300,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: Center(
                    child: Row(

                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.call),
                          color: Colors.black,

                        ),
                        Text("224 817 6217", style: TextStyle(
                            color: Colors.black54,
                            fontSize: 24),),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  height: 100,
                  width:300,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),

                  child: Center(

                    child: Row(

                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.alternate_email),
                            color: Colors.black,

                        ),

                        new Text("krpatel@gmail.com", style: TextStyle(
                            color: Colors.black54,
                            fontSize: 24),),
                      ],
                    ),
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
