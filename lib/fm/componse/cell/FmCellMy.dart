import 'package:flutter/material.dart';
import '../../element/FmTextStyle.dart';

class FmCellMy extends StatelessWidget {
  final Widget prefixWidget;

  final String title;
  final Widget titleWidget;

  final String subtitle;
  final Widget subtitleWidget;

  final Widget suffixWidget;

  final bool isLink;
  final bool isShowBorder;

  final GestureTapCallback onTap;

  FmCellMy(
      {this.prefixWidget,
      this.title,
      this.titleWidget,
      this.subtitle,
      this.subtitleWidget,
      this.suffixWidget,
      this.isLink = false,
      this.isShowBorder = true,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: _child(),
      ),
    );
  }

  Widget _child() {
    List<Widget> children = [];

    if (null != prefixWidget) {
      children.add(prefixWidget);
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
