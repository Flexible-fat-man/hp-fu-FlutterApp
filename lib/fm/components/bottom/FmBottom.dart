import 'dart:core';

import 'package:flutter/material.dart';

class FmBottom extends StatelessWidget {
  final Widget header;
  final Widget body;
  final Widget footer;
  final String mode;

  static const column = "column";
  static const row = "row";
  static const stack = "stack";

  FmBottom(
      {Key key,
      this.header,
      this.body,
      this.footer,
      this.mode = FmBottom.column})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        color: Colors.white,
        margin: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
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
