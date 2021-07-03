library slidable_bar;

import 'package:flutter/material.dart';

class SlidableSideBar extends StatefulWidget {

  final Widget child;
  final ValueChanged<int>? onChange;
  const SlidableSideBar({
    Key? key,
    required this.child,
    this.onChange
  }) : super(key: key);

  @override
  _SlidableSideBarState createState() => _SlidableSideBarState();
}

class _SlidableSideBarState extends State<SlidableSideBar> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: widget.child),
        Positioned(
          right: 0,
        )
      ],
    );
  }
}

class ItemsBar extends StatelessWidget {

  final List<Widget> children;
  final Color? backgroundColor;
  const ItemsBar({
    Key? key,
    required this.children,
    this.backgroundColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: children.length,
        itemBuilder: (context,index){
          return children[index];
        },
      ),
    );
  }

}
