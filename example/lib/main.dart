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

class Example extends StatefulWidget {

  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {

  final SlidableBarController controller = SlidableBarController(initialStatus: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('slidable bar example'),
      ),
      body: Column(
        children: [
          Container(
            height: 210,
            width: 300,
            child: SlidableBar(
              size: 60,
              slidableController: controller,
              side: Side.top,
              barChildren: [
                FlutterLogo(size: 50,),
                FlutterLogo(size: 50,),
                FlutterLogo(size: 50,),
                FlutterLogo(size: 50,),
              ],
              child: Container(
                color: Colors.grey.shade200,
                child: Center(
                  child: ElevatedButton(
                    child: Text("reverse status"),
                    onPressed: (){
                      controller.reverseStatus();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
