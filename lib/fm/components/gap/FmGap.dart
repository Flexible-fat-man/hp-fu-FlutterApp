import 'dart:core';

import 'package:flutter/material.dart';

class FmGap extends StatelessWidget {
  final double height;

  FmGap({
    Key key,
    this.height = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(height: height);
  }
}
