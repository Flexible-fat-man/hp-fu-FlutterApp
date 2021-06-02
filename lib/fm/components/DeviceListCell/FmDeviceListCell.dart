import 'dart:core';

import 'package:flutter/material.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';

class FmDeviceListCell extends StatelessWidget {
  final Widget prefix;
  final String title;
  final String serialNumber;
  final String descriptive;
  final String type;
  final String subtitle;
  final Widget subtitleWidget;
  final bool isLink;
  final bool isCopy;
  final double height;
  final GestureTapCallback onTapCall;

  FmDeviceListCell(
      {Key key,
      this.prefix,
      this.title,
      this.serialNumber,
      this.descriptive,
      this.type,
      this.subtitle,
      this.subtitleWidget,
      this.isLink,
      this.isCopy,
      this.height = 44,
      this.onTapCall})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w400);

    TextStyle subtitleStyle = TextStyle(fontSize: 14,color: ColorHelper.secondaryText);

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
    if (null != isCopy && true == isCopy) {
      _children.add(Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Text(
          '复制',
          style: TextStyle(
            color: Colors.red,
            fontSize: 12,
          ),
        ),
      ));
    }
    _children.add(Container(width: 10));

    return InkWell(
      onTap: onTapCall,
      child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          width: double.infinity,
          // height: height,
          decoration: new BoxDecoration(
            color: Colors.white,
            border:
                  Border(bottom: BorderSide(width: 1, color: ColorHelper.dividerColor)),
          ),
          child: Row(
            children: _children,
          )),
    );
  }
}
