import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slidable_bar/slidable_bar.dart';

void main()=> runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Example(),
    );
  }
}

class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('slidable bar example'),
      ),
      body: SlidableBar(
        width: 60,
        frontColor: Colors.green,
        backgroundColor: Colors.white,
        barChildren: [
          FlutterLogo(size: 50,),
          FlutterLogo(size: 50,),
          FlutterLogo(size: 50,),
          FlutterLogo(size: 50,),
        ],
        child: Container(
          color: Colors.grey.shade200,
        ),
      ),
    );
  }
}
