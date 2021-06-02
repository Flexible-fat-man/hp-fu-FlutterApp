import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:hpfuapp/helper/ApiHelper.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';
import 'package:hpfuapp/helper/WidgetHelper.dart';
import 'package:hpfuapp/router/RouterFluro.dart';
import 'package:hpfuapp/utils/http/http_error.dart';
import 'package:hpfuapp/utils/http/http_manager.dart';
import 'package:hpfuapp/utils/toast_util.dart';

import 'UpdateMobile.dart';
import 'UpdateName.dart';
import 'UpdatePwd.dart';

class Setting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingState();
  }
}

class _SettingState extends State<Setting> {
/*
   * 弹出框
   */
  void showAlertDialog() {
    showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text(
              '提示',
              style: TextStyle(color: ColorHelper.primaryText, fontSize: 16),
            ),
            //可滑动
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  Text(
                    "账户注销后将无法使用此账号登录",
                    style:
                        TextStyle(color: ColorHelper.primaryText, fontSize: 16),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text(
                  '取消',
                  style:
                      TextStyle(color: ColorHelper.primaryText, fontSize: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new TextButton(
                child: new Text(
                  '确定',
                  style:
                      TextStyle(color: ColorHelper.colorPrimary, fontSize: 16),
                ),
                onPressed: () {
                  _requestData();
                },
              ),
            ],
          );
        });
  }

  void _requestData() {
    HttpManager().post(
      url: ApiHelper.solfDelete,
      data: {},
      successCallback: (data) {
        Toast.toast(context, "提交成功");
        RouterFluro.navigateTo(context, "/LoginPage", replace: true);
      },
      errorCallback: (HttpError error) {
        Toast.toast(context, error.message);
      },
    );
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
          "设置",
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
            child: Column(
              children: [
                Column(
                  children: [
                    WidgetHelper.lineHorizontal(),
                    InkWell(
                        //单击事件响应
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return UpdateMobile();
                          }));
                        },
                        child: Container(
                          height: 44,
                          color: Colors.white,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(width: 15),
                              Expanded(
                                child: Text(
                                  "修改手机号",
                                  style: TextStyle(
                                      color: ColorHelper.primaryText,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Text(
                                "",
                                style: TextStyle(
                                    color: ColorHelper.secondaryText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                              Image.asset(
                                "images/ic_mine_arrow.png",
                                fit: BoxFit.scaleDown,
                                width: 9,
                                height: 14,
                              ),
                              Container(width: 15),
                            ],
                          ),
                        )),
                    WidgetHelper.lineHorizontal2(15.0, 0.0, 0.0, 0.0),
                    InkWell(
                        //单击事件响应
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return UpdatePwd();
                          }));
                        },
                        child: Container(
                          height: 44,
                          color: Colors.white,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(width: 15),
                              Expanded(
                                child: Text(
                                  "修改密码",
                                  style: TextStyle(
                                      color: ColorHelper.primaryText,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Text(
                                "",
                                style: TextStyle(
                                    color: ColorHelper.secondaryText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                              Image.asset(
                                "images/ic_mine_arrow.png",
                                fit: BoxFit.scaleDown,
                                width: 9,
                                height: 14,
                              ),
                              Container(width: 15),
                            ],
                          ),
                        )),
                    WidgetHelper.lineHorizontal2(15.0, 0.0, 0.0, 0.0),
                    InkWell(
                        //单击事件响应
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return UpdateName();
                          }));
                        },
                        child: Container(
                          height: 44,
                          color: Colors.white,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(width: 15),
                              Expanded(
                                child: Text(
                                  "修改名称",
                                  style: TextStyle(
                                      color: ColorHelper.primaryText,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Text(
                                "",
                                style: TextStyle(
                                    color: ColorHelper.secondaryText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                              Image.asset(
                                "images/ic_mine_arrow.png",
                                fit: BoxFit.scaleDown,
                                width: 9,
                                height: 14,
                              ),
                              Container(width: 15),
                            ],
                          ),
                        )),
                    WidgetHelper.lineHorizontal2(15.0, 0.0, 0.0, 0.0),
                    InkWell(
                        //单击事件响应
                        onTap: () {
                          showAlertDialog();
                        },
                        child: Container(
                          height: 44,
                          color: Colors.white,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(width: 15),
                              Expanded(
                                child: Text(
                                  "注销账户",
                                  style: TextStyle(
                                      color: ColorHelper.primaryText,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Text(
                                "谨慎操作",
                                style: TextStyle(
                                    color: ColorHelper.secondaryText,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                              Container(width: 10),
                              Image.asset(
                                "images/ic_mine_arrow.png",
                                fit: BoxFit.scaleDown,
                                width: 9,
                                height: 14,
                              ),
                              Container(width: 15),
                            ],
                          ),
                        )),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
