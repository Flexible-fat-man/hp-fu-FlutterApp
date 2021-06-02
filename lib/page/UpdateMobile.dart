import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:hpfuapp/helper/ApiHelper.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';
import 'package:hpfuapp/helper/WidgetHelper.dart';
import 'package:hpfuapp/utils/http/http_error.dart';
import 'package:hpfuapp/utils/http/http_manager.dart';
import 'package:hpfuapp/utils/toast_util.dart';

import 'LoginFormCode.dart';

class UpdateMobile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UpdateMobileState();
  }
}

class _UpdateMobileState extends State<UpdateMobile> {
  String agentMobile = "";
  String code = "";
  final agentMobileController = TextEditingController();
  final codeController = TextEditingController();

  void _requestData() {
    if (agentMobile == "") {
      EasyLoading.showToast("请输入手机号");
      return;
    }
    if (code == "") {
      EasyLoading.showToast("请输入验证码");
      return;
    }
    EasyLoading.show();
    HttpManager().post(
      url: ApiHelper.updateAgentMobile,
      data: {
        "agentMobile": agentMobile,
        "code": code,
      },
      successCallback: (data) {
        EasyLoading.dismiss();
        EasyLoading.showToast("提交成功");
        Navigator.of(context).pop();
      },
      errorCallback: (HttpError error) {
        EasyLoading.dismiss();
        EasyLoading.showToast(error.message);
      },
    );
  }

  void _sendVerifyCode() {
    if (agentMobile == "") {
      Toast.toast(context, "请输入手机号");
      return;
    }
    HttpManager().post(
      url: ApiHelper.sendVerifyCode,
      data: {
        "mobile": agentMobile,
        "type": "3",
      },
      successCallback: (data) {
        Toast.toast(context, "发送成功");
      },
      errorCallback: (HttpError error) {
        Toast.toast(context, error.message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    agentMobileController.addListener(() {
      print('input ${agentMobileController.text}');

      setState(() {
        agentMobile = agentMobileController.text;
      });
    });

    codeController.addListener(() {
      print('input ${codeController.text}');

      setState(() {
        code = codeController.text;
      });
    });

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
          "修改手机号",
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
              WidgetHelper.lineHorizontal(),
              Container(
                height: 44,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 15,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text(
                          "新的手机号",
                          style:
                              TextStyle(color: Color(0xFF383838), fontSize: 14),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: agentMobileController,
                        style:
                            TextStyle(color: Color(0xFF383838), fontSize: 14),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: "请输入新的手机号",
                          hintStyle:
                              TextStyle(color: Color(0xFFCCCCCC), fontSize: 14),
                        ),
                      ),
                    ),
                    Container(
                      width: 15,
                    ),
                  ],
                ),
              ),
              WidgetHelper.lineHorizontal(),
              Container(
                height: 44,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 15,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text(
                          "验证码",
                          style:
                              TextStyle(color: Color(0xFF383838), fontSize: 14),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: codeController,
                              style: TextStyle(
                                  color: Color(0xFF383838), fontSize: 14),
                              decoration: InputDecoration(
                                isCollapsed: true,
                                border: InputBorder.none,
                                hintText: "请输入验证码",
                                hintStyle: TextStyle(
                                    color: Color(0xFFCCCCCC), fontSize: 14),
                              ),
                            ),
                          ),
                          LoginFormCode(
                            onTapCallback: () {
                              _sendVerifyCode();
                            }, // 回调下一步方法，比如调用验证码接口
                            available: true, // 只有是true才能激活倒计时
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 15,
                    ),
                  ],
                ),
              ),
            ]),
          ),
          Container(
            height: 36,
            margin: EdgeInsets.fromLTRB(15, 30, 15, 0),
            width: MediaQuery.of(context).size.width - 50,
            decoration: BoxDecoration(
                color: ColorHelper.colorPrimary,
                borderRadius: BorderRadius.circular(18)),
            child: TextButton(
              child: Text(
                '提交',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              onPressed: () {
                _requestData();
              },
            ),
          ),
        ],
      ),
    );
  }
}
