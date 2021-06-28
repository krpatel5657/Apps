import 'package:flutter/material.dart'

void main() => runApp(Planet());

class Planet extends StatelessWidghet {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planets'
          theme: ThemeData(
        primarySwatch: Colors.blue,
    ),
    home: MyHomePage(title: "Planets Home Page"),
    );
  }


}