import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class FmCheckout extends StatelessWidget {
  bool isCheck;
  Function onTap;
  final double size;
  FmCheckout({this.isCheck, this.onTap, this.size = 36});

  BoxDecoration unSelect = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(20)),
    border: Border.all(width: 1, color: Color(0xFFcccccc)),
  );

  BoxDecoration select = BoxDecoration(
    color: Colors.red,
    borderRadius: BorderRadius.all(Radius.circular(20)),
    border: Border.all(width: 1, color: Colors.red),
  );

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: InkWell(onTap: onTap, child: _child()));
  }

  Widget _child() {
    return !isCheck
        ? Container(width: size, height: size, decoration: unSelect)
        : Container(
            width: size,
            height: size,
            decoration: select,
            child: Center(
              child: Icon(Icons.check, color: Colors.white),
            ));
  }
}
