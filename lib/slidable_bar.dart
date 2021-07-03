library slidable_bar;

import 'dart:async';

import 'package:flutter/material.dart';

class SlidableBar extends StatefulWidget {

  final Widget child;
  final Side side;
  final Duration duration;
  final bool isOpenFirst;
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
    this.isOpenFirst = false
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
        initialData: widget.isOpenFirst,
        builder: (context, snapshot) {
          final isOpened = snapshot.data!;
          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(child: widget.child),
              if(widget.clicker == null)
                AnimatedPositioned(
                  right: [Side.bottom,Side.top].contains(widget.side)
                      ?0
                      :widget.side == Side.right
                      ?isOpened
                      ? widget.width-(widget.clickerSize*0.54)
                      : -(widget.clickerSize*0.54)
                      :null,
                  left: [Side.bottom,Side.top].contains(widget.side)
                      ?0
                      :widget.side == Side.left
                      ?isOpened
                      ?widget.width-(widget.clickerSize*0.54)
                      :-(widget.clickerSize*0.54)
                      :null,
                  bottom: [Side.right,Side.left].contains(widget.side)
                      ?0
                      :widget.side == Side.bottom
                      ?isOpened
                      ?widget.width-(widget.clickerSize*0.54)
                      :-(widget.clickerSize*0.54)
                      :null,
                  top: [Side.right,Side.left].contains(widget.side)
                      ?0
                      :widget.side == Side.top
                      ?isOpened
                      ?widget.width-(widget.clickerSize*0.54)
                      :-(widget.clickerSize*0.54)
                      :null,
                  duration: widget.duration,
                  curve: widget.curve,
                  child: Align(
                    alignment: Alignment(widget.clickerPosition,widget.clickerPosition),
                    child: RotationTransition(
                      turns: AlwaysStoppedAnimation(
                          (widget.side == Side.right ? 315
                              :widget.side == Side.left?135
                              :widget.side == Side.bottom?45:225) / 360),
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
                  right: widget.side == Side.right? isOpened? 0 : -widget.width : widget.side == Side.left?null:0,
                  top: widget.side == Side.top? isOpened? 0 : -widget.width  : widget.side == Side.bottom?null:0,
                  bottom: widget.side == Side.bottom? isOpened? 0 : -widget.width  : widget.side == Side.top?null:0,
                  left: widget.side == Side.left? isOpened? 0 : -widget.width  : widget.side == Side.right?null:0,
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
                      clickerPosition: widget.clickerPosition,
                      side: widget.side
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
  final Side side;
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
    required this.side,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final body = Container(
      width: [Side.left,Side.right].contains(side)?width:null,
      height: [Side.left,Side.right].contains(side)?null:width,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black12,spreadRadius: 0,blurRadius: 5),
        ],
        color: backgroundColor ?? Theme.of(context).primaryColor,
      ),
      child: ListView.builder(
        itemCount: children.length,
        scrollDirection: [Side.right,Side.left].contains(side)?Axis.vertical:Axis.horizontal,
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
    );
    final customClicker = Align(
        alignment: Alignment(clickerPosition,clickerPosition),
        child: GestureDetector(
            onTap: () => controller.add(!isOpen),
            child: clicker));
    if([Side.left,Side.right].contains(side)) {
      return Row(
        children: [
          if(clicker != null && side == Side.left)
            customClicker,
          body,
          if(clicker != null && side == Side.right)
            customClicker
        ],
      );
    } else {
      return Column(
        children: [
          if(clicker != null && side == Side.bottom)
            customClicker,
          body,
          if(clicker != null && side == Side.top)
            customClicker
        ],
      );
    }
  }

}

enum Side{
  top,
  bottom,
  right,
  left
}
