import 'package:flutter/material.dart';
import 'package:hpfuapp/fm/componse/cell/FmCellMy.dart';
import 'package:hpfuapp/page/SettleManage/XNumberTextInputFormatter.dart';

class FmFieldMy extends StatelessWidget {
  final String value;
  final String placeholder;
  final bool enable;
  final Widget suffixWidget;
  final ValueChanged onChanged;

  FmFieldMy({
    this.value = "",
    this.placeholder,
    this.enable,
    this.suffixWidget,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FmCellMy(
      subtitleWidget: _subtitleWidget(),
      suffixWidget: suffixWidget,
    );
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

    TextStyle textStyle = TextStyle(color: Color(0xff333333), fontSize: 16);
    TextStyle placeholderStyle =
        TextStyle(color: Color(0xff999999), fontSize: 16);

    return Expanded(
        child: TextField(
      //设置键盘可录入为小数
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        XNumberTextInputFormatter(
            maxIntegerLength: 8, maxDecimalLength: 3, isAllowDecimal: true),
      ],
      enabled: enable,
      style: textStyle,
      controller: controller,
      decoration: InputDecoration(
          isCollapsed: true,
          hintText: placeholder,
          hintStyle: placeholderStyle,
          border: InputBorder.none),
    ));
  }
}
