import 'dart:core';

import 'package:flutter/material.dart';

class FmField extends StatelessWidget {
  final Widget prefix;
  final String title;
  final double titleWidth;
  final String placeholder;
  final String text;
  final double height;
  final Function onChange;

  FmField(
      {Key key,
      this.prefix,
      this.title,
      this.titleWidth = 80,
      this.placeholder,
      this.text,
      this.height = 44,
      this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyle(
        color: Color(0xff333333), fontSize: 14, fontWeight: FontWeight.w400);

    TextStyle textStyle = TextStyle(color: Color(0xff333333), fontSize: 14);

    TextStyle placeholderStyle =
        TextStyle(color: Color(0xff999999), fontSize: 14);

    List<Widget> _children = [];
    _children.add(Container(width: 10));

    if (null != prefix) {
      _children.add(prefix);
      _children.add(Container(width: 10));
    }

    if (null != title) {
      _children.add(
          SizedBox(width: titleWidth, child: Text(title, style: titleStyle)));
    }

    TextEditingController controller = TextEditingController(text: text);
    controller.addListener(() => onChange(controller.text));

    _children.add(Expanded(
        child: TextField(
      controller: controller,
      style: textStyle,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 0, bottom: 5),
          hintText: placeholder,
          hintStyle: placeholderStyle,
          border: InputBorder.none),
    )));

    return Container(
        width: double.infinity,
        height: height,
        color: Colors.white,
        child: Row(
          children: _children,
        ));
  }
}
