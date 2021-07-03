library slidable_bar;

import 'dart:async';

import 'package:flutter/material.dart';

class SlidableBar extends StatefulWidget {

  final Widget child;
  final Side? side;
  final Duration duration;
  final ValueChanged<int>? onChange;
  final List<Widget> barChildren;
  final Color? backgroundColor;
  final Color frontColor;
  final Curve curve;
  final double width;
  final Widget? clicker;
  final double clickerPosition;
  final double clickerSize;

  const SlidableBar({
    Key? key,
    required this.child,
    required this.barChildren,
    required this.width,
    required this.frontColor,
    this.clicker,
    this.onChange,
    this.side = Side.right,
    this.duration = const Duration(milliseconds: 300),
    this.backgroundColor,
    this.clickerPosition = 0.0,
    this.clickerSize = 55,
    this.curve = Curves.linear,
  }) : super(key: key);

  @override
  _SlidableSideBarState createState() => _SlidableSideBarState();

}

class _SlidableSideBarState extends State<SlidableBar> {

  StreamController<bool> barStatus = StreamController<bool>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: barStatus.stream,
        initialData: true,
        builder: (context, snapshot) {
          final isOpened = snapshot.data!;
          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(child: widget.child),
              if(widget.clicker == null)
                AnimatedPositioned(
                  right: isOpened ? widget.width-(widget.clickerSize*0.54) : -(widget.clickerSize*0.54),
                  bottom: 0,
                  top: 0,
                  duration: widget.duration,
                  curve: widget.curve,
                  child: Align(
                    alignment: Alignment(0.0,widget.clickerPosition),
                    child: RotationTransition(
                      turns: AlwaysStoppedAnimation(315 / 360),
                      child: InkWell(
                        onTap: (){
                          barStatus.add(!isOpened);
                        },
                        child: Container(
                          width: widget.clickerSize,
                          height: widget.clickerSize,
                          decoration: BoxDecoration(
                              color: widget.backgroundColor ?? Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(7)),
                              boxShadow: [
                                BoxShadow(color: Colors.black12,spreadRadius: 1,blurRadius: 5),
                              ]
                          ),
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: widget.clickerSize * 0.23,
                            height: widget.clickerSize * 0.23,
                            margin: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                color: widget.frontColor,
                                shape: BoxShape.circle
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              AnimatedPositioned(
                  right: widget.side == Side.right? isOpened? 0 : -widget.width : null,
                  // top: widget.side == Side.top? isOpened? 0 : -10  : null,
                  // bottom: widget.side == Side.bottom? isOpened? 0 : -10  : null,
                  top: 0,
                  bottom: 0,
                  left: widget.side == Side.left? isOpened? 0 : -widget.width  : null,
                  duration: widget.duration,
                  curve: widget.curve,
                  child: _SideBarContent(
                      children: widget.barChildren,
                      isOpen: isOpened,
                      width: widget.width,
                      onChange: widget.onChange,
                      controller: barStatus,
                      clicker: widget.clicker,
                      backgroundColor: widget.backgroundColor,
                      clickerPosition: widget.clickerPosition
                  )
              ),
            ],
          );
        }
    );
  }


  @override
  void dispose() {
    barStatus.close();
    super.dispose();
  }

}

class _SideBarContent extends StatelessWidget {

  final List<Widget> children;
  final Color? backgroundColor;
  final bool isOpen;
  final double width;
  final Widget? clicker;
  final ValueChanged<int>? onChange;
  final StreamController<bool> controller;
  final double clickerPosition;
  const _SideBarContent({
    Key? key,
    required this.children,
    required this.isOpen,
    required this.width,
    required this.controller,
    required this.backgroundColor,
    required this.onChange,
    required this.clicker,
    required this.clickerPosition,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: width,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black12,spreadRadius: 0,blurRadius: 5),
            ],
            color: backgroundColor ?? Theme.of(context).primaryColor,
          ),
          child: ListView.builder(
            itemCount: children.length,
            itemBuilder: (context,index){
              return GestureDetector(
                onTap: (){
                  controller.add(false);
                  onChange?.call(index);
                },
                child: children[index],
              );
            },
          ),
        ),
        if(clicker != null)
          Align(
              alignment: Alignment(0.0,clickerPosition),
              child: GestureDetector(
                  onTap: () => controller.add(!isOpen),
                  child: clicker))
      ],
    );
  }

}

enum Side{
  top,
  bottom,
  right,
  left
}
