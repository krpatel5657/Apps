import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(
          child: Text("Screen A"),
        )
      ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              // Box decoration takes a gradient
              gradient: LinearGradient(
                // Where the linear gradient begins and ends
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                // Add one stop for each color. Stops should increase from 0 to 1
                stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  // Colors are easy thanks to Flutter's Colors class.
                  Colors.purple[800],
                  Colors.teal[700],
                  Colors.teal[400],
                  Colors.indigo[200],
                ],
              ),

            ),


        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Click here to go to the next screen:", style: TextStyle(color:Colors.white),),
            RaisedButton(
          child: Text("Screen B", style: TextStyle(color:Colors.black, fontSize: 30),),
                onPressed: () {

                  Navigator.push(context, MaterialPageRoute(builder: (context) => Second()),);
                }
            ),
          ],
        ),
    ),
    );
  }
}
class Second extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
          title: Center(
            child: Text("Screen B"),
          )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Click here to go to the next screen:"),
            RaisedButton(
                child: Text("Screen C", style: TextStyle(color:Colors.black, fontSize: 30),),
                onPressed: () {

                  Navigator.push(context, MaterialPageRoute(builder: (context) => Third()),);
                }
            ),
          ],
        ),
      ),
    );
  }
}
class Third extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.yellow,
          title: Center(
            child: Text("Screen C"),
          )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Click here to go to the next screen:"),
            RaisedButton(
                child: Text("Screen D", style: TextStyle(color:Colors.black, fontSize: 30),),
                onPressed: () {

                  Navigator.push(context, MaterialPageRoute(builder: (context) => Fourth()),);
                }
            ),
          ],
        ),
      ),
    );
  }
}
class Fourth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Center(
            child: Text("Screen D"),
          )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Click here to go to the next screen:"),
            RaisedButton(
                child: Text("Screen E", style: TextStyle(color:Colors.black, fontSize: 30),),
                onPressed: () {

                  Navigator.push(context, MaterialPageRoute(builder: (context) => Fifth()),);
                }
            ),
          ],
        ),
      ),
    );
  }
}
class Fifth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Center(
            child: Text("Screen E"),
          )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            Text("Click here to go to the next screen:"),
            RaisedButton(
                child: Text("Screen A", style: TextStyle(color:Colors.black, fontSize: 30),),
                onPressed: () {

                  Navigator.push(context, MaterialPageRoute(builder: (context) => First()),);
                }
            ),
          ],
        ),
      ),
    );
  }
}
