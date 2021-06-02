import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FmWrap extends StatelessWidget {
  double left;
  double top;
  double right;
  double bottom;
  Widget child;

  FmWrap.all(double d, Widget c) {
    left = d;
    top = d;
    right = d;
    bottom = d;
    child = c;
  }

  FmWrap.only({this.left, this.top, this.right, this.bottom, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(left: left, top: top, right: right, bottom: bottom),
      child: child,
    );
  }
}
