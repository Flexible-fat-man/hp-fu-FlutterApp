import 'dart:core';

import 'package:flutter/material.dart';

class FmCard extends StatelessWidget {
  final Widget header;
  final Widget body;
  final Widget footer;
  final String mode;

  static const column = "column";
  static const row = "row";
  static const stack = "stack";

  FmCard(
      {Key key, this.header, this.body, this.footer, this.mode = FmCard.column})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: new BoxDecoration(
          //背景
          color: Colors.white,
          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          //设置四周边框
          border: new Border.all(width: 1, color: Colors.white),
        ),
        child: _child());
  }

  Widget _child() {
    List<Widget> _children = [];
    if (null != header) _children.add(header);
    if (null != body) _children.add(body);
    if (null != footer) _children.add(footer);

    if (row == this.mode) return Row(children: _children);
    if (stack == this.mode) return Stack(children: _children);
    return Column(children: _children);
  }
}
