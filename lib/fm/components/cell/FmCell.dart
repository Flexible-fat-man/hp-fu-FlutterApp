import 'dart:core';

import 'package:flutter/material.dart';

class FmCell extends StatelessWidget {
  final Widget prefix;
  final String title;
  final String subtitle;
  final Widget subtitleWidget;
  final bool isLink;
  final double height;
  final GestureTapCallback onTapCall;

  FmCell(
      {Key key,
      this.prefix,
      this.title,
      this.subtitle,
      this.subtitleWidget,
      this.isLink,
      this.height = 44,
      this.onTapCall})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyle(
        color: Color(0xff333333), fontSize: 14, fontWeight: FontWeight.w400);

    TextStyle subtitleStyle = TextStyle(color: Color(0xff808080), fontSize: 14);

    List<Widget> _children = [];
    _children.add(Container(width: 10));

    if (null != prefix) {
      _children.add(prefix);
      _children.add(Container(width: 10));
    }

    if (null != title) {
      _children.add(Expanded(child: Text(title, style: titleStyle)));
    }

    if (null != subtitle) _children.add(Text(subtitle, style: subtitleStyle));
    if (null != subtitleWidget) _children.add(subtitleWidget);

    if (null != isLink && true == isLink) {
      _children.add(Icon(Icons.chevron_right, color: Color(0xff999999)));
    }
    _children.add(Container(width: 10));

    return InkWell(
      onTap: onTapCall,
      child: Container(
          width: double.infinity,
          height: height,
          color: Colors.white,
          child: Row(
            children: _children,
          )),
    );
  }
}
