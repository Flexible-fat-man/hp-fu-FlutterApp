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

class UpdatePwd extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UpdatePwdState();
  }
}

class _UpdatePwdState extends State<UpdatePwd> {
  String oldPassword = "";
  String newPassword = "";
  String newPasswordRe = "";
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final newPasswordReController = TextEditingController();

  void _requestData() {
    if (oldPassword == "") {
      EasyLoading.showToast("请输入旧密码");
      return;
    }
    if (newPassword == "") {
      EasyLoading.showToast("请输入新密码");
      return;
    }
    if (newPasswordRe == "") {
      EasyLoading.showToast("请再次输入新密码");
      return;
    }
    EasyLoading.show();
    HttpManager().post(
      url: ApiHelper.updatePassword,
      data: {
        "oldPassword": oldPassword,
        "newPassword": newPassword,
        "newPasswordRe": newPasswordRe,
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

  @override
  Widget build(BuildContext context) {
    oldPasswordController.addListener(() {
      print('input ${oldPasswordController.text}');

      setState(() {
        oldPassword = oldPasswordController.text;
      });
    });

    newPasswordController.addListener(() {
      print('input ${newPasswordController.text}');

      setState(() {
        newPassword = newPasswordController.text;
      });
    });

    newPasswordReController.addListener(() {
      print('input ${newPasswordReController.text}');

      setState(() {
        newPasswordRe = newPasswordReController.text;
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
          "修改密码",
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
                          "旧密码",
                          style:
                              TextStyle(color: Color(0xFF383838), fontSize: 14),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: oldPasswordController,
                        style:
                            TextStyle(color: Color(0xFF383838), fontSize: 14),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: "请输入旧密码",
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
                          "新密码",
                          style:
                              TextStyle(color: Color(0xFF383838), fontSize: 14),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: newPasswordController,
                        style:
                            TextStyle(color: Color(0xFF383838), fontSize: 14),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: "请输入新密码",
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
                          "新密码",
                          style:
                              TextStyle(color: Color(0xFF383838), fontSize: 14),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: newPasswordReController,
                        style:
                            TextStyle(color: Color(0xFF383838), fontSize: 14),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: "请再次输入新密码",
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
