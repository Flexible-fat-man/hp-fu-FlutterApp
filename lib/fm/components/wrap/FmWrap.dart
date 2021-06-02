import 'dart:core';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FmWrap extends StatelessWidget {
  double left;
  double top;
  double right;
  double bottom;
  Widget child;

  double width;
  double height;
  double all;

  FmWrap.all({
    Key key,
    this.all,
    this.child,
  }) : super(key: key) {
    this.left = this.all;
    this.right = this.all;

    this.top = this.all;
    this.bottom = this.all;
  }

  FmWrap.row({
    Key key,
    this.width,
    this.child,
  }) : super(key: key) {
    this.left = this.width;
    this.right = this.width;

    this.top = 0;
    this.bottom = 0;
  }

  FmWrap.column({
    Key key,
    this.height,
    this.child,
  }) : super(key: key) {
    this.left = 0;
    this.right = 0;

    this.top = this.height;
    this.bottom = this.height;
  }

  FmWrap.only({
    Key key,
    this.left = 0,
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: child,
    );
  }
}
