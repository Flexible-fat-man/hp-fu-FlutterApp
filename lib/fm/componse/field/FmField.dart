import 'package:flutter/material.dart';
import '../cell/FmCell.dart';

class FmField extends StatelessWidget {
  final Widget prefixWidget;
  final String title;
  final String value;
  final String placeholder;
  final Widget suffixWidget;
  final double height;
  final bool isShowBorder;
  final ValueChanged onChanged;

  FmField({
    this.prefixWidget,
    this.title,
    this.value = "",
    this.placeholder,
    this.suffixWidget,
    this.height = 44,
    this.isShowBorder = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FmCell(
        prefixWidget: prefixWidget,
        titleWidget: _titleWidget(),
        subtitleWidget: _subtitleWidget(),
        suffixWidget: suffixWidget,
        height: height,
        isShowBorder: isShowBorder);
  }

  Widget _titleWidget() {
    return Container(width: 70, child: Text(title));
  }

  Widget _subtitleWidget() {
    TextEditingController controller = TextEditingController.fromValue(
        TextEditingValue(
            text: value,
            selection: TextSelection.fromPosition(TextPosition(
                affinity: TextAffinity.downstream, offset: value.length))));

    controller.addListener(() {
      if (null != onChanged) onChanged(controller.text);
    });

    TextStyle textStyle = TextStyle(color: Color(0xff333333), fontSize: 14);
    TextStyle placeholderStyle =
        TextStyle(color: Color(0xff999999), fontSize: 14);

    return Expanded(
        child: TextField(
      style: textStyle,
      controller: controller,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 0, bottom: 5),
          hintText: placeholder,
          hintStyle: placeholderStyle,
          border: InputBorder.none),
    ));
  }
}
