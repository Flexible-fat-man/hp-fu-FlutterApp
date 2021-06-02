import 'package:flutter/material.dart';

import 'ColorHelper.dart';

class WidgetHelper extends TextField {
  static Widget lineHorizontal() {
    return Container(
      height: 1,
      decoration: new BoxDecoration(
        //背景
        color: ColorHelper.dividerColor,
      ),
    );
  }


  static Widget lineHorizontal2(left, top, right, bottom) {
    return Container(
      margin: EdgeInsets.only(left: left, top: top, right: right, bottom: bottom),
      height: 1,
      decoration: new BoxDecoration(
        //背景
        color: ColorHelper.dividerColor,
      ),
    );
  }


  static Widget card(Widget child) {
    return Container(
        margin: EdgeInsets.only(left: 15, top: 20, right: 15, bottom: 0),
        padding: EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 0),
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: child);
  }

  static Widget cell(String title, String subtitle, Image start) {
    return Container(
      height: 60,
      child: Row(
        children: [
          Container(width: 10),
          start,
          Container(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontSize: 15,
                  fontWeight: FontWeight.w800),
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
                color: Color(0xFFA1A1A1),
                fontSize: 12,
                fontWeight: FontWeight.w400),
          ),
          Container(width: 10),
          Image.asset(
            "images/ic_mine_arrow.png",
            fit: BoxFit.fill,
            width: 9,
            height: 14,
          ),
          Container(width: 10),
        ],
      ),
    );
  }

  static Widget textField(
      String defText, String hintText, ValueChanged<String> _onSubmitted) {
    return TextField(
      controller: TextEditingController(text: defText),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10.0),
        hintText: hintText,
        hintStyle: TextStyle(color: Color(0xFF999999), fontSize: 14),
        enabledBorder: new UnderlineInputBorder(
          borderSide: BorderSide(color: ColorHelper.dividerColor),
        ),
        focusedBorder: new UnderlineInputBorder(
          borderSide: BorderSide(color: ColorHelper.colorPrimary),
        ),
      ),
      onChanged: _onSubmitted,
    );
  }
}
