import 'dart:core';

import 'package:flutter/material.dart';

class FmHeaderCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget buttonTit;
  final String mode;

  static const column = "column";
  static const row = "row";
  static const stack = "stack";

  FmHeaderCard(
      {Key key,
      this.title,
      this.subtitle,
      this.buttonTit,
      this.mode = FmHeaderCard.column})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: _child());
  }

  Widget _child() {
    List<Widget> _children = [];
    if (null != title) _children.add(Expanded(child: Text(title)));
    if (null != subtitle) _children.add(Expanded(child: Text(subtitle)));
    if (null != buttonTit) _children.add(buttonTit);

    if (row == this.mode) return Row(children: _children);
    if (stack == this.mode) return Stack(children: _children);
    return Column(children: _children);
  }
}
