import 'package:flutter/material.dart';
import '../../element/FmTextStyle.dart';

class FmCell extends StatelessWidget {
  final Widget prefixWidget;

  final String title;
  final Widget titleWidget;

  final String subtitle;
  final Widget subtitleWidget;

  final Widget suffixWidget;

  final double height;
  final bool isLink;
  final bool isShowBorder;

  final GestureTapCallback onTap;

  FmCell(
      {this.prefixWidget,
      this.title,
      this.titleWidget,
      this.subtitle,
      this.subtitleWidget,
      this.suffixWidget,
      this.height = 44,
      this.isLink = false,
      this.isShowBorder = true,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        child: _child(),
        decoration: BoxDecoration(
          color: Colors.white,
          border: _border(),
        ),
      ),
    );
  }

  Border _border() {
    if (true == isShowBorder)
      return Border(
          bottom: BorderSide(
              color: Color(0xfff0f0f0), width: 1, style: BorderStyle.solid));
    return Border.fromBorderSide(BorderSide.none);
  }

  Widget _child() {
    List<Widget> children = [];
    children.add(Container(width: 10));

    if (null != prefixWidget) {
      children.add(prefixWidget);
      children.add(Container(width: 10));
    }

    if (null != title)
      children.add(Expanded(
          child: Text(
        title,
        style: FmTextStyle.titleStyle,
      )));
    if (null != subtitle)
      children.add(Text(
        subtitle,
        style: FmTextStyle.subtitleStyle,
      ));

    if (null != titleWidget) children.add(titleWidget);
    if (null != subtitleWidget) children.add(subtitleWidget);

    if (null != suffixWidget) {
      children.add(Container(width: 10));
      children.add(suffixWidget);
    }

    if (isLink)
      children.add(Icon(
        Icons.chevron_right,
        color: Color(0xff999999),
      ));

    children.add(Container(width: 10));
    return Row(children: children);
  }
}
