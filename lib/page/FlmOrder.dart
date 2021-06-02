import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:hpfuapp/fm/componse/wrap/FmWrap.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';
import 'package:hpfuapp/utils/http/http_error.dart';
import 'package:hpfuapp/utils/http/http_manager.dart';
import 'package:hpfuapp/utils/toast_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../fm/componse/field/FmField.dart';
import '../fm/componse/button/FmButton.dart';

class FlmOrder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FlmOrderState();
  }
}

class _FlmOrderState extends State<FlmOrder> {
  String transAmt = "20000";
  String transDate = "20220126";
  String snNo = "00012340099";

  SharedPreferences prefs;

  void _requestData() {
    HttpManager().post(
      url: "/agent/FlmOrderController/moniAdd",
      data: {
        "transAmt": transAmt,
        "transDate": transDate,
        "snNo": snNo,
      },
      successCallback: (data) {
        Toast.toast(context, "提交成功");
        //Navigator.of(context).pop();

        prefs.setString('transAmt', transAmt);
        prefs.setString('transDate', transDate);
        prefs.setString('snNo', snNo);
      },
      errorCallback: (HttpError error) {
        Toast.toast(context, error.message);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _getLocalData();
  }

  void _getLocalData() async {
    prefs = await SharedPreferences.getInstance();
    String transAmtLocal = prefs.getString("transAmt");
    String transDateLocal = prefs.getString("transDate");
    String snNoLocal = prefs.getString("snNo");
    if (null != transAmtLocal && "" != transAmtLocal) {
      setState(() {
        transAmt = transAmtLocal;
        transDate = transDateLocal;
        snNo = snNoLocal;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        leading: GFIconButton(
          icon: Image.asset(
            "images/ic_back_black.png",
            fit: BoxFit.fill,
            width: 12,
            height: 20,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          splashColor: Colors.transparent,
          disabledColor: Colors.transparent,
          highlightColor: Colors.transparent,
          type: GFButtonType.transparent,
        ),
        elevation: 0,
        brightness: Brightness.light,
        title: Text(
          "模拟交易",
          style: TextStyle(fontSize: 16, color: Color(0xFF4A4A4A)),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: ColorHelper.backgroundColor,
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Column(children: [
              FmField(
                title: "交易金额",
                value: transAmt,
                placeholder: "请输入交易金额",
                onChanged: (text) => setState(() => transAmt = text),
              ),
              FmField(
                title: "交易日期",
                value: transDate,
                placeholder: "请输入交易日期",
                onChanged: (text) => setState(() => transDate = text),
              ),
              FmField(
                title: "机器编号",
                value: snNo,
                placeholder: "请输入机器编号",
                onChanged: (text) => setState(() => snNo = text),
              ),
            ]),
          ),
          FmWrap.all(
              15,
              FmButton(
                title: "提交",
                onTap: _requestData,
              )),
        ],
      ),
    );
  }
}
