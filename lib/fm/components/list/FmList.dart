import 'dart:core';

import 'package:flutter/material.dart';

class FmList extends StatelessWidget {
  final List<Widget> children;

  FmList({Key key, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: children.length,
        itemBuilder: (BuildContext context, int index) {
          return children.elementAt(index);
        },
        separatorBuilder: (BuildContext context, int index) =>
            Divider(height: 1.0, color: Color(0xffeeeeee)));
  }
}
