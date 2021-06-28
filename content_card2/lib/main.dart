import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());

}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new First());
  }
}
class First extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.amber,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: AssetImage('images/krishna.jpg'),
                  maxRadius:70,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10,10,10,10),
                  child:Text(
                    "Krishna Patel",
                    style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontSize: 36, fontWeight:FontWeight.bold),
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
                          icon: Icon(Icons.call, color: Colors.amber,size:32),

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
                          icon: Icon(Icons.alternate_email, color: Colors.amber,size: 32),
                        ),

                        Expanded(
                          child: new Text("krpatel5657@gmail.com", style: TextStyle(
                              color: Colors.black54,
                              fontSize: 24),),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.amberAccent,
                  width:200,
                  height: 70,
                  margin: EdgeInsets.fromLTRB(10,100,10,10),
                  child: RaisedButton(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    color: Colors.amberAccent,
                    child: Text("Adjectives", style: TextStyle(color:Colors.white, fontSize: 30),),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Second()),);
                    }
                  ),
                )
              ],
            ),
          ),
        ),
      );

  }
}




class Second extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: names(),
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
    return new Scaffold(
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
              Container(
                color: Colors.amberAccent,
                width:200,
                height: 70,
                margin: EdgeInsets.fromLTRB(10,100,10,10),
                child: RaisedButton(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    color: Colors.amberAccent,
                    child: Text("BACK", style: TextStyle(color:Colors.white, fontSize: 30),),
                    onPressed: () {
                      //Navigator.push(context, MaterialPageRoute(builder: (context)=>First()),);
                      Navigator.pop(context);
                    }
                ),
              )
            ]),
      ),
    );
  }
}
