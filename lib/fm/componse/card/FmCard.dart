import 'package:flutter/material.dart';

class FmCard extends StatelessWidget {
  final Widget header;
  final Widget body;
  final Widget footer;
  final double borderRadius;

  FmCard({this.header, this.body, this.footer, this.borderRadius = 4});

  @override
  Widget build(Object context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: _child(),
      ),
    );
  }

  Widget _child() {
    return Column(
      children: _children(),
    );
  }

  List<Widget> _children() {
    List<Widget> l = [];
    if (null != header) l.add(header);
    if (null != body) l.add(body);
    if (null != footer) l.add(footer);
    return l;
  }
}
