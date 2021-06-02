import 'package:flutter/material.dart';
import '../../element/FmColor.dart';
import 'FmButtonSize.dart';
import 'FmButtonShap.dart';

class FmButton extends StatelessWidget {
  final Widget prefixWidget;
  final String title;
  final Color titleColor;
  final double size;
  final Color bgColor;
  final String shap;
  final GestureTapCallback onTap;

  FmButton(
      {this.prefixWidget,
      this.title,
      this.titleColor = Colors.white,
      this.bgColor = FmColor.primary,
      this.size = FmButtonSize.nomal,
      this.shap = FmButtonShap.stand,
      this.onTap});

  double _width() {
    if (shap == FmButtonShap.square || shap == FmButtonShap.circle) return size;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Widget o = Container(
      width: _width(),
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: _borderRadius(),
        border: _border(),
      ),
      child: _child(),
    );

    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: onTap,
        child: o,
      ),
    );
  }

  BorderRadius _borderRadius() {
    double r = 4;
    if (shap == FmButtonShap.pill || shap == FmButtonShap.circle) r = 22;
    if (shap == FmButtonShap.rectangle) r = 0;

    return BorderRadius.all(Radius.circular(r));
  }

  Border _border() {
    return Border.fromBorderSide(BorderSide.none);
  }

  Widget _child() {
    List<Widget> children = [];
    if (null != prefixWidget) children.add(prefixWidget);

    if (null != prefixWidget && null != title)
      children.add(Container(
        width: 5,
      ));

    if (null != title)
      children.add(Text(
        title,
        style: TextStyle(color: titleColor),
      ));
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: children);
  }
}
